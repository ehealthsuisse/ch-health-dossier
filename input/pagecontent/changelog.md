### Open Issues

The following issues are open and will be addressed in a later release:

* [#60](https://github.com/ehealthsuisse/ch-health-dossier/issues/60) Medical imaging and access
* [#48](https://github.com/ehealthsuisse/ch-health-dossier/issues/48) OpenID Connect client-asymmetric authentication
* [#27](https://github.com/ehealthsuisse/ch-health-dossier/issues/27) Server certificate requirements
* [#13](https://github.com/ehealthsuisse/ch-health-dossier/issues/13) Changes to value sets

### Release 1.0.0-preview, 2026-10-29

This is a preliminary release of the CH Health Dossier Implementation Guide for review. It is based on the
[CH EPR FHIR Implementation Guide 5.0.0](https://fhir.ch/ig/ch-epr-fhir/5.0.0/) and latest proposed changes and takes into account the legal requirements of the electronic health dossier (E-GD) according to the EGDG and the requirements catalogue of the E-GD authorization system. The specification may still change substantially. The main changes compared to CH EPR FHIR are listed per profile.

#### General

* The person for whom the health dossier is kept is called the "holder", as in the EGDG
  [#26](https://github.com/ehealthsuisse/ch-health-dossier/issues/26).
* Added the code system [CH Health Dossier Role](CodeSystem-HealthDossierRole.html): the administration (`ADM`)
  replaces the document and policy administrators, and the legal representative (`LEGREP`) is added
  [#13](https://github.com/ehealthsuisse/ch-health-dossier/issues/13).
* Two confidentiality levels, "normal" and "restricted", instead of three
  ([CH Health Dossier Confidentiality Code](ValueSet-HealthDossierConfidentialityCode.html))
  [#12](https://github.com/ehealthsuisse/ch-health-dossier/issues/12).
* Added the appendix [Enforcement of Access Rules](accesscontrol.html) with the rights by law and by consent, the
  confidentiality levels and the emergency access; it replaces the grouping with CH:ADR.
* Added the appendix [Identifier](identifier.html) with a non-normative explanation of the identifiers and issuers used
  in the health dossier [#28](https://github.com/ehealthsuisse/ch-health-dossier/issues/28).
* Updated the dependencies to CH Core 7.0.0-ballot and IHE MHD 4.2.5.

#### IUA

* Primary systems and digital health applications now use the client credential flow and convey the identity
  token of the user in the token request; the more complex authorization code flow, SMART on FHIR EHR launch and App
  launch are no longer required [#3](https://github.com/ehealthsuisse/ch-health-dossier/issues/3).
* Extended the OAuth 2 client authorization to support digital health applications (dGA) [#32](https://github.com/ehealthsuisse/ch-health-dossier/issues/32).
* Harmonized the OAuth 2 client authorization flow across all supported client types (primary systems, digital health 
  applications, clinical archive systems). Scope claims for authorization are now handled uniformly, 
  removing type-specific logic [#32](https://github.com/ehealthsuisse/ch-health-dossier/issues/32).
* Simplified transactions for clinical archive systems with the TCU role. Requests from these systems no longer need to 
  include the responsible natural person (principal); the clinical archive system is identified by the OID registered
  with its `client_id` during onboarding instead of the GLN of the legally responsible person
  [#57](https://github.com/ehealthsuisse/ch-health-dossier/issues/57).
* Clients authenticate with a signed JWT (client-asymmetric authentication of FHIR Backend Services) instead of an
  HTTP signature [#33](https://github.com/ehealthsuisse/ch-health-dossier/issues/33).
* Added the [Client Registration](client-registration.html) page for the user authorized and the dynamic client registration of digital health applications
  [#11](https://github.com/ehealthsuisse/ch-health-dossier/issues/11),
  [#17](https://github.com/ehealthsuisse/ch-health-dossier/issues/17),
  [#45](https://github.com/ehealthsuisse/ch-health-dossier/issues/45).
* Aligned [ITI-103](iti-103.html) with IUA and RFC 8414: the metadata is retrieved from
  `/.well-known/oauth-authorization-server` and `private_key_jwt` is required as client authentication.
* Updated to changes in the IUA Revision 2.5 standard: the claims `subject_role` and `purpose_of_use` now are arrays 
  of FHIR Coding type [ch-epr-fhir#498](https://github.com/ehealthsuisse/ch-epr-fhir/pull/498).

#### OpenID Connect

* Added the [OpenID Connect](openid-connect.html) page (Annex 8 EPRO-FDHA) with the authorization code flow, the
  identity token, UserInfo and logout; it replaces the CH:XUA Authenticate User transaction
  [#6](https://github.com/ehealthsuisse/ch-health-dossier/issues/6),
  [#16](https://github.com/ehealthsuisse/ch-health-dossier/issues/16).

#### PDQm

* [ITI-119](iti-119.html) identifies a holder by the minimal demographics and the AHVN13 to retrieve the EPR-SPID
  [#2](https://github.com/ehealthsuisse/ch-health-dossier/issues/2).
* Defined the mapping of the patient to eCH-0215 and eCH-0213
  [#7](https://github.com/ehealthsuisse/ch-health-dossier/issues/7).

#### PIXm

* Removed the PIXm Query [ITI-83], local identifiers are not cross-referenced.
* [ITI-104](iti-104.html) only updates the contact information of the holder and requires an extended access token.

#### MHD

* Added the Volume 3 page [Document Sharing Metadata](document-sharing-metadata.html); the author of a document is
  separated from who provided it (provider role and provider institution)
  [#14](https://github.com/ehealthsuisse/ch-health-dossier/issues/14),
  [#35](https://github.com/ehealthsuisse/ch-health-dossier/issues/35).
* Added the transaction [Purge Document [CH:MHD-2]](ch-mhd-2.html), the correction of a document by a new version and
  the personal note of the holder with [CH:MHD-1](ch-mhd-1.html)
  [#14](https://github.com/ehealthsuisse/ch-health-dossier/issues/14).
* The Document Responder supports the [Full-Text Search Option](iti-mhd.html#full-text-search-option)
  [#9](https://github.com/ehealthsuisse/ch-health-dossier/issues/9).
* Removed the Federated Option, the Proxy Option and the homeCommunityId.
* A FHIR document is provided with the [FHIR Documents Publish Option](iti-65.html#providing-a-fhir-document) and
  returned by [ITI-68](iti-68.html#expected-actions) as a native FHIR document Bundle, not wrapped in a Binary resource.
* Updated to IHE MHD 4.2.5: uniqueId is distinguished by `Identifier.type`
  [ch-epr-fhir#462](https://github.com/ehealthsuisse/ch-epr-fhir/issues/462).

#### mCSD

* Removed the LDAP identifiers, the HPD backend considerations and the communities from the profiles and examples.
* The OID of an organization and the element `active` are required
  [ch-epr-fhir#451](https://github.com/ehealthsuisse/ch-epr-fhir/issues/451).
* Communities and military health institutions are marked by their organization type.

#### CH:PPQm

* A Consent records one decision of the holder per consent type, with one profile per consent type instead of the
  policy set templates of the EPR (breaking change), see [CH PPQm Consent](ppqm-consent.html).
* Added the code systems [CH Health Dossier Consent Type](CodeSystem-HealthDossierConsentType.html) and
  [CH Health Dossier Consent Action](CodeSystem-HealthDossierConsentAction.html).
* Added the community mandate and the rules of the indirect authorization
  [#29](https://github.com/ehealthsuisse/ch-health-dossier/issues/29).
* Added access rights for digital health applications
  [#31](https://github.com/ehealthsuisse/ch-health-dossier/issues/31).
* [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) and [PPQ-5](ppq-5.html) specify the authorization by consent type and role,
  the validation rules and the new search parameters.

#### CH:ATC

* The audit trail can be built from the audit events of the document and consent transactions; the Document, Policy, HPD
  and Access Audit Event Content Profiles are removed.
* [ITI-81](iti-81.html) returns the audit events masked ([CH Audit Trail Event](StructureDefinition-ChAuditTrailEvent.html))
  and supports `_sort` on `date` (CP-ITI-1334).
* Removed the EPR specifics: communities, the Aggregate Audit Message Option and the groupings with CH:CPI and CH:ADR.
* Published the CapabilityStatements of both ITI-81 actors
  [ch-epr-fhir#443](https://github.com/ehealthsuisse/ch-epr-fhir/issues/443).

#### RESTful ATNA

* Added the code system [CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html); the audit
  events of the document and consent transactions carry the event type as subtype.
* The audit events record a document by its master identifier only, and the institutions of the user in the new agent
  `group`.
* Corrected the mapping of the access token to the agents: the healthcare professional is the main user and the
  assistant the delegated user.
