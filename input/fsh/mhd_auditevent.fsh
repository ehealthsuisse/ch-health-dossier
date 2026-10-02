// Audit events [ITI-65]
Profile:     ChAuditEventIti65Source
Parent:      AuditProvideBundleSource
Title:       "CH Audit Event for [ITI-65] Document Source"
Description: "This profile is used to define the CH Audit Event for the [ITI-65] transaction and the actor 'Document
Source'."
* insert ChAuditEventIti65Rules
* insert ChAuditEventTypeValueSetRules(0, 1, HealthDossierProvideDocumentAuditEventType)


Profile:     ChAuditEventIti65Recipient
Parent:      AuditProvideBundleRecipient
Title:       "CH Audit Event for [ITI-65] Document Recipient"
Description: "This profile is used to define the CH Audit Event for the [ITI-65] transaction and the actor 'Document
Recipient'."
* insert ChAuditEventIti65Rules
* insert ChAuditEventTypeValueSetRules(1, 1, HealthDossierProvideDocumentAuditEventType)
* subtype[auditTrailType] ^comment = "`ATC_DOC_NEW_VERSION` when the document provided replaces an existing document, `ATC_DOC_CREATE` otherwise."


RuleSet: ChAuditEventIti65Rules
* insert ChAuditEventExtendedRules
* agent[documentSource] ^short = "The 'Document Source' actor (EPR application)"
* agent[documentRecipient] ^short = "The 'Document Recipient' actor (Health Dossier API)"
* entity[submissionSet].what.identifier 1..1
  * value 1..1
  * system 1..1
  * system = "urn:ietf:rfc:3986"
// The entities are sliced by type in MHD and the SubmissionSet is the 'System Object': the documents are identified
// by the resource type
* entity contains document 1..*
* entity[document] ^short = "The documents provided, one entity for each DocumentReference of the Provide Document Bundle"
* entity[document].type = $resourceTypes#DocumentReference "DocumentReference"
* entity[document].role = $objectRole#3 "Report"
* entity[document].what 1..1
* entity[document].what.reference ^short = "The URL of the DocumentReference, if known"
* insert ChAuditEventDocumentEntityRules(document)
* entity[document].detail contains replaces 0..1
* entity[document].detail[replaces] ^short = "The master identifier (uniqueId) of the document which this document replaces, for a new version of a document"
* entity[document].detail[replaces].type = "replaces"
* entity[document].detail[replaces].value[x] only string


Instance:   ChAuditEventIti65SourceExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: document provided by a healthcare professional"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideDocument"
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2949)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2951, Test PDF)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: document provided by a healthcare professional"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideDocument"
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2949)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2951, Test PDF)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventIti65SourceCorrectionExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: new version of a document"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideDocumentCorrection,
with which a healthcare professional publishes the corrected version of a document: the entity of the document names
the document it replaces."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2953)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_NEW_VERSION "New version of a document"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2952, Test PDF\, corrected version)
* entity[document].detail[replaces].type = "replaces"
* entity[document].detail[replaces].valueString = "urn:oid:1.3.6.1.4.1.12559.11.13.2.1.2951"
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientCorrectionExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: new version of a document"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideDocumentCorrection,
with which a healthcare professional publishes the corrected version of a document: the entity of the document names
the document it replaces."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2953)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_NEW_VERSION "New version of a document"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2952, Test PDF\, corrected version)
* entity[document].detail[replaces].type = "replaces"
* entity[document].detail[replaces].valueString = "urn:oid:1.3.6.1.4.1.12559.11.13.2.1.2951"
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventIti65SourceFhirDocumentExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: FHIR document"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideFhirDocument"
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2954)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2955, Konsultationsbericht)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientFhirDocumentExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: FHIR document"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideFhirDocument"
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2954)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2955, Konsultationsbericht)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventIti65SourcePatientExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: document provided by the patient"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideDocumentByPatient,
with which the patient provided a document herself: the main user is the patient, there is no institution or group."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2958)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2956, Austrittsbericht Behandlung im Ausland)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientPatientExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: document provided by the patient"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideDocumentByPatient,
with which the patient provided a document herself: the main user is the patient, there is no institution or group."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2958)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2956, Austrittsbericht Behandlung im Ausland)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventIti65SourceArchiveExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: document provided by a clinical archive system"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideDocumentByArchive,
with which a clinical archive system provided a document: the main user is the technical user, identified by the GLN of the legal responsible person,
and the institution is the provider institution of the document."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2959)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventTcuRules
* insert ChExampleAuditEventGroupRules(2.2.2.2, Spital X)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2957, Austrittsbericht)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientArchiveExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: document provided by a clinical archive system"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideDocumentByArchive,
with which a clinical archive system provided a document: the main user is the technical user, identified by the GLN of the legal responsible person,
and the institution is the provider institution of the document."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2959)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventTcuRules
* insert ChExampleAuditEventGroupRules(2.2.2.2, Spital X)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2957, Austrittsbericht)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventIti65SourceAssistantExample
InstanceOf: ChAuditEventIti65Source
Title:       "Audit Event for [ITI-65] Document Source: document provided by an assistant"
Description: "Audit event of the Document Source for the Provide Document Bundle BundleProvideDocumentByAssistant,
with which an assistant provided a document on behalf of a healthcare professional: the healthcare professional is the
main user and the assistant the delegated user, as conveyed in the ch_delegation extension of the access token."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2961)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventAssRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2960, Laborbericht)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventIti65RecipientAssistantExample
InstanceOf: ChAuditEventIti65Recipient
Title:       "Audit Event for [ITI-65] Document Recipient: document provided by an assistant"
Description: "Audit event of the Document Recipient for the Provide Document Bundle BundleProvideDocumentByAssistant,
with which an assistant provided a document on behalf of a healthcare professional: the healthcare professional is the
main user and the assistant the delegated user, as conveyed in the ch_delegation extension of the access token."
Usage:      #example
* insert ChAuditEventIti65ExampleRules(1.3.6.1.4.1.12559.11.13.2.6.2961)
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_CREATE "Document upload"
* insert ChExampleAuditEventAssRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityDocumentRules(document, 1.3.6.1.4.1.12559.11.13.2.1.2960, Laborbericht)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


RuleSet: ChAuditEventIti65ExampleRules(submissionSetId)
* insert ChExampleAuditEventBaseRules(documentSource, documentRecipient, Health Dossier)
* insert ChExampleAuditEventEntityPatientRules
* subtype[iti65] = $eventTypeCode#ITI-65 "Provide Document Bundle"
* agent[documentRecipient].network.address = "https://example.com"
* entity[submissionSet]
  * what.identifier
    * value = "urn:oid:{submissionSetId}"
    * system = "urn:ietf:rfc:3986"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#20 "Job"
* entity[document]
  * type = $resourceTypes#DocumentReference "DocumentReference"
  * role = $objectRole#3 "Report"


// ---------------------------------------------------------------------------------------------------------------------
// Audit events [ITI-67]
Profile:     ChAuditEventIti67Consumer
Parent:      AuditFindDocumentReferencesConsumer
Title:       "CH Audit Event for [ITI-67] Document Consumer"
Description: "This profile is used to define the CH Audit Event for the [ITI-67] transaction and the actor 'Document
Consumer'."
* insert ChAuditEventExtendedRules
* insert ChAuditEventTypeCodeRules(0, ATC_DOC_SEARCH, Document search)
* agent[client] ^short = "The 'Document Consumer' actor (EPR application)"
* agent[server] ^short = "The 'Document Responder' actor (Health Dossier API)"


Profile:     ChAuditEventIti67Responder
Parent:      AuditFindDocumentReferencesResponder
Title:       "CH Audit Event for [ITI-67] Document Responder"
Description: "This profile is used to define the CH Audit Event for the [ITI-67] transaction and the actor 'Document
Responder'."
* insert ChAuditEventExtendedRules
* insert ChAuditEventTypeCodeRules(1, ATC_DOC_SEARCH, Document search)
* agent[client] ^short = "The 'Document Consumer' actor (EPR application)"
* agent[server] ^short = "The 'Document Responder' actor (Health Dossier API)"


Instance:   ChAuditEventIti67ConsumerExample
InstanceOf: ChAuditEventIti67Consumer
Usage:      #example
* insert ChAuditEventIti67ExampleRules
* insert ChExampleAuditEventClientRules


Instance:   ChAuditEventIti67ResponderExample
InstanceOf: ChAuditEventIti67Responder
Usage:      #example
* insert ChAuditEventIti67ExampleRules
* insert ChExampleAuditEventServerRules(Health Dossier)


RuleSet: ChAuditEventIti67ExampleRules
* insert ChExampleAuditEventBaseRules(client, server, Health Dossier)
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityPatientRules
* type = $auditEventType#rest
* subtype[anySearch] = $restfulInteraction#search "search"
* subtype[iti67] = $eventTypeCode#ITI-67 "Find Document References"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_SEARCH "Document search"
* agent[server].network.address = "https://example.com"
* entity[query]
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#24 "Query"
  * query = "aHR0cDovL2V4YW1wbGUuY29tL2ZoaXIvRG9jdW1lbnRSZWZlcmVuY2U/cGF0aWVudC5pZGVudGlmaWVyPXVybjpvaWQ6Mi4xNi43NTYuNS4zMC4xLjEyNy4zLjEwLjN8NzYxMzM3NjEwNDExMzUzNjUwJnN0YXR1cz1jdXJyZW50"


// ---------------------------------------------------------------------------------------------------------------------
// Audit events [ITI-68]
Profile:     ChAuditEventIti68Consumer
Parent:      AuditRetrieveDocumentConsumer
Title:       "CH Audit Event for [ITI-68] Document Consumer"
Description: "This profile is used to define the CH Audit Event for the [ITI-68] transaction and the actor 'Document
Consumer'."
* insert ChAuditEventIti68Rules
* insert ChAuditEventTypeCodeRules(0, ATC_DOC_READ, Document retrieval)


Profile:     ChAuditEventIti68Responder
Parent:      AuditRetrieveDocumentResponder
Title:       "CH Audit Event for [ITI-68] Document Responder"
Description: "This profile is used to define the CH Audit Event for the [ITI-68] transaction and the actor 'Document
Responder'."
* insert ChAuditEventIti68Rules
* insert ChAuditEventTypeCodeRules(1, ATC_DOC_READ, Document retrieval)


RuleSet: ChAuditEventIti68Rules
* insert ChAuditEventExtendedRules
* agent[client] ^short = "The 'Document Consumer' actor (EPR application)"
* agent[server] ^short = "The 'Document Responder' actor (Health Dossier API)"
* entity[data]
  * ^short = "The document that was accessed"
  * what.reference 1..1
    * ^short = "The URL accessed by the Document Consumer"
* insert ChAuditEventDocumentEntityRules(data)


Instance:   ChAuditEventIti68ConsumerExample
InstanceOf: ChAuditEventIti68Consumer
Usage:      #example
* insert ChAuditEventIti68ExampleRules
* insert ChExampleAuditEventClientRules


Instance:   ChAuditEventIti68ResponderExample
InstanceOf: ChAuditEventIti68Responder
Usage:      #example
* insert ChAuditEventIti68ExampleRules
* insert ChExampleAuditEventServerRules(Health Dossier)


RuleSet: ChAuditEventIti68ExampleRules
// Copy of ChExampleAuditEventBaseRules, with agent codes fixed
* recorded = "2024-10-28T09:43:56Z"
* outcome = #0
* agent[server]
  * type = DCM#110153 "Source Role ID"
  * who.display = "Health Dossier"
  * requestor = false
  * network
    * address = "https://example.org/Binary/d8d1fe44-07e9-4a84-985f-fde97d77d54b"
    * type = #5
* agent[client]
  * type = DCM#110152 "Destination Role ID"
  * who.display = "My e-Health App"
  * requestor = false
  * network
    * address = "192.168.1.1"
    * type = #2
* entity[traceparent]
  * what
    * identifier
      * value = "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00"
  * type = $auditEntityType#4 "Other"
  * role = $objectRole#26 "Processing Element"
// End of copy of ChExampleAuditEventBaseRules
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventEntityPatientRules
* insert ChExampleAuditEventEntityDocumentRules(data, 1.3.6.1.4.1.12559.11.13.2.1.2951, Test PDF)
* type = $auditEventType#rest
* subtype[anyRead] = $restfulInteraction#read "read"
* subtype[iti68] = $eventTypeCode#ITI-68 "Retrieve Document"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_READ "Document retrieval"
* entity[data]
  * what.reference = "https://example.org/Binary/d8d1fe44-07e9-4a84-985f-fde97d77d54b"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#3 "Report"


// ---------------------------------------------------------------------------------------------------------------------
// Audit events [CH:MHD-1]
Invariant: val-audit-source
Description: "The Audit Source is this agent too."
Expression: "$this.who = %resource.source.observer"
Severity: #error


Profile:     ChAuditEventChMhd1Source
Parent:      AuditEvent
Id:          ch-mhd-updatedocumentmetadata-audit-source
Title:       "CH Audit Event for [CH:MHD-1] Document Source"
Description: "This profile is used to define the CH Audit Event for the [CH:MHD-1] transaction and the actor 'Document
Source'."
* modifierExtension 0..0
* type = DCM#110106 "Export"
* action = #U
* subtype ^slicing.discriminator.type = #value
* subtype ^slicing.discriminator.path = "$this"
* subtype ^slicing.rules = #open // allow other codes
* subtype 1..
* subtype contains chmhd1 1..1
* subtype[chmhd1] = urn:e-health-suisse:event-type-code#CH-MHD-1 "Update Document Metadata"
// * severity in R5
* recorded 1..1 // already required
* outcome 1..1
* outcomeDesc MS // encouraged
// source is already required, see invariant val-audit-source use
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.description = "source, recipient, and possibly the user who participated"
* agent contains
	documentSource 1..1 and
	documentResponder 1..1
	// may be many including app identity, user identity, etc
* agent[documentSource].type = DCM#110153 "Source Role ID"
* agent[documentSource].who 1..1
* agent[documentSource] obeys val-audit-source
* agent[documentSource].network 1..1
* agent[documentResponder].type = DCM#110152 "Destination Role ID"
* agent[documentResponder].who 1..1
* agent[documentResponder].network 1..1
* agent[documentSource] ^short = "Document Source"
* agent[documentResponder] ^short = "Document Responder"
* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "type"
* entity ^slicing.rules = #closed
* entity ^slicing.description = "patient and document involved"
* entity contains
	patient 1..1 and
	documentReference 1..1
* entity[patient].type = $auditEntityType#1 "Person"
* entity[patient].role = $objectRole#1 "Patient"
* entity[patient].what 1..1
* entity[patient].what only Reference(Patient)
* entity[documentReference].type = $auditEntityType#2 "System Object"
* entity[documentReference].role = $objectRole#3 "Report"
* entity[documentReference].what 1..1
* entity[documentReference].what only Reference(DocumentReference)
* entity[documentReference].what.reference 1..1
* entity[patient] ^short = "Patient"
* entity[documentReference] ^short = "The document whose metadata is updated"
* insert ChAuditEventDocumentEntityRules(documentReference)
* entity[documentReference].detail contains previousConfidentialityCode 0..1
* entity[documentReference].detail[previousConfidentialityCode] ^short = "The confidentiality code of the document before the update as system|code, where the confidentiality code was changed. The confidentiality code after the update is recorded in securityLabel."
* entity[documentReference].detail[previousConfidentialityCode].type = "previousConfidentialityCode"
* entity[documentReference].detail[previousConfidentialityCode].value[x] only string
* insert ChAuditEventExtendedRules
* insert ChAuditEventTypeValueSetRules(0, 2, HealthDossierUpdateDocumentAuditEventType)
* agent[documentSource] ^short = "The 'Document Source' actor (EPR application)"
* agent[documentResponder] ^short = "The 'Document Responder' actor (Health Dossier API)"


Profile:     ChAuditEventChMhd1Responder
Parent:      AuditEvent
Id:          ch-mhd-updatedocumentmetadata-audit-responder
Title:       "CH Audit Event for [CH:MHD-1] Document Responder"
Description: "This profile is used to define the CH Audit Event for the [CH:MHD-1] transaction and the actor 'Document
Responder'."
* modifierExtension 0..0
* type = DCM#110107 "Import"
* action = #U
* subtype ^slicing.discriminator.type = #value
* subtype ^slicing.discriminator.path = "$this"
* subtype ^slicing.rules = #open // allow other codes
* subtype 1..
* subtype contains chmhd1 1..1
* subtype[chmhd1] = urn:e-health-suisse:event-type-code#CH-MHD-1 "Update Document Metadata"
// * severity in R5
* recorded 1..1 // already required
* outcome 1..1
* outcomeDesc MS // encouraged
// source is already required, see invariant val-audit-source use
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.description = "source, responder, and possibly the user who participated"
* agent contains
	documentSource 1..1 and
	documentResponder 1..1
	// may be many including app identity, user identity, etc
* agent[documentSource].type = DCM#110153 "Source Role ID"
* agent[documentSource].who 1..1
* agent[documentSource].network 1..1
* agent[documentResponder].type = DCM#110152 "Destination Role ID"
* agent[documentResponder].who 1..1
* agent[documentResponder] obeys val-audit-source
* agent[documentResponder].network 1..1
* agent[documentSource] ^short = "Document Source"
* agent[documentResponder] ^short = "Document Responder"
* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "type"
* entity ^slicing.rules = #closed
* entity ^slicing.description = "patient and document involved"
* entity contains
	patient 1..1 and
	documentReference 1..1
* entity[patient].type = $auditEntityType#1 "Person"
* entity[patient].role = $objectRole#1 "Patient"
* entity[patient].what 1..1
* entity[patient].what only Reference(Patient)
* entity[documentReference].type = $auditEntityType#2 "System Object"
* entity[documentReference].role = $objectRole#3 "Report"
* entity[documentReference].what 1..1
* entity[documentReference].what only Reference(DocumentReference)
* entity[documentReference].what.reference 1..1
* entity[patient] ^short = "Patient"
* entity[documentReference] ^short = "The document whose metadata is updated"
* insert ChAuditEventDocumentEntityRules(documentReference)
* entity[documentReference].detail contains previousConfidentialityCode 0..1
* entity[documentReference].detail[previousConfidentialityCode] ^short = "The confidentiality code of the document before the update as system|code, where the confidentiality code was changed. The confidentiality code after the update is recorded in securityLabel."
* entity[documentReference].detail[previousConfidentialityCode].type = "previousConfidentialityCode"
* entity[documentReference].detail[previousConfidentialityCode].value[x] only string
* insert ChAuditEventExtendedRules
* insert ChAuditEventTypeValueSetRules(1, 2, HealthDossierUpdateDocumentAuditEventType)
* subtype[auditTrailType] ^comment = "One subtype for each kind of metadata the request changed: both codes where a request changes the confidentiality code and records a personal note."
* agent[documentSource] ^short = "The 'Document Source' actor (EPR application)"
* agent[documentResponder] ^short = "The 'Document Responder' actor (Health Dossier API)"


Instance:   ChAuditEventChMhd1SourceExample
InstanceOf: ChAuditEventChMhd1Source
Title:       "Audit Event for [CH:MHD-1] Document Source: confidentiality code changed"
Description: "Audit event of the Document Source for the update of the confidentiality code of the document DocRefPdf
by the patient"
Usage:      #example
* insert ChAuditEventChMhd1ExampleRules
* insert ChAuditEventChMhd1ConfidentialityExampleRules
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventChMhd1ResponderExample
InstanceOf: ChAuditEventChMhd1Responder
Title:       "Audit Event for [CH:MHD-1] Document Responder: confidentiality code changed"
Description: "Audit event of the Document Responder for the update of the confidentiality code of the document
DocRefPdf by the patient: the document entity carries the confidentiality code after the update in securityLabel and
the one before the update as a detail."
Usage:      #example
* insert ChAuditEventChMhd1ExampleRules
* insert ChAuditEventChMhd1ConfidentialityExampleRules
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventChMhd1SourcePersonalNoteExample
InstanceOf: ChAuditEventChMhd1Source
Title:       "Audit Event for [CH:MHD-1] Document Source: personal note recorded"
Description: "Audit event of the Document Source for the personal note which the patient recorded on the document
DocRefPdf (see DocRefPdfPersonalNote). The text of the note is not recorded in the audit event."
Usage:      #example
* insert ChAuditEventChMhd1ExampleRules
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_UPDATE_NOTE "Personal note on a document recorded"
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventChMhd1ResponderPersonalNoteExample
InstanceOf: ChAuditEventChMhd1Responder
Title:       "Audit Event for [CH:MHD-1] Document Responder: personal note recorded"
Description: "Audit event of the Document Responder for the personal note which the patient recorded on the document
DocRefPdf (see DocRefPdfPersonalNote). The text of the note is not recorded in the audit event."
Usage:      #example
* insert ChAuditEventChMhd1ExampleRules
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_UPDATE_NOTE "Personal note on a document recorded"
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


RuleSet: ChAuditEventChMhd1ConfidentialityExampleRules
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_UPDATE_CONFIDENTIALITY "Confidentiality code of a document changed"
* entity[documentReference].detail[previousConfidentialityCode].type = "previousConfidentialityCode"
* entity[documentReference].detail[previousConfidentialityCode].valueString = "http://snomed.info/sct|263856008"


RuleSet: ChAuditEventChMhd1ExampleRules
* insert ChExampleAuditEventBaseRules(documentSource, documentResponder, Health Dossier)
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventEntityPatientRules
* insert ChExampleAuditEventEntityDocumentRules(documentReference, 1.3.6.1.4.1.12559.11.13.2.1.2951, Test PDF)
* subtype[chmhd1] = urn:e-health-suisse:event-type-code#CH-MHD-1 "Update Document Metadata"
* agent[documentResponder].network.address = "http://example.org"
* entity[documentReference]
  * what.reference = "http://example.org/DocumentReference/DocRefPdf"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#3 "Report"


// ---------------------------------------------------------------------------------------------------------------------
// Audit events [CH:MHD-2]
RuleSet: ChAuditEventChMhd2Rules
* modifierExtension 0..0
* action = #D
* subtype ^slicing.discriminator.type = #value
* subtype ^slicing.discriminator.path = "$this"
* subtype ^slicing.rules = #open // allow other codes
* subtype 1..
* subtype contains chmhd2 1..1
* subtype[chmhd2] = urn:e-health-suisse:event-type-code#CH-MHD-2 "Purge Document"
// * severity in R5
* recorded 1..1 // already required
* outcome 1..1
* outcomeDesc MS // encouraged
// source is already required, see invariant val-audit-source use
* agent ^slicing.discriminator.type = #value
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.description = "source, responder, and possibly the user who participated"
* agent contains
	documentSource 1..1 and
	documentResponder 1..1
	// may be many including app identity, user identity, etc
* agent[documentSource].type = DCM#110153 "Source Role ID"
* agent[documentSource].who 1..1
* agent[documentSource].network 1..1
* agent[documentResponder].type = DCM#110152 "Destination Role ID"
* agent[documentResponder].who 1..1
* agent[documentResponder].network 1..1
* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "type"
* entity ^slicing.rules = #closed
* entity ^slicing.description = "patient and purged document involved"
* entity contains
	patient 1..1 and
	documentReference 1..1
* entity[patient].type = $auditEntityType#1 "Person"
* entity[patient].role = $objectRole#1 "Patient"
* entity[patient].what 1..1
* entity[patient].what only Reference(Patient)
* entity[documentReference].type = $auditEntityType#2 "System Object"
* entity[documentReference].role = $objectRole#3 "Report"
* entity[documentReference].what 1..1
* entity[documentReference].what only Reference(DocumentReference)
* entity[documentReference].what.reference 1..1
* entity[patient] ^short = "Patient"
* entity[documentReference] ^short = "The purged document. Only its identifiers are recorded: the title, the type and the confidentiality code of a purged document SHALL NOT be recorded."
* insert ChAuditEventDocumentIdentifierEntityRules(documentReference)
* insert ChAuditEventExtendedRules
* agent[documentSource] ^short = "The 'Document Source' actor (EPR application)"
* agent[documentResponder] ^short = "The 'Document Responder' actor (Health Dossier API)"


Profile:     ChAuditEventChMhd2Source
Parent:      AuditEvent
Id:          ch-mhd-purgedocument-audit-source
Title:       "CH Audit Event for [CH:MHD-2] Document Source"
Description: "This profile is used to define the CH Audit Event for the [CH:MHD-2] transaction and the actor 'Document
Source'."
* insert ChAuditEventChMhd2Rules
* insert ChAuditEventTypeCodeRules(0, ATC_DOC_DELETE, Document removal)
* type = DCM#110106 "Export"
* agent[documentSource] obeys val-audit-source


Profile:     ChAuditEventChMhd2Responder
Parent:      AuditEvent
Id:          ch-mhd-purgedocument-audit-responder
Title:       "CH Audit Event for [CH:MHD-2] Document Responder"
Description: "This profile is used to define the CH Audit Event for the [CH:MHD-2] transaction and the actor 'Document
Responder'."
* insert ChAuditEventChMhd2Rules
* insert ChAuditEventTypeCodeRules(1, ATC_DOC_DELETE, Document removal)
* type = DCM#110107 "Import"
* agent[documentResponder] obeys val-audit-source


Instance:   ChAuditEventChMhd2SourceExample
InstanceOf: ChAuditEventChMhd2Source
Title:       "Audit Event for [CH:MHD-2] Document Source: purge by a healthcare professional"
Description: "Audit event of the Document Source for the purge of the document DocRefPdf by a healthcare professional
of the provider institution of the document"
Usage:      #example
* insert ChAuditEventChMhd2ExampleRules
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventChMhd2ResponderExample
InstanceOf: ChAuditEventChMhd2Responder
Title:       "Audit Event for [CH:MHD-2] Document Responder: purge by a healthcare professional"
Description: "Audit event of the Document Responder for the purge of the document DocRefPdf by a healthcare
professional of the provider institution of the document"
Usage:      #example
* insert ChAuditEventChMhd2ExampleRules
* insert ChExampleAuditEventHcpRules
* insert ChExampleAuditEventGroupRules(2.2.2.1, Praxis Seeblick)
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


Instance:   ChAuditEventChMhd2SourcePatientExample
InstanceOf: ChAuditEventChMhd2Source
Title:       "Audit Event for [CH:MHD-2] Document Source: purge by the patient"
Description: "Audit event of the Document Source for the purge of the document DocRefPdf by the patient"
Usage:      #example
* insert ChAuditEventChMhd2ExampleRules
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventClientRules
* type = DCM#110106 "Export"


Instance:   ChAuditEventChMhd2ResponderPatientExample
InstanceOf: ChAuditEventChMhd2Responder
Title:       "Audit Event for [CH:MHD-2] Document Responder: purge by the patient"
Description: "Audit event of the Document Responder for the purge of the document DocRefPdf by the patient"
Usage:      #example
* insert ChAuditEventChMhd2ExampleRules
* insert ChExampleAuditEventPatRules
* insert ChExampleAuditEventServerRules(Health Dossier)
* type = DCM#110107 "Import"


RuleSet: ChAuditEventChMhd2ExampleRules
* insert ChExampleAuditEventBaseRules(documentSource, documentResponder, Health Dossier)
* insert ChExampleAuditEventEntityPatientRules
* action = #D
* subtype[chmhd2] = urn:e-health-suisse:event-type-code#CH-MHD-2 "Purge Document"
* subtype[auditTrailType] = $healthDossierAuditEventType#ATC_DOC_DELETE "Document removal"
* agent[documentResponder].network.address = "http://example.org"
* entity[documentReference]
  * what.reference = "http://example.org/DocumentReference/DocRefPdf"
  * what.identifier.system = "urn:ietf:rfc:3986"
  * what.identifier.value = "urn:oid:1.3.6.1.4.1.12559.11.13.2.1.2951"
  * type = $auditEntityType#2 "System Object"
  * role = $objectRole#3 "Report"
