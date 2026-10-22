Instance: CH.PIXm.Manager
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Manager"
* name = "CH_PIXm_Manager"
* title = "PIXm Patient Identifier Cross-reference Manager (server)"
* status = #active
* date = "2026-07-15"
* description = "The Patient Identifier Cross-reference Manager allows a conditional update to revise contact information of an existing patient."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #server
* rest.documentation = "Patient Identifier Cross-reference Manager support for [ITI-104]."
* rest.security.cors = false
* rest.security.description = "TLS SHALL be used together with IUA basic access token"
* rest.resource.type = #Patient
* rest.resource.supportedProfile = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-pixm-patient-feed"
* rest.resource.interaction.code = #update
* rest.resource.interaction.documentation = "conditional update for [ITI-104]"
* rest.resource.conditionalUpdate = true

Instance: CH.PIXm.Source
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Source"
* name = "CH_PIXm_Source"
* title = "PIXm Patient Identity Source (client)"
* status = #active
* date = "2026-07-15"
* description = "The Patient Identity Source can do a conditional update to revise contact information of an existing patient."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #client
* rest.documentation = "Patient Identity Source support for [ITI-104]."
* rest.security.cors = false
* rest.security.description = "TLS SHALL be used together with IUA basic access token"
* rest.resource.type = #Patient
* rest.resource.supportedProfile = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-pixm-patient-feed"
* rest.resource.interaction.code = #update
* rest.resource.interaction.documentation = "conditional update for [ITI-104]"
* rest.resource.conditionalUpdate = true
