### Scope

This transaction is used by the Policy Consumer to retrieve the consents of a health dossier, e.g. to show the holder
the access rights granted, or to show a health professional the access rights it may pass on. The only HTTP method
which SHALL be supported is `GET`.

### HTTP Method GET

<figure>
  {% include PPQm-5_actor_diagram.svg %}
  <figcaption>Figure 6: PPQ-5: HTTP Method GET</figcaption>
</figure>

#### Trigger Events

The Policy Consumer sends this message to retrieve existing consents from the Policy Repository.

#### Request Message

The request body SHALL be empty.

The request SHALL contain the search parameter `patient:identifier`. The _Policy Repository_ SHALL support the
following search parameters on the [Consent](StructureDefinition-ch-ppqm-consent.html) resource, and their
combination:

| Parameter | Type | Path | Description |
|---|---|---|---|
| patient:identifier | token | Consent.patient.identifier | The patient (EPR-SPID)<br/>`Consent?patient:identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|[epr-spid]` |
| identifier | token | Consent.identifier | The consent identifier<br/>`Consent?identifier=[uuid]` |
| category | token | Consent.category | The consent type<br/>`Consent?category=http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierConsentType|access` |
| actor:identifier | token | Consent.provision.actor.reference.identifier | The grantee<br/>`Consent?actor:identifier=urn:oid:2.51.1.3|[gln]` |
| period | date | Consent.provision.period | The validity<br/>`Consent?period=ge2026-10-05` |
| source-reference:identifier | token | Consent.sourceReference.identifier | The delegations derived from an access right<br/>`Consent?source-reference:identifier=urn:ietf:rfc:3986|[uuid]` |
{:class="table table-bordered"}

Table 1: Search parameters of PPQ-5

The search parameters are the ones defined for Consent in FHIR R4. Grantees without a system in the identifier,
e.g. a representative or a group, are searched with the identifier value only (`Consent?actor:identifier=[value]`).

#### Expected Actions

Upon receiving the HTTP `GET` request, the Policy Repository SHALL:
- Authorize the request: the patient of the request SHALL be the patient of the access token (`person_id`), and for
  the role `ADM` the community of the administration (`subject_organization_id`) SHALL manage the health dossier.
- Return only the consents the requester may retrieve, as defined in
  [Who May Record and Retrieve Which Consent](ppqm.html#who-may-record-and-retrieve-which-consent). Consents the
  requester may not retrieve SHALL NOT be included in the response, and their number SHALL NOT be disclosed.
- Create a PPQ-5 response according to the transaction outcome.

#### Response Message

The PPQ-5 response SHALL be created according to the section
[3.1.0.9](https://hl7.org/fhir/R4/http.html#search) of the FHIR R4 specification. If the response body
is a Bundle, then it SHALL comply to the
[PpqmRetrieveResponseBundle](StructureDefinition-PpqmRetrieveResponseBundle.html) profile
([example](Bundle-PpqmRetrieveResponseBundle.html)).

### Security Considerations

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with
server certificates.

The transaction SHALL use client authentication and authorization using an extended access token defined in
[IUA](iti-71.html) conveyed as defined in the
[Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

The **Policy Consumer** SHALL record an audit event according to
[CH Audit Event for [PPQ-5] Policy Consumer](StructureDefinition-ChAuditEventPpq5Consumer.html).

The **Policy Repository** SHALL record an audit event according to
[CH Audit Event for [PPQ-5] Policy Repository](StructureDefinition-ChAuditEventPpq5Repository.html).
