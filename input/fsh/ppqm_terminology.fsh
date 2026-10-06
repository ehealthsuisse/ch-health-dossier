// Terminology of CH:PPQm: the consent types of the electronic health dossier (E-GD), the actions a consent may grant,
// and the value sets the Consent profiles bind to.

CodeSystem: HealthDossierConsentType
Id: HealthDossierConsentType
Title: "CH Health Dossier Consent Type"
Description: "The types of consent of the electronic health dossier (E-GD). Each type corresponds to one decision of the
holder, or of a person acting for the holder, foreseen by the EGDG or the requirements catalogue of the E-GD, and to one
Consent profile of CH:PPQm."
* ^caseSensitive = true
* ^experimental = false
* ^content = #complete

* #opening "Opening of the health dossier" "The health dossier was opened, and the holder has full access to it (Art.
11 para. 1, Art. 20-22 EGDG)."
* #opening ^designation[+].language = #de-CH
* #opening ^designation[=].value = "Eröffnung des E-GD"

* #emergency-access "Emergency access" "Health professionals and health institutions may access the health dossier in
a medical emergency without a granted right (Art. 11 para. 2 let. b, Art. 13 para. 3 EGDG). The holder may exclude and
allow it again at any time."
* #emergency-access ^designation[+].language = #de-CH
* #emergency-access ^designation[=].value = "Notfallzugriff"

* #access "Access for a health professional, group or health institution" "The holder grants a health professional, a
group of health professionals or a health institution access to the health dossier (Art. 11 para. 2 let. a, Art. 13
para. 1 EGDG)."
* #access ^designation[+].language = #de-CH
* #access ^designation[=].value = "Berechtigung von Gesundheitsfachpersonen, Gruppen und Gesundheitseinrichtungen"

* #indirect-authorization "Indirect authorization" "A health professional or health institution confirms in the health
dossier a consent the holder gave outside the health dossier (Art. 11 para. 3, Art. 13 para. 2 EGDG)."
* #indirect-authorization ^designation[+].language = #de-CH
* #indirect-authorization ^designation[=].value = "Indirekte Erteilung von Zugriffsrechten"

* #indirect-authorization-setting "Indirect authorization setting" "Whether health professionals and health
institutions may confirm a consent the holder gave outside the health dossier (Art. 11 para. 3 EGDG). The holder may
exclude and allow it again at any time."
* #indirect-authorization-setting ^designation[+].language = #de-CH
* #indirect-authorization-setting ^designation[=].value = "Zulassung der indirekten Erteilung von Zugriffsrechten"

* #delegation "Delegation" "A health professional, group or health institution passes on its access right to another
health professional, group or health institution, within the limits of the access right it holds."
* #delegation ^designation[+].language = #de-CH
* #delegation ^designation[=].value = "Weitergabe des Zugriffsrechts"

* #representative "Representative" "The holder appoints a representative and sets the representative's rights (Art. 11
para. 5 EGDG)."
* #representative ^designation[+].language = #de-CH
* #representative ^designation[=].value = "Vertretung"

* #legal-representative "Legal representative" "A legal representative exercises the rights of the holder (Art. 12
EGDG)."
* #legal-representative ^designation[+].language = #de-CH
* #legal-representative ^designation[=].value = "Gesetzliche Stellvertretung"

* #digital-health-application "Digital health application" "The holder authorizes a digital health application to
access the health dossier on the holder's behalf (Art. 11 para. 2 let. c, Art. 16 EGDG)."
* #digital-health-application ^designation[+].language = #de-CH
* #digital-health-application ^designation[=].value = "Digitale Gesundheitsanwendung"

* #military-recording "Recording by military health professionals" "The holder consents that military health
professionals and health institutions record data in the health dossier (Art. 14 para. 2 EGDG)."
* #military-recording ^designation[+].language = #de-CH
* #military-recording ^designation[=].value = "Erfassung durch Gesundheitsfachpersonen der Armee"


ValueSet: HealthDossierConsentTypeVS
Id: HealthDossierConsentType
Title: "CH Health Dossier Consent Type Value Set"
Description: "The types of consent of the electronic health dossier (E-GD)."
* ^experimental = false
* include codes from system HealthDossierConsentType


CodeSystem: HealthDossierConsentAction
Id: HealthDossierConsentAction
Title: "CH Health Dossier Consent Action"
Description: "The actions a consent of the electronic health dossier (E-GD) may grant. The confidentiality levels a
grantee may read are not an action: they are given in `Consent.provision.securityLabel`."
* ^caseSensitive = true
* ^experimental = false
* ^content = #complete

* #read "Read documents" "Search documents by their metadata and by full text, and view them."
* #read ^designation[+].language = #de-CH
* #read ^designation[=].value = "Dokumente suchen und einsehen"

* #record "Record documents" "Record new documents in the health dossier."
* #record ^designation[+].language = #de-CH
* #record ^designation[=].value = "Dokumente erfassen"

* #delete "Delete documents" "Delete documents of the health dossier."
* #delete ^designation[+].language = #de-CH
* #delete ^designation[=].value = "Dokumente löschen"

* #edit-metadata "Edit document metadata" "Change the confidentiality level of a document and record a comment on it."
* #edit-metadata ^designation[+].language = #de-CH
* #edit-metadata ^designation[=].value = "Vertraulichkeitsstufe ändern und Kommentar erfassen"

* #read-demographics "Read personal data" "View the personal data of the holder in the index of holders."
* #read-demographics ^designation[+].language = #de-CH
* #read-demographics ^designation[=].value = "Personendaten im Index einsehen"

* #edit-contact "Add contact data" "Add contact data (address, e-mail, phone) to the personal data of the holder in the
index of holders."
* #edit-contact ^designation[+].language = #de-CH
* #edit-contact ^designation[=].value = "Kontaktdaten im Index ergänzen"

* #read-directory "Read the directory" "View the directory of health professionals, groups and health institutions."
* #read-directory ^designation[+].language = #de-CH
* #read-directory ^designation[=].value = "Verzeichnis der Gesundheitsfachpersonen und Gesundheitseinrichtungen einsehen"

* #read-audit-trail "Read the audit trail" "View the log of the accesses to the health dossier."
* #read-audit-trail ^designation[+].language = #de-CH
* #read-audit-trail ^designation[=].value = "Protokolldaten einsehen"

* #configure-emergency-access "Configure emergency access" "Exclude emergency access and allow it again."
* #configure-emergency-access ^designation[+].language = #de-CH
* #configure-emergency-access ^designation[=].value = "Notfallzugriff ausschliessen bzw. zulassen"

* #configure-indirect-authorization "Configure indirect authorization" "Exclude the indirect authorization of health
professionals and health institutions and allow it again."
* #configure-indirect-authorization ^designation[+].language = #de-CH
* #configure-indirect-authorization ^designation[=].value = "Indirekte Erteilung von Zugriffsrechten ausschliessen bzw. zulassen"

* #manage-access "Manage access rights" "Grant and revoke access rights of health professionals, groups and health
institutions on behalf of the holder."
* #manage-access ^designation[+].language = #de-CH
* #manage-access ^designation[=].value = "Gesundheitsfachpersonen, Gruppen und Gesundheitseinrichtungen berechtigen"

* #delegate "Pass on the access right" "Pass on the right to read documents of the confidentiality level 'allgemein'
to another health professional, group or health institution, for a limited period."
* #delegate ^designation[+].language = #de-CH
* #delegate ^designation[=].value = "Zugriffsrecht weitergeben"


ValueSet: HealthDossierConsentActionVS
Id: HealthDossierConsentAction
Title: "CH Health Dossier Consent Action Value Set"
Description: "The actions a consent of the electronic health dossier (E-GD) may grant."
* ^experimental = false
* include codes from system HealthDossierConsentAction


ValueSet: HealthDossierConsentAccessAction
Id: HealthDossierConsentAccessAction
Title: "CH Health Dossier Consent Action for Health Professionals"
Description: "The actions the holder may grant a health professional, group or health institution."
* ^experimental = false
* HealthDossierConsentAction#read "Read documents"
* HealthDossierConsentAction#delegate "Pass on the access right"


ValueSet: HealthDossierConsentRepresentativeAction
Id: HealthDossierConsentRepresentativeAction
Title: "CH Health Dossier Consent Action for Representatives"
Description: "The actions the holder may grant a representative. A representative may always view the directory of
health professionals and health institutions and the personal data of the holder in the index of holders, without a
grant."
* ^experimental = false
* HealthDossierConsentAction#read "Read documents"
* HealthDossierConsentAction#delete "Delete documents"
* HealthDossierConsentAction#edit-metadata "Edit document metadata"
* HealthDossierConsentAction#edit-contact "Add contact data"
* HealthDossierConsentAction#read-audit-trail "Read the audit trail"
* HealthDossierConsentAction#configure-emergency-access "Configure emergency access"
* HealthDossierConsentAction#configure-indirect-authorization "Configure indirect authorization"


ValueSet: HealthDossierConsentDigitalHealthApplicationAction
Id: HealthDossierConsentDigitalHealthApplicationAction
Title: "CH Health Dossier Consent Action for Digital Health Applications"
Description: "The actions the holder may grant a digital health application. They are the scopes the IUA Authorization
Server may issue to the digital health application acting for the holder."
* ^experimental = false
* HealthDossierConsentAction#read "Read documents"
* HealthDossierConsentAction#record "Record documents"
* HealthDossierConsentAction#delete "Delete documents"
* HealthDossierConsentAction#edit-metadata "Edit document metadata"
* HealthDossierConsentAction#read-demographics "Read personal data"
* HealthDossierConsentAction#edit-contact "Add contact data"
* HealthDossierConsentAction#read-directory "Read the directory"
* HealthDossierConsentAction#manage-access "Manage access rights"


ValueSet: HealthDossierConsentPurposeOfUse
Id: HealthDossierConsentPurposeOfUse
Title: "CH Health Dossier Consent Purpose of Use"
Description: "The purposes of use a consent of the electronic health dossier (E-GD) may refer to: normal access and
emergency access. The purposes of automatic upload of the EPR (`AUTO`, `DICOM_AUTO`) are not used: the write right of
health professionals follows from the law and does not need a consent."
* ^experimental = false
* $purposeOfUse#NORM "Normal Access"
* $purposeOfUse#EMER "Emergency Access"


ValueSet: HealthDossierConsentActorRole
Id: HealthDossierConsentActorRole
Title: "CH Health Dossier Consent Actor Role"
Description: "The roles of the grantee of a consent of the electronic health dossier (E-GD)."
* ^experimental = false
* $healthDossierRole#PAT "Patient"
* $healthDossierRole#REP "Representative"
* $healthDossierRole#LEGREP "Legal representative"
* $healthDossierRole#HCP "Healthcare professional"


// TODO: the qualifier `urn:e-health-suisse:dga-client-id` of a digital health application is not defined in ITI-71
// yet; it has to be aligned with the client registration (issue #11).
ValueSet: PpqmActorIdentifierType
Title: "CH PPQm Actor Identifier Type"
Description: "The identifier types (name qualifiers) of the actors and performers of a CH:PPQm Consent. They are the
`user_id_qualifier` values of the access token (see ITI-71), together with the qualifiers of an organization and of a
digital health application."
* ^experimental = false

* $URI#urn:e-health-suisse:2015:epr-spid                   "EPR-SPID"
* $URI#urn:e-health-suisse:representative-id               "Representative ID"
* $URI#urn:gs1:gln                                         "GLN"
* $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id "Organization ID"
* $URI#urn:e-health-suisse:dga-client-id                   "Digital health application client ID"


ValueSet: PpqmFeedRequestHttpMethod
Title: "CH PPQm Feed Request HTTP Method"
Description: "HTTP methods allowed in CH:PPQm Feed requests"
* ^experimental = false

* http://hl7.org/fhir/http-verb#POST    "POST"
* http://hl7.org/fhir/http-verb#PUT     "PUT"
* http://hl7.org/fhir/http-verb#DELETE  "DELETE"
