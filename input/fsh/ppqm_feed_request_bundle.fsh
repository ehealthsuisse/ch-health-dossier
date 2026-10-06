Profile: PpqmFeedRequestBundle
Parent: Bundle
Id: PpqmFeedRequestBundle
Title: "CH PPQm Feed Request Bundle"
Description: "Bundle for Mobile Privacy Policy Bundle Feed requests"

* obeys ch-epr-ppqm-method-equality


* type  = http://hl7.org/fhir/bundle-type#transaction

* entry             1..*
* entry             obeys ch-epr-ppqm-constistent-ids
* entry.resource    only ChPpqmConsent

* entry.request                 obeys ch-epr-ppqm-url-format
* entry.request.method          from PpqmFeedRequestHttpMethod (required)
* entry.request.ifNoneMatch     0..0
* entry.request.ifModifiedSince 0..0
* entry.request.ifMatch         0..0
* entry.request.ifNoneExist     0..0



Invariant:      ch-epr-ppqm-method-equality
Description:    "HTTP methods of all request shall be the same"
Expression:     "entry.request.method.distinct().count() = 1"
Severity:       #error

Invariant:      ch-epr-ppqm-url-format
Description:    "URL format shall suit the HTTP method"
Expression:     "(
                    (method = 'POST') and (url = 'Consent')
                ) or (
                    (method != 'POST') and url.startsWith('Consent?identifier=') and url.lower().matches('^consent\\\\?identifier=urn:uuid:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
                )"
Severity:       #error

Invariant:      ch-epr-ppqm-constistent-ids
Description:    "For PUT, the consent identifier in the embedded resource shall be the same as in the entry URL"
Expression:     "(request.method != 'PUT') or (resource.identifier.value.lower() = request.url.substring(19).lower())"       // 19 is the length of "Consent?identifier="
Severity:       #error


Instance: PpqmFeedRequestBundleAdd
InstanceOf: PpqmFeedRequestBundle
Title: "PPQm Feed Request Bundle (POST)"
Description: "CH:PPQm Feed Request Bundle for HTTP method POST -- the holder grants an access right to a health
institution and appoints a representative"
Usage: #example
* type = http://hl7.org/fhir/bundle-type#transaction
* entry[+].request.method = #POST
* entry[=].request.url = "Consent"
* entry[=].resource = PpqmConsentAccessInstitutionExample
* entry[+].request.method = #POST
* entry[=].request.url = "Consent"
* entry[=].resource = PpqmConsentRepresentativeExample


Instance: PpqmFeedRequestBundleUpdate
InstanceOf: PpqmFeedRequestBundle
Title: "PPQm Feed Request Bundle (PUT)"
Description: "CH:PPQm Feed Request Bundle for HTTP method PUT -- the holder excludes emergency access and updates the
access right of a health institution"
Usage: #example
* type = http://hl7.org/fhir/bundle-type#transaction
* entry[+].request.method = #PUT
* entry[=].request.url = "Consent?identifier=urn:uuid:37eacb2e-33e7-4e9c-8a6d-6b55f19bd503"
* entry[=].resource = PpqmConsentEmergencyAccessExcludedExample
* entry[+].request.method = #PUT
* entry[=].request.url = "Consent?identifier=urn:uuid:79761ad4-0630-4614-8ce6-e6451e158d78"
* entry[=].resource = PpqmConsentAccessInstitutionExample


Instance: PpqmFeedRequestBundleDelete
InstanceOf: PpqmFeedRequestBundle
Title: "PPQm Feed Request Bundle (DELETE)"
Description: "CH:PPQm Feed Request Bundle for HTTP method DELETE -- the holder revokes an access right and the
authorization of a digital health application"
Usage: #example
* type = http://hl7.org/fhir/bundle-type#transaction
* entry[+].request.method = #DELETE
* entry[=].request.url = "Consent?identifier=urn:uuid:79761ad4-0630-4614-8ce6-e6451e158d78"
* entry[+].request.method = #DELETE
* entry[=].request.url = "Consent?identifier=urn:uuid:111f1e4b-4c0c-4cf5-9882-646dccc81273"


Instance: PpqmFeedResponseBundle
InstanceOf: Bundle
Title: "PPQm Feed Response Bundle"
Description: "CH:PPQm Feed Response Bundle"
Usage: #example
* id = "6de90529-3baa-4157-9bef-e945363b2c39"
* type = http://hl7.org/fhir/bundle-type#transaction-response
* link[+].relation = "self"
* link[=].url = "http://example.com"
* entry[+].fullUrl = "http://example.com/Consent/a0336005-dfb6-4b57-a904-d9172d112535"
* entry[=].response.status = "201 Created"
* entry[+].fullUrl = "http://example.com/Consent/d0e1c5b1-fbc9-48e1-a677-75ea2ef69fae"
* entry[=].response.status = "201 Created"
* entry[+].fullUrl = "http://example.com/Consent/05460feb-62bb-49eb-aa16-fbe3baa2785a"
* entry[=].response.status = "201 Created"
