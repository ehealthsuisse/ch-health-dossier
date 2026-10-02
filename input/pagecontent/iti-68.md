This section describes the additional requirements for the Swiss EPR of the [Retrieve Document
[ITI-68]](https://profiles.ihe.net/ITI/MHD/ITI-68.html) transaction defined in the MHD Profile published in the IHE ITI
Trial Implementation “Mobile Access to Health Documents”.

### Scope

The Retrieve Document [ITI-68] transaction is used by the Document Consumer to retrieve a
document from the Document Responder. 

### Actor Roles

**Actor:** Document Consumer   
**Role:** Requests a document from the Document Responder.   
**Actor:** Document Responder   
**Role:** Serves the document to the Document Consumer.   

### Referenced Standards

1. [Mobile access to Health Documents (MHD), Rev. {{site.data.fhir.ver.ihemhdfhir | split: "/" | last}}]({{site.data.fhir.ver.ihemhdfhir}})
2. This MHD Profile is based on Release 4 of the [HL7® FHIR®](https://hl7.org/fhir/R4/index.html) standard.

### Messages

<div>{% include MHD_ActorDiagram_ITI-68.svg %}</div>

#### Retrieve Document Request Message

The Document Consumer retrieves the document with the URL in `DocumentReference.content.attachment.url` of the
DocumentReference it received from the Document Responder.

_Retrieve Document_ example **request**:
```http
GET https://example.org/Binary/d8d1fe44-07e9-4a84-985f-fde97d77d54b HTTP/1.1
Accept: application/pdf
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00
```

####  Expected Actions

The Document Responder SHALL return a FHIR document as a native FHIR document Bundle resource and SHALL NOT wrap it in a Binary resource. For other data standard MHD behavior applies.

How a FHIR document is published is described in [ITI-65](iti-65.html#publishing-a-fhir-document).

#### CapabilityStatement Resource

The CapabilityStatement resource for the **Document Consumer** is [MHD Document Consumer](CapabilityStatement-CH.MHD.DocumentConsumer.html).

The CapabilityStatement resource for the **Document Responder** is [MHD Document Responder](CapabilityStatement-CH.MHD.DocumentResponder.html).

### Security Consideration

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with 
server certificates. 

The transaction SHALL use client authentication and authorization using an extended access token defined in [IUA](iti-71.html) conveyed as defined in the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction.

For every Retrieve Document [ITI-68] request, the Document Responder SHALL enforce the access rules of the patient
and of the requesting health professional or health institution, as described in [Appendix: Enforcement of Access Rules](accesscontrol.html).
The Document Responder SHALL reject the request if the requester is not authorized to retrieve the document.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

##### Document Consumer Audit

The **Document Consumer** SHALL record an audit event according to
[CH Audit Event for [ITI-68] Document Consumer](StructureDefinition-ChAuditEventIti68Consumer.html)
([example](AuditEvent-ChAuditEventIti68ConsumerExample.html)).

The request of this transaction carries only the URL of the document. To record the master identifier, title, type
and confidentiality code of the document, the Document Consumer SHALL keep the DocumentReference it received before,
e.g. in the response of [Find Document References [ITI-67]](iti-67.html), from which it took the URL.

##### Document Responder Audit

The **Document Responder** SHALL record an audit event according to
[CH Audit Event for [ITI-68] Document Responder](StructureDefinition-ChAuditEventIti68Responder.html)
([example](AuditEvent-ChAuditEventIti68ResponderExample.html)).

The request of this transaction carries only the URL of the document. To record the master identifier, title, type
and confidentiality code of the document, the Document Responder SHALL retrieve internally the DocumentReference of
the document requested.
