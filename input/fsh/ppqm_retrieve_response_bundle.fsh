Profile: PpqmRetrieveResponseBundle
Parent: Bundle
Id: PpqmRetrieveResponseBundle
Title: "CH PPQm Retrieve Response Bundle"
Description: "Bundle for Mobile Privacy Policy Retrieve responses"


* type  = http://hl7.org/fhir/bundle-type#searchset

* entry.resource    only ChPpqmConsent


Instance: PpqmRetrieveResponseBundle
InstanceOf: PpqmRetrieveResponseBundle
Title: "CH PPQm Retrieve Response Bundle"
Description: "PPQm Retrieve Response Bundle"
Usage: #example
* type = http://hl7.org/fhir/bundle-type#searchset
* total = 4
* link.relation = "self"
* link.url = "http://example.com/ppqm/Consent?patient:identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650"
* entry[+].resource     = PpqmConsentOpeningExample
* entry[=].fullUrl      = "http://example.com/ppqm/Consent/PpqmConsentOpeningExample"
* entry[=].search.mode  = #match
* entry[+].resource     = PpqmConsentEmergencyAccessExample
* entry[=].fullUrl      = "http://example.com/ppqm/Consent/PpqmConsentEmergencyAccessExample"
* entry[=].search.mode  = #match
* entry[+].resource     = PpqmConsentIndirectAuthorizationSettingExample
* entry[=].fullUrl      = "http://example.com/ppqm/Consent/PpqmConsentIndirectAuthorizationSettingExample"
* entry[=].search.mode  = #match
* entry[+].resource     = PpqmConsentAccessHcpExample
* entry[=].fullUrl      = "http://example.com/ppqm/Consent/PpqmConsentAccessHcpExample"
* entry[=].search.mode  = #match
