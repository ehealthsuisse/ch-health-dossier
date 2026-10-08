// ---------------------------------------------------------------------------------------------------------------------
// ITI-81: the access to the audit trail, recorded by the Patient Audit Consumer and the Patient Audit Record Repository.
// The audit event of the Patient Audit Record Repository is part of the audit trail of the patient (ATC_LOG_READ) and
// replaces the Access Audit Trail Content Profile of CH:ATC.
Profile:     ChAuditEventIti81Consumer
Parent:      PatientQuery
Title:       "CH Audit Event for [ITI-81] Patient Audit Consumer"
Description: "This profile is used to define the CH Audit Event for the [ITI-81] transaction and the actor 'Patient
Audit Consumer'."
* insert ChAuditEventIti81Rules
* insert ChAuditEventTypeCodeRules(0, ATC_LOG_READ, Accessing the Patient Audit Record Repository)


Profile:     ChAuditEventIti81Repository
Parent:      PatientQuery
Title:       "CH Audit Event for [ITI-81] Patient Audit Record Repository"
Description: "This profile is used to define the CH Audit Event for the [ITI-81] transaction and the actor 'Patient
Audit Record Repository'. It records the access to the audit trail of a patient and is returned in the audit trail
with the type ATC_LOG_READ."
* insert ChAuditEventIti81Rules
* insert ChAuditEventTypeCodeRules(1, ATC_LOG_READ, Accessing the Patient Audit Record Repository)


RuleSet: ChAuditEventIti81Rules
* insert ChAuditEventExtendedRules
* agent[client] ^short = "The 'Patient Audit Consumer' actor"
* agent[server] ^short = "The 'Patient Audit Record Repository' actor (Health Dossier API)"
* subtype contains iti81 1..1
* subtype[iti81] = $eventTypeCode#ITI-81 "Retrieve ATNA Audit Event"
* entity[query] ^short = "The audit event query"
* entity[patient] ^short = "The patient whose audit trail was retrieved"


Instance:   ChAuditEventIti81ConsumerExample
InstanceOf: ChAuditEventIti81Consumer
Usage:      #example
Description: "Audit event of the Patient Audit Consumer: the patient retrieves the audit trail of their health dossier."
* insert ChAuditEventIti81ExampleRules
* insert ChExampleAuditEventClientRules


Instance:   ChAuditEventIti81RepositoryExample
InstanceOf: ChAuditEventIti81Repository
Usage:      #example
Description: "Audit event of the Patient Audit Record Repository: the patient retrieves the audit trail of their health
dossier."
* insert ChAuditEventIti81ExampleRules
* insert ChExampleAuditEventServerRules(Health Dossier)


RuleSet: ChAuditEventIti81ExampleRules
* insert ChExampleAuditEventBaseRules(client, server, Health Dossier)
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventEntityPatientRules
* type = $auditEventType#rest "Restful Operation"
* subtype[anySearch] = $restfulInteraction#search "search"
* subtype[iti81] = $eventTypeCode#ITI-81 "Retrieve ATNA Audit Event"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_LOG_READ "Accessing the Patient Audit Record Repository"
* agent[server].network.address = "http://example.com"
* entity[query]
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#24 "Query"
  // http://example.com/AuditEvent?entity.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&date=ge2026-01-01
  * query = "aHR0cDovL2V4YW1wbGUuY29tL0F1ZGl0RXZlbnQ/ZW50aXR5LmlkZW50aWZpZXI9dXJuOm9pZDoyLjE2Ljc1Ni41LjMwLjEuMTI3LjMuMTAuM3w3NjEzMzc2MTA0MTEzNTM2NTAmZGF0ZT1nZTIwMjYtMDEtMDE="

// ---------------------------------------------------------------------------------------------------------------------
// ITI-81 response: the audit trail of a patient as returned by the Patient Audit Record Repository. Each audit event is
// derived from an audit event recorded by the actor serving a request, masked as described in the Expected Actions of
// ITI-81: the time reduced to the day, an assistant only with the role, without the technical details of the request,
// and only for successful requests.
ValueSet:    HealthDossierAuditTrailEventType
Id:          HealthDossierAuditTrailEventType
Title:       "CH Health Dossier Audit Trail Event Type"
Description: "All types of events in the audit trail of an electronic health dossier."
* ^experimental = false
* include codes from system HealthDossierAuditEventType


Profile:     ChAuditTrailEvent
Parent:      AuditEvent
Id:          ChAuditTrailEvent
Title:       "CH Audit Trail Event"
Description: "An audit event of the audit trail of a patient, as returned by the Patient Audit Record Repository with
Retrieve ATNA Audit Event [ITI-81]. It is derived from an audit event recorded by the actor serving a request and
masked: the time is reduced to the day, an assistant is only identified by the role, and the technical details of the
request are not returned."
* obeys ch-atc-recorded-day and ch-atc-period-day and ch-atc-patient and ch-atc-no-technical-entity
* meta.security ^slicing.discriminator.type = #value
* meta.security ^slicing.discriminator.path = "$this"
* meta.security ^slicing.rules = #open
* meta.security contains abstracted 1..1 and redacted 1..1
* meta.security[abstracted] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#ABSTRED "abstracted"
* meta.security[abstracted] ^short = "The time of the event is reduced to the day"
* meta.security[redacted] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#REDACTED "redacted"
* meta.security[redacted] ^short = "The identity of an assistant and the technical details of the request are removed"
* subtype ^slicing.discriminator.type = #value
* subtype ^slicing.discriminator.path = "$this"
* subtype ^slicing.rules = #open
* insert ChAuditEventTypeValueSetRules(1, 1, HealthDossierAuditTrailEventType)
* recorded ^short = "The start of the day of the event in Swiss local time (YYYY-MM-DDT00:00:00+01:00 or +02:00), not the time of the event"
* period 1..1
* period ^short = "The day of the event in Swiss local time"
* period.start 1..1
* period.start ^short = "The day of the event (YYYY-MM-DD)"
* period.end 1..1
* period.end ^short = "The day of the event (YYYY-MM-DD)"
* outcome 1..1
* outcome = #0
* outcome ^short = "Only successful requests are part of the audit trail"
* agent.network 0..0
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #closed
* agent ^short = "The user, the assistant, the group or the Policy Repository; the client and server systems are not returned"
* agent contains mainUser 0..1 and delegatedUser 0..1 and group 0..* and repository 0..1
* agent[mainUser]
  * ^short = "The responsible user: the patient, a representative, a legal representative, a healthcare professional, the administration or a technical user, or the healthcare professional on whose behalf an assistant acted"
  * type = $v3ParticipationType#RESP "responsible party"
  * role 1..1
  * altId 1..1
  * name 1..1
  * purposeOfUse 0..1
  * purposeOfUse from http://fhir.ch/ig/ch-term/ValueSet/EprPurposeOfUse
* agent[delegatedUser]
  * ^short = "An assistant who acted on behalf of the main user, only identified by the role"
  * type = $v3ParticipationType#PPRF "primary performer"
  * role 1..1
  * role = $healthDossierRole#ASS "Assistant"
  * who 0..0
  * altId 0..0
  * name 0..0
* agent[group]
  * ^short = "A health institution or group of healthcare professionals of the main user"
  * type = $v3RoleClass#PROV "healthcare provider"
  * role 1..1
  * role = $ehealthAgentRole#GRP "Group"
  * who 1..1
  * who.identifier 1..1
  * who.identifier only OidIdentifier
  * name 1..1
* agent[repository]
  * ^short = "The Policy Repository, which added or deleted a consent itself"
  * type = DCM#110150 "Application"
  * requestor = true
  * who 1..1
  * who.identifier 1..1
  * who.identifier only OidIdentifier
  * who.display 1..1
* source.site 1..1
* source.site ^short = "The OID of the health dossier"
* entity ^short = "The patient and the data concerned; the traceparent and the query of a search are not returned"


Invariant:   ch-atc-recorded-day
Description: "recorded is the start of a day in Swiss local time"
Expression:  "recorded.toString().matches('^[0-9]{4}-[0-9]{2}-[0-9]{2}T00:00:00([.]0+)?[+]0[12]:00$')"
Severity:    #error


Invariant:   ch-atc-period-day
Description: "period.start and period.end are the same day (YYYY-MM-DD), the day of recorded"
Expression:  "period.start.toString().length() = 10 and period.end.toString() = period.start.toString() and recorded.toString().substring(0, 10) = period.start.toString()"
Severity:    #error


Invariant:   ch-atc-patient
Description: "The patient is identified by the EPR-SPID"
Expression:  "entity.where(role.code = '1' and what.identifier.system = 'urn:oid:2.16.756.5.30.1.127.3.10.3').count() = 1"
Severity:    #error


Invariant:   ch-atc-no-technical-entity
Description: "The traceparent (Processing Element) and the query of a search are not returned"
Expression:  "entity.where(role.code = '24' or role.code = '26').empty()"
Severity:    #error


Profile:     ChAtcIti81Response
Parent:      Bundle
Id:          CH-ATC.ITI-81.Response
Title:       "Retrieve ATNA Audit Event [ITI-81] Response"
Description: "The response of the Patient Audit Record Repository to Retrieve ATNA Audit Event [ITI-81]: the audit trail
of a patient, masked to the day and without duplicates."
* type = #searchset
* entry.resource 1..1
* entry.resource only ChAuditTrailEvent or OperationOutcome


// Examples of the masked audit trail
RuleSet: ChAuditTrailEventExampleRules(day)
* meta.security[abstracted] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#ABSTRED "abstracted"
* meta.security[redacted] = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#REDACTED "redacted"
* recorded = "{day}T00:00:00+02:00"
* period.start = "{day}"
* period.end = "{day}"
* outcome = #0
* source
  * site = "2.16.756.4.5.6"
  * observer.display = "Health Dossier"
* entity[+]
  * what.identifier
    * system = "urn:oid:2.16.756.5.30.1.127.3.10.3"
    * value = "761337610411353650"
  * type = $auditEntityType#1 "Person"
  * role = $objectRole#1 "Patient"


RuleSet: ChAuditTrailEventHcpRules
* agent[mainUser]
  * type = $v3ParticipationType#RESP "responsible party"
  * role = $healthDossierRole#HCP "Healthcare professional"
  * altId = "2000000090092"
  * name = "Martina Musterarzt"
  * purposeOfUse = $purposeOfUse#NORM "Normal Access"
* agent[group]
  * type = $v3RoleClass#PROV "healthcare provider"
  * role = $ehealthAgentRole#GRP "Group"
  * who.identifier.system = "urn:ietf:rfc:3986"
  * who.identifier.value = "urn:oid:2.2.2.1"
  * name = "Praxis Seeblick"


RuleSet: ChAuditTrailEventPatRules
* agent[mainUser]
  * type = $v3ParticipationType#RESP "responsible party"
  * role = $healthDossierRole#PAT "Patient"
  * altId = "761337610411353650"
  * name = "Franziska Muster"
  * purposeOfUse = $purposeOfUse#NORM "Normal Access"


Instance:   ChAuditTrailEventDocCreateExample
InstanceOf: ChAuditTrailEvent
Usage:      #inline
* id = "7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e01"
* insert ChAuditTrailEventExampleRules(2026-10-05)
* insert ChAuditTrailEventHcpRules
* type = $auditEventType#rest "Restful Operation"
* subtype[+] = $eventTypeCode#ITI-65 "Provide Document Bundle"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* action = #C
* agent[mainUser].requestor = true
* agent[group].requestor = false
* entity[+]
  * what.identifier.system = "urn:ietf:rfc:3986"
  * what.identifier.value = "urn:oid:1.3.6.1.4.1.12559.11.13.2.1.2951"
  * type = $resourceTypes#DocumentReference "DocumentReference"
  * role = $objectRole#3 "Report"


Instance:   ChAuditTrailEventDocReadAssistantExample
InstanceOf: ChAuditTrailEvent
Usage:      #inline
* id = "7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e02"
* insert ChAuditTrailEventExampleRules(2026-10-06)
* insert ChAuditTrailEventHcpRules
* type = $auditEventType#rest "Restful Operation"
* subtype[+] = $eventTypeCode#ITI-68 "Retrieve Document"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_READ "Document retrieval"
* action = #R
* agent[mainUser].requestor = false
* agent[group].requestor = false
* agent[delegatedUser]
  * type = $v3ParticipationType#PPRF "primary performer"
  * role = $healthDossierRole#ASS "Assistant"
  * requestor = true
* entity[+]
  * what.identifier.system = "urn:ietf:rfc:3986"
  * what.identifier.value = "urn:oid:1.3.6.1.4.1.12559.11.13.2.1.2951"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#3 "Report"


Instance:   ChAuditTrailEventConsentUpdateExample
InstanceOf: ChAuditTrailEvent
Usage:      #inline
* id = "7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e03"
* insert ChAuditTrailEventExampleRules(2026-10-06)
* insert ChAuditTrailEventPatRules
* type = $auditEventType#rest "Restful Operation"
* subtype[+] = urn:e-health-suisse:event-type-code#PPQ-3 "Mobile Privacy Policy Feed"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_POL_DIS_EMER_USE "Disabling Emergency Access"
* action = #U
* agent[mainUser].requestor = true
* entity[+]
  * what.identifier.system = "urn:ietf:rfc:3986"
  * what.identifier.value = "urn:uuid:37eacb2e-33e7-4e9c-8a6d-6b55f19bd503"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#4 "Domain Resource"
  * detail[+].type = "consentType"
  * detail[=].valueString = "http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierConsentType|emergency-access"


Instance:   ChAuditTrailEventLogReadExample
InstanceOf: ChAuditTrailEvent
Usage:      #inline
* id = "7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e04"
* insert ChAuditTrailEventExampleRules(2026-10-07)
* insert ChAuditTrailEventPatRules
* type = $auditEventType#rest "Restful Operation"
* subtype[+] = $eventTypeCode#ITI-81 "Retrieve ATNA Audit Event"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_LOG_READ "Accessing the Patient Audit Record Repository"
* action = #E
* agent[mainUser].requestor = true


Instance:   ch-atc-iti-81-response-sample
InstanceOf: ChAtcIti81Response
Title:      "ITI-81 response: masked audit trail"
Description: "The audit trail of Franziska Muster, masked to the day: a document uploaded by a healthcare
professional, the document retrieved by an assistant on her behalf (only the role of the assistant), the emergency
access excluded by the patient, and an earlier access of the patient to the audit trail. The assistant retrieved the
document three times on that day; the duplicates are removed."
Usage:      #example
* type = #searchset
* total = 4
* link[+].relation = "self"
* link[=].url = "http://example.com/AuditEvent?entity.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&date=ge2026-10-01"
* entry[+].fullUrl = "http://example.com/AuditEvent/7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e01"
* entry[=].resource = ChAuditTrailEventDocCreateExample
* entry[=].search.mode = #match
* entry[+].fullUrl = "http://example.com/AuditEvent/7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e02"
* entry[=].resource = ChAuditTrailEventDocReadAssistantExample
* entry[=].search.mode = #match
* entry[+].fullUrl = "http://example.com/AuditEvent/7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e03"
* entry[=].resource = ChAuditTrailEventConsentUpdateExample
* entry[=].search.mode = #match
* entry[+].fullUrl = "http://example.com/AuditEvent/7b3d0a7e-1c1b-4f3e-9a55-2d1f0c6c8e04"
* entry[=].resource = ChAuditTrailEventLogReadExample
* entry[=].search.mode = #match
