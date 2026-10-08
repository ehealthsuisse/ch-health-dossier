### Scope

This transaction is used by the Policy Source to add, update, or delete a set of consents of a health dossier, e.g.
when the patient grants an access right and appoints a representative at the same time. The only HTTP method which SHALL be supported is `POST`.

### HTTP Method POST

<figure>
  {% include PPQm-4_actor_diagram.svg %}
  <figcaption>Figure 5: PPQ-4: HTTP Method POST</figcaption>
</figure>

#### Trigger Event

The Policy Source uses HTTP method `POST` to perform an operation on a set of consents in the Policy Repository,
as an ACID transaction.

#### Request Message

The request body SHALL represent a single Bundle resource compliant to the
[PpqmFeedRequestBundle](StructureDefinition-PpqmFeedRequestBundle.html) profile
([example for an access right and a representative](Bundle-PpqmFeedRequestBundleAdd.html)).

The request SHALL be sent to `[baseUrl]`.

#### Expected Actions

Upon receiving the HTTP `POST` request, the Policy Repository SHALL:
- Validate the Bundle resource contained in the request body.
- On each request entry, perform the operation specified the attribute `entry.request.method` on the embedded
  [CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) resource, with the authorization, validation and
  Policy Repository rules of [PPQ-3](ppq-3.html#expected-actions-common-to-all-http-methods):
  - "POST" — add the consent.
  - "PUT" — update the consent if it is already present, otherwise add it.
  - "DELETE" — delete the consent.
- Validate the rules of [PPQ-3](ppq-3.html#validation) against the consents of the patient as they are after all
  entries of the Bundle.
- Process the Bundle as a whole: if one entry fails, no entry SHALL be persisted.
- Create a PPQ-4 response according to the transaction outcome.

#### Response Message

The PPQ-4 response SHALL be created according to the section
[3.1.0.11](https://hl7.org/fhir/R4/http.html#transaction) of the FHIR R4 specification.

### Security Considerations

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with
server certificates.

The transaction SHALL use client authentication and authorization using an extended access token defined in
[IUA](iti-71.html) conveyed as defined in the
[Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

The **Policy Source** and **Policy Repository** SHALL record an audit event according to:
- [CH Audit Event for [PPQ-3] **Create** Privacy Policy](StructureDefinition-ChAuditEventPpq3Create.html)
- [CH Audit Event for [PPQ-3] **Update** Privacy Policy](StructureDefinition-ChAuditEventPpq3Update.html)
- [CH Audit Event for [PPQ-3] **Delete** Privacy Policy](StructureDefinition-ChAuditEventPpq3Delete.html)

All audit events may be sent to the Audit Record Repository in a single Bundle (ITI-20 Send Audit Bundle Request).
[Example of such a Bundle](Bundle-ChAuditEventPpq4Example.html).
