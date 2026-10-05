This section describes the additional requirements for the Swiss Health Dossier of the [Provide Document Bundle
[ITI-65]](https://profiles.ihe.net/ITI/MHD/ITI-65.html) transaction defined in the MHD Profile published in the IHE ITI 
Trial Implementation “Mobile Access to Health Documents”.

### Scope

In the Swiss Health Dossier the transaction is used by the MHD Document Source to store documents in the Health Dossier.

### Actor Roles

**Actor:** Document Source  
**Role:** Sends documents and metadata to the Document Recipient.  
**Actor:** Document Recipient  
**Role:** Accepts the document and metadata sent from the Document Source.  

### Referenced Standards

1. [Mobile access to Health Documents (MHD), Rev. {{site.data.fhir.ver.ihemhdfhir | split: "/" | last}}]({{site.data.fhir.ver.ihemhdfhir}})  
2. This MHD Profile is based on Release 4 of the [HL7® FHIR®](https://hl7.org/fhir/R4/index.html) standard.

### Messages

<div>{% include MHD_ActorDiagram_ITI-65.svg %}</div>

#### Provide Document Bundle Request Message

The FHIR `Bundle.meta.profile` shall have the following value:

`https://profiles.ihe.net/ITI/MHD/StructureDefinition/IHE.MHD.Minimal.ProvideBundle`

The additional metadata of the Swiss Health Dossier is defined with:

* [Author of the document](#author-of-the-document)
* [DocumentEntry.originalProviderRole](#documententryoriginalproviderrole)
* [Confidentiality code](#confidentiality-code)
* [Provider institution](#provider-institution)

The request Bundle SHALL follow the [CH MHD Provide Document Bundle](StructureDefinition-ch-mhd-providedocumentbundle.html)
Profile. Examples:

- [document provided by a healthcare professional](Bundle-BundleProvideDocument.html)
- [document provided by an assistant on behalf of a healthcare professional](Bundle-BundleProvideDocumentByAssistant.html)
- [document provided by a clinical archive system](Bundle-BundleProvideDocumentByArchive.html)
- [document provided by the patient](Bundle-BundleProvideDocumentByPatient.html)

The `sourceId` extension of the SubmissionSet, which MHD requires, SHALL carry the OID of the application of the
Document Source which provides the document. It is information only: no right to the document follows from it.

The `DocumentReference.content.attachment.url` value SHALL point to the resource carrying the document content, which
SHALL be included in the Bundle: a Binary resource, or the FHIR document Bundle resource for a FHIR document published
with the [ITI-65 FHIR Documents Publish Option](#publishing-a-fhir-document) (see
[Resolving references in Bundles](https://hl7.org/fhir/R4/bundle.html#references) for how to create a valid reference).

##### Publishing a FHIR document

The Document Source and the Document Recipient SHALL support the ITI-65 FHIR Documents Publish Option (see
[Actor options](iti-mhd.html#actor-options)). A FHIR document is published as the FHIR document Bundle resource itself,
carried in the entry of the Provide Document Bundle, and is not converted to a base64 encoded Binary
resource. `DocumentReference.content.attachment.url` points to that Bundle resource, `contentType` is
`application/fhir+json` or `application/fhir+xml`, and `size` and `hash` SHALL be absent.

The document is retrieved as a native FHIR document Bundle resource as well, see
[ITI-68](iti-68.html#expected-actions).

Example: [Provide Document Bundle for a FHIR document](Bundle-BundleProvideFhirDocument.html).

##### Correction of a published document

To correct a document (see the use case [Correction of a published document by a healthcare
professional](iti-mhd.html#use-cases)), the Document Source publishes the corrected document and points with
`DocumentReference.relatesTo` of type `replaces` to the document it corrects. The Document Recipient SHALL set the
`status` of the replaced document to `superseded` and SHALL keep it accessible: a superseded document is no longer
returned when searching for the current documents, but it can still be found with the `status` search parameter in
[ITI-67](iti-67.html) and retrieved with [ITI-68](iti-68.html).

Examples: [Provide Document Bundle for a corrected document](Bundle-BundleProvideDocumentCorrection.html), which
replaces the document [DocRefPdf](DocumentReference-DocRefPdf.html), and the replaced document
[as returned by the Document Responder after the correction](DocumentReference-DocRefPdfSuperseded.html), with the
`status` `superseded`.

Who may publish a new version of a document depends on the role of the requester, and on the role of the user who
provided the document to be replaced ([originalProviderRole](#documententryoriginalproviderrole)) and its
[provider institution](#provider-institution):

{:class="table table-bordered"}
| Roles                  | Documents of which a new version may be published                                                    |
|------------------------|------------------------------------------------------------------------------------------------------|
| `PAT`, `REP`, `LEGREP`, `ADM` | The documents provided by the patient or by a person acting on their behalf, i.e. with the originalProviderRole `PAT`, `REP`, `LEGREP` or `ADM` |
| `HCP`, `ASS`           | The documents whose provider institution is an institution or group the requester is a member of     |
| `TCU`                  | The documents with the originalProviderRole `TCU` whose provider institution is the institution the technical user acts for |

<figcaption ID="1">Table 1: Roles which may publish a new version of a document.</figcaption>

The roles are the ones of the [CH Health Dossier Role](CodeSystem-HealthDossierRole.html) code system, conveyed in the
access token of the requester (see [Get Access Token [ITI-71]](iti-71.html)). A patient cannot publish a new version of
a document provided by a healthcare professional, an assistant or a technical user, but can record a
[personal note](ch-mhd-1.html#recording-a-personal-note) on it. The Document Recipient SHALL reject a request to
replace a document which the requester may not replace with HTTP `403 Forbidden` and an OperationOutcome with the issue
code `forbidden`.

The new version carries its own originalProviderRole and provider institution, the ones of the user who publishes it.

##### Author of the document

The author of a document is information for the reader of the document metadata. The author is not necessarily the
user who provides the document, e.g. where a patient provides the report of a treatment abroad, or where a clinical
archive system provides the report of a healthcare professional. 

The author is optional and is given as text, in one of two forms:

- a single party, i.e. a person, an institution, the patient or a related person: a logical reference with the name
  in `author.display` and the kind of party in `author.type` (`Practitioner`, `Organization`, `Patient` or
  `RelatedPerson`), see the example
  [document provided by the patient](DocumentReference-DocRefPdfProvidedByPatient.html)
  ([Provide Document Bundle](Bundle-BundleProvideDocumentByPatient.html));
- a person together with the institution the person authored the document for: a reference to a PractitionerRole
  contained in the DocumentReference, which carries the name of the person in `practitioner.display` and the name of
  the institution in `organization.display`, each with the `type`, see the example
  [document provided by a healthcare professional](DocumentReference-DocRefPdf.html).

In both forms the Document Source MAY add an identifier to the name, e.g. the GLN of a healthcare professional, the
OID of an institution or the EPR-SPID of the patient, see the example
[document provided by a clinical archive system](DocumentReference-DocRefPdfProvidedByArchive.html)
([Provide Document Bundle](Bundle-BundleProvideDocumentByArchive.html)).

A DocumentReference carries at most one author. Where a document has more than one author, e.g. a FHIR document with
more than one `Composition.author`, the Document Source SHALL give the main author.

##### DocumentEntry.originalProviderRole

An extra metadata attribute SHALL be used to distinguish documents originally provided by patients, their
representatives or legal representatives from documents originally provided by healthcare professionals, assistants,
technical users or the administration. The extra metadata attribute SHALL be set by the Document Source actor to the
role value of the current user. It SHALL NOT be changed with
[Update Document Metadata [CH:MHD-1]](ch-mhd-1.html#metadata-which-may-be-updated), and the Document Responder rejects
such a request with an UnmodifiableMetadataError. The required metadata about the originalProviderRole of the Author is
represented in the DocumentReference using the extension with the URL
[http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ext-author-authorrole](StructureDefinition-ch-ext-author-authorrole.html).
The values are defined in the value set [CH Health Dossier Author Role](ValueSet-HealthDossierAuthorRole.html).

The Document Recipient SHALL verify that the originalProviderRole equals the role of the requester in the access token
(`subject_role`, see [Get Access Token [ITI-71]](iti-71.html)), and SHALL reject the request with HTTP `403 Forbidden`
and an OperationOutcome with the issue code `forbidden` otherwise.

##### Confidentiality code

The confidentiality code of the document (`DocumentReference.securityLabel`) SHALL be one of the two confidentiality
levels of the health dossier defined in the value set
[CH Health Dossier Confidentiality Code](ValueSet-HealthDossierConfidentialityCode.html): "allgemein" or "privat".
Health professionals and health institutions with an access right may read documents of the level "allgemein".
Documents of the level "privat" can only be read by the holder, and by those to whom the holder released them (see
[CH:PPQm](ppqm.html#consent-types)). The patient, a representative, a legal representative or the administration may
change the confidentiality code with [Update Document Metadata [CH:MHD-1]](ch-mhd-1.html#metadata-which-may-be-updated).

##### Provider institution

The provider institution is the health institution, or the group of healthcare professionals, on whose behalf a
healthcare professional, an assistant or a technical user provides the document. It is conveyed in
`DocumentReference.custodian` as a logical reference with the OID of the institution or group in
`custodian.identifier`.

The Document Source SHALL set the provider institution when the role of the current user is `HCP`, `ASS` or `TCU`, and
SHALL NOT set it otherwise: a document provided by the patient, a representative, a legal representative or the
administration has no provider institution.

The Document Recipient SHALL verify that the provider institution is an institution or group the requester is a member
of, i.e. that its OID is the one of the organization (`subject_organization_id`) or of one of the groups (`ch_group`)
in the access token of the requester (see [Get Access Token [ITI-71]](iti-71.html)), and SHALL reject the request with
HTTP `403 Forbidden` and an OperationOutcome with the issue code `forbidden` otherwise.

The provider institution SHALL NOT be changed with
[Update Document Metadata [CH:MHD-1]](ch-mhd-1.html#metadata-which-may-be-updated). The healthcare professionals and
assistants who are members of the provider institution may publish a
[new version](#correction-of-a-published-document) of the document and may [purge](ch-mhd-2.html) it, and may find the
documents their institution provided with the search parameter `custodian` of
[Find Document References [ITI-67]](iti-67.html#documents-provided-by-an-institution).

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
patient and of the requesting health professional or health institution, as described in [Appendix: Enforcement of Access Rules](accesscontrol.html).
The Document Recipient SHALL reject the request if the requester is not authorized to record data in the health
dossier of the patient concerned, or if the patient has declared that the data of the treatment concerned shall not
be recorded in their health dossier.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

##### Document Source Audit

The **Document Source** SHALL record an audit event according to
[CH Audit Event for [ITI-65] Document Source](StructureDefinition-ChAuditEventIti65Source.html) 
([example](AuditEvent-ChAuditEventIti65SourceExample.html)). Further examples of the Document Source:
[new version of a document](AuditEvent-ChAuditEventIti65SourceCorrectionExample.html),
[FHIR document](AuditEvent-ChAuditEventIti65SourceFhirDocumentExample.html),
[document provided by an assistant](AuditEvent-ChAuditEventIti65SourceAssistantExample.html),
[document provided by the patient](AuditEvent-ChAuditEventIti65SourcePatientExample.html),
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
- [document provided by the patient](AuditEvent-ChAuditEventIti65RecipientPatientExample.html), for the
  DocumentReference [DocRefPdfProvidedByPatient](DocumentReference-DocRefPdfProvidedByPatient.html)
  ([Provide Document Bundle](Bundle-BundleProvideDocumentByPatient.html));
- [document provided by a clinical archive system](AuditEvent-ChAuditEventIti65RecipientArchiveExample.html), for the
  DocumentReference [DocRefPdfProvidedByArchive](DocumentReference-DocRefPdfProvidedByArchive.html)
  ([Provide Document Bundle](Bundle-BundleProvideDocumentByArchive.html)).
