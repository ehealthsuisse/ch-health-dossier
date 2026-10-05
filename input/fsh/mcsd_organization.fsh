Profile: CHmCSDOrganization
Parent: http://fhir.ch/ig/ch-core/StructureDefinition/ch-core-organization-epr
Id: CH.mCSD.Organization
Title: "CH mCSD Organization"
Description: "CH mCSD profile on Organization"
* obeys ch-mcsd-organization-ihe-conformance
* identifier 1..
* identifier contains OID 0..1
* identifier[OID] only OidIdentifier
* identifier[OID] ^short = "The OID of the organization"
* identifier[OID] ^patternIdentifier.system = "urn:ietf:rfc:3986"
* type 1..
* name 1..


Invariant: ch-mcsd-organization-ihe-conformance
Description: "The Organization needs to conform to IHE.mCSD.Organization"
Expression: "conformsTo('https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization')"
Severity: #error


Mapping:  CHmCSDOrganizationToHCProfessional
Source:   CHmCSDOrganization
Target:   "https://www.bag.admin.ch/epra"
Title:    "LDAP schema"
* -> "HCRegulatedOrganization"
* identifier -> "HCRegulatedOrganization.hcIdentifier"
* name -> "HCRegulatedOrganization.O"
* alias -> "HCRegulatedOrganization.O"
* name -> "HCRegulatedOrganization.hcRegisteredName"
* alias -> "HCRegulatedOrganization.hcRegisteredName"
* type -> "HCRegulatedOrganization.businessCategory"
* active -> "HCRegulatedOrganization.hpdProviderStatus"
* address -> "HCRegulatedOrganization.hpdProviderPracticeAddress"
* contact.address -> "HCRegulatedOrganization.hpdProviderBillingAddress"
* contact.address -> "HCRegulatedOrganization.hpdProviderMailingAddress"
* type -> "HCRegulatedOrganization.HcSpecialisation"
* telecom -> "HCRegulatedOrganization.telephoneNumber"
* telecom -> "HCRegulatedOrganization.facsimileTelephoneNumber"
* partOf -> "HCRegulatedOrganization.memberOf"
* meta.lastUpdated -> "HCRegulatedOrganization.modifyTimestamp"
* contact.address -> "HCRegulatedOrganization.hpdProviderLegalAddress"
* contact.telecom -> "HCRegulatedOrganization.hpdMedicalRecordsDeliveryEmailAddress"


Instance: CHmCSDOrganizationSpitalX
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization Spital X"
Description: "An example of CHmCSDOrganization that contains the same information as Spital X in the Swiss examples"
* id = "SpitalX"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.201"
* active = true
* type[+].coding = $sct#394802001 "General medicine"
* type[+].coding = $sct#22232009 "Hospital"
* name = "Spital X"
* telecom[+].system = #fax
* telecom[=].value = "+41 71 111 22 99"
* telecom[+].system = #phone
* telecom[=].value = "+41 71 111 22 33"
* address[+].use = #work
* address[=].line[+] = "Spital X"
* address[=].line[+] = "95 Rorschacher Strasse"
* address[=].city = "St. Gallen"
* address[=].state = "SG"
* address[=].postalCode = "9007"
* address[=].country = "CH"


Instance: CHmCSDOrganizationSpitalXDept3
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization Spital X Dept. 3"
Description: "An example of CHmCSDOrganization that contains the same information as Spital X, Dept. 3 in the Swiss
examples"
* id = "SpitalXDept3"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.203"
* active = true
* type[+].coding = $sct#225728007 "Accident and Emergency department"
* type[+].coding = $sct#22232009 "Hospital"
* name = "Dept. 3"
* telecom[+].system = #fax
* telecom[=].value = "+41 71 111 22 27"
* telecom[+].system = #phone
* telecom[=].value = "+41 71 111 22 19"
* address[+].use = #work
* address[=].line[+] = "Spital X - Medicina d'urgenza e di salvataggio"
* address[=].line[+] = "95 Rorschacher Strasse"
* address[=].city = "St. Gallen"
* address[=].state = "SG"
* address[=].postalCode = "9007"
* address[=].country = "CH"
* partOf = Reference(CHmCSDOrganizationSpitalX)


Instance: CHmCSDOrganizationPraxisP
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization Praxis P"
Description: "An example of CHmCSDOrganization that contains the same information as Praxis P in the Swiss
examples"
* id = "PraxisP"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.210"
* active = true
* type[+].coding = $sct#35971002 "Ambulatory care site"
* type[+].coding = $sct#394802001 "General medicine"
* name = "Praxis P"
* telecom[+].system = #fax
* telecom[=].value = "+41 71 271 22 99"
* telecom[+].system = #phone
* telecom[=].value = "+41 71 271 22 33"
* address[+].use = #work
* address[=].line[+] = "Praxis P"
* address[=].line[+] = "47 Langgasse"
* address[=].city = "St. Gallen"
* address[=].state = "SG"
* address[=].postalCode = "9000"
* address[=].country = "CH"


// Organization types of the electronic health dossier (E-GD) which the access rules depend on: the community managing
// health dossiers (Art. 15 and 31 EGDG), whose administration acts on the dossiers it manages, and the military health
// institution, whose health professionals may record data only with the consent of the holder (Art. 14 para. 2 EGDG).
// They are carried as an additional coding of Organization.type, next to the type of the health institution.

CodeSystem: HealthDossierOrganizationType
Id: HealthDossierOrganizationType
Title: "CH Health Dossier Organization Type"
Description: "The types of organizations in the directory of health professionals and health institutions which the
access rules of the electronic health dossier (E-GD) depend on."
* ^caseSensitive = true
* ^experimental = false
* ^content = #complete
* #community "Community" "A community managing health dossiers, whose administration acts on the health dossiers it manages (Art. 15 and 31 EGDG)."
* #community ^designation[+].language = #de-CH
* #community ^designation[=].value = "Gemeinschaft"
* #military "Military health institution" "A military health institution, whose health professionals may record data only with the consent of the holder (Art. 14 para. 2 EGDG)."
* #military ^designation[+].language = #de-CH
* #military ^designation[=].value = "Militärische Gesundheitseinrichtung"


ValueSet: HealthDossierOrganizationTypeVS
Id: HealthDossierOrganizationType
Title: "CH Health Dossier Organization Type Value Set"
Description: "The types of organizations in the directory of health professionals and health institutions which the
access rules of the electronic health dossier (E-GD) depend on."
* ^experimental = false
* include codes from system HealthDossierOrganizationType


Instance: CHmCSDOrganizationCommunity
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization: Community"
Description: "An example of a community managing health dossiers, marked with the organization type community."
* id = "Community"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.999.1"
* active = true
* type[+].coding = HealthDossierOrganizationType#community "Community"
* name = "Community managing the health dossier"


Instance: CHmCSDOrganizationMilitary
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization: Military Health Institution"
Description: "An example of a military health institution, marked with the organization type military next to the type
of the health institution."
* id = "MilitaryHealthInstitution"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.999.3"
* active = true
* type[+].coding = $sct#22232009 "Hospital"
* type[+].coding = HealthDossierOrganizationType#military "Military health institution"
* name = "Military health institution"
