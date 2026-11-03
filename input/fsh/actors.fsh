// ActorDefinitions referenced by the conformance statements in the narrative (§id^actor:...§).
// IHE does not (yet) publish ActorDefinition resources for PIXm, PDQm, MHD, mCSD, IUA or ATNA, so the
// CH Health Dossier actors are defined here. If IHE publishes them, link them via derivedFrom.

RuleSet: CommonActor
* status = #active
* experimental = false
* type = #system

Instance: ch-pixm-source
InstanceOf: ActorDefinition
Title: "PIXm Patient Identity Source"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pixm-source"
* name = "CH_PIXm_Source"
* description = "The Patient Identity Source revises the contact information of an existing patient in the Swiss Health Dossier."
* documentation = "See [Patient Identity Feed FHIR [ITI-104]](iti-104.html) and [PIXm](iti-pixm.html)."
* reference = "https://profiles.ihe.net/ITI/PIXm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Source"

Instance: ch-pixm-manager
InstanceOf: ActorDefinition
Title: "PIXm Patient Identifier Cross-reference Manager"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pixm-manager"
* name = "CH_PIXm_Manager"
* description = "The Patient Identifier Cross-reference Manager manages the cross-referencing of patient identifiers and accepts revisions of the patient contact information in the Swiss Health Dossier."
* documentation = "See [Patient Identity Feed FHIR [ITI-104]](iti-104.html) and [PIXm](iti-pixm.html)."
* reference = "https://profiles.ihe.net/ITI/PIXm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Manager"

Instance: ch-pdqm-consumer
InstanceOf: ActorDefinition
Title: "PDQm Patient Demographics Consumer"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pdqm-consumer"
* name = "CH_PDQm_Consumer"
* description = "The Patient Demographics Consumer requests patients matching demographics from the Patient Demographics Supplier."
* documentation = "See [Patient Demographics Match [ITI-119]](iti-119.html) and [PDQm](iti-pdqm.html)."
* reference = "https://profiles.ihe.net/ITI/PDQm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PDQm.Consumer"

Instance: ch-pdqm-supplier
InstanceOf: ActorDefinition
Title: "PDQm Patient Demographics Supplier"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pdqm-supplier"
* name = "CH_PDQm_Supplier"
* description = "The Patient Demographics Supplier returns the patients matching the demographics provided by the Patient Demographics Consumer."
* documentation = "See [Patient Demographics Match [ITI-119]](iti-119.html) and [PDQm](iti-pdqm.html)."
* reference = "https://profiles.ihe.net/ITI/PDQm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PDQm.Supplier"

Instance: ch-mhd-source
InstanceOf: ActorDefinition
Title: "MHD Document Source"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mhd-source"
* name = "CH_MHD_DocumentSource"
* description = "The Document Source provides documents and their metadata to the Document Recipient, and updates or purges them."
* documentation = "See [MHD](iti-mhd.html), [ITI-65](iti-65.html), [CH:MHD-1](ch-mhd-1.html) and [CH:MHD-2](ch-mhd-2.html)."
* reference = "https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentSource"

Instance: ch-mhd-recipient
InstanceOf: ActorDefinition
Title: "MHD Document Recipient"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mhd-recipient"
* name = "CH_MHD_DocumentRecipient"
* description = "The Document Recipient receives documents and their metadata from the Document Source."
* documentation = "See [MHD](iti-mhd.html) and [ITI-65](iti-65.html)."
* reference = "https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentRecipient"

Instance: ch-mhd-consumer
InstanceOf: ActorDefinition
Title: "MHD Document Consumer"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mhd-consumer"
* name = "CH_MHD_DocumentConsumer"
* description = "The Document Consumer queries document metadata and retrieves documents from the Document Responder."
* documentation = "See [MHD](iti-mhd.html), [ITI-67](iti-67.html) and [ITI-68](iti-68.html)."
* reference = "https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentConsumer"

Instance: ch-mhd-responder
InstanceOf: ActorDefinition
Title: "MHD Document Responder"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mhd-responder"
* name = "CH_MHD_DocumentResponder"
* description = "The Document Responder returns document metadata and documents to the Document Consumer, and processes metadata updates and purges of the Document Source."
* documentation = "See [MHD](iti-mhd.html), [ITI-67](iti-67.html), [ITI-68](iti-68.html), [CH:MHD-1](ch-mhd-1.html) and [CH:MHD-2](ch-mhd-2.html)."
* reference = "https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.MHD.DocumentResponder"

Instance: ch-mcsd-query-client
InstanceOf: ActorDefinition
Title: "mCSD Query Client"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mcsd-query-client"
* name = "CH_mCSD_QueryClient"
* description = "The Query Client queries the Care Services Selective Supplier (Directory) for care services resources."
* documentation = "See [mCSD](iti-mcsd.html) and [ITI-90](iti-90.html)."
* reference = "https://profiles.ihe.net/ITI/mCSD/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.QueryClient"

Instance: ch-mcsd-directory
InstanceOf: ActorDefinition
Title: "mCSD Directory"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mcsd-directory"
* name = "CH_mCSD_Directory"
* description = "The Directory (Care Services Selective Supplier and Update Consumer) provides and maintains the care services resources of the Swiss Health Dossier."
* documentation = "See [mCSD](iti-mcsd.html), [ITI-90](iti-90.html) and [ITI-130](iti-130.html)."
* reference = "https://profiles.ihe.net/ITI/mCSD/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.Directory"

Instance: ch-mcsd-data-source
InstanceOf: ActorDefinition
Title: "mCSD Data Source"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-mcsd-data-source"
* name = "CH_mCSD_DataSource"
* description = "The Data Source (Care Services Feed client) creates, updates and deletes care services resources in the Directory."
* documentation = "See [mCSD](iti-mcsd.html) and [ITI-130](iti-130.html)."
* reference = "https://profiles.ihe.net/ITI/mCSD/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.mCSD.DataSource"

Instance: ch-ppqm-policy-source
InstanceOf: ActorDefinition
Title: "PPQm Policy Source"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-ppqm-policy-source"
* name = "CH_PPQm_PolicySource"
* description = "The Policy Source adds, updates and deletes privacy policies (consents) of the holder in the Policy Repository."
* documentation = "See [CH:PPQm](ppqm.html), [PPQ-3](ppq-3.html) and [PPQ-4](ppq-4.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicySourceConsumer"

Instance: ch-ppqm-policy-consumer
InstanceOf: ActorDefinition
Title: "PPQm Policy Consumer"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-ppqm-policy-consumer"
* name = "CH_PPQm_PolicyConsumer"
* description = "The Policy Consumer retrieves privacy policies (consents) of the holder from the Policy Repository."
* documentation = "See [CH:PPQm](ppqm.html) and [PPQ-5](ppq-5.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicySourceConsumer"

Instance: ch-ppqm-policy-repository
InstanceOf: ActorDefinition
Title: "PPQm Policy Repository"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-ppqm-policy-repository"
* name = "CH_PPQm_PolicyRepository"
* description = "The Policy Repository stores the privacy policies (consents) of the holder and serves them to Policy Sources and Policy Consumers."
* documentation = "See [CH:PPQm](ppqm.html), [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) and [PPQ-5](ppq-5.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PPQm.PolicyRepository"

Instance: ch-atna-audit-creator
InstanceOf: ActorDefinition
Title: "ATNA Audit Creator"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-atna-audit-creator"
* name = "CH_ATNA_AuditCreator"
* description = "Any actor (Secure Node or Secure Application) that records audit events and sends them to the Audit Record Repository."
* documentation = "See [RESTful ATNA](iti-restful-atna.html) and [ITI-20](iti-20.html); based on [IHE ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATNA.AuditCreator"

Instance: ch-atna-audit-record-repository
InstanceOf: ActorDefinition
Title: "ATNA Audit Record Repository"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-atna-audit-record-repository"
* name = "CH_ATNA_AuditRecordRepository"
* description = "The Audit Record Repository receives and stores the audit events of the Audit Creators."
* documentation = "See [RESTful ATNA](iti-restful-atna.html) and [ITI-20](iti-20.html); based on [IHE ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATNA.AuditRecordRepository"

Instance: ch-atc-patient-audit-consumer
InstanceOf: ActorDefinition
Title: "CH:ATC Patient Audit Consumer"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-atc-patient-audit-consumer"
* name = "CH_ATC_PatientAuditConsumer"
* description = "The Patient Audit Consumer retrieves the audit trail of a health dossier from the Patient Audit Record Service."
* documentation = "See [CH:ATC](ch-atc.html) and [ITI-81](iti-81.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditConsumer"

Instance: ch-atc-patient-audit-record-service
InstanceOf: ActorDefinition
Title: "CH:ATC Patient Audit Record Service"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-atc-patient-audit-record-service"
* name = "CH_ATC_PatientAuditRecordService"
* description = "The Patient Audit Record Service returns the audit trail of a health dossier to the Patient Audit Consumer."
* documentation = "See [CH:ATC](ch-atc.html) and [ITI-81](iti-81.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.ATC.PatientAuditRecordService"

Instance: ch-iua-authorization-client
InstanceOf: ActorDefinition
Title: "IUA Authorization Client"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-iua-authorization-client"
* name = "CH_IUA_AuthorizationClient"
* description = "The Authorization Client requests access tokens from the Authorization Server and incorporates them in requests to Resource Servers."
* documentation = "See [IUA](iti-iua.html), [ITI-71](iti-71.html), [ITI-72](iti-72.html), [ITI-103](iti-103.html) and [Client Registration](client-registration.html); based on [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)."

Instance: ch-iua-authorization-server
InstanceOf: ActorDefinition
Title: "IUA Authorization Server"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-iua-authorization-server"
* name = "CH_IUA_AuthorizationServer"
* description = "The Authorization Server registers clients and issues access tokens to Authorization Clients."
* documentation = "See [IUA](iti-iua.html), [ITI-71](iti-71.html), [ITI-103](iti-103.html) and [Client Registration](client-registration.html); based on [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)."

Instance: ch-iua-resource-server
InstanceOf: ActorDefinition
Title: "IUA Resource Server"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-iua-resource-server"
* name = "CH_IUA_ResourceServer"
* description = "The Resource Server validates the access token of a request and enforces the access rules of the health dossier."
* documentation = "See [IUA](iti-iua.html), [ITI-72](iti-72.html) and [Enforcement of Access Rules](accesscontrol.html); based on [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)."
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.HealthDossier.API"

Instance: ch-oidc-identity-provider
InstanceOf: ActorDefinition
Title: "OpenID Connect Identity Provider"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-oidc-identity-provider"
* name = "CH_OIDC_IdentityProvider"
* description = "The Identity Provider authenticates users and issues identity tokens to Relying Parties."
* documentation = "See [OpenID Connect](openid-connect.html) and [Identifier](identifier.html); based on [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)."

Instance: ch-oidc-relying-party
InstanceOf: ActorDefinition
Title: "OpenID Connect Relying Party"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-oidc-relying-party"
* name = "CH_OIDC_RelyingParty"
* description = "The Relying Party (an application of the health dossier) authenticates users at the Identity Provider."
* documentation = "See [OpenID Connect](openid-connect.html); based on [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)."
