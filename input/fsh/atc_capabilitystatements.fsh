Instance: CH.ATC.PatientAuditRecordService
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditRecordService"
* name = "CH_ATC_PatientAuditRecordService"
* title = "CH:ATC Patient Audit Record Service (server)"
* status = #active
* date = "2026-10-22"
* description = "Defines the CapabilityStatement for the Patient Audit Record Service actor of ITI-81."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #server
* rest.resource.type = #AuditEvent
* rest.resource.supportedProfile = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ChAuditTrailEvent"
* rest.resource.documentation = "For Retrieve ATNA Audit Event [ITI-81]. The server SHALL support the _sort result parameter on date, in ascending (_sort=date) and descending (_sort=-date) order (CP-ITI-1334)."
* rest.resource.interaction.code = #search-type
* rest.resource.interaction.documentation = "ITI-81: the search parameters are evaluated on the masked audit events"
* rest.resource.searchParam[0].name = "date"
* rest.resource.searchParam[=].type = #date
* rest.resource.searchParam[+].name = "agent.identifier"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "entity.identifier"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "entity-type"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "entity-role"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "subtype"
* rest.resource.searchParam[=].type = #token

Instance: CH.ATC.PatientAuditConsumer
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditConsumer"
* name = "CH_ATC_PatientAuditConsumer"
* title = "CH:ATC Patient Audit Consumer (client)"
* status = #active
* date = "2026-10-22"
* description = "Defines the CapabilityStatement for the Patient Audit Consumer actor of ITI-81."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #client
* rest.documentation = "The Patient Audit Consumer initiates the Retrieve ATNA Audit Event [ITI-81] transaction with the Retrieve Audit Message Option to retrieve the audit trail of a health dossier from the Patient Audit Record Service."
* rest.resource.type = #AuditEvent
* rest.resource.supportedProfile = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ChAuditTrailEvent"
* rest.resource.documentation = "For Retrieve ATNA Audit Event [ITI-81]. The Patient Audit Consumer MAY use the _sort result parameter on date; when it relies on a specific order of the audit events, it SHALL request it with _sort."
* rest.resource.interaction.code = #search-type
* rest.resource.interaction.documentation = "ITI-81"
* rest.resource.searchParam[0].name = "date"
* rest.resource.searchParam[=].type = #date
* rest.resource.searchParam[+].name = "agent.identifier"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "entity.identifier"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[=].documentation = "SHALL be included in every query and SHALL carry the EPR-SPID of the holder."
* rest.resource.searchParam[+].name = "entity-type"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "entity-role"
* rest.resource.searchParam[=].type = #token
* rest.resource.searchParam[+].name = "subtype"
* rest.resource.searchParam[=].type = #token
