// Examples of the CH:PPQm Consent profiles, one per consent type, for the holder with the EPR-SPID 761337610411353650.
//
// Organizations of the examples: the community managing the health dossier (urn:oid:2.999.1), the Auryn-Spital
// (urn:oid:2.16.10.89.201), the Fuchur-Klinik (urn:oid:2.16.10.89.214) and a military health institution
// (urn:oid:2.999.3). Health professionals: Dr. Bastian Bux (GLN 7601002469531) and Dr. Gisi Gmork (GLN 7601000394385).

RuleSet: PpqmConsentExampleHolder
* patient.identifier.value = "761337610411353650"

RuleSet: PpqmConsentExamplePerformerHolder
* performer.identifier.type.coding = $URI#urn:e-health-suisse:2015:epr-spid
* performer.identifier.system = "urn:oid:2.16.756.5.30.1.127.3.10.3"
* performer.identifier.value = "761337610411353650"

RuleSet: PpqmConsentExamplePerformerCommunity
* performer.identifier.type.coding = $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id
* performer.identifier.value = "urn:oid:2.999.1"
* performer.display = "Community managing the health dossier"

RuleSet: PpqmConsentExampleGranteeBux
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference.identifier.type.coding = $URI#urn:gs1:gln
* provision.actor.reference.identifier.system = "urn:oid:2.51.1.3"
* provision.actor.reference.identifier.value = "7601002469531"
* provision.actor.reference.display = "Dr. Bastian Bux"


Instance: PpqmConsentOpeningExample
InstanceOf: ChPpqmConsentOpening
Title: "PPQm Consent: Opening"
Description: "The health dossier was opened automatically, without objection of the holder. The community managing
the health dossier records the opening."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Opening of the health dossier. The holder has full access.</p></div>"
* identifier.value = "urn:uuid:52f0b1ed-ec02-4f5b-a3bf-7f6ef91a7201"
* category = HealthDossierConsentType#opening
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-01T09:00:00+02:00"
* insert PpqmConsentExamplePerformerCommunity
* organization.identifier.value = "urn:oid:2.999.1"
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-opening"
* provision.type = #permit
* provision.actor.role = $healthDossierRole#PAT
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:2015:epr-spid
* provision.actor.reference.identifier.system = "urn:oid:2.16.756.5.30.1.127.3.10.3"
* provision.actor.reference.identifier.value = "761337610411353650"


Instance: PpqmConsentEmergencyAccessExample
InstanceOf: ChPpqmConsentEmergencyAccess
Title: "PPQm Consent: Emergency Access allowed"
Description: "Emergency access setting created when the health dossier was opened: all health professionals and
health institutions may read documents of the confidentiality level 'allgemein' in an emergency."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Emergency access allowed: documents of the level 'allgemein' can be read in an emergency.</p></div>"
* identifier.value = "urn:uuid:37eacb2e-33e7-4e9c-8a6d-6b55f19bd503"
* category = HealthDossierConsentType#emergency-access
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-01T09:00:00+02:00"
* insert PpqmConsentExamplePerformerCommunity
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-emergency-access"
* provision.type = #permit
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#EMER "Emergency Access"


Instance: PpqmConsentEmergencyAccessExcludedExample
InstanceOf: ChPpqmConsentEmergencyAccess
Title: "PPQm Consent: Emergency Access excluded"
Description: "The holder excluded emergency access: the emergency access setting is updated to the type deny."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Emergency access excluded by the holder.</p></div>"
* identifier.value = "urn:uuid:37eacb2e-33e7-4e9c-8a6d-6b55f19bd503"
* category = HealthDossierConsentType#emergency-access
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-05T18:30:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-emergency-access"
* provision.type = #deny
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#EMER "Emergency Access"


Instance: PpqmConsentIndirectAuthorizationSettingExample
InstanceOf: ChPpqmConsentIndirectAuthorizationSetting
Title: "PPQm Consent: Indirect Authorization allowed"
Description: "Indirect authorization setting created when the health dossier was opened: health professionals and
health institutions may confirm a consent the holder gave outside the health dossier."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Indirect authorization allowed.</p></div>"
* identifier.value = "urn:uuid:93ce256b-2c9c-4025-a06c-b87c7a407caa"
* category = HealthDossierConsentType#indirect-authorization-setting
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-01T09:00:00+02:00"
* insert PpqmConsentExamplePerformerCommunity
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization-setting"
* provision.type = #permit


Instance: PpqmConsentAccessHcpExample
InstanceOf: ChPpqmConsentAccess
Title: "PPQm Consent: Access for a Health Professional"
Description: "The holder grants Dr. Bastian Bux the right to read the documents of the confidentiality level
'allgemein' until 31 March 2027, with the right to pass it on, and releases one document of the confidentiality level
'privat' to him."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Dr. Bastian Bux may read the documents of the level 'allgemein' and one selected private document until 2027-03-31, and may pass on the access right.</p></div>"
* identifier.value = "urn:uuid:3733b8a5-52f5-49fc-b2d2-cad3d2b0b949"
* category = HealthDossierConsentType#access
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-02T14:12:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-access"
* provision.type = #permit
* provision.period.end = "2027-03-31"
* insert PpqmConsentExampleGranteeBux
* provision.action[+] = HealthDossierConsentAction#read
* provision.action[+] = HealthDossierConsentAction#delegate
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#NORM "Normal Access"
* provision.provision[+].type = #permit
* provision.provision[=].data[+].meaning = #instance
* provision.provision[=].data[=].reference = Reference(DocRefPdf)


Instance: PpqmConsentAccessInstitutionExample
InstanceOf: ChPpqmConsentAccess
Title: "PPQm Consent: Access for a Health Institution"
Description: "The holder grants all health professionals and assistants registered as members of the Fuchur-Klinik
the right to read the documents of the confidentiality level 'allgemein' during a hospital stay."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Members of the Fuchur-Klinik may read the documents of the level 'allgemein' from 2026-11-02 to 2026-11-30.</p></div>"
* identifier.value = "urn:uuid:79761ad4-0630-4614-8ce6-e6451e158d78"
* category = HealthDossierConsentType#access
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-20T10:05:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-access"
* provision.type = #permit
* provision.period.start = "2026-11-02"
* provision.period.end = "2026-11-30"
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference.identifier.type.coding = $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id
* provision.actor.reference.identifier.value = "urn:oid:2.16.10.89.214"
* provision.actor.reference.display = "Fuchur-Klinik"
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#NORM "Normal Access"


Instance: PpqmConsentIndirectAuthorizationExample
InstanceOf: ChPpqmConsentIndirectAuthorization
Title: "PPQm Consent: Indirect Authorization"
Description: "The holder consented orally at the Auryn-Spital. An assistant of the Auryn-Spital records the consent
in the health dossier, verified with a one-time code the holder received by SMS."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Consent given at the Auryn-Spital, verified with a one-time code: members of the Auryn-Spital may read the documents of the level 'allgemein' until 2026-12-31.</p></div>"
* identifier.value = "urn:uuid:0c118fcf-4640-4613-9b4d-d75b31b3fa59"
* category = HealthDossierConsentType#indirect-authorization
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-03T08:47:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-indirect-authorization"
* verification.verified = true
* verification.verificationDate = "2026-10-03T08:48:12+02:00"
* provision.type = #permit
* provision.period.end = "2026-12-31"
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference.identifier.type.coding = $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id
* provision.actor.reference.identifier.value = "urn:oid:2.16.10.89.201"
* provision.actor.reference.display = "Auryn-Spital"
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#NORM "Normal Access"


Instance: PpqmConsentDelegationExample
InstanceOf: ChPpqmConsentDelegation
Title: "PPQm Consent: Delegation"
Description: "Dr. Bastian Bux passes his access right on to Dr. Gisi Gmork for a second opinion, until 31 October
2026."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Dr. Bastian Bux passes on his access right to Dr. Gisi Gmork until 2026-10-31.</p></div>"
* identifier.value = "urn:uuid:7e67c129-59a5-4664-8c8b-03c58df7d607"
* category = HealthDossierConsentType#delegation
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-04T11:20:00+02:00"
* performer.identifier.type.coding = $URI#urn:gs1:gln
* performer.identifier.system = "urn:oid:2.51.1.3"
* performer.identifier.value = "7601002469531"
* performer.display = "Dr. Bastian Bux"
* sourceReference.identifier.system = "urn:ietf:rfc:3986"
* sourceReference.identifier.value = "urn:uuid:3733b8a5-52f5-49fc-b2d2-cad3d2b0b949"
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-delegation"
* provision.type = #permit
* provision.period.end = "2026-10-31"
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference.identifier.type.coding = $URI#urn:gs1:gln
* provision.actor.reference.identifier.system = "urn:oid:2.51.1.3"
* provision.actor.reference.identifier.value = "7601000394385"
* provision.actor.reference.display = "Dr. Gisi Gmork"
* provision.action = HealthDossierConsentAction#read
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"
* provision.purpose = $purposeOfUse#NORM "Normal Access"


Instance: PpqmConsentRepresentativeExample
InstanceOf: ChPpqmConsentRepresentative
Title: "PPQm Consent: Representative"
Description: "The holder appoints a representative who may read the documents of both confidentiality levels, add
contact data, view the audit trail and configure emergency access."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Representative with the rights to read all documents, add contact data, view the audit trail and configure emergency access.</p></div>"
* identifier.value = "urn:uuid:081bda8c-c053-42e6-93e6-686364d75401"
* category = HealthDossierConsentType#representative
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-02T19:40:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-representative"
* provision.type = #permit
* provision.actor.role = $healthDossierRole#REP
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:representative-id
* provision.actor.reference.identifier.value = "representative12345"
* provision.action[+] = HealthDossierConsentAction#read
* provision.action[+] = HealthDossierConsentAction#edit-contact
* provision.action[+] = HealthDossierConsentAction#read-audit-trail
* provision.action[+] = HealthDossierConsentAction#configure-emergency-access
* provision.securityLabel[+] = $sct#17621005 "Normal (qualifier value)"
* provision.securityLabel[+] = $sct#263856008 "Restricted (qualifier value)"


Instance: PpqmConsentLegalRepresentativeExample
InstanceOf: ChPpqmConsentLegalRepresentative
Title: "PPQm Consent: Legal Representative"
Description: "The administration of the community records a legal representative on the instruction of the competent
authority."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>Legal representative set up by the community on the instruction of the competent authority.</p></div>"
* identifier.value = "urn:uuid:041a5b4f-33a2-46bf-ae49-c3463949ff09"
* category = HealthDossierConsentType#legal-representative
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-05T09:15:00+02:00"
* insert PpqmConsentExamplePerformerCommunity
* sourceAttachment.contentType = #application/pdf
* sourceAttachment.title = "Instruction of the competent authority"
* sourceAttachment.url = "http://example.com/instruction-123.pdf"
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-legal-representative"
* provision.type = #permit
* provision.actor.role = $healthDossierRole#LEGREP
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:representative-id
* provision.actor.reference.identifier.value = "legalrepresentative6789"


Instance: PpqmConsentDigitalHealthApplicationExample
InstanceOf: ChPpqmConsentDigitalHealthApplication
Title: "PPQm Consent: Digital Health Application"
Description: "The holder authorizes a diabetes diary application to read the documents of the confidentiality level
'allgemein' and to record documents until 30 September 2027."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>The diabetes diary may read the documents of the level 'allgemein' and record documents until 2027-09-30.</p></div>"
* identifier.value = "urn:uuid:111f1e4b-4c0c-4cf5-9882-646dccc81273"
* category = HealthDossierConsentType#digital-health-application
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-01T20:02:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-digital-health-application"
* provision.type = #permit
* provision.period.start = "2026-10-01"
* provision.period.end = "2027-09-30"
* provision.actor.role = $healthDossierRole#PAT
* provision.actor.reference.identifier.type.coding = $URI#urn:e-health-suisse:dga-client-id
* provision.actor.reference.identifier.value = "diabetes-diary-app"
* provision.actor.reference.display = "Diabetes diary"
* provision.action[+] = HealthDossierConsentAction#read
* provision.action[+] = HealthDossierConsentAction#record
* provision.securityLabel = $sct#17621005 "Normal (qualifier value)"


Instance: PpqmConsentMilitaryRecordingExample
InstanceOf: ChPpqmConsentMilitaryRecording
Title: "PPQm Consent: Recording by Military Health Professionals"
Description: "The holder consents that a military health institution records data in the health dossier."
Usage: #example
* text.status = #generated
* text.div = "<div xmlns='http://www.w3.org/1999/xhtml'><p>The military health institution may record data in the health dossier.</p></div>"
* identifier.value = "urn:uuid:f36e1cc8-2433-4340-b81f-00c3517a2282"
* category = HealthDossierConsentType#military-recording
* insert PpqmConsentExampleHolder
* dateTime = "2026-10-04T07:30:00+02:00"
* insert PpqmConsentExamplePerformerHolder
* policy.uri = "http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ppqm-consent-military-recording"
* provision.type = #permit
* provision.actor.role = $healthDossierRole#HCP
* provision.actor.reference.identifier.type.coding = $URI#urn:oasis:names:tc:xspa:1.0:subject:organization-id
* provision.actor.reference.identifier.value = "urn:oid:2.999.3"
* provision.actor.reference.display = "Military health institution"
* provision.action = HealthDossierConsentAction#record
