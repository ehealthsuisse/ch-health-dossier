Profile: CHmCSDPractitioner
Parent: http://fhir.ch/ig/ch-core/StructureDefinition/ch-core-practitioner-epr
Id: CH.mCSD.Practitioner
Title: "CH mCSD Practitioner"
Description: "CH mCSD profile on Practitioner"
* obeys ch-mcsd-practitioner-ihe-conformance
* active 1..
* active ^comment = "Required in the health dossier: the corresponding attribute is mandatory in the IHE HPD profile, and a query using the search parameter 'active' returns different results for instances in which the element is absent."
* qualification 1.. // hcProfession is required


Invariant: ch-mcsd-practitioner-ihe-conformance
Description: "The Practitioner needs to conform to IHE.mCSD.Practitioner"
Expression: "conformsTo('https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner')"
Severity: #error


Profile: CHmCSDFeedPractitioner
Parent: CHmCSDPractitioner
Id: CH.mCSD.Feed.Practitioner
Title: "CH mCSD Feed Practitioner"
Description: "CH mCSD profile on Practitioner Feed"
* gender from CHmCSDPractitionerGenderVS (required)
* gender ^short = "male | female"


ValueSet: CHmCSDPractitionerGenderVS
Id: ch-mcsd-practitioner-gender-vs
Title: "CH mCSD Practitioner Administrative Gender Value Set"
Description: """Value set for the administrative gender of a CH mCSD Practitioner. Only 'male' and 'female' values are
allowed in the HPD context."""
* ^experimental = false
* include http://hl7.org/fhir/administrative-gender#male
* include http://hl7.org/fhir/administrative-gender#female


Mapping:  CHmCSDPractitionerToHCProfessional
Source:   CHmCSDPractitioner
Target:   "https://www.bag.admin.ch/epra"
Title:    "LDAP schema"
* -> "HCProfessional"
* identifier -> "HCProfessional.hcIdentifier"
* qualification.code -> "HCProfessional.hcProfession"
* active -> "HCProfessional.hpdProviderStatus" // Information is lost: Active, Inactive, Retired, Deceased to boolean
* name.text -> "HCProfessional.displayName"
* name.prefix -> "HCProfessional.title"
* name.given -> "HCProfessional.givenName"
* name.family -> "HCProfessional.sn"
* name.text -> "HCProfessional.cn"
* communication.coding.code -> "HCProfessional.hpdProviderLanguageSupported"
* gender -> "HCProfessional.gender"
* telecom -> "HCProfessional.hpdMedicalRecordsDeliveryEmailAddress"
* telecom -> "HCProfessional.mail"
* meta.lastUpdated -> "HCProfessional.modifyTimestamp"
* address -> "HCProfessional.physicalDeliveryOfficeName"
* address -> "HCProfessional.hpdProviderMailingAddress"
* address -> "HCProfessional.hpdProviderBillingAddress"
* address -> "HCProfessional.hpdProviderPracticeAddress"
* telecom -> "HCProfessional.telephoneNumber" // [system='phone']
* telecom -> "HCProfessional.mobile"
* telecom -> "HCProfessional.pager"
* telecom -> "HCProfessional.facsimileTelephoneNumber" // [system='fax']
* qualification.code -> "HCProfessional.hcSpecialisation"
* address -> "HCProfessional.hpdProviderLegalAddress"


Instance: CHmCSDPractitionerDrPeterPan
InstanceOf: CHmCSDPractitioner
Title: "CH mCSD Practitioner Dr. Peter Pan"
Description: "An example of CHmCSDPractitioner that contains the same information as Dr. Peter Pan in the Swiss examples"
* id = "DrPeterPan"
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601000102737"
* active = true
* name.text = "Peter Pan"
* name.family = "Pan"
* name.given = "Peter" // Wrong (Pan) in the example
* name.prefix = "Dr."
* telecom[+].system = #email
* telecom[=].value = "peter.pan@email.com"
* telecom[+].system = #fax
* telecom[=].value = "+41 32 001 00 05"
* telecom[+].system = #phone
* telecom[=].value = "+41 79 001 00 06"
* telecom[=].use = #mobile
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 04"
* telecom[+].system = #pager
* telecom[=].value = "+41 79 001 00 07"
* gender = #male
* qualification[+].code = $sct#309343006 "Physician"
* qualification[+].code = $medreg#1051 "General internal medicine"
* communication[+].coding = $bcp47#de
* communication[+].coding = $bcp47#fr
* communication[+].coding = $bcp47#en
* communication[+].coding = $bcp47#it

Instance: mCSD-No-peer-Practitioner-DrAndrews
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601002469197"
* active = true
* name.text = "Ann Andrews"
* name.family = "Andrews"
* name.given = "Ann"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "ann.andrews@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 04"
* gender = #female
* qualification[0].code = $sct#3842006 "Chiropractor"
* qualification[+].code = urn:oid:2.16.756.5.30.1.127.3.5#1011 "Chiropractic specialist"
* communication[0] = urn:ietf:bcp:47#de
* communication[+] = urn:ietf:bcp:47#fr
* communication[+] = urn:ietf:bcp:47#en
* communication[+] = urn:ietf:bcp:47#it

Instance: mCSD-No-peer-Practitioner-DrMeier
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601000194633"
* active = true
* name.text = "Hans Meier"
* name.family = "Meier"
* name.given = "Hans"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "drhmeier@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 81"
* gender = #male
* qualification[0].code = $sct#309343006 "Physician"
* qualification[+].code = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"
* communication = urn:ietf:bcp:47#de

Instance: mCSD-No-peer-Practitioner-DrReynolds
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601002467377"
* active = true
* name.text = "Richard Reynolds"
* name.family = "Reynolds"
* name.given = "Richard"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "rreynolds@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 99"
* gender = #male
* qualification[0].code = $sct#309343006 "Physician"
* qualification[+].code = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"
* communication[0] = urn:ietf:bcp:47#fr
* communication[+] = urn:ietf:bcp:47#en
* communication[+] = urn:ietf:bcp:47#it

Instance: mCSD-Peer-to-peer-Practitioner-DrBux
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601002469531"
* active = false
* name.text = "Bastian Bux"
* name.family = "Bux"
* name.given = "Bastian"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "bBux@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 99"
* gender = #male
* qualification[0].code = $sct#309343006 "Physician"
* qualification[+].code = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"
* communication[0] = urn:ietf:bcp:47#fr
* communication[+] = urn:ietf:bcp:47#en
* communication[+] = urn:ietf:bcp:47#it

Instance: mCSD-Peer-to-peer-Practitioner-DrGmork
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601000394385"
* active = true
* name.text = "Gisi Gmork"
* name.family = "Gmork"
* name.given = "Gisi"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "gGmork@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 99"
* gender = #male
* qualification[0].code = $sct#309343006 "Physician"
* qualification[+].code = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"
* communication[0] = urn:ietf:bcp:47#fr
* communication[+] = urn:ietf:bcp:47#en
* communication[+] = urn:ietf:bcp:47#it

Instance: mCSD-Peer-to-peer-Practitioner-DrKoreander
InstanceOf: CHmCSDPractitioner
Usage: #example
* identifier[GLN].system = "urn:oid:2.51.1.3"
* identifier[GLN].value = "7601000732385"
* active = false
* name.text = "Karl Koreander"
* name.family = "Koreander"
* name.given = "Karl"
* name.prefix = "Dr."
* telecom[0].system = #email
* telecom[=].value = "Karl.Koreander@email.com"
* telecom[+].system = #phone
* telecom[=].value = "+41 32 001 00 04"
* gender = #male
* qualification.code = $sct#309343006 "Physician"
* communication[0] = urn:ietf:bcp:47#de
* communication[+] = urn:ietf:bcp:47#fr
* communication[+] = urn:ietf:bcp:47#en
* communication[+] = urn:ietf:bcp:47#it
