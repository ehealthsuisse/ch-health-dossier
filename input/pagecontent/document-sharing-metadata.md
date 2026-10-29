This page defines the metadata of the documents in the health dossier: which metadata a document carries, the value
set each one is bound to, and the element of the DocumentReference it is conveyed in. The metadata are the same in all
document transactions: the Document Source provides them with [Provide Document Bundle [ITI-65]](iti-65.html), the
Document Responder returns them with [Find Document References [ITI-67]](iti-67.html), and the holder may update some
of them with [Update Document Metadata [CH:MHD-1]](ch-mhd-1.html). They are defined in the profile
[CH MHD DocumentReference](StructureDefinition-ch-mhd-documentreference.html).

### Document metadata

{:class="table table-bordered"}
| Metadata | Opt. | DocumentReference element | Comment |
|---|---|---|---|
| Document Identifier | R | [`masterIdentifier`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.masterIdentifier) |  |
| Identifier | O | [`identifier`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.identifier) |  |
| Status | R | [`status`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.status) | `current` or `superseded`, see [New version of a document](#new-version-of-a-document) |
| [Holder](#holder) | R | [`subject`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.subject) | The EPR-SPID in `subject.identifier` |
| Document category | R | [`category`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.category) | Value set [DocumentEntry.classCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.classCode.html) |
| Document type | R | [`type`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.type) | Value set [DocumentEntry.typeCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.typeCode.html) |
| Title | R | [`content.attachment.title`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.title) |  |
| Creation time | R | [`content.attachment.creation`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.creation) |  |
| Event code | O | [`context.event`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.context.event) | Value set [DocumentEntry.eventCodeList](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.eventCodeList.html) |
| Facility type | R | [`context.facilityType`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.context.facilityType) | Value set [DocumentEntry.healthcareFacilityTypeCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.healthcareFacilityTypeCode.html) |
| Practice setting | R | [`context.practiceSetting`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.context.practiceSetting) | Value set [DocumentEntry.practiceSettingCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.practiceSettingCode.html) |
| Related identifier | O | [`context.related`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.context.related) |  |
| Format | R | [`content.format`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.format) | Value set [DocumentEntry.formatCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.formatCode.html) |
| MIME type | R | [`content.attachment.contentType`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.contentType) | Value set [DocumentEntry.mimeType](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.mimeType.html) |
| Language | R | [`content.attachment.language`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.language) | Value set [DocumentEntry.languageCode](http://fhir.ch/ig/ch-term/ValueSet-DocumentEntry.languageCode.html) |
| Size | O | [`content.attachment.size`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.size) | Absent for a FHIR document |
| Hash | O | [`content.attachment.hash`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.hash) | Absent for a FHIR document |
| Document location | R | [`content.attachment.url`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.content.attachment.url) | See [ITI-65](iti-65.html#provide-document-bundle-request-message) and [ITI-68](iti-68.html) |
| [Author](#author) | O | [`author`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.author) |  |
| [Provider role](#provider-role) | R | [`extension:providerRole`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.extension:providerRole) | Value set [CH Health Dossier Provider Role](ValueSet-HealthDossierProviderRole.html) |
| [Provider institution](#provider-institution) | C | [`custodian`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.custodian) | Required when the provider role is `HCP`, `ASS` or `TCU`, absent otherwise |
| [Confidentiality code](#confidentiality-code) | R | [`securityLabel`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.securityLabel) | Value set [CH Health Dossier Confidentiality Code](ValueSet-HealthDossierConfidentialityCode.html) |
| [Personal note](#personal-note) | O | [`extension:personalNote`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.extension:personalNote) |  |
| [Replaced document](#new-version-of-a-document) | O | [`relatesTo`](StructureDefinition-ch-mhd-documentreference-definitions.html#DocumentReference.relatesTo) | With the code `replaces` |

<figcaption ID="1">Table 1: Metadata of a document. Opt.: R required, O optional, C conditional.</figcaption>

### Submission set metadata

A document is provided in a submission set ([CH MHD SubmissionSet](StructureDefinition-ch-mhd-submissionset.html)),
which MHD requires.

{:class="table table-bordered"}
| Metadata | Opt. | SubmissionSet element | Comment |
|---|---|---|---|
| Unique Identifier of the submission | R | [`identifier:uniqueId`](StructureDefinition-ch-mhd-submissionset-definitions.html#List.identifier:uniqueId) |  |
| Holder | R | [`subject`](StructureDefinition-ch-mhd-submissionset-definitions.html#List.subject) | The EPR-SPID in `subject.identifier` |
| Date | R | [`date`](StructureDefinition-ch-mhd-submissionset-definitions.html#List.date) |  |
| Source | R | [`extension:sourceId`](StructureDefinition-ch-mhd-submissionset-definitions.html#List.extension:sourceId) | The source SHALL carry the OID of the application of the Document Source which provides the document. It is information only: no right to the document follows from it. |

<figcaption ID="2">Table 2: Metadata of a submission set.</figcaption>

### Holder

The holder is the person for whom the health dossier is kept. The holder is identified in `DocumentReference.subject`
by a logical reference with the EPR-SPID in `subject.identifier`, not by a contained resource. 

### Author

The author of a document is information for the reader of the document metadata. The author is not necessarily the
user who provides the document, e.g. where a holder provides the report of a treatment abroad, or where a clinical
archive system provides the report of a healthcare professional.

The author is optional and is given in one of three forms:

1. **A single party as text**, i.e. a person, an institution, the holder or a related person: the name of the reference in `author.display` and the kind of party in `author.type` (`Practitioner`, `Organization`, `Patient`
   or `RelatedPerson`), see the example [FHIR document](Bundle-BundleProvideFhirDocument.html).
2. **A person and an institution as text**, i.e. a person together with the institution the person authored the
   document for: a reference to a PractitionerRole contained in the DocumentReference, which carries the name of the
   person in `practitioner.display` and the name of the institution in `organization.display`, each with the `type`.
   This form fits where only the names are known, e.g. where a holder provides the report of a treatment abroad, see
   the example [document provided by the holder](DocumentReference-DocRefPdfProvidedByPatient.html)
   ([Provide Document Bundle](Bundle-BundleProvideDocumentByPatient.html)), or the example
   [document provided by a healthcare professional](DocumentReference-DocRefPdf.html).
3. **A person and an institution as structured data**, where the Document Source has them, e.g. the primary system of
   a healthcare professional: as in form 2 a contained PractitionerRole, but its `practitioner` and `organization`
   point to a contained Practitioner and a contained Organization. The Practitioner carries the name of the person
   (`name.given`, `name.family` and the title in `name.prefix`), the Organization the name of the institution (`name`)
   and its address (`address`), see the example
   [author as structured data](DocumentReference-DocRefPdfStructuredAuthor.html)
   ([Provide Document Bundle](Bundle-BundleProvideDocumentStructuredAuthor.html)).

In all forms the Document Source MAY add an identifier, e.g. the GLN of a healthcare professional, the OID of an
institution or the EPR-SPID of the holder: in form 1 in `author.identifier`, in form 2 in `practitioner.identifier`
and `organization.identifier` of the contained PractitionerRole, see the example
[document provided by a clinical archive system](DocumentReference-DocRefPdfProvidedByArchive.html)
([Provide Document Bundle](Bundle-BundleProvideDocumentByArchive.html)), and in form 3 in `identifier` of the
contained Practitioner and Organization.

A DocumentReference carries at most one author. Where a document has more than one author, e.g. a FHIR document with
more than one `Composition.author`, the Document Source SHALL give the main author.

The author SHALL NOT be changed with [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated). Since the author is
mostly given as text, the search parameters on the structured name of the author are not supported, see
[ITI-67](iti-67.html#search-for-the-author-of-a-document).

### Provider role

The provider role is the role of the user who provided the document. It distinguishes documents provided by holders,
their representatives or legal representatives from documents provided by healthcare professionals, assistants,
technical users or the administration. Together with the [provider institution](#provider-institution) it
determines who may provide a [new version](iti-65.html#correction-of-a-provided-document) of the document or
[purge](ch-mhd-2.html) it.

The provider role SHALL be conveyed in the DocumentReference with the extension
[http://fhir.ch/ig/ch-health-dossier/StructureDefinition/ch-ext-provider-role](StructureDefinition-ch-ext-provider-role.html),
with a value from the value set [CH Health Dossier Provider Role](ValueSet-HealthDossierProviderRole.html). The
Document Source SHALL set it to the role of the current user, which the Document Recipient verifies against the access
token (see [ITI-65](iti-65.html#verification-of-the-provider-role-and-the-provider-institution)). It SHALL NOT be
changed with [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated).

### Provider institution

The provider institution is the health institution, or the group of healthcare professionals, on whose behalf a
healthcare professional, an assistant or a technical user provides the document. It is conveyed in
`DocumentReference.custodian` as a logical reference with the OID of the institution or group in
`custodian.identifier`, and optionally its name in `custodian.display`. It is not necessarily the institution of the
author of the document.

The Document Source SHALL set the provider institution when the role of the current user is `HCP`, `ASS` or `TCU`, and
SHALL NOT set it otherwise. The Document Recipient verifies it against the access token (see
[ITI-65](iti-65.html#verification-of-the-provider-role-and-the-provider-institution)).

The provider institution SHALL NOT be changed with [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated). The
healthcare professionals and assistants who are members of the provider institution may provide a
[new version](iti-65.html#correction-of-a-provided-document) of the document and may [purge](ch-mhd-2.html) it.

### Confidentiality code

The confidentiality code of the document (`DocumentReference.securityLabel`) SHALL be one of the two confidentiality
levels of the health dossier defined in the value set
[CH Health Dossier Confidentiality Code](ValueSet-HealthDossierConfidentialityCode.html): "normal" (SNOMED CT
`17621005` Normal, "allgemein" in the EGDG) or "restricted" (SNOMED CT `263856008` Restricted, "privat" in the EGDG).
Health professionals and assistants may read documents of the level "normal", if the holder authorized the health
professional or the institution.
Documents of the level "restricted" can only be read by the holder, by representatives and community administrators, and by the
health professionals, groups and health institutions to whom the holder granted access to the individual document (see
[CH:PPQm](ppqm-consent.html#consent-access)).

The holder, a representative, a legal representative or the community administrators may change the confidentiality
code with [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated).

### Personal note

The holder may record a personal note on a document, e.g. where the holder does not agree with the author on the
correctness of its data (Art. 8 para. 4 EGDG). The note is conveyed in the extension
[personalNote](StructureDefinition-ch-ext-personalnote.html) with the text of the note, the holder it belongs to and the
time it was recorded. It is part of the metadata only: the document itself stays unchanged and no new version is
provided. A document may carry at most one personal note of the holder.

A personal note is recorded with [CH:MHD-1](ch-mhd-1.html#recording-a-personal-note).

### New version of a document

A document may be updated by a new version, e.g. to correct a provided document. The new version points with
`DocumentReference.relatesTo` of type `replaces` to the document it replaces, and the replaced document gets the
`status` `superseded`. A new version may carry a new set of metadata in its DocumentReference, which may update the
provider role, the provider institution and the confidentiality code. The Document Source sets them for the new
version as described in [ITI-65](iti-65.html#correction-of-a-provided-document).
