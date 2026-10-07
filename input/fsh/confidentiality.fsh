// Confidentiality levels of the electronic health dossier (E-GD).
//
// The Botschaft EGDG (ch. 4.1 "Vereinfachung der Vertraulichkeitsstufen") reduces the confidentiality levels from three
// to two, "allgemein" and "privat". The two levels are defined here, and used for the documents, the consents and the
// audit events alike.
//
// TODO: the codes of the two levels are not decided yet (issue #12). Until they are, "allgemein" is represented by
// SNOMED CT `Normal` and "privat" by SNOMED CT `Restricted`, both taken from the CH Term value set. The value set should
// move to CH Term once it can be maintained there.

ValueSet: HealthDossierConfidentialityCode
Id: HealthDossierConfidentialityCode
Title: "CH Health Dossier Confidentiality Code"
Description: "The two confidentiality levels of the electronic health dossier (E-GD), \"allgemein\" and \"privat\"
(Botschaft EGDG, ch. 4.1 \"Vereinfachung der Vertraulichkeitsstufen\"). Health professionals and health institutions
with a right to view may read data of the level \"allgemein\". Data of the level \"privat\" can only be viewed by the
holder, unless the holder releases them to individual health professionals or health institutions, or to a
representative. Used for the confidentiality code of a document (`DocumentReference.securityLabel`), the confidentiality levels a consent grants
(`Consent.provision.securityLabel`), and the confidentiality code of a document in the audit events."
* ^experimental = false
* $sct#17621005 "Normal (qualifier value)"
* $sct#17621005 ^designation[0].language = #de-CH
* $sct#17621005 ^designation[0].value = "allgemein"
* $sct#17621005 ^designation[1].language = #fr-CH
* $sct#17621005 ^designation[1].value = "général"
* $sct#17621005 ^designation[2].language = #it-CH
* $sct#17621005 ^designation[2].value = "generale"
* $sct#263856008 "Restricted (qualifier value)"
* $sct#263856008 ^designation[0].language = #de-CH
* $sct#263856008 ^designation[0].value = "privat"
* $sct#263856008 ^designation[1].language = #fr-CH
* $sct#263856008 ^designation[1].value = "privé"
* $sct#263856008 ^designation[2].language = #it-CH
* $sct#263856008 ^designation[2].value = "privato"
