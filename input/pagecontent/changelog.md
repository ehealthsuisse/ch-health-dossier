### DSTU1 Release 2026-08-xx

#### Resolved Issues
* PDQm
  * Defined mapping for eCH-0215 / 213 (https://github.com/ehealthsuisse/ch-health-dossier/issues/7)
  * Added support for identifying a patient by the minimal demographics and the AHVN13 in ITI-119 to retrieve the EPR-SPID (https://github.com/ehealthsuisse/ch-health-dossier/issues/2)
* PIXm
    * Removed ITI-83 Query (no local-id cross-referencing) 
    * Restricted ITI-104 Feed to allow only update of contact information (revise message), requires extended access token
* MHD 
  * Removing Federated Option, Proxy Option and homeCommunityId 
  * Require Minimal Data based on Health Dossier Metadata Option
  * Replaced the CH:ADR Authorization Decision Consumer grouping in ITI-65,  ITI-67, ITI-68, CH:MHD-1 and ITI-81 with the
    new [Appendix: Enforcement of Access Rules](accesscontrol.html), covering the access rules of the patient and of the
    requesting health professional or health institution
  * Added the CH MHD DocumentReference profile to the Volume 3 menu and moved the menu definition from `input/includes/menu.xml` to the `menu` attribute in `sushi-config.yaml`
  * Required `DocumentReference.author` (1..*) and required it to be identified either by a logical reference carrying
    the identifier of the authoring person or institution in `author.identifier` — analogous to `subject.identifier`
    carrying the EPR-SPID, typically a GLN, or an EPR-SPID for a patient author — or by a reference to a resource,
    contained or held elsewhere (invariant `ch-mhd-author-1`). 
  * Removed DocumentReference.sourcePatientInfo and authorSpeciality requirement
  * Required the ITI-65 FHIR Documents Publish Option for the Document Source and the Document Recipient, so that a
    FHIR document can be published as a FHIR document Bundle resource in the `FhirDocuments` entry of the
    [CH MHD Provide Document Bundle](StructureDefinition-ch-mhd-providedocumentbundle.html) instead of being converted
    to a base64 encoded Binary resource, see [ITI-65](iti-65.html#publishing-a-fhir-document). Required in
    [ITI-68](iti-68.html#expected-actions) that a FHIR document is returned as a native FHIR document Bundle resource
    and not wrapped in a Binary resource, in line with the European Health Data API.
    TODO: provide an example for it
  * Added the use case [Healthcare professional corrects a published document](iti-mhd.html#use-cases): a
    document with incorrect data is corrected by publishing a new version, the incorrect document is not removed and
    stays accessible; how the corrected document is published is described in
    [ITI-65](iti-65.html#correction-of-a-published-document).
    TODO: provide an example for it (corrected document with `DocumentReference.relatesTo` of type `replaces`, replaced
    document with `status` `superseded`)
  * Added the use case [Document published in the health dossier of the wrong person](iti-mhd.html#use-cases): the
    document has to be deleted, and the health professional or health institution which published it requests the
    deletion with [CH:MHD-1](ch-mhd-1.html#requesting-the-deletion-of-a-document) by setting the DeletionStatus
    extension to `urn:e-health-suisse:2019:deletionStatus:deletionRequested`.
    TODO: provide an example for it
  * Added the use case [Patient has a document deleted](iti-mhd.html#use-cases): the patient can have any document of
    their health dossier deleted, the ones they recorded themselves as well as the ones a health professional or
    health institution published. The deletion is requested with the same DeletionStatus extension as above.
    TODO: provide an example for it
  * Added the use case [Patient adds a personal note to a document](iti-mhd.html#use-cases): where patient and author
    do not agree on the correctness of a document, or the author is no longer practising, the patient can record a
    personal note on the document, without a new version of the document. The note is recorded with
    [CH:MHD-1](ch-mhd-1.html#recording-a-personal-note) in the new extension
    [CH Extension Personal Note](StructureDefinition-ch-ext-personalnote.html), which carries an `Annotation` with the
    text of the note, the patient it belongs to and the time it was recorded; it is not recorded in
    `DocumentReference.description`, which carries the comment of the author of the document.
    TODO: provide an example for it
  * Stated in [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated) which metadata may be updated by which role:
    the confidentiality code and the personal note by `PAT`, `REP`, `LEGREP` and `ADM`, the deletion status by these
    roles and by `HCP` and `ASS`; every other change requires a new version of the document. A request updating other metadata, or metadata the
    role of the requester may not update, is rejected with an UnmodifiableMetadataError
* Roles
  * Added the CodeSystem [CH Health Dossier Role](CodeSystem-HealthDossierRole.html)
    (`urn:oid:2.16.756.5.30.1.127.3.10.19`) with the roles of the E-GD, succeeding the CH Term code system for eHealth
    roles (`urn:oid:2.16.756.5.30.1.127.3.10.6`): the two administrator roles Document Administrator (`DADM`) and
    Policy Administrator (`PADM`) are replaced by the single role `ADM` (Administration), and `LEGREP` (Gesetzliche
    Vertretung) is added for the legal representative of a minor or of a person lacking capacity of judgement, as
    distinct from a representative designated by the holder (`REP`). The OID still has to be registered with
    eHealth Suisse
  * Replaced the ValueSet `EprParticipant` with [CH Health Dossier Participant](ValueSet-HealthDossierParticipant.html),
    which combines the roles above with the group of health professionals (`GRP`), and repointed the bindings of
    `AuditEvent.agent.role` and `AuditEvent.entity.role` in the ATC audit event profiles to it
  * Rebound the extension [CH Extension Author AuthorRole](StructureDefinition-ch-ext-author-authorrole.html) to the new
    ValueSet [CH Health Dossier Author Role](ValueSet-HealthDossierAuthorRole.html), replacing the CH Term value set
    DocumentEntry.originalProviderRole; the group of health professionals (`GRP`) is not part of it, since a group
    cannot be the author of a document (the canonical url changed anyway, but it is also a breaking change)
* Fork from [CH EPR FHIR](https://fhir.ch/ig/ch-epr-fhir/5.0.0/), rename to CH Health Dossier