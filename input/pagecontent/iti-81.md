### Constraints on Retrieve ATNA Audit Event [ITI-81] for CH:ATC

The Retrieve ATNA Audit Event [ITI-81] transaction is defined in [IHE ITI TF-2: 3.81](https://profiles.ihe.net/ITI/TF/Volume2/ITI-81.html). The following rules shall be applied for the CH:ATC profile.

#### Message Semantics

The Retrieve ATNA Audit Event message shall be a HTTP GET request sent to the Patient Audit Record Repository. This message is a FHIR search (see [http://hl7.org/fhir/R4/search.html](http://hl7.org/fhir/R4/search.html)) on AuditEvent Resources (see [http://hl7.org/fhir/R4/auditevent.html](http://hl7.org/fhir/R4/auditevent.html)). This "search" target is formatted as:

``` http
<scheme>://<authority>/<path>/AuditEvent?date=ge[start-time]&date=le[stop-time]&<query>
```

where:

<ol type="a">
  <li>
    <code>&lt;scheme&gt;</code> shall be https.
  </li>
  <li>
    <code>&lt;query&gt;</code> shall include the entity.identifier as defined in <a href="#additional-atna-search-parameters">Additional ATNA Search Parameters</a> and may include additional ATNA Search parameters. If entity.identifier is not included an HTTP response code 400 - Bad Request shall be returned.
  </li>
</ol>


#### Additional ATNA Search Parameters

The Patient Audit Consumer may use the search parameters listed in Retrieve Audit Event [ITI-81]. The Patient Audit
Record Repository SHALL evaluate all search parameters on the masked audit events (see [Expected Actions](#expected-actions)),
never on the recorded audit events: a search parameter on an element which is not returned, e.g. `address` or the
identifier of an assistant, does not match any audit event.

**entity.identifier** is a parameter of token type. This parameter specifies unique identifier for the object. The parameter value should be identified in accordance to the entity type;   
For example:   
``` http
http://example.com/ARRservice/AuditEvent?date=ge2026-03-22&date=le2026-10-07&entity.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650
```

The Audit Record Repository shall match this parameter with the AuditEvent.entity.what.identifier field that is of type identifier (ParticipantObjectID in DICOM schema).

For the CH:ATC profile the entity.identifier has to be the EPR-SPID:   
`entity.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|<<<value EPR-SPID>>>`


#### Message Semantics for Response

The returned AuditEvent FHIR resources in the Bundle are derived from the audit events recorded by the actors serving
the requests, see [Audit trail of the document transactions](volume3.html#audit-trail-of-the-document-transactions) and
[Audit trail of the consent transactions](volume3.html#audit-trail-of-the-consent-transactions). They are not returned
as recorded, but masked and without duplicates as described in [Expected Actions](#expected-actions).

The response SHALL conform to [Retrieve ATNA Audit Event [ITI-81] Response](StructureDefinition-CH-ATC.ITI-81.Response.html),
and each audit event to [CH Audit Trail Event](StructureDefinition-ChAuditTrailEvent.html), see the
[example](Bundle-ch-atc-iti-81-response-sample.html).

The Patient Audit Consumer may restrict the audit events returned to certain types of events with the search parameter `subtype` and the codes of the [audit event types](volume3.html#audit-trail-consumption-event-types), for example:
``` http
http://example.com/ARRservice/AuditEvent?date=ge2026-03-22&date=le2026-10-07&entity.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&subtype=http://fhir.ch/ig/ch-health-dossier/CodeSystem/HealthDossierAuditEventType|ATC_DOC_READ
```


#### Expected Actions

The audit trail shows the requester who processed which data of the health dossier on which day, but not the time of
day, the identity of an assistant, how often an action was performed, or the technical details of the request. The
recorded audit events keep the exact time and all details. They are not available over this transaction, but only
outside of it, e.g. on a request for access to the personal data under the Data Protection Act (Art. 25 DSG).

Only the audit events of successful requests (`outcome` 0) are part of the audit trail. Requests which were rejected,
e.g. because the requester had no access right, did not process any data of the health dossier and are not returned.

##### Masking

The Patient Audit Record Repository SHALL apply the following rules to every audit event of the response, whoever
performed the event, including the patient and the representatives:

<ol type="a">
  <li>
    <strong>Time:</strong> the time of the event is reduced to the day, determined in Swiss local time
    (Europe/Zurich). <code>period.start</code> and <code>period.end</code> carry that day as a date
    (<code>YYYY-MM-DD</code>). <code>recorded</code> carries the start of that day
    (<code>YYYY-MM-DDT00:00:00+01:00</code> or <code>+02:00</code>); it has no meaning beyond the day and SHALL NOT be
    displayed as a time.
  </li>
  <li>
    <strong>Assistant:</strong> where an assistant made the request (<code>agent[delegatedUser]</code>), only the role
    <code>ASS</code> is returned, without the name, the identifier and <code>who</code> of the assistant. The
    healthcare professional on whose behalf the assistant acted is returned as main user.
  </li>
  <li>
    <strong>Technical details:</strong> the agents of the client and server systems with their network addresses, the
    <code>traceparent</code> entity and the query of a search (<code>entity[query]</code>) are not returned.
  </li>
  <li>
    <strong>Identity:</strong> <code>id</code> and <code>meta</code> are set by the Patient Audit Record Repository
    and do not refer to the recorded audit event. <code>meta.security</code> carries the codes <code>ABSTRED</code>
    (abstracted) and <code>REDACTED</code> (redacted) from <code>http://terminology.hl7.org/CodeSystem/v3-ObservationValue</code>.
  </li>
</ol>

The masked audit events conform to [CH Audit Trail Event](StructureDefinition-ChAuditTrailEvent.html).

##### Duplicates

Audit events which are identical after the masking, apart from `id` and `meta`, SHALL be returned only once, so that the
response does not show how often the same user performed the same action on the same data on one day. Each remaining
audit event is returned as an AuditEvent resource of its own; the audit events are not combined into a summary.

For example, a healthcare professional who retrieves the same document three times on 7 October 2026 results in one
audit event of the type `ATC_DOC_READ` for that day. Retrieving two different documents on that day results in two
audit events.

The Patient Audit Record Repository SHALL remove the duplicates before paging the result; `Bundle.total`, where
returned, counts the audit events after the removal.

##### Search and sort on the masked values

The Patient Audit Record Repository SHALL evaluate the search parameter `date` and the sort on the masked values, never
on the recorded time, so that a search with a time of day cannot narrow down the time of an event. The Patient Audit
Consumer SHOULD search with dates (`YYYY-MM-DD`). The order of the audit events within a day carries no meaning.

#### Security Considerations

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with
server certificates.

The transaction SHALL use client authentication and authorization using an extended access token defined in [IUA](iti-71.html) conveyed as defined in the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction.

For every Retrieve ATNA Audit Event [ITI-81] request, the Patient Audit Record Repository SHALL enforce the access
rules as described in [Appendix: Enforcement of Access Rules](accesscontrol.html).
Audit records the requester is not authorized to see SHALL NOT be included in the response.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

##### Patient Audit Consumer Audit

The **Patient Audit Consumer** SHALL record an audit event according to
[CH Audit Event for [ITI-81] Patient Audit Consumer](StructureDefinition-ChAuditEventIti81Consumer.html)
([example](AuditEvent-ChAuditEventIti81ConsumerExample.html)).

##### Patient Audit Record Repository Audit

The **Patient Audit Record Repository** SHALL record an audit event according to
[CH Audit Event for [ITI-81] Patient Audit Record Repository](StructureDefinition-ChAuditEventIti81Repository.html)
([example](AuditEvent-ChAuditEventIti81RepositoryExample.html)) for every Retrieve ATNA Audit Event [ITI-81] request,
with the type `ATC_LOG_READ` in the audit trail of the patient, whoever made the request (the patient, a
representative, a legal representative or the administration). The audit event is returned, masked, by later requests
for the audit trail of that patient.
