// PPQ-3
//
// The audit events of PPQ-3 carry the type of the event in the audit trail of the patient as an additional subtype,
// and record the consent with its type, its grantee and the end of its validity, so that the audit trail of the
// patient can be built from the audit events of the Policy Repository. The profiles are shared by the Policy Source and
// the Policy Repository: the Policy Repository SHALL record the type of the event, the Policy Source MAY record it.

Profile:     ChAuditEventPpq3Create
Parent:      PatientCreate
Title:       "CH Audit Event for [PPQ-3] Create privacy policy"
Description: "This profile is used to define the CH Audit Event for the [PPQ-3] transaction and the actors 'Policy
Source' and 'Policy Repository' when adding a consent."
* insert ChAuditEventPpq3Rules
* insert ChAuditEventTypeValueSetRules(0, 1, HealthDossierAddConsentAuditEventType)


Profile:     ChAuditEventPpq3Update
Parent:      PatientUpdate
Title:       "CH Audit Event for [PPQ-3] Update privacy policy"
Description: "This profile is used to define the CH Audit Event for the [PPQ-3] transaction and the actors 'Policy
Source' and 'Policy Repository' when updating a consent."
* insert ChAuditEventPpq3Rules
* subtype[anyUpdate] = $restfulInteraction#update "update"
* insert ChAuditEventTypeValueSetRules(0, 1, HealthDossierUpdateConsentAuditEventType)


Profile:     ChAuditEventPpq3Delete
Parent:      PatientDelete
Title:       "CH Audit Event for [PPQ-3] Delete privacy policy"
Description: "This profile is used to define the CH Audit Event for the [PPQ-3] transaction and the actors 'Policy
Source' and 'Policy Repository' when deleting a consent, and for the Policy Repository when it deletes a consent
itself (Policy Repository rules)."
* insert ChAuditEventPpq3Rules
* insert ChAuditEventTypeCodeRules(0, ATC_POL_REMOVE_AUT_PART_AL, Remove authorization for participants to access level/date)


RuleSet: ChAuditEventPpq3Rules
* insert ChAuditEventExtendedRules
* agent[client] ^short = "The 'Policy Source' actor (EPR application)"
* agent[server] ^short = "The 'Policy Repository' actor (Health Dossier API)"
* subtype contains ppq3 1..1
* subtype[ppq3] = urn:e-health-suisse:event-type-code#PPQ-3 "Mobile Privacy Policy Feed"
* entity[data] ^short = "The consent being created, updated or deleted"
  * what.identifier 1..1
    * ^short = "The business identifier of the consent, Consent.identifier"
    * value 1..1
    * system 1..1
    * system = "urn:ietf:rfc:3986"
  // About the role: the CH:PPQ-1 profile specifies the role as "Security Resource" (13), but BALP currently only
  // allows 3, 4 and 20 for that slice.
  // https://profiles.ihe.net/ITI/BALP/1.1.4/ValueSet-RestObjectRoles.html
  * role = $objectRole#4 "Domain Resource"
  * name 0..1
  * name ^short = "The grantee as displayed, Consent.provision.actor.reference.display"
  * detail ^slicing.discriminator.type = #value
  * detail ^slicing.discriminator.path = "type"
  * detail ^slicing.rules = #open
  * detail contains consentType 1..1 and grantee 0..1 and validityEnd 0..1
  * detail[consentType].type = "consentType"
  * detail[consentType].value[x] only string
  * detail[consentType] ^short = "The consent type as system|code, Consent.category"
  * detail[grantee].type = "grantee"
  * detail[grantee].value[x] only string
  * detail[grantee] ^short = "The grantee as identifier type|value, Consent.provision.actor.reference.identifier"
  * detail[validityEnd].type = "validityEnd"
  * detail[validityEnd].value[x] only string
  * detail[validityEnd] ^short = "The end of the validity as yyyy-mm-dd, Consent.provision.period.end"
* entity[patient] ^short = "The patient whose consents are being managed"


Instance:   ChAuditEventPpq3CreateExample
InstanceOf: ChAuditEventPpq3Create
Title:      "Audit Event for [PPQ-3] Policy Source: indirect authorization recorded"
Description: "Audit event of the Policy Source: a health professional records the consent the patient gave orally at
the Auryn-Spital (indirect authorization)."
Usage:      #example
* insert ChAuditEventPpq3ExampleRules
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventClientRules
* insert ChExampleAuditEventBaseRules(client, server, Policy Repository)
* subtype[anyCreate] = $restfulInteraction#create "create"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_POL_CREATE_AUT_PART_AL "Authorize participants to access level/date"
* entity[data]
  * what.identifier.value = "urn:uuid:0c118fcf-4640-4613-9b4d-d75b31b3fa59"
  * name = "Auryn-Spital"
  * detail[consentType].valueString = "http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierConsentType|indirect-authorization"
  * detail[grantee].valueString = "urn:oasis:names:tc:xspa:1.0:subject:organization-id|urn:oid:2.16.10.89.201"
  * detail[validityEnd].valueString = "2026-12-31"


Instance:   ChAuditEventPpq3UpdateExample
InstanceOf: ChAuditEventPpq3Update
Title:      "Audit Event for [PPQ-3] Policy Repository: emergency access excluded"
Description: "Audit event of the Policy Repository: the patient excludes emergency access."
Usage:      #example
* insert ChAuditEventPpq3ExampleRules
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventServerRules(Policy Repository)
* insert ChExampleAuditEventBaseRules(client, server, Policy Repository)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_POL_DIS_EMER_USE "Disabling Emergency Access"
* entity[data]
  * what.identifier.value = "urn:uuid:37eacb2e-33e7-4e9c-8a6d-6b55f19bd503"
  * detail[consentType].valueString = "http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierConsentType|emergency-access"


Instance:   ChAuditEventPpq3DeleteExample
InstanceOf: ChAuditEventPpq3Delete
Title:      "Audit Event for [PPQ-3] Policy Source: access right revoked"
Description: "Audit event of the Policy Source: the patient revokes the access right of the Fuchur-Klinik."
Usage:      #example
* insert ChAuditEventPpq3ExampleRules
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventClientRules
* recorded = "2024-10-28T09:43:56Z"
* outcome = #0
* subtype[anyDelete] = $restfulInteraction#delete "delete"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_POL_REMOVE_AUT_PART_AL "Remove authorization for participants to access level/date"
* agent[client]
  * type = DCM#110150 "Application"
  * who.display = "My e-Health App"
  * requestor = false
  * network
    * address = "192.168.1.1"
    * type = #2
* agent[server]
  * type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#custodian "Custodian"
  * who.display = "Policy Repository"
  * requestor = false
  * network.type = #5 // The address needs to be define in each example (transaction specific)
* entity[traceparent]
  * what.identifier.value = "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00"
  * type = $auditEntityType#4 "Other"
  * role = $objectRole#26 "Processing Element"
* entity[data]
  * what.identifier.value = "urn:uuid:79761ad4-0630-4614-8ce6-e6451e158d78"
  * name = "Fuchur-Klinik"
  * detail[consentType].valueString = "http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierConsentType|access"
  * detail[grantee].valueString = "urn:oasis:names:tc:xspa:1.0:subject:organization-id|urn:oid:2.16.10.89.214"
  * detail[validityEnd].valueString = "2026-11-30"


RuleSet: ChAuditEventPpq3ExampleRules
* insert ChExampleAuditEventEntityPatientRules
* type = $auditEventType#rest "Restful Operation"
* subtype[ppq3] = urn:e-health-suisse:event-type-code#PPQ-3 "Mobile Privacy Policy Feed"
* agent[server].network.address = "http://example.com"
* entity[data]
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#4 "Domain Resource"
  * what.identifier.system = "urn:ietf:rfc:3986"
  * detail[consentType].type = "consentType"


// ---------------------------------------------------------------------------------------------------------------------
// PPQ-4
Instance:   ChAuditEventPpq4Example
InstanceOf: Bundle
Usage:      #example
* type = #batch
* entry[+]
  * resource = ChAuditEventPpq3CreateExample
  * request
    * method = #POST
    * url = "http://example.com/AuditEvent"
* entry[+]
  * resource = ChAuditEventPpq3UpdateExample
  * request
    * method = #POST
    * url = "http://example.com/AuditEvent"
* entry[+]
  * resource = ChAuditEventPpq3DeleteExample
  * request
    * method = #POST
    * url = "http://example.com/AuditEvent"


// ---------------------------------------------------------------------------------------------------------------------
// PPQ-5
Profile:     ChAuditEventPpq5Consumer
Parent:      PatientQuery
Title:       "CH Audit Event for [PPQ-5] Policy Consumer"
Description: "This profile is used to define the CH Audit Event for the [PPQ-5] transaction and the actor 'Policy
Consumer'."
* insert ChAuditEventPpq5Rules


Profile:     ChAuditEventPpq5Repository
Parent:      PatientQuery
Title:       "CH Audit Event for [PPQ-5] Policy Repository"
Description: "This profile is used to define the CH Audit Event for the [PPQ-5] transaction and the actor 'Policy
Repository'."
* insert ChAuditEventPpq5Rules


RuleSet: ChAuditEventPpq5Rules
* insert ChAuditEventExtendedRules
* agent[client] ^short = "The 'Policy Consumer' actor (EPR application)"
* agent[server] ^short = "The 'Policy Repository' actor (Health Dossier API)"
* subtype contains ppq5 1..1
* subtype[anySearch] = $restfulInteraction#search "search"
* subtype[ppq5] = urn:e-health-suisse:event-type-code#PPQ-5 "Mobile Privacy Policy Retrieve"
* entity[query] ^short = "The privacy policy query"
* entity[patient] ^short = "The patient whose privacy policies are being accessed"


Instance:   ChAuditEventPpq5ConsumerExample
InstanceOf: ChAuditEventPpq5Consumer
Usage:      #example
* insert ChAuditEventPpq5ExampleRules
* insert ChExampleAuditEventServerRules(Policy Repository)
* insert ChExampleAuditEventBaseRules(client, server, Policy Repository)


Instance:   ChAuditEventPpq5RepositoryExample
InstanceOf: ChAuditEventPpq5Repository
Usage:      #example
* insert ChAuditEventPpq5ExampleRules
* insert ChExampleAuditEventServerRules(Policy Repository)
* insert ChExampleAuditEventBaseRules(client, server, Policy Repository)


RuleSet: ChAuditEventPpq5ExampleRules
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventEntityPatientRules
* type = $auditEventType#rest "Restful Operation"
* subtype[ppq5] = urn:e-health-suisse:event-type-code#PPQ-5 "Mobile Privacy Policy Retrieve"
* subtype[anySearch] = $restfulInteraction#search "search"
* agent[server].network.address = "http://example.com"
* entity[query]
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#24 "Query"
  * query = "aHR0cHM6Ly9leGFtcGxlLm9yZy9maGlyL0NvbnNlbnQ/cGF0aWVudDppZGVudGlmaWVyPXVybjpvaWQ6Mi4xNi43NTYuNS4zMC4xLjEyNy4zLjEwLjN8NzYxMzM3NjEwNDExMzUzNjUw"