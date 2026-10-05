### Enforcement of Access Rules

Access to a health dossier is granted by the law and by the holder of the dossier. Holders define the access rights
for their health dossier with consents (see [CH:PPQm](ppqm.html)): they may authorize health professionals, groups,
health institutions and connected digital health applications, exclude access in medical emergencies, and appoint a
representative acting on their behalf.

Health professionals and health institutions may view data of a health dossier only in the context of a treatment 
and only where the holder has granted them the corresponding right. Where the holder gave consent 
outside the Health Dossier system, the health professional or health institution SHALL confirm the receipt of that consent 
in the health dossier. In medical emergencies, health professionals and health institutions may access the health dossier 
without a granted right, unless the holder has excluded emergency access.

Every actor serving a request of the Health Dossier API SHALL evaluate and enforce these rules individually for each
request, before any data is created, updated, returned or otherwise disclosed. The decision SHALL take into account:

- the authenticated identity, the role, the organization and the purpose of use of the requester, as conveyed in the
  access token (see [Get Access Token [ITI-71]](iti-71.html));
- for health professionals and health institutions, their entry in the directory of health professionals and health
  institutions (see [Find Matching Care Services [ITI-90]](iti-90.html)) and the treatment context they assert;
- the rights by law and the consents in effect for the patient concerned, including those defined by a representative;
- the confidentiality level of the data concerned.

A request that is not permitted SHALL be rejected. Data the requester is not authorized to see SHALL NOT be included
in a response.

How the decision is reached, computed by the serving actor itself or obtained from a separate authorization decision
service, is out of scope of this specification.

#### Rights by law

The following rights follow from the law and the role of the requester. No consent is recorded for them; they are
enforced from the access token, the directory and the metadata of the documents.

| Right | Who | Legal basis |
|---|---|---|
| Record treatment-relevant data | Health professionals, and assistants on their behalf; military health professionals only with a [consent](ppqm.html#consent-military-recording) | Art. 14 EGDG |
| Search, view, publish a new version of and delete the documents provided by a member of the own group or health institution ([provider institution](iti-65.html#provider-institution)) | Health professionals and assistants registered as members of the group or health institution | Art. 8 EGDG |
| Act on behalf of a health professional or health institution | Assistants (`ASS`), within the rights of the health professional (`principal_id`) | Art. 26 and 28 EGDG |
| Maintain the directory entries of the own members | The administration of a community (`ADM`), and staff of a health institution authorized by the community | Art. 15 para. 2 EGDG |
| View the directory of health professionals and health institutions | All authenticated users | — |
{:class="table table-bordered"}

Table 1: Rights by law

#### Rights by consent

The following rights follow from the consents of the holder in effect. A consent is in effect if it is stored in the
Policy Repository, its `provision.type` is permit and the date of the request is within its `provision.period`.

| Right | Who | Consent |
|---|---|---|
| Full access: search and view all documents, record, delete, change the confidentiality code and record a personal note, view the audit trail, view and add contact data, manage the consents | The holder (`PAT`), unless a legal representative is in effect | [Opening](ppqm.html#consent-opening) |
| Search and view the documents of the level "allgemein", and the documents of the level "privat" released to the grantee | The health professional, group or health institution granted, and every health professional and assistant registered as their member | [Access](ppqm.html#consent-access), [indirect authorization](ppqm.html#consent-indirect-authorization), [delegation](ppqm.html#consent-delegation) |
| Pass on the access right | As above, if the access right grants the action `delegate` | [Access](ppqm.html#consent-access) |
| Search and view the documents of the level "allgemein" in an emergency | All health professionals and assistants, with the purpose of use `EMER` | [Emergency access](ppqm.html#consent-emergency-access) of type permit |
| Confirm a consent given outside the health dossier | Health professionals and assistants, for themselves or their group or health institution | [Indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) of type permit |
| The actions granted by the holder | The representative (`REP`) | [Representative](ppqm.html#consent-representative) |
| All rights of the holder, except appointing a representative | The legal representative (`LEGREP`) | [Legal representative](ppqm.html#consent-legal-representative) |
| The actions granted by the holder, acting for the authenticated holder | A digital health application | [Digital health application](ppqm.html#consent-digital-health-application) |
| Record data | A military health professional or health institution | [Military recording](ppqm.html#consent-military-recording) |
{:class="table table-bordered"}

Table 2: Rights by consent

Who may add, update, delete and retrieve which consent is defined in
[Who May Record and Retrieve Which Consent](ppqm.html#who-may-record-and-retrieve-which-consent).

#### Confidentiality levels

Every document carries one of the two confidentiality levels "allgemein" and "privat" (see
[Confidentiality code](iti-65.html#confidentiality-code)). Health professionals, groups and health institutions with an
access right, an indirect authorization or a delegation, and all health professionals in an emergency, may only read
documents of the level "allgemein". A document of the level "privat" may only be read by the holder, the legal
representative, a representative granted the level "privat", and the grantees of an access right releasing that
document.

#### Emergency access

A request with the purpose of use `EMER` from a health professional or assistant SHALL be permitted for the documents
of the level "allgemein" only while the [emergency access](ppqm.html#consent-emergency-access) of the patient is of
type permit. If the health professional, or a group or health institution in the access token, already holds an
access right, the request SHALL be processed with that access right as a normal access, and SHALL NOT trigger a
notification of the holder. Otherwise the holder SHALL be notified when an emergency access is activated, once for a
sequence of emergency accesses of the same health professional or assistant.

The audit event of the request records the purpose of use of the access token as declared by the requester (see
[ITI-20](iti-20.html)).

#### Administration of the community

The administration (`ADM`) acts only on the health dossiers managed by its community: the community of the
administration (`subject_organization_id` of the access token, see [ITI-71](iti-71.html#administrators)) SHALL be the
community managing the health dossier (`Consent.organization` of the [opening](ppqm.html#consent-opening)). Requests for
other health dossiers SHALL be rejected.

| Activity of the administration | Legal basis | Rule |
|---|---|---|
| Maintain the directory entries of the own members ([ITI-130](iti-130.html)) | Art. 15 para. 2 EGDG, by law | No patient concerned; the entry belongs to the community. |
| Open and dissolve a health dossier, record a legal representative | Art. 12 para. 4, Art. 22 and 24 EGDG | Consent types [opening](ppqm.html#consent-opening) and [legal representative](ppqm.html#consent-legal-representative); the request or the instruction of the authority stays with the community. |
| Process the content or the settings of a health dossier on behalf of the holder (documents, contact data, audit trail, consents) | Art. 15 para. 1 EGDG, on mandate of the holder | The mandate is documented by the community. |
{:class="table table-bordered"}

Table 3: Activities of the administration

#### Digital health applications

A digital health application is an IUA Authorization Client acting for the authenticated holder. The IUA Authorization
Server issues it an access token with the `subject_role` `PAT` only while a
[digital health application](ppqm.html#consent-digital-health-application) consent for its `client_id` is in effect
(see [ITI-71](iti-71.html#digital-health-applications)). Every actor serving a request of a digital health application
SHALL restrict it to the actions granted in that consent, and to the confidentiality levels in its
`provision.securityLabel`.

#### Military health professionals

A health professional or assistant acting for a military health institution (an organization of the type
[military](CodeSystem-HealthDossierOrganizationType.html) in the directory, see [mCSD](iti-mcsd.html)) may only record
data while a [military recording](ppqm.html#consent-military-recording) consent of the patient for the health
professional or the health institution is in effect.

#### Technical users

A technical user (`TCU`), e.g. a clinical archive system, requests access tokens without an authenticated natural
person (see [Get Access Token [ITI-71]](iti-71.html#clinical-archive-systems)). A technical user may only use the
transactions for which the grouping with the IUA Authorization Client allows `TCU` in the Remark column of the required
actor groupings of the respective profile. Every actor serving a request of the Health Dossier API SHALL reject a request
with an access token with the `subject_role` `TCU` for any other transaction.
