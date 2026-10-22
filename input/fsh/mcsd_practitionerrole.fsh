Profile: CHmCSDPractitionerRole
Parent: http://fhir.ch/ig/ch-core/StructureDefinition/ch-core-practitionerrole-epr
Id: CH.mCSD.PractitionerRole
Title: "CH mCSD PractitionerRole"
Description: "CH mCSD profile on PractitionerRole"
* obeys ch-mcsd-practitionerrole-ihe-conformance
* active 1..
* active ^comment = "Required in the health dossier: the corresponding attribute is mandatory in the IHE HPD profile, and a query using the search parameter 'active' returns different results for instances in which the element is absent."
* practitioner only Reference(CHmCSDPractitioner)
* practitioner 1.. // From HPD
* organization only Reference(CHmCSDOrganization)
* organization 1.. // From HPD
* code 1.. // From mCSD


Invariant: ch-mcsd-practitionerrole-ihe-conformance
Description: "The PractitionerRole needs to conform to IHE.mCSD.PractitionerRole"
Expression: "conformsTo('https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole')"
Severity: #error


Mapping:  CHmCSDPractitionerRoleToRelationship
Source:   CHmCSDPractitionerRole
Target:   "https://www.bag.admin.ch/epra"
Title:    "LDAP schema"
* -> "Relationship"
* active -> "HCProfessional.hpdProviderStatus"
* organization -> "Relationship.owner"
* practitioner -> "Relationship.member"
* code -> "HCProfessional.hcProfession"
* specialty -> "HCProfessional.hcSpecialisation"


Instance: ChmCSDPractitionerRolePeterPanSpitalXDept3
InstanceOf: CHmCSDPractitionerRole
Title: "CH mCSD PractitionerRole Dr. Peter Pan at Spital X Dept. 3"
Description: "An example of CHmCSDPractitionerRole that contains the same information as Dr. Peter Pan - Spital X, Dept. 3
Relationship in the Swiss examples"
* id = "PeterPanSpitalXDept3"
* active = true
* practitioner = Reference(CHmCSDPractitionerDrPeterPan)
* organization = Reference(CHmCSDOrganizationSpitalXDept3)
* code = $sct#309343006 "Physician"
* specialty = $medreg#1051 "General internal medicine"


Instance: ChmCSDPractitionerRolePeterPanPraxisP
InstanceOf: CHmCSDPractitionerRole
Title: "CH mCSD PractitionerRole Dr. Peter Pan at Praxis P"
Description: "An example of CHmCSDPractitionerRole that contains the same information as Dr. Peter Pan - Praxis P
Relationship in the Swiss examples"
* id = "PeterPanPraxisP"
* active = true
* practitioner = Reference(CHmCSDPractitionerDrPeterPan)
* organization = Reference(CHmCSDOrganizationPraxisP)
* code = $sct#309343006 "Physician"
* specialty = $medreg#1051 "General internal medicine"

Instance: mCSD-No-peer-PractitionerRole-AnnAndrewsSpitalXOsteopathie
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#3842006 "Chiropractor"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1011 "Chiropractic specialist"

Instance: mCSD-No-peer-PractitionerRole-HansMeierSpitalX
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#309343006 "Physician"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"

Instance: mCSD-No-peer-PractitionerRole-RichardReynoldsSpitalX
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#309343006 "Physician"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"

Instance: mCSD-Peer-to-peer-PractitionerRole-BastianBuxAuryn-Spital
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#309343006 "Physician"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"

Instance: mCSD-Peer-to-peer-PractitionerRole-GisiGmorkFuchur-Klinik
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#309343006 "Physician"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"

Instance: mCSD-Peer-to-peer-PractitionerRole-KoreanderFuchur-Klinik
InstanceOf: CHmCSDPractitionerRole
Usage: #example
* active = true
* practitioner = Reference(mCSD-No-peer-Practitioner-DrAndrews)
* organization = Reference(mCSD-No-peer-Organization-SpitalX-Osteopathie)
* code = $sct#309343006 "Physician"
* specialty = urn:oid:2.16.756.5.30.1.127.3.5#1051 "General internal medicine"
