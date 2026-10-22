Instance: CH.HealthDossier.API
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.HealthDossier.API"
* name = "CH_HealthDossier_API"
* title = "Health Dossier API (server)"
* status = #active
* date = "2020-07-08"
* description = "CapabilityStatement for Health Dossier API (server)."
* kind = #requirements
* imports[0] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Manager"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PDQm.Supplier"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentRecipient"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentResponder"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.Directory"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicyRepository"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATNA.AuditRecordRepository"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditRecordService"
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #server

Instance: CH.HealthDossier.App
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.HealthDossier.App"
* name = "CH_HealthDossier_App"
* title = "Health App (client)"
* status = #active
* date = "2020-07-08"
* description = "CapabilityStatement for Health App (client)."
* kind = #requirements
* imports[0] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PDQm.Consumer"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Source"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentSource"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentConsumer"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.QueryClient"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.DataSource"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicySourceConsumer"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATNA.AuditCreator"
* imports[+] = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditConsumer"
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest.mode = #client
