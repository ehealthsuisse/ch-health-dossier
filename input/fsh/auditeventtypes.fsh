// Audit event types of the electronic health dossier (E-GD): what happened, from the point of view of the patient.
//
// Successor of the Audit Trail Consumption event types of the EPR (`urn:oid:2.16.756.5.30.1.127.3.10.7`,
// ChEhealthCodesystemAtc in CH Term). The codes whose meaning is unchanged keep their value. `ATC_DOC_UPDATE` is split
// into the change of the confidentiality code and the recording of a personal note, and the new version of a document
// is added. The types are carried as an additional subtype in the audit events of the transactions, so that the audit
// trail of a patient can be built from, and filtered on, the audit events of the actors serving the requests.
//
// The types of the consent transactions (`ATC_POL_...`) keep the codes of the EPR for the access rights and the
// emergency access. The default confidentiality level (`ATC_POL_DEF_CONFLEVEL`) and the exclusion list
// (`ATC_POL_INCL_BLACKLIST`, `ATC_POL_EXL_BLACKLIST`) are dropped, and the setting of the indirect authorization is
// added.

CodeSystem: HealthDossierAuditEventType
Id: HealthDossierAuditEventType
Title: "CH Health Dossier Audit Event Type"
Description: "The types of events in the audit trail of an electronic health dossier (E-GD), from the point of view of
the patient. Successor of the Audit Trail Consumption event types of the EPR (`urn:oid:2.16.756.5.30.1.127.3.10.7`):
the codes whose meaning is unchanged keep their value, the document update is split into the change of the
confidentiality code and the recording of a personal note, and the new version of a document is added. For the
consents, the default confidentiality level and the exclusion list are dropped, and the setting of the indirect
authorization is added."
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


* #ATC_POL_CREATE_AUT_PART_AL "Authorize participants to access level/date" "A consent granting rights to a participant was recorded: an access right, an indirect authorization, a delegation, a representative, a legal representative, a digital health application, or the opening of the health dossier."
* #ATC_POL_CREATE_AUT_PART_AL ^designation[+].language = #de-CH
* #ATC_POL_CREATE_AUT_PART_AL ^designation[=].value = "Teilnehmende für Zugriffsstufe/Datum autorisieren"
* #ATC_POL_CREATE_AUT_PART_AL ^designation[+].language = #fr-CH
* #ATC_POL_CREATE_AUT_PART_AL ^designation[=].value = "Autoriser les participants pour ce niveau d’accès / à cette date"
* #ATC_POL_CREATE_AUT_PART_AL ^designation[+].language = #it-CH
* #ATC_POL_CREATE_AUT_PART_AL ^designation[=].value = "Autorizzare i partecipanti ad accedere a un livello/una data"
* #ATC_POL_CREATE_AUT_PART_AL ^designation[+].language = #rm-CH
* #ATC_POL_CREATE_AUT_PART_AL ^designation[=].value = "Autorisar las persunas participantas per in stgalim d'access/per ina data"

* #ATC_POL_UPDATE_AUT_PART_AL "Update access level/date of authorized participants" "A consent granting rights to a participant was updated."
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[+].language = #de-CH
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[=].value = "Zugriffsstufe/Datum autorisierter Teilnehmender aktualisieren"
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[+].language = #fr-CH
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[=].value = "Mettre à jour le niveau d’accès / la date des participants autorisés"
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[+].language = #it-CH
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[=].value = "Aggiornare il livello/la data di accesso dei partecipanti autorizzati"
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[+].language = #rm-CH
* #ATC_POL_UPDATE_AUT_PART_AL ^designation[=].value = "Actualisar il stgalim d'access/la data per las persunas participantas autorisadas"

* #ATC_POL_REMOVE_AUT_PART_AL "Remove authorization for participants to access level/date" "A consent was deleted, by a user or by the Policy Repository."
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[+].language = #de-CH
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[=].value = "Autorisierung von Teilnehmenden für Zugriffsstufe/Datum aufheben"
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[+].language = #fr-CH
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[=].value = "Supprimer l’autorisation des participants à ce niveau d’accès / à cette date"
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[+].language = #it-CH
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[=].value = "Rimuovere l'autorizzazione di accesso dei partecipanti al livello/alla data"
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[+].language = #rm-CH
* #ATC_POL_REMOVE_AUT_PART_AL ^designation[=].value = "Annullar l'autorisaziun da persunas participantas per in stgalim d'access/per ina data"

* #ATC_POL_ENA_EMER_USE "Enabling Emergency Access" "The emergency access was allowed."
* #ATC_POL_ENA_EMER_USE ^designation[+].language = #de-CH
* #ATC_POL_ENA_EMER_USE ^designation[=].value = "Notfall-Zugriff aktivieren"
* #ATC_POL_ENA_EMER_USE ^designation[+].language = #fr-CH
* #ATC_POL_ENA_EMER_USE ^designation[=].value = "Autoriser l’accès d’urgence"
* #ATC_POL_ENA_EMER_USE ^designation[+].language = #it-CH
* #ATC_POL_ENA_EMER_USE ^designation[=].value = "Abilitare l'accesso di emergenza"
* #ATC_POL_ENA_EMER_USE ^designation[+].language = #rm-CH
* #ATC_POL_ENA_EMER_USE ^designation[=].value = "Activar l'access d'urgenza"

* #ATC_POL_DIS_EMER_USE "Disabling Emergency Access" "The emergency access was excluded."
* #ATC_POL_DIS_EMER_USE ^designation[+].language = #de-CH
* #ATC_POL_DIS_EMER_USE ^designation[=].value = "Notfall-Zugriff deaktivieren"
* #ATC_POL_DIS_EMER_USE ^designation[+].language = #fr-CH
* #ATC_POL_DIS_EMER_USE ^designation[=].value = "Désactiver l’accès d’urgence"
* #ATC_POL_DIS_EMER_USE ^designation[+].language = #it-CH
* #ATC_POL_DIS_EMER_USE ^designation[=].value = "Disabilitare l'accesso di emergenza"
* #ATC_POL_DIS_EMER_USE ^designation[+].language = #rm-CH
* #ATC_POL_DIS_EMER_USE ^designation[=].value = "Deactivar l'access d'urgenza"

* #ATC_POL_ENA_INDIRECT_AUT "Enabling Indirect Authorization" "The indirect authorization of health professionals and health institutions was allowed."
* #ATC_POL_ENA_INDIRECT_AUT ^designation[+].language = #de-CH
* #ATC_POL_ENA_INDIRECT_AUT ^designation[=].value = "Indirekte Erteilung von Zugriffsrechten zulassen"
* #ATC_POL_ENA_INDIRECT_AUT ^designation[+].language = #fr-CH
* #ATC_POL_ENA_INDIRECT_AUT ^designation[=].value = "Autoriser l'octroi indirect de droits d'accès"
* #ATC_POL_ENA_INDIRECT_AUT ^designation[+].language = #it-CH
* #ATC_POL_ENA_INDIRECT_AUT ^designation[=].value = "Abilitare il conferimento indiretto di diritti d'accesso"

* #ATC_POL_DIS_INDIRECT_AUT "Disabling Indirect Authorization" "The indirect authorization of health professionals and health institutions was excluded."
* #ATC_POL_DIS_INDIRECT_AUT ^designation[+].language = #de-CH
* #ATC_POL_DIS_INDIRECT_AUT ^designation[=].value = "Indirekte Erteilung von Zugriffsrechten ausschliessen"
* #ATC_POL_DIS_INDIRECT_AUT ^designation[+].language = #fr-CH
* #ATC_POL_DIS_INDIRECT_AUT ^designation[=].value = "Exclure l'octroi indirect de droits d'accès"
* #ATC_POL_DIS_INDIRECT_AUT ^designation[+].language = #it-CH
* #ATC_POL_DIS_INDIRECT_AUT ^designation[=].value = "Escludere il conferimento indiretto di diritti d'accesso"


ValueSet: HealthDossierDocumentAuditEventType
Id: HealthDossierDocumentAuditEventType
Title: "CH Health Dossier Document Audit Event Type"
Description: "The types of events in the audit trail of an electronic health dossier which concern documents."
* ^experimental = false
* HealthDossierAuditEventType#ATC_DOC_CREATE
* HealthDossierAuditEventType#ATC_DOC_NEW_VERSION
* HealthDossierAuditEventType#ATC_DOC_READ
* HealthDossierAuditEventType#ATC_DOC_UPDATE_CONFIDENTIALITY
* HealthDossierAuditEventType#ATC_DOC_UPDATE_NOTE
* HealthDossierAuditEventType#ATC_DOC_DELETE
* HealthDossierAuditEventType#ATC_DOC_SEARCH


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


ValueSet: HealthDossierConsentAuditEventType
Id: HealthDossierConsentAuditEventType
Title: "CH Health Dossier Consent Audit Event Type"
Description: "The types of events in the audit trail of an electronic health dossier which concern consents, recorded
with Mobile Privacy Policy Feed [PPQ-3]."
* ^experimental = false
* HealthDossierAuditEventType#ATC_POL_CREATE_AUT_PART_AL
* HealthDossierAuditEventType#ATC_POL_UPDATE_AUT_PART_AL
* HealthDossierAuditEventType#ATC_POL_REMOVE_AUT_PART_AL
* HealthDossierAuditEventType#ATC_POL_ENA_EMER_USE
* HealthDossierAuditEventType#ATC_POL_DIS_EMER_USE
* HealthDossierAuditEventType#ATC_POL_ENA_INDIRECT_AUT
* HealthDossierAuditEventType#ATC_POL_DIS_INDIRECT_AUT


ValueSet: HealthDossierAddConsentAuditEventType
Id: HealthDossierAddConsentAuditEventType
Title: "CH Health Dossier Add Consent Audit Event Type"
Description: "The types of events in the audit trail for a consent added with Mobile Privacy Policy Feed [PPQ-3] or by
the Policy Repository: the authorization of a participant, or the emergency access and the indirect authorization
setting added at the opening of the health dossier."
* ^experimental = false
* HealthDossierAuditEventType#ATC_POL_CREATE_AUT_PART_AL
* HealthDossierAuditEventType#ATC_POL_ENA_EMER_USE
* HealthDossierAuditEventType#ATC_POL_DIS_EMER_USE
* HealthDossierAuditEventType#ATC_POL_ENA_INDIRECT_AUT
* HealthDossierAuditEventType#ATC_POL_DIS_INDIRECT_AUT


ValueSet: HealthDossierUpdateConsentAuditEventType
Id: HealthDossierUpdateConsentAuditEventType
Title: "CH Health Dossier Update Consent Audit Event Type"
Description: "The types of events in the audit trail for a consent updated with Mobile Privacy Policy Feed [PPQ-3]: the
update of the authorization of a participant, or the change of the emergency access or of the indirect authorization
setting."
* ^experimental = false
* HealthDossierAuditEventType#ATC_POL_UPDATE_AUT_PART_AL
* HealthDossierAuditEventType#ATC_POL_ENA_EMER_USE
* HealthDossierAuditEventType#ATC_POL_DIS_EMER_USE
* HealthDossierAuditEventType#ATC_POL_ENA_INDIRECT_AUT
* HealthDossierAuditEventType#ATC_POL_DIS_INDIRECT_AUT
