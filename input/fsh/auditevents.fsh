// All profiles and rules for the CH Audit Events, used by other profiles

Profile:     ChAuditEventBasicToken
Parent:      AuditEvent
Title:       "CH Audit Event with a Basic Auth Token"
Description: "This is the profile for Swiss Audit Events when a transaction is secured with a Basic Authorization Token."
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent contains mainUser 0..1 and delegatedUser 0..1 and group 0..*
* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "type"
* entity ^slicing.rules = #open
* insert ChAuditEventRules


Profile:     ChAuditEventExtendedToken
Parent:      ChAuditEventBasicToken
Title:       "CH Audit Event with an Extended Auth Token"
Description: "This is the profile for Swiss Audit Events when a transaction is secured with an Extended Authorization
Token."
* agent[mainUser] 1..1
  * purposeOfUse 1..1
* entity contains patient 1..1
* entity[patient] 1..1
  * what.identifier 1..1
    * value 1..1
    * system 1..1
    * system = "urn:oid:2.16.756.5.30.1.127.3.10.3"


// All rules that apply to the AuditEvents with both Basic and Extended Tokens
// You have to define the slices in the profile before applying this one
RuleSet: ChAuditEventRules
* agent[mainUser]
  * ^short = "The responsible user: the patient, representative, healthcare professional, administrator or technical user who made the request, or the healthcare professional on whose behalf an assistant made it"
  * type = $v3ParticipationType#RESP "responsible party"
  * role 1..1
  * altId 1..1
  * name 1..1
  * purposeOfUse 0..1
  * purposeOfUse from http://fhir.ch/ig/ch-term/ValueSet/EprPurposeOfUse
* agent[delegatedUser]
  * ^short = "The assistant who made the request on behalf of the main user. Only present when the access token carries a delegation."
  * type = $v3ParticipationType#PPRF "primary performer"
  * role 1..1
  * altId 1..1
  * name 1..1
* agent[group]
  * ^short = "A health institution or group of healthcare professionals the main user is a member of (optional)"
  * ^comment = "Optional. The groups and institutions of the main user as conveyed in the access token (ch_group), or only the one on whose behalf the main user acts where that is known, e.g. the provider institution of a document which is provided, replaced or purged. Absent when the main user is a patient, a representative, a legal representative or an administrator."
  * type = $v3RoleClass#PROV "healthcare provider"
  * role 1..1
  * role = $ehealthAgentRole#GRP "Group"
  * who 1..1
  * who.identifier 1..1
  * who.identifier only OidIdentifier
  * who.identifier ^short = "OID of the institution or group"
  * name 1..1
  * name ^short = "Name of the institution or group"
* source
  * site 1..1
  * site ^short = "The OID of the audit source"
* entity contains traceparent 0..1
* entity[traceparent]
  * ^short = "The 'traceparent' header value of the transaction"
  * what 1..1
    * identifier 1..1
      * value 1..1
      * value ^short = "The 'traceparent' header value"
  * type = $auditEntityType#4 "Other"
  * role = $objectRole#26 "Processing Element"


// Rule Sets for our AuditEvents with basic access tokens
RuleSet: ChAuditEventBasicRules
* agent contains mainUser 0..1 and delegatedUser 0..1 and group 0..*
* insert ChAuditEventRules


// Rule Sets for our AuditEvents with extended access tokens
RuleSet: ChAuditEventExtendedRules
* agent contains mainUser 1..1 and delegatedUser 0..1 and group 0..*
* insert ChAuditEventRules
* agent[mainUser].purposeOfUse 1..1
* entity[patient] 1..1
  * what.identifier 1..1
    * value 1..1
    * system 1..1
    * system = "urn:oid:2.16.756.5.30.1.127.3.10.3"


// The type of the event in the audit trail of the patient, as an additional subtype. It is required for the actor
// serving the request (min 1) and optional for the actor making it (min 0).
RuleSet: ChAuditEventTypeCodeRules(min, code, display)
* subtype contains auditTrailType {min}..1
* subtype[auditTrailType] ^short = "The type of the event in the audit trail of the patient"
* subtype[auditTrailType] = $healthDossierAuditEventType#{code} "{display}"


// As above, where the type is one of the codes of a value set
RuleSet: ChAuditEventTypeValueSetRules(min, max, valueSet)
* subtype contains auditTrailType {min}..{max}
* subtype[auditTrailType] ^short = "The type of the event in the audit trail of the patient"
* subtype[auditTrailType] from {valueSet} (required)


// The document a transaction is about. Only its master identifier is recorded, not its title, type or
// confidentiality code. The slice has to be defined in the profile before applying this rule set.
RuleSet: ChAuditEventDocumentEntityRules(slice)
* entity[{slice}].what.identifier 1..1
* entity[{slice}].what.identifier ^short = "The master identifier (uniqueId) of the document, DocumentReference.masterIdentifier"
* entity[{slice}].what.identifier.system 1..1
* entity[{slice}].what.identifier.value 1..1
* entity[{slice}] ^comment = "Only the master identifier of the document is recorded: the title, the type and the confidentiality code of the document SHALL NOT be recorded."
* entity[{slice}].name ..0
* entity[{slice}].securityLabel ..0
* entity[{slice}].description ..0


// Reference mapping from the XUA assertion to the CH Audit Event
Mapping: ChXuaToAuditEventMapping
Source:  ChAuditEventBasicToken
Target:  "https://www.bag.admin.ch/epra"
Title:   "CH XUA Assertion"
* agent[mainUser]
  * role         -> "AttributeStatement/Attribute[@Name=\"urn:oasis:names:tc:xacml:2.0:subject:role\"]/AttributeValue/Role"
  * altId        -> "Subject/NameID"
  * name         -> "AttributeStatement/Attribute[@Name=\"urn:oasis:names:tc:xspa:1.0:subject:subject-id\"]/AttributeValue"
  * purposeOfUse -> "AttributeStatement/Attribute[@Name=\"urn:oasis:names:tc:xspa:1.0:subject:purposeofuse\"]/AttributeValue/PurposeOfUse"
* agent[delegatedUser]
  * altId        -> "Subject/SubjectConfirmation/NameID"
  * name         -> "Subject/SubjectConfirmation/SubjectConfirmationData/AttributeStatement/Attribute[@Name=\"urn:oasis:names:tc:xspa:1.0:subject:subject-id\"]/AttributeValue"


// Reference mappings from the IUA Basic/Extended Token to the CH Audit Event.
// The access token always describes the authenticated user in the ihe_iua and ch_epr extensions. Where that user acts
// on behalf of a healthcare professional (assistant), the healthcare professional is conveyed in the ch_delegation
// extension. In the audit event the main user is the responsible party, so the two cases map differently.
// A technical user (TCU) has no ch_delegation extension: its user_id is the GLN of the legal responsible person.
Mapping: ChJwtToAuditEventMapping
Source:  ChAuditEventBasicToken
Target:  "https://www.bag.admin.ch/epra"
Title:   "CH JWT Basic/Extended Token without delegation"
Description: "Access token of a patient, representative, legal representative, healthcare professional, administrator or technical user (no ch_delegation extension): the authenticated user is the main user, there is no delegated user. For a technical user the identifier is the GLN of the legal responsible person of the clinical archive system."
* agent[mainUser]
  * role         -> "extensions.ihe_iua.subject_role"
  * altId        -> "extensions.ch_epr.user_id"
  * name         -> "extensions.ihe_iua.subject_name"
  * purposeOfUse -> "extensions.ihe_iua.purpose_of_use"
* agent[group]
  * who.identifier -> "extensions.ch_group.id" "One agent for each group recorded"
  * name           -> "extensions.ch_group.name" "One agent for each group recorded"


Mapping: ChJwtDelegationToAuditEventMapping
Source:  ChAuditEventBasicToken
Target:  "https://www.bag.admin.ch/epra"
Title:   "CH JWT Basic/Extended Token with delegation"
Description: "Access token of an assistant acting on behalf of a healthcare professional (ch_delegation extension present): the healthcare professional is the main user, the authenticated assistant is the delegated user."
* agent[mainUser]
  * role         -> "HCP" "The principal is a healthcare professional, the role is not conveyed in the token"
  * altId        -> "extensions.ch_delegation.principal_id"
  * name         -> "extensions.ch_delegation.principal"
  * purposeOfUse -> "extensions.ihe_iua.purpose_of_use"
* agent[delegatedUser]
  * role         -> "extensions.ihe_iua.subject_role" "ASS"
  * altId        -> "extensions.ch_epr.user_id"
  * name         -> "extensions.ihe_iua.subject_name"
* agent[group]
  * who.identifier -> "extensions.ch_group.id" "One agent for each group recorded"
  * name           -> "extensions.ch_group.name" "One agent for each group recorded"


// Rule Sets for examples

// Base rules for all examples
// Also update the copy of this rule set in ChAuditEventIti130ExampleRules (mcsd_auditevent.fsh)
// Also update the copy of this rule set in ChAuditEventIti68ExampleRules (mhd_auditevent.fsh)
RuleSet: ChExampleAuditEventBaseRules(sourceSlice, destinationSlice, server)
* recorded = "2024-10-28T09:43:56Z"
* outcome = #0
* agent[{sourceSlice}]
  * type = DCM#110153 "Source Role ID"
  * who.display = "My e-Health App"
  * requestor = false
  * network
    * address = "192.168.1.1"
    * type = #2
* agent[{destinationSlice}]
  * type = DCM#110152 "Destination Role ID"
  * who.display = "{server}"
  * requestor = false
  * network.type = #5 // The address needs to be define in each example (transaction specific)
* entity[traceparent]
  * what.identifier.value = "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00"
  * type = $auditEntityType#4 "Other"
  * role = $objectRole#26 "Processing Element"


// Rules for audit on the client side
RuleSet: ChExampleAuditEventClientRules
* source
  * site = "2.16.756.1.2.3"
  * observer.display = "My e-Health App"


// Rules for audit on the server side, the server label names the serving system (Health Dossier, MPI, HPD)
RuleSet: ChExampleAuditEventServerRules(server)
* source
  * site = "2.16.756.4.5.6"
  * observer.display = "{server}"


// Rules for an extended token for an healthcare professional
RuleSet: ChExampleAuditEventHcpRules
* agent[mainUser]
  * role = $healthDossierRole#HCP "Healthcare professional"
  * altId = "2000000090092"
  * name = "Martina Musterarzt"
  * requestor = true
  * purposeOfUse = $purposeOfUse#NORM "Normal Access"


// Rules for an entity representing a patient
RuleSet: ChExampleAuditEventEntityPatientRules
* entity[patient]
  * what.identifier
    * value = "761337610411353650"
    * system = "urn:oid:2.16.756.5.30.1.127.3.10.3"
  * type = $auditEntityType#1 "Person"
  * role = $objectRole#1 "Patient"


// Rules for an extended token for a patient
RuleSet: ChExampleAuditEventPatRules
* agent[mainUser]
  * role = $healthDossierRole#PAT "Patient"
  * altId = "761337610411353650"
  * name = "Franziska Muster"
  * requestor = true
  * purposeOfUse = $purposeOfUse#NORM "Normal Access"


// Rules for an extended token for an assistant acting on behalf of a healthcare professional: the healthcare
// professional (principal) is the main user, the assistant is the delegated user
RuleSet: ChExampleAuditEventAssRules
* agent[mainUser]
  * role = $healthDossierRole#HCP "Healthcare professional"
  * altId = "2000000090092"
  * name = "Martina Musterarzt"
  * requestor = false
  * purposeOfUse = $purposeOfUse#NORM "Normal Access"
* agent[delegatedUser]
  * type = $v3ParticipationType#PPRF "primary performer"
  * role = $healthDossierRole#ASS "Assistant"
  * altId = "2000000090108"
  * name = "Dagmar Musterassistent"
  * requestor = true


// Rules for an extended token for a technical user (clinical archive system)
RuleSet: ChExampleAuditEventTcuRules
* agent[mainUser]
  * role = $healthDossierRole#TCU "Technical user"
  * altId = "7601000201041"
  * name = "Clinical archive system Spital X"
  * requestor = true
  * purposeOfUse = $purposeOfUse#AUTO "Automatic Upload"


// Rules for the institution or group on whose behalf the main user acts
RuleSet: ChExampleAuditEventGroupRules(oid, name)
* agent[group]
  * type = $v3RoleClass#PROV "healthcare provider"
  * role = $ehealthAgentRole#GRP "Group"
  * who.identifier.system = "urn:ietf:rfc:3986"
  * who.identifier.value = "urn:oid:{oid}"
  * name = "{name}"
  * requestor = false


// Rules for an entity representing a document, the slice type and role have to be set in the example
RuleSet: ChExampleAuditEventEntityDocumentRules(slice, uniqueId)
* entity[{slice}]
  * what.identifier.system = "urn:ietf:rfc:3986"
  * what.identifier.value = "urn:oid:{uniqueId}"
