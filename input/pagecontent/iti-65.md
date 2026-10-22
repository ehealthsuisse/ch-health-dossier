This section describes the additional requirements for the Swiss Health Dossier of the [Provide Document Bundle
[ITI-65]](https://profiles.ihe.net/ITI/MHD/ITI-65.html) transaction defined in the MHD Profile published in the IHE ITI 
Trial Implementation “Mobile Access to Health Documents”.

### Scope

In the Swiss Health Dossier the transaction is used by the MHD Document Source to provide documents to the Health Dossier.

### Actor Roles

**Actor:** Document Source  
**Role:** Sends documents and metadata to the Document Recipient.  
**Actor:** Document Recipient  
**Role:** Accepts the document and metadata sent from the Document Source.  

### Referenced Standards

1. [Mobile Access to Health Documents (MHD), Rev. {{site.data.fhir.ver.ihemhdfhir | split: "/" | last}}]({{site.data.fhir.ver.ihemhdfhir}})  
2. This MHD Profile is based on Release 4 of the [HL7® FHIR®](https://hl7.org/fhir/R4/index.html) standard.

### Messages

<div>{% include MHD_ActorDiagram_ITI-65.svg %}</div>

#### Provide Document Bundle Request Message

The FHIR `Bundle.meta.profile` shall have the following value:

`https://profiles.ihe.net/ITI/MHD/StructureDefinition/IHE.MHD.Minimal.ProvideBundle`

The metadata of the document is defined
in [Document Sharing Metadata](document-sharing-metadata.html).

The request Bundle SHALL follow the [CH MHD Provide Document Bundle](StructureDefinition-ch-mhd-providedocumentbundle.html)
Profile. Examples:

- [document provided by a healthcare professional](Bundle-BundleProvideDocument.html)
- [document provided by an assistant on behalf of a healthcare professional](Bundle-BundleProvideDocumentByAssistant.html)
- [document provided by a clinical archive system](Bundle-BundleProvideDocumentByArchive.html)
- [document provided by the holder](Bundle-BundleProvideDocumentByPatient.html)
- [document with the author as structured data](Bundle-BundleProvideDocumentStructuredAuthor.html)

The `DocumentReference.content.attachment.url` value SHALL point to the resource carrying the document content, which
SHALL be included in the Bundle: a Binary resource, or the FHIR document Bundle resource for a FHIR document provided
with the [ITI-65 FHIR Documents Publish Option](#providing-a-fhir-document) (see
[Resolving references in Bundles](https://hl7.org/fhir/R4/bundle.html#references) for how to create a valid reference).

##### Providing a FHIR document

The Document Source and the Document Recipient SHALL support the ITI-65 FHIR Documents Publish Option (see
[Actor options](iti-mhd.html#actor-options)). A FHIR document is provided as the FHIR document Bundle resource itself,
carried in the entry of the Provide Document Bundle, and is not converted to a base64 encoded Binary
resource. `DocumentReference.content.attachment.url` points to that Bundle resource, `contentType` is
`application/fhir+json` or `application/fhir+xml`, and `size` and `hash` SHALL be absent.

The document is retrieved as a native FHIR document Bundle resource as well, see
[ITI-68](iti-68.html#expected-actions).

Example: [Provide Document Bundle for a FHIR document](Bundle-BundleProvideFhirDocument.html).

##### Correction of a provided document

To correct a document (see the use case [Healthcare professional corrects a provided
document](iti-mhd.html#use-cases)), the Document Source provides the corrected document and points with
`DocumentReference.relatesTo` of type `replaces` to the document it corrects. The Document Recipient SHALL set the
`status` of the replaced document to `superseded` and SHALL keep it accessible: a superseded document is no longer
returned when searching for the current documents, but it can still be found with the `status` search parameter in
[ITI-67](iti-67.html) and retrieved with [ITI-68](iti-68.html). The confidentiality code of the replaced document SHALL
NOT be changed by the replacement. The Document Source sets the [confidentiality code](document-sharing-metadata.html#confidentiality-code) of the
new version, which may differ from the one of the replaced document.

Examples: [Provide Document Bundle for a corrected document](Bundle-BundleProvideDocumentCorrection.html), which
replaces the document [DocRefPdf](DocumentReference-DocRefPdf.html), and the replaced document
[as returned by the Document Responder after the correction](DocumentReference-DocRefPdfSuperseded.html), with the
`status` `superseded`.

Who may provide a new version of a document depends on the role of the requester, and on the role of the user who
provided the document to be replaced ([provider role](document-sharing-metadata.html#provider-role)) and its
[provider institution](document-sharing-metadata.html#provider-institution):

{:class="table table-bordered"}
| Roles                  | Documents of which a new version may be provided                                                     |
|------------------------|------------------------------------------------------------------------------------------------------|
| `PAT`, `REP`, `LEGREP`, `ADM` | The documents provided by the holder or by a person acting on their behalf, i.e. with the provider role `PAT`, `REP`, `LEGREP` or `ADM` |
| `HCP`, `ASS`           | The documents whose provider institution is an institution or group the requester is a member of     |
| `TCU`                  | The documents with the provider role `TCU` whose provider institution is the institution the technical user acts for |

<figcaption ID="1">Table 1: Roles which may provide a new version of a document.</figcaption>

The roles are the ones of the [CH Health Dossier Role](CodeSystem-HealthDossierRole.html) code system, conveyed in the
access token of the requester (see [Get Access Token [ITI-71]](iti-71.html)). A holder cannot provide a new version of
a document provided by a healthcare professional, an assistant or a technical user, but can record a
[personal note](ch-mhd-1.html#recording-a-personal-note) on it. The Document Recipient SHALL reject a request to
replace a document which the requester may not replace with HTTP `403 Forbidden` and an OperationOutcome with the issue
code `forbidden`.

The new version carries its own provider role and provider institution, the ones of the user who provides it.

##### Verification of the provider role and the provider institution

The Document Recipient SHALL verify that the [provider role](document-sharing-metadata.html#provider-role) equals the
role of the requester in the access token (`subject_role`, see [Get Access Token [ITI-71]](iti-71.html)).

Where the document carries a [provider institution](document-sharing-metadata.html#provider-institution), the Document
Recipient SHALL verify that it is an institution or group the requester is a member of, i.e. that its OID is the one of
the organization (`subject_organization_id`) or of one of the groups (`ch_group`) in the access token of the requester.

The Document Recipient SHALL reject a request which fails one of these verifications with HTTP `403 Forbidden` and an
OperationOutcome with the issue code `forbidden`.

#### Provide Document Bundle Response Message

The response Bundle SHALL follow the [CH MHD Provide Document Bundle Response](StructureDefinition-ch-mhd-providedocumentbundle-response.html)
Profile ([example: Bundle: BundleProvideDocument-Response](Bundle-BundleProvideDocument-Response.html)).

#### CapabilityStatement Resource

The CapabilityStatement resource for the **Document Source** is [MHD Document Source](CapabilityStatement-CH.MHD.DocumentSource.html).

The CapabilityStatement resource for the **Document Recipient** is [MHD Document Recipient](CapabilityStatement-CH.MHD.DocumentRecipient.html).

### Security Consideration

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with 
server certificates. 

The transaction SHALL use client authentication and authorization using an extended access token defined in [IUA](iti-71.html) conveyed as defined in the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction.

For every Provide Document Bundle [ITI-65] request, the Document Recipient SHALL enforce the access rules of the
holder and of the requesting health professional or health institution, as described in [Appendix: Enforcement of Access Rules](accesscontrol.html).
The Document Recipient SHALL reject the request if the requester is not authorized to record data in the health dossier of the holder concerned.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

##### Document Source Audit

The **Document Source** SHALL record an audit event according to
[CH Audit Event for [ITI-65] Document Source](StructureDefinition-ChAuditEventIti65Source.html) 
([example](AuditEvent-ChAuditEventIti65SourceExample.html)). Further examples of the Document Source:
[new version of a document](AuditEvent-ChAuditEventIti65SourceCorrectionExample.html),
[FHIR document](AuditEvent-ChAuditEventIti65SourceFhirDocumentExample.html),
[document provided by an assistant](AuditEvent-ChAuditEventIti65SourceAssistantExample.html),
[document provided by the holder](AuditEvent-ChAuditEventIti65SourcePatientExample.html),
[document provided by a clinical archive system](AuditEvent-ChAuditEventIti65SourceArchiveExample.html).

##### Document Recipient Audit

The **Document Recipient** SHALL record an audit event according to
[CH Audit Event for [ITI-65] Document Recipient](StructureDefinition-ChAuditEventIti65Recipient.html)
([example](AuditEvent-ChAuditEventIti65RecipientExample.html), for the DocumentReference
[DocRefPdf](DocumentReference-DocRefPdf.html) provided with the
[Provide Document Bundle](Bundle-BundleProvideDocument.html)).

The audit events record every document provided with its master identifier (not its title, type or confidentiality
code), the user who provided it and, for a healthcare professional, an assistant or a technical user, the provider
institution. Further examples of the Document Recipient:

- [new version of a document](AuditEvent-ChAuditEventIti65RecipientCorrectionExample.html), which names the document
  it replaces, for the DocumentReference in the
  [Provide Document Bundle for a corrected document](Bundle-BundleProvideDocumentCorrection.html);
- [FHIR document](AuditEvent-ChAuditEventIti65RecipientFhirDocumentExample.html), for the DocumentReference in the
  [Provide Document Bundle for a FHIR document](Bundle-BundleProvideFhirDocument.html);
- [document provided by an assistant](AuditEvent-ChAuditEventIti65RecipientAssistantExample.html), with the
  healthcare professional as main user and the assistant as delegated user, for the DocumentReference in the
  [Provide Document Bundle](Bundle-BundleProvideDocumentByAssistant.html);
- [document provided by the holder](AuditEvent-ChAuditEventIti65RecipientPatientExample.html), for the
  DocumentReference [DocRefPdfProvidedByPatient](DocumentReference-DocRefPdfProvidedByPatient.html)
  ([Provide Document Bundle](Bundle-BundleProvideDocumentByPatient.html));
- [document provided by a clinical archive system](AuditEvent-ChAuditEventIti65RecipientArchiveExample.html), for the
  DocumentReference [DocRefPdfProvidedByArchive](DocumentReference-DocRefPdfProvidedByArchive.html)
  ([Provide Document Bundle](Bundle-BundleProvideDocumentByArchive.html)).
