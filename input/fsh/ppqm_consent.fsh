// CH:PPQm Consent profiles.
//
// TODO: remove before publishing. The titles of the profiles carry the consent number (C1-C13) of the working note
// ppqm-egd-analysis.md, for the review of the consent types.
//
// One base profile and one derived profile per consent type of the electronic health dossier (E-GD), see the
// CodeSystem HealthDossierConsentType. The Consent describes the decision of the holder per use case; how a serving
// actor derives an access decision from it (XACML policy sets, database rows or anything else) is out of scope.

RuleSet: PpqmIdentifierOnlyReference(path)
* {path}.reference 0..0
* {path}.identifier 1..1
* {path}.identifier.use 0..0
* {path}.identifier.type 1..1
* {path}.identifier.type.coding 1..1
* {path}.identifier.type.coding from PpqmActorIdentifierType (required)
* {path}.identifier.type.coding ^short = "Identifier type (name qualifier), as the user_id_qualifier of the access token"
* {path}.identifier.type.coding.system 1..1
* {path}.identifier.type.coding.version 0..0
* {path}.identifier.type.coding.code 1..1
* {path}.identifier.type.coding.userSelected 0..0
* {path}.identifier.type.text 0..0
* {path}.identifier.value 1..1
* {path}.identifier.period 0..0
* {path}.identifier.assigner 0..0
* {path}.display 0..1


Profile: ChPpqmConsent
Parent: Consent
Id: ch-ppqm-consent
Title: "CH PPQm Consent"
Description: "Base profile of a consent of the electronic health dossier (E-GD). A Consent records one decision of the
holder, or of a person acting for the holder, for one consent type (`category`). Every Consent SHALL conform to the
profile of its consent type."
* obeys ch-ppqm-consent-type-profile

* identifier                1..1
* identifier                ^short = "Business identifier of the consent, a UUID in URN format. PPQ-3 updates and deletes a consent by this identifier."
* identifier.use            0..0
* identifier.type           0..0
* identifier.system         1..1
* identifier.system         = "urn:ietf:rfc:3986"
* identifier.value          1..1
* identifier.value          obeys ch-ppqm-uuid-format
* identifier.period         0..0
* identifier.assigner       0..0

* status        = #active
* status ^short = "Fixed status value. A consent is revoked by deleting it, and expires at the end of provision.period."

* scope         = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* scope ^short  = "Fixed scope value"
* scope.coding  1..1

* category                  1..1
* category                  from HealthDossierConsentTypeVS (required)
* category                  ^short = "The consent type"
* category.coding           1..1
* category.coding.system    1..1
* category.coding.code      1..1

* patient                       1..1
* patient.reference             0..0
* patient.identifier            1..1
* patient.identifier            only EPRSPIDIdentifier
* patient.identifier.use        0..0
* patient.identifier.type       0..0
* patient.identifier.period     0..0
* patient.identifier.assigner   0..0
* patient.display               0..0

* dateTime          1..1
* dateTime          ^short = "When the consent was given"

* performer         1..1
* performer         only Reference(Patient or RelatedPerson or Practitioner or Organization)
* performer         ^short = "Who took the decision: the holder, a representative, a legal representative, a health professional or an organization"
* insert PpqmIdentifierOnlyReference(performer)

* organization              0..1
* organization              ^short = "The community managing the health dossier"
* organization.reference    0..0
* organization.identifier   1..1
* organization.identifier   only OidIdentifier

* source[x]         0..1
* source[x]         only Attachment or Reference(Consent or DocumentReference)
* source[x]         ^short = "Evidence of the consent, or the consent the right is derived from"

* policy            1..1
* policy            ^short = "The rules of the consent type"
* policy.authority  0..0
* policy.uri        1..1
* policy.uri        ^short = "The canonical URL of the profile of the consent type, which defines its rules"
* policyRule        0..0

* verification      0..1

* provision                 1..1
* provision.type            1..1
* provision.period          0..1
* provision.period          ^short = "Validity of the consent. No period means valid until revoked."
* provision.period.start    0..1
* provision.period.start    ^short = "Start date of the validity, yyyy-mm-dd"
* provision.period.start    obeys ch-ppqm-date-format
* provision.period.end      0..1
* provision.period.end      ^short = "End date of the validity, yyyy-mm-dd"
* provision.period.end      obeys ch-ppqm-date-format

* provision.actor                       0..1
* provision.actor                       ^short = "The grantee. No actor means the provision applies to all health professionals and health institutions."
* provision.actor.role                  from HealthDossierConsentActorRole (required)
* provision.actor.role.coding           1..1
* provision.actor.role.coding.system    1..1
* provision.actor.role.coding.code      1..1
* provision.actor.reference             only Reference(Patient or RelatedPerson or Practitioner or Organization or Device)
* insert PpqmIdentifierOnlyReference(provision.actor.reference)

* provision.action                  from HealthDossierConsentActionVS (required)
* provision.action.coding           1..1
* provision.securityLabel           from HealthDossierConfidentialityCode (required)
* provision.securityLabel           ^short = "The confidentiality levels the grantee may read"
* provision.purpose                 from HealthDossierConsentPurposeOfUse (required)
* provision.class                   0..0
* provision.code                    0..0
* provision.dataPeriod              0..0
* provision.data                    0..0

* provision.provision                       0..*
* provision.provision                       ^short = "Documents of the confidentiality level 'privat' the holder releases to the grantee"
* provision.provision.type                  1..1
* provision.provision.type                  = #permit
* provision.provision.period                0..0
* provision.provision.actor                 0..0
* provision.provision.action                0..0
* provision.provision.securityLabel         0..0
* provision.provision.purpose               0..0
* provision.provision.class                 0..0
* provision.provision.code                  0..0
* provision.provision.dataPeriod            0..0
* provision.provision.data                  1..*
* provision.provision.data.meaning          = #instance
* provision.provision.data.reference        only Reference(DocumentReference)
* provision.provision.provision             0..0


Invariant:      ch-ppqm-consent-type-profile
Description:    "The Consent SHALL conform to the profile of its consent type"
Expression:     "conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-opening') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-emergency-access') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-access') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization-setting') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-delegation') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-representative') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-legal-representative') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-digital-health-application') or
                 conformsTo('http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-military-recording')"
Severity:       #error

Invariant:      ch-ppqm-uuid-format
Description:    "The value SHALL be a UUID in URN format"
Expression:     "lower().matches('^urn:uuid:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')"
Severity:       #error

Invariant:      ch-ppqm-date-format
Description:    "Timestamp must have precision of days, i.e. not contain the time part"
Expression:     "toString().matches('^[0-9]{4}-[0-9]{2}-[0-9]{2}$')"
Severity:       #error

Invariant:      ch-ppqm-grantee-hcp
Description:    "The grantee SHALL be a health professional (GLN) or a group or health institution (organization ID in URN format)"
Expression:     "identifier.type.coding.where(code = 'urn:gs1:gln').exists() or
                 (identifier.type.coding.where(code = 'urn:oasis:names:tc:xspa:1.0:subject:organization-id').exists() and identifier.value.lower().matches('^urn:oid:([0-2])((\\\\.0)|(\\\\.[1-9][0-9]*))*$'))"
Severity:       #error

Invariant:      ch-ppqm-representative-id
Description:    "The representative SHALL be identified by a representative ID without spaces"
Expression:     "identifier.type.coding.where(code = 'urn:e-health-suisse:representative-id').exists() and identifier.value.matches('^\\\\S+$')"
Severity:       #error

Invariant:      ch-ppqm-performer-is-patient
Description:    "The performer SHALL be the holder of the health dossier"
Expression:     "performer.identifier.where(type.coding.where(code = 'urn:e-health-suisse:2015:epr-spid').exists() and value = %resource.patient.identifier.value).exists()"
Severity:       #error

Invariant:      ch-ppqm-read-levels
Description:    "The confidentiality levels SHALL be given if and only if the right to read documents is granted"
Expression:     "action.coding.where(code = 'read').exists() = securityLabel.exists()"
Severity:       #error


// ---------------------------------------------------------------------------------------------------------------------
// C1: opening

Profile: ChPpqmConsentOpening
Parent: ChPpqmConsent
Id: ch-ppqm-consent-opening
Title: "CH PPQm Consent: Opening (C1)"
Description: "Opening of the health dossier (Art. 20-22 EGDG). Documents that the health dossier was opened, either
automatically by the canton without objection of the holder, or voluntarily with the explicit consent of the holder.
Grants the holder full access to the health dossier (Art. 11 para. 1 EGDG). The rights by law of health
professionals, health institutions and the community follow from the existence of this consent."
* category = HealthDossierConsentType#opening
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-opening"
* performer only Reference(Patient or RelatedPerson or Organization)
* performer ^short = "The holder or the legal representative for a voluntary opening, the canton or the community for an automatic opening"
* organization 1..1
* source[x] 0..0
* verification 0..0
* provision.type = #permit
* provision.period 0..0
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#PAT
* provision.actor.reference only Reference(Patient)
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:2015:epr-spid
* provision.action 0..0
* provision.securityLabel 0..0
* provision.purpose 0..0
* provision.provision 0..0
* obeys ch-ppqm-actor-is-patient

Invariant:      ch-ppqm-actor-is-patient
Description:    "The grantee SHALL be the holder of the health dossier"
Expression:     "provision.actor.reference.identifier.where(value = %resource.patient.identifier.value).exists()"
Severity:       #error


// ---------------------------------------------------------------------------------------------------------------------
// C2: emergency access

Profile: ChPpqmConsentEmergencyAccess
Parent: ChPpqmConsent
Id: ch-ppqm-consent-emergency-access
Title: "CH PPQm Consent: Emergency Access (C2)"
Description: "Emergency access setting (Art. 11 para. 2 let. b, Art. 13 para. 3 EGDG). Created with type permit when
the health dossier is opened: all health professionals and health institutions may read documents of the
confidentiality level 'allgemein' with the purpose of use emergency. The holder excludes emergency access by updating
the type to deny, and allows it again by updating the type to permit."
* category = HealthDossierConsentType#emergency-access
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-emergency-access"
* performer only Reference(Patient or RelatedPerson or Organization)
* source[x] 0..0
* verification 0..0
* provision.type ^short = "permit: emergency access is allowed | deny: emergency access is excluded"
* provision.period 0..0
* provision.actor 0..0
* provision.action 1..1
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel 1..1
* provision.securityLabel = $sct#17621005
* provision.purpose 1..1
* provision.purpose = $purposeOfUse#EMER
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C3, C4: access for a health professional, a group or a health institution

Profile: ChPpqmConsentAccess
Parent: ChPpqmConsent
Id: ch-ppqm-consent-access
Title: "CH PPQm Consent: Access for a Health Professional, Group or Health Institution (C3, C4)"
Description: "The holder grants a health professional, a group of health professionals or a health institution the
right to read the documents of the confidentiality level 'allgemein' (Art. 11 para. 2 let. a, Art. 13 para. 1 EGDG),
optionally for a limited period and with the right to pass it on. Every health professional and assistant registered
in the directory as member of a group or health institution inherits the right of the group or institution. Documents
of the confidentiality level 'privat' are released individually in nested provisions."
* category = HealthDossierConsentType#access
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-access"
* performer only Reference(Patient or RelatedPerson)
* performer ^short = "The holder or the legal representative"
* source[x] 0..0
* verification 0..0
* provision.type = #permit
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference only Reference(Practitioner or Organization)
* provision.actor.reference obeys ch-ppqm-grantee-hcp
* provision.action 1..2
* provision.action from HealthDossierConsentAccessAction (required)
* provision.action ^short = "read, and delegate if the grantee may pass on the access right"
* provision obeys ch-ppqm-access-read
* provision.securityLabel 1..1
* provision.securityLabel = $sct#17621005
* provision.purpose 1..1
* provision.purpose = $purposeOfUse#NORM

Invariant:      ch-ppqm-access-read
Description:    "The right to read documents SHALL be granted"
Expression:     "action.coding.where(code = 'read').exists()"
Severity:       #error


// ---------------------------------------------------------------------------------------------------------------------
// C5: indirect authorization

Profile: ChPpqmConsentIndirectAuthorization
Parent: ChPpqmConsent
Id: ch-ppqm-consent-indirect-authorization
Title: "CH PPQm Consent: Indirect Authorization (C5)"
Description: "A health professional or health institution confirms in the health dossier the consent the holder gave
outside the health dossier, e.g. orally in a practice (Art. 11 para. 3, Art. 13 para. 2 EGDG). Recorded by the health
professional or an assistant. The grantee is the health professional, group or health institution the consent was
given to, not the assistant who records it. Grants the right to read the documents of the confidentiality level
'allgemein'. The consent SHALL carry evidence, as an attachment, a document or a verification with the holder."
* category = HealthDossierConsentType#indirect-authorization
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization"
* performer only Reference(Patient)
* performer ^short = "The holder who gave the consent outside the health dossier"
* obeys ch-ppqm-performer-is-patient
* dateTime ^short = "When the holder gave the consent"
* source[x] only Attachment or Reference(DocumentReference)
* source[x] ^short = "Evidence of the consent, e.g. a scan of the signed form or the signature captured on a tablet"
* verification ^short = "Verification of the consent with the holder, e.g. with a one-time code"
* obeys ch-ppqm-indirect-evidence
* provision.type = #permit
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference only Reference(Practitioner or Organization)
* provision.actor.reference obeys ch-ppqm-grantee-hcp
* provision.action 1..1
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel 1..1
* provision.securityLabel = $sct#17621005
* provision.purpose 1..1
* provision.purpose = $purposeOfUse#NORM
* provision.provision 0..0

Invariant:      ch-ppqm-indirect-evidence
Description:    "The consent SHALL carry evidence (source or verification)"
Expression:     "source.exists() or verification.exists()"
Severity:       #error


// ---------------------------------------------------------------------------------------------------------------------
// C6: indirect authorization setting

Profile: ChPpqmConsentIndirectAuthorizationSetting
Parent: ChPpqmConsent
Id: ch-ppqm-consent-indirect-authorization-setting
Title: "CH PPQm Consent: Indirect Authorization Setting (C6)"
Description: "Indirect authorization setting (Art. 11 para. 3 EGDG). Created with type permit when the health dossier
is opened: health professionals and health institutions may confirm a consent the holder gave outside the health
dossier (indirect authorization). The holder excludes the indirect authorization by updating the type to deny, and
allows it again by updating the type to permit."
* category = HealthDossierConsentType#indirect-authorization-setting
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization-setting"
* performer only Reference(Patient or RelatedPerson or Organization)
* source[x] 0..0
* verification 0..0
* provision.type ^short = "permit: indirect authorization is allowed | deny: indirect authorization is excluded"
* provision.period 0..0
* provision.actor 0..0
* provision.action 0..0
* provision.securityLabel 0..0
* provision.purpose 0..0
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C7: delegation

Profile: ChPpqmConsentDelegation
Parent: ChPpqmConsent
Id: ch-ppqm-consent-delegation
Title: "CH PPQm Consent: Delegation (C7)"
Description: "A health professional, group or health institution holding an access right with the right to pass it on
passes the right to read the documents of the confidentiality level 'allgemein' on to another health professional,
group or health institution, e.g. for a second opinion. The delegation references the access right it is derived
from, and its end date SHALL NOT be later than the end date of that access right."
* category = HealthDossierConsentType#delegation
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-delegation"
* performer only Reference(Practitioner or Organization)
* performer ^short = "The health professional, group or health institution passing on the access right"
* performer obeys ch-ppqm-grantee-hcp
* source[x] 1..1
* source[x] only Reference(Consent)
* source[x] ^short = "The access right the delegation is derived from"
* sourceReference.identifier 1..1
* sourceReference.identifier ^short = "The business identifier of the access right the delegation is derived from"
* sourceReference.identifier.system 1..1
* sourceReference.identifier.system = "urn:ietf:rfc:3986"
* sourceReference.identifier.value 1..1
* sourceReference.identifier.value obeys ch-ppqm-uuid-format
* verification 0..0
* provision.type = #permit
* provision.period 1..1
* provision.period.end 1..1
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference only Reference(Practitioner or Organization)
* provision.actor.reference obeys ch-ppqm-grantee-hcp
* provision.action 1..1
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel 1..1
* provision.securityLabel = $sct#17621005
* provision.purpose 1..1
* provision.purpose = $purposeOfUse#NORM
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C8: representative

Profile: ChPpqmConsentRepresentative
Parent: ChPpqmConsent
Id: ch-ppqm-consent-representative
Title: "CH PPQm Consent: Representative (C8)"
Description: "The holder appoints a representative and sets the representative's rights (Art. 11 para. 5 EGDG): the
confidentiality levels the representative may read, and the further actions the representative may take. A
representative may always view the directory of health professionals and health institutions and the personal data
of the holder in the index of holders. A legal representative may not appoint a representative (Art. 12 para. 1
EGDG)."
* category = HealthDossierConsentType#representative
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-representative"
* performer only Reference(Patient)
* performer ^short = "The holder"
* obeys ch-ppqm-performer-is-patient
* source[x] only Attachment or Reference(DocumentReference)
* source[x] ^short = "The mandate, where the representative is appointed by the administration on behalf of the holder"
* verification 0..0
* provision.type = #permit
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#REP
* provision.actor.reference only Reference(RelatedPerson)
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:representative-id
* provision.actor.reference obeys ch-ppqm-representative-id
* provision.action from HealthDossierConsentRepresentativeAction (required)
* provision.securityLabel 0..2
* provision obeys ch-ppqm-read-levels
* provision.purpose 0..0
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C9: legal representative

Profile: ChPpqmConsentLegalRepresentative
Parent: ChPpqmConsent
Id: ch-ppqm-consent-legal-representative
Title: "CH PPQm Consent: Legal Representative (C9)"
Description: "A legal representative exercises the rights of the holder (Art. 12 EGDG). Recorded by the administration
of the community on the instruction of the competent authority, never by the holder. The legal representative has
all rights of the holder, except appointing a representative; the rights follow from the law and are not listed in the
consent. When a legal representative is set up, the access rights of the holder are revoked and all consents the
holder recorded are deleted."
* category = HealthDossierConsentType#legal-representative
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-legal-representative"
* performer only Reference(Organization)
* performer ^short = "The community or the authority that set up the legal representation"
* performer.identifier.type.coding = $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id
* source[x] only Attachment or Reference(DocumentReference)
* source[x] ^short = "The instruction of the competent authority"
* verification 0..0
* provision.type = #permit
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#LEGREP
* provision.actor.reference only Reference(RelatedPerson)
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:representative-id
* provision.actor.reference obeys ch-ppqm-representative-id
* provision.action 0..0
* provision.securityLabel 0..0
* provision.purpose 0..0
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C10: digital health application

Profile: ChPpqmConsentDigitalHealthApplication
Parent: ChPpqmConsent
Id: ch-ppqm-consent-digital-health-application
Title: "CH PPQm Consent: Digital Health Application (C10)"
Description: "The holder authorizes an admitted digital health application to access the health dossier on the
holder's behalf for a chosen period (Art. 11 para. 2 let. c, Art. 16 EGDG). The actions granted are the scopes the
IUA Authorization Server may issue to the application, which acts as client of the authenticated holder. The
authorization is revoked automatically after three months of inactivity."
* category = HealthDossierConsentType#digital-health-application
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-digital-health-application"
* performer only Reference(Patient or RelatedPerson)
* performer ^short = "The holder or the legal representative"
* source[x] 0..0
* verification 0..0
* provision.type = #permit
* provision.period 1..1
* provision.period.end 1..1
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#PAT
* provision.actor.role ^short = "The application acts for the holder"
* provision.actor.reference only Reference(Device)
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:dga-client-id
* provision.actor.reference.identifier.value ^short = "The client_id the application is registered with at the IUA Authorization Server"
* provision.action 1..*
* provision.action from HealthDossierConsentDigitalHealthApplicationAction (required)
* provision.securityLabel 0..2
* provision obeys ch-ppqm-read-levels
* provision.purpose 0..0
* provision.provision 0..0


// ---------------------------------------------------------------------------------------------------------------------
// C13: recording by military health professionals

Profile: ChPpqmConsentMilitaryRecording
Parent: ChPpqmConsent
Id: ch-ppqm-consent-military-recording
Title: "CH PPQm Consent: Recording by Military Health Professionals (C13)"
Description: "The holder consents that a military health professional or health institution records data in the
health dossier (Art. 14 para. 2 EGDG). Unlike civilian health professionals, military health professionals may record
data only with this consent. The consent grants no right to read; reading follows from an access right."
* category = HealthDossierConsentType#military-recording
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-military-recording"
* performer only Reference(Patient or RelatedPerson)
* performer ^short = "The holder or the legal representative"
* source[x] 0..0
* verification 0..0
* provision.type = #permit
* provision.actor 1..1
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference only Reference(Practitioner or Organization)
* provision.actor.reference obeys ch-ppqm-grantee-hcp
* provision.action 1..1
* provision.action = HealthDossierConsentAction#record
* provision.securityLabel 0..0
* provision.purpose 0..0
* provision.provision 0..0
