This section describes the additional requirements for the Health Dossier API of the [Find Document References
[ITI-67]](https://profiles.ihe.net/ITI/MHD/ITI-67.html) transaction defined in the MHD Profile published in the IHE ITI
Trial Implementation “Mobile Access to Health Documents”.

### Scope

The Find Document References transaction is used to find DocumentReference Resources that
satisfy a set of parameters. The result of the query is a FHIR Bundle containing DocumentReference Resources that match the
query parameters.

### Actor Roles

**Actor:** Document Consumer   
**Role:** Requests a list of DocumentReference Resources, matching the supplied set of criteria, from the Document Responder.   
**Actor:** Document Responder   
**Role:** Returns DocumentReference Resources that match the search criteria provided by the Document Consumer.   

### Referenced Standards

1. [Mobile access to Health Documents (MHD), Rev. {{site.data.fhir.ver.ihemhdfhir | split: "/" | last}}]({{site.data.fhir.ver.ihemhdfhir}})
2. This MHD Profile is based on Release 4 of the [HL7® FHIR®](https://hl7.org/fhir/R4/index.html) standard.

### Messages

<div>{% include MHD_ActorDiagram_ITI-67.svg %}</div>

#### Find Document References Request Message

§iti67-1^ch-mhd-consumer:The Document Consumer **SHALL** include the search parameter patient.identifier with the OID of the EPR-SPID.§
The holder is given in `DocumentReference.subject` as a logical reference with the EPR-SPID in `subject.identifier` (see
[Holder](document-sharing-metadata.html#holder)). §iti67-2^ch-mhd-responder:The Document Responder **SHALL** resolve this logical reference through
the EPR-SPID to the holder in the community, so that the chained search parameter `patient.identifier` finds the
documents of the holder.§
§iti67-3^ch-mhd-consumer:The search parameters of type [token](https://hl7.org/fhir/R4/search.html#token) **SHALL** contain both the system and the code.§

_Find Document References_ example **request**:
```http
GET [base]/DocumentReference?patient.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&status=current HTTP/1.1
Accept: application/fhir+json
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00
```

##### Full-Text Search Option

§iti67-4^ch-mhd-responder:The Document Responder **SHALL** support the [Full-Text Search Option](https://profiles.ihe.net/ITI/MHD/ITI-67.html#236741211-full-text-search-option)
with the search parameter `full-text`, which specifies terms or phrases used to search the textual content of the documents
(see [MHD Actor Options](iti-mhd.html#full-text-search-option)).§ The Document Consumer MAY use the `full-text` search parameter.

_Find Document References_ example **request** with full-text search:
```http
GET [base]/DocumentReference?patient.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&status=current&full-text=diabetes%20AND%20%22chronic%20pain%22 HTTP/1.1
Accept: application/fhir+json
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00
```

##### Documents provided by an institution

§iti67-5^ch-mhd-responder:The Document Responder **SHALL** support the search parameter `custodian` with the modifier `:identifier`, which finds the
documents provided on behalf of an institution or group (see
[Provider institution](document-sharing-metadata.html#provider-institution)).§

_Find Document References_ example **request** for the documents provided by an institution:
```http
GET [base]/DocumentReference?patient.identifier=urn:oid:2.16.756.5.30.1.127.3.10.3|761337610411353650&status=current&custodian:identifier=urn:ietf:rfc:3986|urn:oid:2.2.2.1 HTTP/1.1
Accept: application/fhir+json
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00
```

##### Search for the author of a document

The author of a document is mostly given as text, and only where the Document Source has it as structured data in
contained resources (see [Author](document-sharing-metadata.html#author)). §iti67-6^ch-mhd-consumer:The search parameters
`author.given` and `author.family` of the
[Find Document References [ITI-67]](https://profiles.ihe.net/ITI/MHD/ITI-67.html) transaction of MHD, which would only
find the authors given as structured data, are therefore not supported: the Document Consumer **SHALL NOT** use them, and the Document Responder is not required to process them.§ This
is a deviation from MHD. A document can be found by the name of its author with the
[Full-Text Search Option](#full-text-search-option), where the name is part of the textual content of the document.

####  Expected Actions

§iti67-7^ch-mhd-responder:The Document Responder **SHALL** process the query to discover the DocumentReference entries that match the search parameters given.§

§iti67-8^ch-mhd-responder:The Document Responder **SHALL** set the `DocumentReference.content.attachment.url` value to the URL used in ITI-68
transactions to retrieve that document's content.§

#### Find Document References Response Message

§iti67-9^ch-mhd-responder:The response Bundle **SHOULD** follow the [CH MHD Find Document References Response message](StructureDefinition-ch-mhd-documentreference-bundle.html)
Profile ([example: MHD Find DocumentReferences](Bundle-Bundle-FindDocumentReferences.html)).§

#### CapabilityStatement Resource

The CapabilityStatement resource for the **Document Consumer** is [MHD Document Consumer](CapabilityStatement-CH.MHD.DocumentConsumer.html).

The CapabilityStatement resource for the **Document Responder** is [MHD Document Responder](CapabilityStatement-CH.MHD.DocumentResponder.html).

### Security Consideration

§iti67-10^ch-mhd-consumer,ch-mhd-responder:The transaction **SHALL** be secured by Transport Layer Security (TLS) encryption and server authentication with 
server certificates.§ 

§iti67-11^ch-mhd-consumer,ch-mhd-responder:The transaction **SHALL** use client authentication and authorization using an extended access token defined in [IUA](iti-71.html) conveyed as defined in the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction.§

§iti67-12^ch-mhd-responder:For every Find Document References [ITI-67] request, the Document Responder **SHALL** enforce the access rules of the
holder and of the requesting health professional or health institution, as described in [Appendix: Enforcement of Access Rules](accesscontrol.html).§
§iti67-13^ch-mhd-responder:DocumentReference resources the requester is not authorized to see **SHALL NOT** be included in the response.§

§iti67-14^ch-mhd-consumer,ch-mhd-responder:The actors **SHALL** support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).§

#### Security Audit Considerations

##### Document Consumer Audit

§iti67-15^ch-mhd-consumer:The **Document Consumer** **SHALL** record an audit event according to
[CH Audit Event for [ITI-67] Document Consumer](StructureDefinition-ChAuditEventIti67Consumer.html) 
([example](AuditEvent-ChAuditEventIti67ConsumerExample.html)).§

##### Document Responder Audit

§iti67-16^ch-mhd-responder:The **Document Responder** **SHALL** record an audit event according to
[CH Audit Event for [ITI-67] Document Responder](StructureDefinition-ChAuditEventIti67Responder.html)
([example](AuditEvent-ChAuditEventIti67ResponderExample.html)).§
