// ActorDefinitions referenced by the conformance statements in the narrative (§id^actor:...§).
// IHE does not (yet) publish ActorDefinition resources for PIXm, PDQm, MHD, mCSD or BALP, so the
// CH Health Dossier actors are defined here. If IHE publishes them, link them via derivedFrom.

RuleSet: CommonActor
* status = #active
* experimental = false
* type = #system

Instance: ch-pixm-source
InstanceOf: ActorDefinition
Title: "PIXm Patient Identity Source"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pixm-source"
* name = "CH_PIXm_Source"
* description = "The Patient Identity Source revises the contact information of an existing patient in the Swiss Health Dossier."
* documentation = "See [Patient Identity Feed FHIR [ITI-104]](iti-104.html) and [PIXm](iti-pixm.html)."
* reference = "https://profiles.ihe.net/ITI/PIXm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Source"

Instance: ch-pixm-manager
InstanceOf: ActorDefinition
Title: "PIXm Patient Identifier Cross-reference Manager"
Usage: #definition
* insert CommonActor
* url = "http://fhir.ch/ig/ch-health-dossier/ActorDefinition/ch-pixm-manager"
* name = "CH_PIXm_Manager"
* description = "The Patient Identifier Cross-reference Manager manages the cross-referencing of patient identifiers and accepts revisions of the patient contact information in the Swiss Health Dossier."
* documentation = "See [Patient Identity Feed FHIR [ITI-104]](iti-104.html) and [PIXm](iti-pixm.html)."
* reference = "https://profiles.ihe.net/ITI/PIXm/volume-1.html"
* capabilities = "http://fhir.ch/ig/ch-health-dossier/CapabilityStatement/CH.PIXm.Manager"
