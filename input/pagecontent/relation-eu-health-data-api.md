{% assign eu = "https://build.fhir.org/ig/euridice-org/eu-health-data-api" %}
<style>
  table.eu-comparison { table-layout: fixed; width: 100%; }
  table.eu-comparison th:nth-child(1) { width: 15%; }
  table.eu-comparison th:nth-child(2) { width: 38%; }
  table.eu-comparison th:nth-child(3) { width: 38%; }
  table.eu-comparison th:nth-child(4) { width: 9%; }
  table.eu-comparison td { overflow-wrap: break-word; }
</style>

This page compares the CH Health Dossier with the [EU Health Data API]({{eu}}/index.html) implementation guide of HL7
Europe, which defines the FHIR API of the Interoperability Component of EHR systems for the European Health Data Space
(EHDS). The comparison follows the profiles of this implementation guide and, within each profile, its transactions.
Each point links to the statement in both implementation guides.

<div markdown="1" class="stu-note">

This comparison is informative and not definitive. The EU Health Data API (version 1.0.0-ballot, CI build of
2026-10-21) is in ballot reconciliation and is not final yet, and this implementation guide is a preview for review.
Both specifications may still change substantially, so the comparison may be outdated for single points. It does not
go into all details: in case of doubt the text of the respective implementation guide applies.

</div>

### Overview

Both implementation guides build on the same IHE profiles (IUA, PDQm, MHD) and the same versions of the IHE packages
(PDQm 3.2, MHD 4.2), and both use SMART Backend Services client authentication. They differ in their scope:

- The EU Health Data API defines the API an EHR system offers to other systems. It covers
  [system-to-system authorization only]({{eu}}/authorization.html#scope-system-to-system-authorization) and excludes
  [user-level authorization, audit logging formats and bulk data export]({{eu}}/index.html#scope). It defines
  [composite actors]({{eu}}/actors.html) (Document Publisher, Document Access Provider, Document Consumer, Resource
  Access Provider, Resource Consumer) that group IHE and HL7 actors.
- The CH Health Dossier defines the national FHIR API of the health dossier, the
  [Health Dossier API](index.html#profiles-grouped-actors-actors-and-transactions), for portals, primary systems,
  digital health apps and clinical archive systems. It covers the authentication and authorization of the
  [user](iti-iua.html#use-cases), the enforcement of the [access rules](accesscontrol.html) of the holder and the
  audit trail, and identifies the holder only by the [EPR-SPID](index.html#logical-reference-and-contained-resources).

| Profile | EU Health Data API | CH Health Dossier |
|---|---|---|
| [IUA](#iua) | [Authorization]({{eu}}/authorization.html): IUA actors grouped with SMART Backend Services | [IUA](iti-iua.html) with [ITI-103](iti-103.html), [ITI-71](iti-71.html), [ITI-72](iti-72.html) |
| [PDQm](#pdqm) | [Patient Lookup]({{eu}}/patient-match.html): ITI-78 required, ITI-119 optional | [PDQm](iti-pdqm.html): [ITI-119](iti-119.html) only |
| [PIXm](#pixm) | Not used | [PIXm](iti-pixm.html): [ITI-104](iti-104.html) |
| [MHD](#mhd) | [Document Exchange]({{eu}}/document-exchange.html): ITI-67, ITI-68, ITI-105 | [MHD](iti-mhd.html): [ITI-65](iti-65.html), [ITI-67](iti-67.html), [ITI-68](iti-68.html), [CH:MHD-1](ch-mhd-1.html), [CH:MHD-2](ch-mhd-2.html) |
| [RESTful ATNA](#restful-atna-and-chatc) | Out of scope (ATNA referenced for TLS only) | [RESTful ATNA](iti-restful-atna.html): [ITI-20](iti-20.html) |
| [CH:ATC](#restful-atna-and-chatc) | Out of scope | [CH:ATC](ch-atc.html): [ITI-81](iti-81.html) |
| [mCSD](#mcsd) | Practitioner and Organization by [Resource Access]({{eu}}/resource-access.html#practitioner) | [mCSD](iti-mcsd.html): [ITI-90](iti-90.html), [ITI-130](iti-130.html) |
| [CH:PPQm](#chppqm) | Out of scope | [CH:PPQm](ppqm.html): [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), [PPQ-5](ppq-5.html) |
| [Not covered by the CH Health Dossier](#not-covered-by-the-ch-health-dossier) | [Capability Discovery]({{eu}}/capability-discovery.html), [Resource Access]({{eu}}/resource-access.html) (IPA) | - |
{:class="table table-bordered"}

<figcaption ID="1">Table 1: Profiles and the corresponding functional areas of the EU Health Data API.</figcaption>

<br/>

The column "Relation" in the tables below uses the following values: **Aligned** (same requirement), **Differs**
(different or contradicting requirements), **CH only** or **EU only** (only specified by one implementation guide).

### IUA

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Basis | IUA actors, [SMART Backend Services is authoritative]({{eu}}/authorization.html#iua-and-smart-backend-services) where they differ | IUA national extension, client authentication per [SMART client-confidential-asymmetric](iti-iua.html#security-consideration) | Aligned |
| User | [System-to-system only]({{eu}}/authorization.html#scope-system-to-system-authorization), user-level authorization [future work]({{eu}}/authorization.html#potential-future-work-user-level-authorization) | User authenticated with [OpenID Connect](iti-iua.html#actors-and-transactions), technical user (`TCU`) without user | CH only |
| Transport security | [ATNA TLS 1.2 Floor using BCP195]({{eu}}/authorization.html#transport-security) | [ATNA Secure Node with STX:HTTPS IUA Option](iti-iua.html#grouping) | Aligned |
{:class="table table-bordered eu-comparison"}

#### Get Authorization Server Metadata [ITI-103]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Endpoint | Resource Server SHALL provide [`[base]/.well-known/smart-configuration`]({{eu}}/authorization.html#authorization-server-discovery) | Authorization Server provides [`/.well-known/oauth-authorization-server`](iti-103.html#message-example) (RFC 8414) | Differs |
| Content | [`token_endpoint`, `grant_types_supported`, `jwks_uri`, `private_key_jwt`]({{eu}}/authorization.html#authorization-server-discovery) | [`token_endpoint`, `grant_types_supported`, `jwks_uri`, `private_key_jwt`](iti-103.html#authorization-server-metadata-response) | Aligned |
{:class="table table-bordered eu-comparison"}

#### Get Access Token [ITI-71]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Grant type and client authentication | [`client_credentials` with `private_key_jwt`]({{eu}}/authorization.html#get-access-token) | [`client_credentials` with `private_key_jwt`](iti-71.html#message-semantics) | Aligned |
| Scopes | [SMART v2 `system/` scopes]({{eu}}/authorization.html#scopes), e.g. `system/DocumentReference.rs`, `system/Bundle.r` | [`purpose_of_use` and `subject_role`](iti-71.html#message-semantics), and SMART v2 `user/` and `patient/` scopes per application type (clinical archive system, primary system, digital health app), e.g. `user/DocumentReference.cruds` | Differs |
| Patient and user context | Not defined (system-to-system) | [`person_id`, `principal`, `group`, `id_token`](iti-71.html#message-semantics), basic and [extended access token](iti-71.html#scope) | CH only |
| Client registration | [Out of band]({{eu}}/authorization.html#client-registration-prerequisite) | Onboarding and [Client Registration](client-registration.html) | Differs |
| Token format | Not constrained ([SMART Backend Services]({{eu}}/authorization.html#iua-and-smart-backend-services)) | [Signed JWT](iti-71.html#security-consideration), SAML token not used | CH only |
{:class="table table-bordered eu-comparison"}

#### Incorporate Access Token [ITI-72]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Bearer token | [`Authorization: Bearer` on all requests]({{eu}}/authorization.html#incorporate-access-token) | [ITI-72](iti-72.html) | Aligned |
| Token introspection | Resource Server [MAY use ITI-102]({{eu}}/authorization.html#incorporate-access-token) with an external Authorization Server | Introspection Option [SHALL NOT be used](iti-iua.html#actor-options) | Differs |
{:class="table table-bordered eu-comparison"}

### PDQm

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Transactions | [ITI-78 required, ITI-119 optional]({{eu}}/patient-match.html#provider-requirements) | [ITI-78 not required](iti-pdqm.html#actors-and-transactions-content-specifications), ITI-119 used | Differs |
| Patient reference | Consumer uses `Patient.id` or [chained identifier search]({{eu}}/document-exchange.html#option-chained-identifier-search) | [No addressable Patient resources](index.html#logical-reference-and-contained-resources), the EPR-SPID is used | Differs |
| Grouping | [IUA actors]({{eu}}/patient-match.html#authorization) | [IUA actors](iti-pdqm.html#required-actor-grouping), basic access token | Aligned |
{:class="table table-bordered eu-comparison"}

#### Mobile Patient Demographics Query [ITI-78]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Search | Provider and Consumer [SHALL support `identifier`]({{eu}}/patient-match.html#iti-78-mobile-patient-demographics-query-patientsearch---required), Provider SHALL support further demographics parameters | [Not required](iti-pdqm.html#actors-and-transactions-content-specifications) | Differs |
{:class="table table-bordered eu-comparison"}

#### Patient Demographics Match [ITI-119]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Input | Patient [SHOULD conform to EU Base Patient]({{eu}}/patient-match.html#patient-demographics-match-iti-119-patientmatch--optional), `onlyCertainMatches` SHALL be supported | [CH PDQm Match Input Parameters](iti-119.html#message-semantics), AHVN13 MAY be provided as identifier | Differs |
| Number of results | [Governance may define]({{eu}}/patient-match.html#design-rationale) an OperationOutcome requesting more traits | [Not more than 5 matches](iti-119.html#expected-actions), otherwise an OperationOutcome requesting more parameters | Aligned |
| Returned identifiers | Not constrained | [Only the EPR-SPID](iti-119.html#expected-actions) | CH only |
{:class="table table-bordered eu-comparison"}

### PIXm

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Profile | Not a dependency, named as [one means to obtain the patient identity]({{eu}}/document-exchange.html#patient-identity-in-document-publication) | [PIXm](iti-pixm.html) without ITI-83 | CH only |
{:class="table table-bordered eu-comparison"}

#### Patient Identity Feed FHIR [ITI-104]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Feed | Not specified | [Update of the contact information](iti-104.html#scope) of the holder only | CH only |
{:class="table table-bordered eu-comparison"}

### MHD

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Actors | [Composite actors]({{eu}}/actors.html#document-exchange) grouping MHD Document Source, Responder, Recipient and Consumer | [MHD actors](iti-mhd.html#actors-and-transactions) of the Health App and the Health Dossier API | Aligned |
| Find Document Lists [ITI-66] | [Not used]({{eu}}/document-exchange.html#actors-and-transactions) | [SHALL not be made available](iti-mhd.html#actors-and-transactions) | Aligned |
| Metadata | [Base FHIR DocumentReference]({{eu}}/document-exchange.html#search-response), no return profile | [CH MHD DocumentReference](document-sharing-metadata.html) (Health Dossier Metadata Option) | Differs |
| Patient reference | Literal or logical reference [left to governance]({{eu}}/patient-match.html#patient-lookup-governance), [chained search not possible]({{eu}}/document-exchange.html#option-chained-identifier-search) with logical references | [Logical reference with the EPR-SPID](document-sharing-metadata.html#holder) in `subject.identifier`, which the Document Responder [SHALL resolve for `patient.identifier`](iti-67.html#find-document-references-request-message) | Differs |
| Document type | [LOINC codes per priority category]({{eu}}/document-exchange.html#ehds-priority-categories-and-type-codes) | [DocumentEntry.typeCode](document-sharing-metadata.html#document-metadata) value set of CH Term | Differs |
| Unstructured documents (e.g. PDF) | [Content patterns FHIR document and DICOM KOS only]({{eu}}/document-exchange.html#document-content) | [Any document as Binary](iti-65.html#provide-document-bundle-request-message), e.g. a [PDF](iti-68.html#retrieve-document-request-message), with its [MIME type](document-sharing-metadata.html#document-metadata) | Differs |
| Imaging | Imaging report with [type `85430-7`]({{eu}}/priority-area-imaging-report.html#document-exchange), imaging manifest (MADO) as [two DocumentReferences, FHIR and DICOM KOS, linked with `transforms`]({{eu}}/priority-area-imaging-manifest.html#dual-documentreference-pattern-mado) ([open issue]({{eu}}/open-issues.html#issue-12-mado-dual-encoding-for-imaging-manifests)), image retrieval [out of scope]({{eu}}/priority-area-imaging-manifest.html#ihe-mado) | [DICOM KOS](DocumentReference-DocRefKos.html) with the [StudyInstanceUID in `context.related`](document-sharing-metadata.html#document-metadata) | Differs |
| Update and purge of documents | Not specified | [CH:MHD-1](ch-mhd-1.html) and [CH:MHD-2](ch-mhd-2.html) | CH only |
{:class="table table-bordered eu-comparison"}

#### Provide Document Bundle [ITI-65]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Publication transaction | [ITI-105 Simplified Publish]({{eu}}/document-exchange.html#iti-105-simplified-publish), [ITI-65 MAY be supported]({{eu}}/document-exchange.html#other-publication-transactions) | [ITI-65](iti-65.html) only | Differs |
| FHIR documents | [Base64 encoded in `attachment.data`]({{eu}}/document-exchange.html#iti-105-simplified-publish) of ITI-105 | [FHIR document Bundle in raw format](iti-65.html#providing-a-fhir-document) (ITI-65 FHIR Documents Publish Option) | Differs |
| Patient identity | [Not required to look up the patient]({{eu}}/document-exchange.html#patient-identity-in-document-publication) | [EPR-SPID in `subject.identifier`](document-sharing-metadata.html#holder) | CH only |
| Corrections | Not specified | [New version replacing the document](iti-65.html#correction-of-a-provided-document) | CH only |
{:class="table table-bordered eu-comparison"}

#### Find Document References [ITI-67]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Patient | [`patient` or `patient.identifier`]({{eu}}/document-exchange.html#search-capabilities) | [`patient.identifier` with the EPR-SPID](iti-67.html#find-document-references-request-message) | Aligned |
| Search parameters | Provider [SHALL support `_id`, `type`, `category`, `creation`]({{eu}}/document-exchange.html#search-capabilities) | [`full-text`](iti-67.html#full-text-search-option) and [`custodian:identifier`](iti-67.html#documents-provided-by-an-institution), [no `author.given` and `author.family`](iti-67.html#search-for-the-author-of-a-document) | Differs |
| Response | [Base FHIR DocumentReference]({{eu}}/document-exchange.html#search-response) | [CH MHD Find Document References Response](iti-67.html#find-document-references-response-message) | Differs |
| Access control | [Scopes]({{eu}}/authorization.html#document-consumer-mhd-iti-67-iti-68) | [Access rules of the holder](iti-67.html#security-consideration) applied to the result | CH only |
{:class="table table-bordered eu-comparison"}

#### Retrieve Document [ITI-68]

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| FHIR documents | [Native FHIR document Bundle, not wrapped in Binary]({{eu}}/document-exchange.html#document-content) | [Native FHIR document Bundle, not wrapped in Binary](iti-68.html#expected-actions) | Aligned |
| On-demand documents | [Supported]({{eu}}/document-exchange.html#on-demand-documents), without `hash` and `size` | Not specified, `hash` and `size` [absent for FHIR documents](iti-65.html#providing-a-fhir-document) | EU only |
| Access control | [Scopes]({{eu}}/authorization.html#document-consumer-mhd-iti-67-iti-68) | [Access rules of the holder](iti-68.html#security-consideration) | CH only |
{:class="table table-bordered eu-comparison"}

### RESTful ATNA and CH:ATC

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Record Audit Event [ITI-20] | [Audit logging formats are out of scope]({{eu}}/index.html#scope) | [ITI-20](iti-20.html) with the [CH audit event profiles](volume3.html) per transaction | CH only |
| Retrieve ATNA Audit Event [ITI-81] | Out of scope | [Audit trail of the holder](ch-atc.html) | CH only |
| Trace context | Not specified | [`traceparent` header](tracecontext.html) | CH only |
{:class="table table-bordered eu-comparison"}

### mCSD

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Find Matching Care Services [ITI-90] | [Practitioner]({{eu}}/resource-access.html#practitioner) and [Organization]({{eu}}/resource-access.html#organization) by Resource Access (IPA) | [ITI-90](iti-90.html) | Differs |
| Care Services Feed [ITI-130] | Not specified | [ITI-130](iti-130.html) | CH only |
{:class="table table-bordered eu-comparison"}

### CH:PPQm

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Privacy policies [PPQ-3], [PPQ-4], [PPQ-5] | [Member States MAY layer user-level authorization]({{eu}}/authorization.html#potential-future-work-user-level-authorization) | [Consents of the holder](ppqm.html) | CH only |
{:class="table table-bordered eu-comparison"}

### Not covered by the CH Health Dossier

| Topic | EU Health Data API | CH Health Dossier | Relation |
|---|---|---|---|
| Capability discovery | [`instantiates` and `implementationGuide`]({{eu}}/capability-discovery.html#actor-conformance-via-instantiates) in the CapabilityStatement | [CapabilityStatements](capstatements.html) per actor | EU only |
| Resource access | [IPA search and read]({{eu}}/resource-access.html#supported-resources) of clinical resources | Not specified | EU only |
| Content | [Content IGs per priority category]({{eu}}/priority-categories.html) | Not specified in this implementation guide | EU only |
{:class="table table-bordered eu-comparison"}
