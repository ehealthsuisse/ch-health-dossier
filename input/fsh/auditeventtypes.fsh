// Audit event types of the electronic health dossier (E-GD): what happened, from the point of view of the patient.
//
// Successor of the Audit Trail Consumption event types of the EPR (`urn:oid:2.16.756.5.30.1.127.3.10.7`,
// ChEhealthCodesystemAtc in CH Term). The codes whose meaning is unchanged keep their value. `ATC_DOC_UPDATE` is split
// into the change of the confidentiality code and the recording of a personal note, and the new version of a document
// is added. The types are carried as an additional subtype in the audit events of the transactions, so that the audit
// trail of a patient can be built from, and filtered on, the audit events of the actors serving the requests.
//
// Only the types of the document transactions are defined so far.

CodeSystem: HealthDossierAuditEventType
Id: HealthDossierAuditEventType
Title: "CH Health Dossier Audit Event Type"
Description: "The types of events in the audit trail of an electronic health dossier (E-GD), from the point of view of
the patient. Successor of the Audit Trail Consumption event types of the EPR (`urn:oid:2.16.756.5.30.1.127.3.10.7`):
the codes whose meaning is unchanged keep their value, the document update is split into the change of the
confidentiality code and the recording of a personal note, and the new version of a document is added."
* ^caseSensitive = true
* ^experimental = false
* ^content = #complete

* #ATC_DOC_CREATE "Document upload" "A document was provided to the health dossier."
* #ATC_DOC_CREATE ^designation[+].language = #de-CH
* #ATC_DOC_CREATE ^designation[=].value = "Dokument-Upload"
* #ATC_DOC_CREATE ^designation[+].language = #fr-CH
* #ATC_DOC_CREATE ^designation[=].value = "Chargement de documents"
* #ATC_DOC_CREATE ^designation[+].language = #it-CH
* #ATC_DOC_CREATE ^designation[=].value = "Upload di un documento"
* #ATC_DOC_CREATE ^designation[+].language = #rm-CH
* #ATC_DOC_CREATE ^designation[=].value = "Upload d'in document"

* #ATC_DOC_NEW_VERSION "New version of a document" "A new version of a document, which replaces an existing document, was provided to the health dossier."
* #ATC_DOC_NEW_VERSION ^designation[+].language = #de-CH
* #ATC_DOC_NEW_VERSION ^designation[=].value = "Neue Version eines Dokuments"
* #ATC_DOC_NEW_VERSION ^designation[+].language = #fr-CH
* #ATC_DOC_NEW_VERSION ^designation[=].value = "Nouvelle version d'un document"
* #ATC_DOC_NEW_VERSION ^designation[+].language = #it-CH
* #ATC_DOC_NEW_VERSION ^designation[=].value = "Nuova versione di un documento"

* #ATC_DOC_READ "Document retrieval" "A document was retrieved from the health dossier."
* #ATC_DOC_READ ^designation[+].language = #de-CH
* #ATC_DOC_READ ^designation[=].value = "Dokumentabruf"
* #ATC_DOC_READ ^designation[+].language = #fr-CH
* #ATC_DOC_READ ^designation[=].value = "Récupération de documents"
* #ATC_DOC_READ ^designation[+].language = #it-CH
* #ATC_DOC_READ ^designation[=].value = "Ricerca di un documento"
* #ATC_DOC_READ ^designation[+].language = #rm-CH
* #ATC_DOC_READ ^designation[=].value = "Consultar in document"

* #ATC_DOC_UPDATE_CONFIDENTIALITY "Confidentiality code of a document changed" "The confidentiality code in the metadata of a document was changed."
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[+].language = #de-CH
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[=].value = "Änderung der Vertraulichkeitsstufe eines Dokuments"
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[+].language = #fr-CH
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[=].value = "Modification du niveau de confidentialité d'un document"
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[+].language = #it-CH
* #ATC_DOC_UPDATE_CONFIDENTIALITY ^designation[=].value = "Modifica del grado di riservatezza di un documento"

* #ATC_DOC_UPDATE_NOTE "Personal note on a document recorded" "A personal note of the patient on a document was recorded or replaced."
* #ATC_DOC_UPDATE_NOTE ^designation[+].language = #de-CH
* #ATC_DOC_UPDATE_NOTE ^designation[=].value = "Erfassung eines persönlichen Vermerks zu einem Dokument"
* #ATC_DOC_UPDATE_NOTE ^designation[+].language = #fr-CH
* #ATC_DOC_UPDATE_NOTE ^designation[=].value = "Saisie d'une remarque personnelle sur un document"
* #ATC_DOC_UPDATE_NOTE ^designation[+].language = #it-CH
* #ATC_DOC_UPDATE_NOTE ^designation[=].value = "Registrazione di un'annotazione personale su un documento"

* #ATC_DOC_DELETE "Document removal" "A document was irrevocably removed from the health dossier."
* #ATC_DOC_DELETE ^designation[+].language = #de-CH
* #ATC_DOC_DELETE ^designation[=].value = "Dokumentlöschung"
* #ATC_DOC_DELETE ^designation[+].language = #fr-CH
* #ATC_DOC_DELETE ^designation[=].value = "Suppression de documents"
* #ATC_DOC_DELETE ^designation[+].language = #it-CH
* #ATC_DOC_DELETE ^designation[=].value = "Rimozione di un documento"
* #ATC_DOC_DELETE ^designation[+].language = #rm-CH
* #ATC_DOC_DELETE ^designation[=].value = "Stizzar in document"

* #ATC_DOC_SEARCH "Document search" "The documents of the health dossier were searched."
* #ATC_DOC_SEARCH ^designation[+].language = #de-CH
* #ATC_DOC_SEARCH ^designation[=].value = "Dokumentensuche"
* #ATC_DOC_SEARCH ^designation[+].language = #fr-CH
* #ATC_DOC_SEARCH ^designation[=].value = "Recherche de documents"
* #ATC_DOC_SEARCH ^designation[+].language = #it-CH
* #ATC_DOC_SEARCH ^designation[=].value = "Ricerca documenti"
* #ATC_DOC_SEARCH ^designation[+].language = #rm-CH
* #ATC_DOC_SEARCH ^designation[=].value = "Tschertga da documents"


ValueSet: HealthDossierDocumentAuditEventType
Id: HealthDossierDocumentAuditEventType
Title: "CH Health Dossier Document Audit Event Type"
Description: "The types of events in the audit trail of an electronic health dossier which concern documents."
* ^experimental = false
* include codes from system HealthDossierAuditEventType


ValueSet: HealthDossierProvideDocumentAuditEventType
Id: HealthDossierProvideDocumentAuditEventType
Title: "CH Health Dossier Provide Document Audit Event Type"
Description: "The types of events in the audit trail for a document provided with Provide Document Bundle [ITI-65]:
the upload of a document, or the new version of a document which replaces an existing one."
* ^experimental = false
* HealthDossierAuditEventType#ATC_DOC_CREATE
* HealthDossierAuditEventType#ATC_DOC_NEW_VERSION


ValueSet: HealthDossierUpdateDocumentAuditEventType
Id: HealthDossierUpdateDocumentAuditEventType
Title: "CH Health Dossier Update Document Metadata Audit Event Type"
Description: "The types of events in the audit trail for an update of the metadata of a document with Update Document
Metadata [CH:MHD-1]: the change of the confidentiality code, or the recording of a personal note."
* ^experimental = false
* HealthDossierAuditEventType#ATC_DOC_UPDATE_CONFIDENTIALITY
* HealthDossierAuditEventType#ATC_DOC_UPDATE_NOTE
