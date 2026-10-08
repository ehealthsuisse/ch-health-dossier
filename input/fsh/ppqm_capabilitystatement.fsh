// Server Actor
Instance: CH.PPQm.PolicyRepository
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicyRepository"
* name = "CH_PPQm_Policy_Repository"
* title = "PPQm Policy Repository (server)"
* status = #active
* experimental = false
* date = "2024-03-19"
* description = "CapabilityStatement for the Policy Repository actor in the CH:PPQm profile (server)."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #server
* rest.documentation = "CH:PPQm endpoints"
* rest.resource[+].type = #Consent
* rest.resource[=].interaction[+].code = #create                  // PPQ-3 POST
* rest.resource[=].interaction[=].documentation = "PPQ-3 POST — Add a consent"
* rest.resource[=].interaction[+].code = #search-type             // PPQ-5
* rest.resource[=].interaction[=].documentation = "PPQ-5 — Retrieve consents"
* rest.resource[=].conditionalUpdate = true                       // PPQ-3 PUT
* rest.resource[=].conditionalDelete = #single                    // PPQ-3 DELETE
* rest.resource[=].versioning = #no-version
* insert PpqmConsentResourceRules
* rest.resource[+].type = #Bundle
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/PpqmFeedRequestBundle"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/PpqmRetrieveResponseBundle"
* rest.interaction[+].code = #transaction
* rest.interaction[=].documentation = "Only the PPQ-4 transaction is supported."


// Client Actor
Instance: CH.PPQm.PolicySourceConsumer
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicySourceConsumer"
* name = "CH_PPQm_Policy_Source_Consumer"
* title = "PPQm Policy Source and Consumer (client)"
* status = #active
* experimental = false
* date = "2024-03-19"
* description = "CapabilityStatement for the Policy Source and Policy Consumer actors in the CH:PPQm profile (client)."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #client
* rest.documentation = "CH:PPQm endpoints"
* rest.resource[+].type = #Consent
* rest.resource[=].interaction[+].code = #create                  // PPQ-3 POST
* rest.resource[=].interaction[=].documentation = "PPQ-3 POST — Add a consent"
* rest.resource[=].interaction[+].code = #search-type             // PPQ-5
* rest.resource[=].interaction[=].documentation = "PPQ-5 — Retrieve consents"
* rest.resource[=].conditionalUpdate = true                       // PPQ-3 PUT
* rest.resource[=].conditionalDelete = #single                    // PPQ-3 DELETE
* rest.resource[=].versioning = #no-version
* insert PpqmConsentResourceRules
* rest.resource[+].type = #Bundle
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/PpqmFeedRequestBundle"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/PpqmRetrieveResponseBundle"
* rest.interaction[+].code = #transaction
* rest.interaction[=].documentation = "Only the PPQ-4 transaction is supported."

RuleSet: PpqmConsentResourceRules
* rest.resource[=].searchParam[+].name = "patient"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
* rest.resource[=].searchParam[=].type = #reference
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The patient (EPR-SPID), required, searched with the modifier :identifier"
* rest.resource[=].searchParam[+].name = "identifier"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-identifier"
* rest.resource[=].searchParam[=].type = #token
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The consent identifier"
* rest.resource[=].searchParam[+].name = "category"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Consent-category"
* rest.resource[=].searchParam[=].type = #token
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The consent type"
* rest.resource[=].searchParam[+].name = "actor"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Consent-actor"
* rest.resource[=].searchParam[=].type = #reference
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The grantee, searched with the modifier :identifier"
* rest.resource[=].searchParam[+].name = "period"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Consent-period"
* rest.resource[=].searchParam[=].type = #date
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The validity"
* rest.resource[=].searchParam[+].name = "source-reference"
* rest.resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Consent-source-reference"
* rest.resource[=].searchParam[=].type = #reference
* rest.resource[=].searchParam[=].documentation = "PPQ-5 — The delegations derived from an access right, searched with the modifier :identifier"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-opening"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-emergency-access"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-access"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization-setting"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-delegation"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-representative"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-legal-representative"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-digital-health-application"
* rest.resource[=].supportedProfile[+] = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-military-recording"
