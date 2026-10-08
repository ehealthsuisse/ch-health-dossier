### DSTU1 Release 2026-08-xx

#### Resolved Issues
* Replaced the term "holder" with "patient" in all pages, profiles, code systems and examples.
* Integrated the ch-epr-fhir issues [#456](https://github.com/ehealthsuisse/ch-epr-fhir/issues/456), [#458](https://github.com/ehealthsuisse/ch-epr-fhir/issues/458) and [#460](https://github.com/ehealthsuisse/ch-epr-fhir/issues/460)
* IUA
  * Refactored the specification to use the IUA client credential flow for portals, primary systems and digital health apps and convey 
    the Identity Token in in the *id_token* field of the token request. 
  * Add support for client-asymmetric authentication specified in FHIR Backend Service authentication section and is used in the European Health Data Space and UMZH Connect.  
  * Removed the SMART on FHIR standalone and EHR launch option. 
  * Removed the specification of the TCU option, the separate token flow for technical users, since TCU requests are
    now usual client credential requests without an identity token of a user. The `TCU` role and the onboarding checks
    for clinical archive systems in [ITI-71](iti-71.html#clinical-archive-systems) remain. 
  * Updated the `subject_role` scope and claim in [ITI-71](iti-71.html) to the code system
    [CH Health Dossier Role](CodeSystem-HealthDossierRole.html) (`2.16.756.5.30.1.127.3.10.19`) with all roles
    (`PAT`, `REP`, `LEGREP`, `HCP`, `ASS`, `TCU`, `ADM`), corrected `LREP` to `LEGREP` and the role of the assistant
    in the JWT example to `ASS`.
  * Corrected the `purpose_of_use` system in the JWT examples of [ITI-71](iti-71.html) from
    `urn:uuid:2.16.756.5.30.1.127.3.10.5` to `urn:oid:2.16.756.5.30.1.127.3.10.5`.
  * Replaced the CH:XUA Authenticate User transaction with the user authentication specified in
    [OpenID Connect](openid-connect.html): the IUA Authorization Client authenticates the user at the Identity Provider
    as Relying Party and conveys the identity token in the `id_token` parameter of [ITI-71](iti-71.html); updated the
    IUA actor diagram accordingly.
  * Changed the [ITI-71](iti-71.html) token request example of a clinical archive system from a basic to an extended
    access token with `person_id`, since the clinical archive knows the EPR-SPID and no longer queries it with PIXm ITI-83.
    Added a token request example of a clinical archive system for a basic access token (without `person_id`), e.g. to
    record its audit events with ITI-20. The `scope` parameter with the `purpose_of_use` and `subject_role` scopes is
    required for both basic and extended access tokens, and the `subject_role` and `purpose_of_use` claims are required
    in the basic access token too.
  * Replaced the remarks referring to the removed Workflow Initiator Option and Technical User Option in the required
    actor groupings with the transactions a technical user (`TCU`) may use: ITI-65, ITI-90, ITI-130, ITI-119, ITI-20, not allowed for all other IUA Authorization Clients. Added the rule to reject `TCU` access tokens
    for other transactions in [Enforcement of Access Rules](accesscontrol.html#technical-users).
  * Updated the `user_id` table of the JWT `ch_epr` extension in [ITI-71](iti-71.html): merged the Document
    Administrator and Policy Administrator into Administration (`ADM`) with the qualifier
    `urn:e-health-suisse:administrator-id`, added the Legal Representative (`LEGREP`) with the qualifier
    `urn:e-health-suisse:representative-id`, and corrected the swapped administrator qualifiers.
  * [ITI-65](iti-65.html#provider-role): renamed the extension CH Extension Author AuthorRole
    (`ch-ext-author-authorrole`) to [CH Extension Provider Role](StructureDefinition-ch-ext-provider-role.html). The
    provider role SHALL NOT be changed with CH:MHD-1, added legal representatives and the administration, and linked
    the provider role to the value set
    [CH Health Dossier Provider Role](ValueSet-HealthDossierProviderRole.html) instead of the CH Term value sets.
  * Corrected the mapping of the access token to the audit event agents in
    [CH Audit Event with a Basic Auth Token](StructureDefinition-ChAuditEventBasicToken-mappings.html): for an access
    token with the `ch_delegation` extension (assistant) the healthcare professional (principal) is the main user
    and the authenticated assistant is the delegated user; the mapping had the two swapped. A technical user is the
    main user, identified by the GLN of the legal responsible person. Described the two agents in [ITI-20](iti-20.html).
* Corrections
  * The audit event examples of the MHD, PIXm, PDQm, mCSD and PPQm transactions carry the role of the healthcare
    professional in the code system [CH Health Dossier Role](CodeSystem-HealthDossierRole.html)
    (`urn:oid:2.16.756.5.30.1.127.3.10.19`) instead of the EPR code system `urn:oid:2.16.756.5.30.1.127.3.10.6`.
  * The ATNA audit event examples name the server-side actor (audit source and destination agent) after the serving
    system instead of `Community A`: `Health Dossier` for MHD, `MPI` for PIXm and PDQm, `HPD` for mCSD, `Policy Repository` for PPQm.
  * Removed the mTLS alternative from the security considerations of [ITI-90](iti-90.html) and [ITI-20](iti-20.html),
    the transactions are authorized with a basic access token.
  * Fixed the broken links to the message semantics and to the SMART on FHIR scopes in [ITI-71](iti-71.html).
  * The MHD Document Responder is grouped with the IUA Resource Server (was IUA Authorization Client), see
    [MHD](iti-mhd.html#required-actor-groupings).
  * Corrected the scope of [CH:MHD-1](ch-mhd-1.html) (Document Source instead of Document Consumer) and removed a
    duplicated sentence.
  * Renamed the error codes of [CH:MHD-1](ch-mhd-1.html#expected-actions) `XDSMetadataIdentifierError` and
    `XDSPatientIDReconciliationError` to `MetadataIdentifierError` and `PatientIDReconciliationError`.
  * Removed the unused NamingSystem `IheItiXds2013UniqueId` (`urn:ihe:iti:xds:2013:uniqueId`).
  * Distinct titles for the PPQm code systems and value sets with the same title.
* OpenID Connect
  * Added the OpenID Connect page (Annex 8) specifying the authorization code flow, identity token, UserInfo and RP-initiated logout for EPR Identity Providers.
* Sequence diagrams
  * Removed the SMART on FHIR sequence diagrams for patients and healthcare professionals (EHR launch).
  * Removed the mTLS option, the IUA JWT token option is now the regular IUA flow with the extended access token.
  * Removed the ITI-83 PIXm query from the clinical archive diagram, the clinical archive knows the EPR-SPID.
  * Removed the loop over confidentiality codes when publishing documents.
  * Removed the unused diagram sources for the SMART on FHIR standalone launch with the identity provider.
  * Renamed the participant group "Community Components" to "Health Dossier Information System".
* mCSD
  * [Examples](iti-mcsd.html#examples): removed the link to the eHealth Suisse test data (Community A and B) and
    cropped the picture of the example structure to the health institutions and health professionals, the
    communities are no longer shown.
  * Removed the community information from the mCSD examples: the Organization example of Community A and its note
    that the community itself is not returned, since health institutions and health professionals are no longer
    related to a community.
  * Removed the LDAP identifiers (`urn:ietf:rfc:4514`, the DN of the HPD entry) from the profiles
    [CH mCSD Organization](StructureDefinition-CH.mCSD.Organization.html),
    [CH mCSD Practitioner](StructureDefinition-CH.mCSD.Practitioner.html) and
    [CH mCSD PractitionerRole](StructureDefinition-CH.mCSD.PractitionerRole.html), from all mCSD examples and from the
    LDAP schema mappings, together with the profile LdapIdentifier and the NamingSystem LDAP. Removed the considerations
    for implementing mCSD with an LDAP backend (HPD) from [ITI-130](iti-130.html). The informative mapping to the LDAP
    schema of the HPD in the profiles is kept.
* PDQm
  * Defined mapping for eCH-0215 / 213 (https://github.com/ehealthsuisse/ch-health-dossier/issues/7)
  * Added support for identifying a patient by the minimal demographics and the AHVN13 in ITI-119 to retrieve the EPR-SPID (https://github.com/ehealthsuisse/ch-health-dossier/issues/2)
  * Added a sequence diagram for retrieving the EPR-SPID of a patient by the minimal demographics and the AHVN13
* PIXm
    * Removed ITI-83 Query (no local-id cross-referencing) 
    * Restricted ITI-104 Feed to allow only update of contact information (revise message), requires extended access token
* MHD 
  * Removing Federated Option, Proxy Option and homeCommunityId 
  * Require Minimal Data based on Health Dossier Metadata Option
  * Replaced the CH:ADR Authorization Decision Consumer grouping in ITI-65,  ITI-67, ITI-68, CH:MHD-1 and ITI-81 with the
    new [Appendix: Enforcement of Access Rules](accesscontrol.html), covering the access rules of the patient and of the
    requesting health professional or health institution
  * Added the CH MHD DocumentReference profile to the Volume 3 menu
  * Separated the author of a document from who provided it, in the
    [CH MHD DocumentReference](StructureDefinition-ch-mhd-documentreference.html) only, without the SubmissionSet:
    * `DocumentReference.author` (0..1) is information for the reader and is given in one of three forms: a logical
      reference with `display` and `type` (Practitioner, Organization, Patient or RelatedPerson), a contained
      PractitionerRole with the name of the person and of the institution as text in `practitioner.display` and
      `organization.display`, or a contained PractitionerRole referencing a contained Practitioner (structured name
      with given name, family name and title) and a contained Organization (name and address); an identifier (GLN,
      OID, EPR-SPID) may be added (invariants `ch-mhd-author-1`, `ch-mhd-author-2` and `ch-mhd-author-3`), see
      [ITI-65](iti-65.html#author-of-the-document). No right to a document follows from its author.
    * `DocumentReference.custodian` carries the [provider institution](iti-65.html#provider-institution): the OID of
      the institution or group on whose behalf the document was provided. It is required for the provider role
      `HCP`, `ASS` and `TCU` and absent otherwise (invariant `ch-mhd-custodian-1`).
    * The Document Recipient verifies the provider role and the provider institution against the access token
      in [ITI-65](iti-65.html); both, and the author, cannot be changed with [CH:MHD-1](ch-mhd-1.html).
    * Stated in [ITI-65](iti-65.html#correction-of-a-published-document) which role may publish a new version of
      which documents, and keyed the right of `HCP` and `ASS` to purge a document in
      [CH:MHD-2](ch-mhd-2.html#roles-which-may-purge-a-document) on the provider institution instead of the author.
    * Removed the extension for the SubmissionSet.Author.AuthorRole from the
      [CH MHD SubmissionSet](StructureDefinition-ch-mhd-submissionset.html): the role of the provider is carried in
      the DocumentReference only.
    * [ITI-67](iti-67.html): added the search parameter `custodian` to find the documents provided by an institution;
      the search parameters `author.given` and `author.family` of MHD are not supported, since the author is mostly
      given as text (deviation from MHD). Replaced `author` by `custodian` in the MHD Document Consumer and Document Responder
      CapabilityStatements.
    * Audit events of the document transactions ([ITI-65](iti-65.html), [ITI-68](iti-68.html),
      [CH:MHD-1](ch-mhd-1.html), [CH:MHD-2](ch-mhd-2.html)): the document is recorded only with its master identifier,
      not its title, type or confidentiality code (for ITI-65 one entity per document, naming the replaced document
      for a new version; for a change of the confidentiality code in CH:MHD-1 the new confidentiality code), with the role `Report` instead of `Job` in CH:MHD-1 and
      CH:MHD-2. Added the optional agent `group` (0..*) for the institutions or groups of the main user to the CH audit event
      profiles, fixed the system of the patient identifier to the EPR-SPID for transactions with an extended access
      token, and added audit event examples for all document transaction examples (see [ITI-20](iti-20.html) and
      [CH:ATC](volume3.html#audit-trail-of-the-document-transactions)).
    * Added the code system [CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html),
      successor of the Audit Trail Consumption event types of the EPR: `ATC_DOC_UPDATE` is split into
      `ATC_DOC_UPDATE_CONFIDENTIALITY` and `ATC_DOC_UPDATE_NOTE`, and `ATC_DOC_NEW_VERSION` is added. The audit
      events of the document transactions carry the type as an additional subtype, required for the actor serving
      the request, so that an audit consumer can filter on it (see
      [audit event types](volume3.html#audit-trail-consumption-event-types)).
    * Removed the CH:ATC Document Audit Event Content Profile (profile `DocumentAuditEvent`, value set
      `DocumentAuditEventType`, identifier profile `ch-atc-uniqueid-identifier` and the examples `atc-doc-*`): the
      audit trail of a patient is built from the audit events of the document transactions, see
      [CH:ATC](volume3.html#audit-trail-of-the-document-transactions). The response of [ITI-81](iti-81.html) and the
      Patient Audit Record Repository CapabilityStatement refer to the audit event profiles of the Document Recipient
      and Document Responder instead, and ITI-81 can be filtered on the audit event types with `subtype`.
    * Added the examples [document provided by the patient](DocumentReference-DocRefPdfProvidedByPatient.html)
      (author as a contained PractitionerRole with the names of the foreign doctor and clinic as text),
      [document provided by a clinical archive system](DocumentReference-DocRefPdfProvidedByArchive.html) and
      [author as structured data](DocumentReference-DocRefPdfStructuredAuthor.html), each with
      its Provide Document Bundle, and the Provide Document Bundle for a document provided by an assistant with
      its audit events (healthcare professional as main user, assistant as delegated user).
  * Removed DocumentReference.sourcePatientInfo and authorSpeciality requirement
  * Required the ITI-65 FHIR Documents Publish Option for the Document Source and the Document Recipient, so that a
    FHIR document can be published as a FHIR document Bundle resource in the `FhirDocuments` entry of the
    [CH MHD Provide Document Bundle](StructureDefinition-ch-mhd-providedocumentbundle.html) instead of being converted
    to a base64 encoded Binary resource, see [ITI-65](iti-65.html#publishing-a-fhir-document). Required in
    [ITI-68](iti-68.html#expected-actions) that a FHIR document is returned as a native FHIR document Bundle resource
    and not wrapped in a Binary resource, in line with the European Health Data API. Added the example
    [Provide Document Bundle for a FHIR document](Bundle-BundleProvideFhirDocument.html).
  * Added the use case [Healthcare professional corrects a published document](iti-mhd.html#use-cases): a
    document with incorrect data is corrected by publishing a new version, the incorrect document is not removed and
    stays accessible; how the corrected document is published is described in
    [ITI-65](iti-65.html#correction-of-a-published-document). Added the examples
    [Provide Document Bundle for a corrected document](Bundle-BundleProvideDocumentCorrection.html)
    (`DocumentReference.relatesTo` of type `replaces`) and
    [replaced document with status superseded](DocumentReference-DocRefPdfSuperseded.html).
  * Added the transaction [Purge Document [CH:MHD-2]](ch-mhd-2.html) with the synchronous operation
    [`DocumentReference/[id]/$purge`](OperationDefinition-CHMhdPurge.html), modelled after the R6 `Patient/$purge`
    operation, which irrevocably removes a document with all versions of its metadata. It replaces requesting the
    deletion with CH:MHD-1 by setting the DeletionStatus extension to `deletionRequested`; the DeletionStatus
    extension itself is kept for now.
  * Removed the List resource (SubmissionSet) from the Document Consumer CapabilityStatement, since Find Document
    Lists [ITI-66] is not available.
  * Added the use case [Healthcare professional deletes a document published for the wrong person](iti-mhd.html#use-cases): the
    document has to be deleted, and the health professional or health institution which published it deletes it with
    [CH:MHD-2](ch-mhd-2.html).
  * Added the use case [Patient deletes a document](iti-mhd.html#use-cases): the patient can have any document of
    their health dossier deleted, the ones they recorded themselves as well as the ones a health professional or
    health institution published, with [CH:MHD-2](ch-mhd-2.html).
  * Added the use case [Patient adds a personal note to a document](iti-mhd.html#use-cases): where patient and author
    do not agree on the correctness of a document, or the author is no longer practising, the patient can record a
    personal note on the document, without a new version of the document. The note is recorded with
    [CH:MHD-1](ch-mhd-1.html#recording-a-personal-note) in the new extension
    [CH Extension Personal Note](StructureDefinition-ch-ext-personalnote.html), which carries an `Annotation` with the
    text of the note, the patient it belongs to and the time it was recorded; a document carries at most one personal
    note. It is not recorded in
    `DocumentReference.description`, which carries the comment of the author of the document. Added the example
    [DocumentReference with a personal note](DocumentReference-DocRefPdfPersonalNote.html).
  * Stated in [CH:MHD-1](ch-mhd-1.html#metadata-which-may-be-updated) which metadata may be updated by which role:
    the confidentiality code and the personal note by `PAT`, `REP`, `LEGREP` and `ADM`; every other change requires a
    new version of the document. A request updating other metadata, or metadata the role of the requester may not
    update, is rejected with an UnmodifiableMetadataError
  * [#9](https://github.com/ehealthsuisse/ch-health-dossier/issues/9): Required the
    [Full-Text Search Option](iti-mhd.html#full-text-search-option) for the Document Responder (optional for the Document Consumer);
    the Document Responder SHALL support the `full-text` search parameter in [ITI-67](iti-67.html#full-text-search-option),
    added to the MHD Document Consumer and Document Responder CapabilityStatements.
    Grouped the actor options table per actor. Needs update to the to be published MHD release.
* Roles
  * Added the CodeSystem [CH Health Dossier Role](CodeSystem-HealthDossierRole.html)
    (`urn:oid:2.16.756.5.30.1.127.3.10.19`) with the roles of the E-GD, succeeding the CH Term code system for eHealth
    roles (`urn:oid:2.16.756.5.30.1.127.3.10.6`): the two administrator roles Document Administrator (`DADM`) and
    Policy Administrator (`PADM`) are replaced by the single role `ADM` (Administration), and `LEGREP` (Gesetzliche
    Vertretung) is added for the legal representative of a minor or of a person lacking capacity of judgement, as
    distinct from a representative designated by the patient (`REP`). The OID still has to be registered with
    eHealth Suisse
  * Replaced the ValueSet `EprParticipant` with [CH Health Dossier Participant](ValueSet-HealthDossierParticipant.html),
    which combines the roles above with the group of health professionals (`GRP`), and repointed the bindings of
    `AuditEvent.agent.role` and `AuditEvent.entity.role` in the ATC audit event profiles to it
  * Rebound the extension [CH Extension Provider Role](StructureDefinition-ch-ext-provider-role.html) to the new
    ValueSet [CH Health Dossier Provider Role](ValueSet-HealthDossierProviderRole.html); the group of health
    professionals (`GRP`) is not part of it, since a group cannot provide a document (the canonical url changed anyway, but it is also a breaking change)
* Confidentiality code
  * Added the value set [CH Health Dossier Confidentiality Code](ValueSet-HealthDossierConfidentialityCode.html) with
    the two levels of the E-GD, "allgemein" (SNOMED CT `Normal`) and "privat" (SNOMED CT `Restricted`); `Secret` is not
    used any more. Bound
    `DocumentReference.securityLabel` of the [CH MHD DocumentReference](StructureDefinition-ch-mhd-documentreference.html),
    the confidentiality code of the document in the audit events and `Consent.provision.securityLabel` of CH:PPQm to it,
    and described it in [ITI-65](iti-65.html#confidentiality-code). The codes are not decided yet (issue #12).
  * The pages name the two levels by their SNOMED CT concepts, "normal" and "restricted", instead of the EGDG terms
    "allgemein" and "privat"; [ITI-65](iti-65.html#confidentiality-code) gives the mapping.
* PPQm
  * Adapted [CH:PPQm](ppqm.html) to the EGDG and the requirements catalogue of the E-GD authorization system: a
    Consent records one decision of the patient per consent type, instead of the image of an EPR policy set template.
    Separated the rights by law from the rights by consent, described a use case per consent type and added the
    authorization of the transactions by consent type and role.
  * [CH:PPQm](ppqm.html) in Volume 1 gives an overview of the consent types only; the rights by law and by consent, the
    common rules, the use case per consent type and the authorization by consent type and role moved to the new
    Volume 3 page [CH PPQm Consent](ppqm-consent.html).
  * Replaced the profile `PpqmConsent` and the template profiles 201-304 with the base profile
    [CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) and one profile per consent type: opening, emergency
    access, access for a health professional, group or health institution, indirect authorization, indirect
    authorization setting, delegation, representative, legal representative, digital health application and recording
    by military health professionals, each with an example. Breaking change.
  * Added the code systems [CH Health Dossier Consent Type](CodeSystem-HealthDossierConsentType.html) and
    [CH Health Dossier Consent Action](CodeSystem-HealthDossierConsentAction.html), and the client ID of a digital
    health application as actor identifier type. The emergency access applies to the level "normal" only; the default provide level (template 203) and the purposes of use
    `AUTO` and `DICOM_AUTO` are dropped.
  * Removed the code systems and value sets of the policy set templates and the referenced policy sets, the consent
    identifier type, the XACML mapping and the section on the relation to CH:PPQ.
  * [PPQ-3](ppq-3.html) and [PPQ-4](ppq-4.html): added the expected actions common to all HTTP methods, the
    authorization by consent type and role with the performer of the consent, the validation rules by consent type and
    the Policy Repository rules (legal representative, delegations of a deleted access right, digital health
    application after three months without access, purged documents, dissolution). PPQ-4 validates the rules against
    the consents as they are after all entries, and processes the Bundle as a whole.
  * The Policy Repository adds the [opening](ppqm-consent.html#consent-opening), the emergency access and the indirect
    authorization setting itself when the Register E-GD records the opening, automatic (canton as performer) or
    voluntary, and records it with
    [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html).
    The administration may only retrieve the opening. The opening requires the community managing the health dossier
    in `organization`, which SHALL be the one of the Register E-GD, and carries no `source[x]`. The PPQ-4 add example now shows a request of the
    patient.
  * [PPQ-5](ppq-5.html): added the search parameters `category`, `actor:identifier`, `period` and
    `source-reference:identifier`, made `patient:identifier` required, and filtered the response by the consents the
    requester may retrieve. Updated the CapabilityStatements with the search parameters and the profiles per consent
    type.
  * Replaced the security considerations of PPQ-3, PPQ-4 and PPQ-5 with the extended access token of IUA; removed the
    XUA/mTLS alternative and the grouping of the Policy Repository with CH:ADR.
  * Built the audit trail of the consents from the audit events of the Policy Repository, see
    [Audit trail of the consent transactions](volume3.html#audit-trail-of-the-consent-transactions): the PPQ-3 audit
    events carry the type of the event in the audit trail as subtype, and record the consent type, the grantee and the
    end of the validity. Added the policy types to [CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html)
    (`ATC_POL_...`, with the new `ATC_POL_ENA_INDIRECT_AUT` and `ATC_POL_DIS_INDIRECT_AUT`; `ATC_POL_DEF_CONFLEVEL`,
    `ATC_POL_INCL_BLACKLIST` and `ATC_POL_EXL_BLACKLIST` dropped). Removed the CH:ATC Policy Audit Event profile, its
    value set and examples; ITI-81 returns the PPQ-3 audit events of the Policy Repository instead.
  * Added [CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html)
    for the consents the Policy Repository deletes without a user (digital health application without access for
    three months, dissolution, death), with the Policy Repository as initiating agent and the reason of the deletion.
    Deletions caused by the request of a user are recorded with that user and the `traceparent` of the request.
* CH:ATC
  * [ITI-81](iti-81.html#expected-actions): the Patient Audit Record Repository returns the audit events masked: the
    time reduced to the day (`period` as date, `recorded` at the start of the day in Swiss local time), an assistant
    only with the role `ASS`, without the technical details (client and server agents, `traceparent`, query), and
    marked with `ABSTRED` and `REDACTED` in `meta.security`. Audit events identical after the masking are returned only
    once, before paging; `date` and the sort are evaluated on the masked values. Removed the filtering of duplicates by
    the Patient Audit Consumer.
  * [CH:ATC](ch-atc.html): removed the EPR specifics (communities, reference community, Aggregate Audit Message
    Option, groupings with CH:CPI and CH:ADR) and the figures; the actors are grouped with IUA as in the other
    profiles (`TCU` not allowed for the Patient Audit Consumer). Added the use cases of the legal representative and
    the administration. [ITI-81](iti-81.html) requires the extended access token of IUA; removed the XUA/mTLS
    alternative.
  * Removed the HPD Group Entry Audit Event Content Profile (profile `HpdAuditEvent`, value set `HpdAuditEventType`,
    audit event type `ATC_HPD_GROUP_ENTRY_NOTIFY` and the example `atc-hpd-group-entry-notify`): the patient has no
    right to information about changes in the members of a group of healthcare professionals.
  * Replaced the Access Audit Trail Content Profile (profile `AccessAuditTrailEvent`, value set
    `AccessAuditTrailEventType` and the example `atc-log-read`) with
    [CH Audit Event for [ITI-81] Patient Audit Record Repository](StructureDefinition-ChAuditEventIti81Repository.html),
    recorded by the Patient Audit Record Repository for every ITI-81 request, and added
    [CH Audit Event for [ITI-81] Patient Audit Consumer](StructureDefinition-ChAuditEventIti81Consumer.html) for the
    Patient Audit Consumer, as for the other transactions. Added `ATC_LOG_READ` to
    [CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html).
  * Added [CH Audit Trail Event](StructureDefinition-ChAuditTrailEvent.html) for the masked audit events of the
    [ITI-81](iti-81.html) response (day in `period`, `recorded` at the start of the day, assistant only with the role,
    no client and server agents, no `traceparent` and query, only successful requests) and replaced the response Bundle
    profile [Retrieve ATNA Audit Event [ITI-81] Response](StructureDefinition-CH-ATC.ITI-81.Response.html) and its
    example, now in FSH, with it. The search parameters are evaluated on the masked audit events; removed the list of
    search parameters the Patient Audit Consumer shall not use.
  * Moved the audit trail of the document and consent transactions and the audit event types from CH:ATC to
    [Volume 3](volume3.html), and merged the tables of the event types and of the audit event profiles into one table
    with the transaction, the audit event profile and an example per type, as in CH EPR FHIR.
* Access rules
  * [Enforcement of Access Rules](accesscontrol.html): added the rights by law and the rights by consent, the rules for
    the confidentiality levels, the emergency access, the administration of the community, digital health
    applications and military health professionals.
  * [ITI-71](iti-71.html#administrators): an administrator claims the community in `group_id`; the IUA Authorization
    Server verifies it in the directory and conveys it in `subject_organization_id`, now required for `ADM`. Added the
    verification of the consent for [digital health applications](iti-71.html#digital-health-applications) and the
    `client_id` claim.
  * [ITI-71](iti-71.html#the-jwt-ch_epr-extension): the `user_id` of representatives, legal representatives and the
    administration is a representative or administrator ID resolved from the `sub` of the identity token (was
    "IdP-ID"); how these IDs are defined is open.
  * [mCSD](iti-mcsd.html#communities-and-military-health-institutions): added the code system
    [CH Health Dossier Organization Type](CodeSystem-HealthDossierOrganizationType.html) to mark communities and
    military health institutions, with examples.
* Fork from [CH EPR FHIR](https://fhir.ch/ig/ch-epr-fhir/5.0.0/), rename to CH Health Dossier