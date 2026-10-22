Profile: CHmCSDOrganization
Parent: http://fhir.ch/ig/ch-core/StructureDefinition/ch-core-organization-epr
Id: CH.mCSD.Organization
Title: "CH mCSD Organization"
Description: "CH mCSD profile on Organization"
* obeys ch-mcsd-organization-ihe-conformance
* active 1..
* active ^comment = "Required in the health dossier: the corresponding attribute is mandatory in the IHE HPD profile, and a query using the search parameter 'active' returns different results for instances in which the element is absent."
* identifier 1..
* identifier contains OID 1..1
* identifier[OID] only OidIdentifier
* identifier[OID] ^short = "The OID of the organization"
* identifier[OID] ^patternIdentifier.system = "urn:ietf:rfc:3986"
* type 1..
* type ^slicing.discriminator.type = #pattern
* type ^slicing.discriminator.path = "$this"
* type ^slicing.rules = #open
* type ^slicing.description = "Slice for the organization type of the health dossier"
* type contains community 0..1
* type[community] = HealthDossierOrganizationType#community
* type[community] ^short = "Community managing health dossiers"
* type[community] ^definition = "Marks a community managing health dossiers (Art. 15 and 31 EGDG), whose administration
acts on the health dossiers it manages. A military health institution is marked with the SNOMED CT code
722172003 |Military health institution (environment)| of the health institution type instead."
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


// Organization type of the electronic health dossier (E-GD) which the access rules depend on: the community managing
// health dossiers (Art. 15 and 31 EGDG), whose administration acts on the dossiers it manages. SNOMED CT has no concept
// for it yet. A military health institution (Art. 14 para. 2 EGDG) uses the SNOMED CT code 722172003 instead.

CodeSystem: HealthDossierOrganizationType
Id: HealthDossierOrganizationType
Title: "CH Health Dossier Organization Type"
Description: "The types of organizations in the directory of health professionals and health institutions which the
access rules of the electronic health dossier (E-GD) depend on and which SNOMED CT does not cover."
* ^caseSensitive = true
* ^experimental = false
* ^content = #complete
* #community "Community" "A community managing health dossiers, whose administration acts on the health dossiers it manages (Art. 15 and 31 EGDG)."
* #community ^designation[+].language = #de-CH
* #community ^designation[=].value = "Gemeinschaft"


Instance: CHmCSDOrganizationCommunity
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization: Community"
Description: "An example of a community managing health dossiers, marked with the organization type community."
* id = "Community"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.999.1"
* active = true
* type[community].coding = HealthDossierOrganizationType#community "Community"
* name = "Community managing the health dossier"


Instance: CHmCSDOrganizationMilitary
InstanceOf: CHmCSDOrganization
Title: "CH mCSD Organization: Military Health Institution"
Description: "An example of a military health institution, marked with the SNOMED CT code 722172003 Military health
institution (environment) as the type of the health institution."
* id = "MilitaryHealthInstitution"
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.999.3"
* active = true
* type[+].coding = $sct#722172003 "Military health institution"
* name = "Military health institution"

Instance: mCSD-No-peer-Organization-SpitalX
InstanceOf: CHmCSDOrganization
Usage: #example
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.201"
* active = true
* type[0] = $sct#394802001 "General medicine"
* type[+] = $sct#22232009 "Hospital"
* name = "Spital X"
* telecom[0].system = #email
* telecom[=].value = "test@test.fr"
* telecom[+].system = #phone
* telecom[=].value = "+41 71 111 22 33"
* address.use = #work
* address.line[0] = "Spital X"
* address.line[+] = "95 Rorschacher Strasse"
* address.city = "St. Gallen"
* address.state = "SG"
* address.postalCode = "9007"
* address.country = "CH"

Instance: mCSD-No-peer-Organization-SpitalX-Osteopathie
InstanceOf: CHmCSDOrganization
Usage: #example
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.202"
* active = true
* type[0] = $sct#416304004 "Osteopathic manipulative medicine"
* type[+] = $sct#22232009 "Hospital"
* name = "Spital X - Osteopathie"
* telecom.system = #phone
* telecom.value = "+41 71 111 23 24"
* address.use = #work
* address.line[0] = "Spital X - Osteopathie"
* address.line[+] = "95 Rorschacher Strasse"
* address.city = "St. Gallen"
* address.state = "SG"
* address.postalCode = "9007"
* address.country = "CH"
* partOf = Reference(mCSD-No-peer-Organization-SpitalX)

Instance: mCSD-Peer-to-peer-Organization-Auryn-Spital
InstanceOf: CHmCSDOrganization
Usage: #example
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.201"
* active = true
* type = $sct#22232009 "Hospital"
* name = "Auryn-Spital"

Instance: mCSD-Peer-to-peer-Organization-Fuchur-Klinik
InstanceOf: CHmCSDOrganization
Usage: #example
* identifier[OID].system = "urn:ietf:rfc:3986"
* identifier[OID].value = "urn:oid:2.16.10.89.214"
* active = false
* type = $sct#22232009 "Hospital"
* name = "Fuchur-Klinik"
