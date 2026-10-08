This page specifies the consents of [CH:PPQm](ppqm.html): the rules common to all consent types, the use case and
content of each consent type, and which role may record and retrieve which consent.

### Rights by Law and Rights by Consent

The EGDG separates the rights that follow from the law from the rights the patient grants:

- **Rights by law** need no consent. The patient has full access to the health dossier (Art. 11 para. 1 EGDG).
  Health professionals and health institutions record treatment-relevant data (Art. 14 para. 1 EGDG), and correct or
  destroy the data they recorded (Art. 8 EGDG), together with the members of their group or institution. Assistants
  act on behalf of a health professional or health institution (Art. 26 and 28 EGDG). The administration of the
  community maintains the directory entries of its members (Art. 15 para. 2 EGDG). These rights are enforced from the
  role in the access token, the directory and the authorship of a document.
- **Rights by consent** are granted by the patient, or by a person acting for the patient (Art. 11 para. 2-5, Art. 12,
  13, 15 and 16 EGDG). Each of them is recorded as a Consent of one of the consent types below.

The opening of the health dossier is recorded as a consent too: the rights by law of health professionals and the
community follow from its existence.

### Common Rules

Every Consent conforms to the [CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) profile and to the profile
of its consent type, given in `Consent.category` (see [HealthDossierConsentType](CodeSystem-HealthDossierConsentType.html),
and the overview of the consent types in [CH:PPQm](ppqm.html#consent-types)). Common rules of all consent types:

- The Consent is identified by a UUID in `identifier`. The Policy Source assigns it when adding the Consent and uses it
  to update and delete the Consent.
- `policy.uri` is the canonical URL of the profile of the consent type, whose rules apply.
- `performer` is who took the decision, `dateTime` when it was taken. Who recorded the Consent is recorded in the
  audit event of the transaction (see [PPQ-3](ppq-3.html#security-audit-considerations)).
- `provision.period` limits the validity. A Consent without period is valid until it is deleted. A Consent is revoked
  by deleting it.
- The confidentiality levels a grantee may read are listed in `provision.securityLabel`: "normal" or "restricted" (see
  [HealthDossierConfidentialityCode](ValueSet-HealthDossierConfidentialityCode.html)). Documents of the level "restricted"
  released individually are listed in a nested `provision.provision` with `data.meaning = instance`.
- The further rights granted are listed in `provision.action` (see
  [HealthDossierConsentAction](CodeSystem-HealthDossierConsentAction.html)).
- Grantees and performers are referenced by identifier only, with the identifier type of the access token
  (`user_id_qualifier`, see [ITI-71](iti-71.html)): EPR-SPID for the patient, GLN for a health professional, the
  organization ID for a group, health institution, community or authority, the representative ID for a
  representative or legal representative, and the client ID for a digital health application.

### Consent Types

#### Opening {#consent-opening}

The health dossier is opened automatically by the canton when the patient does not object, or voluntarily on request of
the patient or the legal representative with explicit consent (Art. 20-22 EGDG). The Register E-GD records the
opening and the community managing the health dossier.

When the Register E-GD records the opening, the Policy Repository adds the following consents itself, with the
person or authority who opened the health dossier as `performer` (the patient or the legal representative for a
voluntary opening, the canton for an automatic opening, see
[Policy Repository rules](ppq-3.html#policy-repository-rules)):

- [Opening](StructureDefinition-ch-ppqm-consent-opening.html) with the patient as grantee and the community managing
  the health dossier in `organization` ([example](Consent-PpqmConsentOpeningExample.html)),
- [Emergency access](#consent-emergency-access) with type permit
  ([example](Consent-PpqmConsentEmergencyAccessExample.html)),
- [Indirect authorization setting](#consent-indirect-authorization-setting) with type permit
  ([example](Consent-PpqmConsentIndirectAuthorizationSettingExample.html)).

When the health dossier is dissolved, on request of the patient or the legal representative or on the death of the
patient, the Policy Repository deletes all consents of the patient.

#### Emergency access {#consent-emergency-access}

In a medical emergency, health professionals, their assistants and the members of groups and health institutions may
read the documents of the confidentiality level "normal" without an access right, with the purpose of use
emergency (Art. 13 para. 3 EGDG). The patient may exclude emergency access at any time, and allow it again (Art. 11
para. 2 let. b EGDG).

The patient authenticates in the portal and opens the emergency access setting. To exclude emergency access, the portal
updates the [Emergency access](StructureDefinition-ch-ppqm-consent-emergency-access.html) consent created at the
opening to type deny with the Mobile Privacy Policy Feed (PPQ-3) transaction
([example](Consent-PpqmConsentEmergencyAccessExcludedExample.html)); to allow it again, it updates the consent to type
permit. A representative may change the setting if the patient granted the action `configure-emergency-access`.

Rules for the serving actors: a health professional, group or health institution that already holds an access right
is processed with that access right, not as an emergency access. The patient is notified when an emergency access is
activated, once for a sequence of emergency accesses of the same health professional or assistant.

#### Access for a health professional, group or health institution {#consent-access}

The patient authorizes a health professional, a group of health professionals or a health institution to read the
documents of the confidentiality level "normal" (Art. 11 para. 2 let. a, Art. 13 para. 1 EGDG). The patient
authenticates in the portal, opens the access settings, searches the health professional, group or health institution
in the directory and selects it. The patient optionally sets an end date, selects whether the grantee may pass on the
access right, and selects documents of the confidentiality level "restricted" the grantee may read as well.

The portal adds an [Access](StructureDefinition-ch-ppqm-consent-access.html) consent with the Mobile Privacy Policy
Feed (PPQ-3) or the Mobile Privacy Policy Bundle Feed (PPQ-4) transaction, with:

- the GLN of the health professional, or the organization ID of the group or health institution, as grantee,
- the action `read`, and `delegate` if the grantee may pass on the access right,
- the level "normal" in `provision.securityLabel`,
- a nested provision per selected document of the level "restricted".

Examples: [health professional with a restricted document and the right to pass on](Consent-PpqmConsentAccessHcpExample.html),
[health institution for a hospital stay](Consent-PpqmConsentAccessInstitutionExample.html).

Every health professional and assistant registered in the directory as member of an authorized group or health
institution inherits the access right. The patient revokes the access right by deleting the consent.

#### Indirect authorization {#consent-indirect-authorization}

The patient may give a health professional or health institution a consent outside the health dossier, e.g. orally in
a practice. The health professional or health institution confirms the receipt of that consent in the health dossier
(Art. 11 para. 3, Art. 13 para. 2 EGDG).

The health professional or an assistant authenticates in the primary system and records an
[Indirect authorization](StructureDefinition-ch-ppqm-consent-indirect-authorization.html) consent with the Mobile
Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentIndirectAuthorizationExample.html)):

- the patient as `performer` and the time the consent was given in `dateTime`,
- the health professional, or the group or health institution, the consent was given to as grantee; not the assistant
  who records it,
- the action `read` and the level "normal",
- evidence of the consent: a scan of the signed form or the signature captured on a tablet in `source[x]`, or a
  verification with the patient (e.g. a one-time code sent to the patient) in `verification`.

Rules for the Policy Repository: it rejects the consent while the
[Indirect authorization setting](#consent-indirect-authorization-setting) is of type deny. The patient is notified of
every indirect authorization.

#### Indirect authorization setting {#consent-indirect-authorization-setting}

The patient may exclude the indirect authorization at any time, and allow it again (Art. 11 para. 3 EGDG). The
exclusion takes precedence over consents the patient gave outside the health dossier.

The portal updates the [Indirect authorization setting](StructureDefinition-ch-ppqm-consent-indirect-authorization-setting.html)
consent created at the opening to type deny, or back to type permit, with the Mobile Privacy Policy Feed (PPQ-3)
transaction. A representative may change the setting if the patient granted the action
`configure-indirect-authorization`.

#### Delegation {#consent-delegation}

A health professional holding an access right with the action `delegate` passes the right to read the documents of the
confidentiality level "normal" on to another health professional, group or health institution for a limited
period, e.g. for a second opinion or a substitution. The same applies to the members of an authorized group or health
institution and their assistants.

The health professional authenticates in the portal or the primary system, searches the health professional, group or
health institution in the directory and sets the end date. The portal or primary system adds a
[Delegation](StructureDefinition-ch-ppqm-consent-delegation.html) consent with the Mobile Privacy Policy Feed (PPQ-3)
transaction ([example](Consent-PpqmConsentDelegationExample.html)), with the identifier of the access right it is
derived from in `sourceReference`.

Rules for the Policy Repository: it rejects a delegation if the access right referenced is not in effect, does not
grant the action `delegate`, or ends before the end date of the delegation. When the access right referenced is
deleted, the Policy Repository deletes the delegations derived from it.

#### Representative {#consent-representative}

The patient appoints a representative and sets the representative's rights (Art. 11 para. 5 EGDG). The patient
authenticates in the portal, enters the representative and selects the confidentiality levels the representative may
read and the actions the representative may take:

| Action | Right |
|---|---|
| `read` | Search and view the documents of the confidentiality levels in `provision.securityLabel` |
| `delete` | Delete documents |
| `edit-metadata` | Change the confidentiality level of a document and record a comment |
| `edit-contact` | Add contact data to the personal data of the patient in the index of patients |
| `read-audit-trail` | View the audit trail |
| `configure-emergency-access` | Exclude and allow emergency access |
| `configure-indirect-authorization` | Exclude and allow the indirect authorization |
{:class="table table-bordered"}

Table 1: Actions a patient may grant a representative

A representative may always view the directory of health professionals and health institutions and the personal data
of the patient in the index of patients.

The portal adds a [Representative](StructureDefinition-ch-ppqm-consent-representative.html) consent with the Mobile
Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentRepresentativeExample.html)). A legal
representative may not appoint a representative (Art. 12 para. 1 EGDG).

#### Legal representative {#consent-legal-representative}

A legal representative exercises the rights of a patient who is a minor or lacks the capacity of judgement (Art. 12
EGDG). The administration of the community records the legal representative on the instruction of the competent
authority, never the patient.

The administration authenticates in the portal and adds a
[Legal representative](StructureDefinition-ch-ppqm-consent-legal-representative.html) consent with the Mobile Privacy
Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentLegalRepresentativeExample.html)), with the community or
the authority as `performer` and the instruction of the authority in `source[x]`. The legal representative has all
rights of the patient, except appointing a representative; the rights are not listed in the consent.

Rules for the Policy Repository: when a legal representative is set up, the access rights of the patient are revoked,
and all consents the patient took (with the patient as `performer`) are deleted.

#### Digital health application {#consent-digital-health-application}

The patient authorizes an admitted digital health application to access the health dossier on the patient's behalf
(Art. 11 para. 2 let. c, Art. 16 EGDG), for a chosen period, and selects what the application may do:

| Action | Right |
|---|---|
| `read` | Search and view the documents of the confidentiality levels in `provision.securityLabel` |
| `record` | Record documents |
| `delete` | Delete documents |
| `edit-metadata` | Change the confidentiality level of a document and record a comment |
| `read-demographics` | View the personal data of the patient in the index of patients |
| `edit-contact` | Add contact data to the personal data of the patient in the index of patients |
| `read-directory` | View the directory of health professionals and health institutions |
| `manage-access` | Grant and revoke [access rights](#consent-access) of health professionals, groups and health institutions |
{:class="table table-bordered"}

Table 2: Actions a patient may grant a digital health application

The portal adds a [Digital health application](StructureDefinition-ch-ppqm-consent-digital-health-application.html)
consent with the Mobile Privacy Policy Feed (PPQ-3) transaction
([example](Consent-PpqmConsentDigitalHealthApplicationExample.html)), with the client ID of the application as
grantee.

The digital health application is an IUA Authorization Client acting for the authenticated patient; it is not a
grantee of its own. The IUA Authorization Server issues an access token to the application only while the patient has
a session with a recognized identity provider, and only with the scopes covered by the actions of the consent. With
the action `manage-access`, the application acts as Policy Source for the access rights of the patient.

Rules for the Policy Repository: the patient may revoke the authorization at any time by deleting the consent. The
consent is deleted automatically after three months without access by the application.

#### Recording by military health professionals {#consent-military-recording}

Unlike civilian health professionals, military health professionals and health institutions record data in the
health dossier only with the consent of the patient (Art. 14 para. 2 EGDG). The patient authenticates in the portal,
searches the military health professional or health institution in the directory and selects it. The portal adds a
[Military recording](StructureDefinition-ch-ppqm-consent-military-recording.html) consent with the action `record`
with the Mobile Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentMilitaryRecordingExample.html)).
The consent grants no right to read; reading requires an [access right](#consent-access).

### Who May Record and Retrieve Which Consent

The Policy Repository authorizes each request by the consent type and the role of the user in the access token, as
shown in Table 3. C = create, R = retrieve, U = update, D = delete.

| Consent type | `PAT` | `REP` | `LEGREP` | `HCP` | `ASS` | `ADM` |
|---|---|---|---|---|---|---|
| Opening | <samp>  R    </samp> | <samp>  R    </samp> | <samp>  R    </samp> | – | – | <samp>  R    </samp> (1) |
| Emergency access | <samp>  R U  </samp> | <samp>  R U  </samp> (2) | <samp>  R U  </samp> | – | – | <samp>  R U  </samp> (3) |
| Access | <samp>C R U D</samp> (4) | <samp>  R    </samp> | <samp>C R U D</samp> | <samp>  R    </samp> (5) | <samp>  R    </samp> (5) | <samp>C R U D</samp> (3) |
| Indirect authorization | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>C R    </samp> (6) | <samp>C R    </samp> (6) | <samp>  R    </samp> |
| Indirect authorization setting | <samp>  R U  </samp> | <samp>  R U  </samp> (2) | <samp>  R U  </samp> | – | – | <samp>  R U  </samp> (3) |
| Delegation | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>C R U D</samp> (7) | <samp>C R U D</samp> (7) | <samp>  R    </samp> |
| Representative | <samp>C R U D</samp> | <samp>  R    </samp> (8) | – | – | – | <samp>C R U D</samp> (3) |
| Legal representative | – | – | <samp>  R    </samp> | – | – | <samp>C R U D</samp> |
| Digital health application | <samp>C R U D</samp> | – | <samp>C R U D</samp> | – | – | <samp>  R    </samp> |
| Military recording | <samp>C R U D</samp> | – | <samp>C R U D</samp> | <samp>  R    </samp> (5) | – | <samp>C R U D</samp> (3) |
{:class="table table-bordered"}

Table 3: Authorization of the CH:PPQm transactions by consent type and role

Notes:

1. The Policy Repository adds the opening, the emergency access and the indirect authorization setting itself when the
   health dossier is opened, and deletes all consents when it is dissolved (see [Opening](#consent-opening)).
2. If the patient granted the representative the action for the respective setting: `configure-emergency-access` for
   the emergency access, `configure-indirect-authorization` for the indirect authorization setting.
3. On the mandate of the patient (Art. 15 para. 1 EGDG).
4. Also a digital health application acting for the patient, with the action `manage-access`.
5. Consents in which the health professional, or a group or health institution the health professional or assistant
   is a registered member of, is the grantee.
6. If the indirect authorization setting is of type permit.
7. Delegations derived from an access right of the health professional, or of a group or health institution the
   health professional or assistant is a registered member of, with the action `delegate`.
8. The consent appointing the representative.

The role `TCU` is not allowed. Requests of the role `ADM` are only allowed for health dossiers managed by the community
of the administration (`Consent.organization` of the opening).

### Open Issues

1. **Settings created at the opening.** Emergency access and the indirect authorization setting are created with type
   permit at the opening and toggled between permit and deny by update, rather than existing only as a deny while the
   patient excludes. To be confirmed.
2. **Emergency access overridden by an access right.** The requirements catalogue asks that such an access is not
   logged as emergency access. The audit events of this guide record the purpose of use of the access token as
   declared by the user; whether the serving actor may record a different purpose of use is to be decided.
3. **Indirect authorization.** Open in the requirements catalogue: whether further rights than reading "normal"
   follow, and the form of the evidence. Open as well: the period of validity, and whether existing indirect
   authorizations lose their effect when the patient excludes the indirect authorization.
4. **Legal representative.** The requirements catalogue revokes the access rights of the patient and deletes the
   consents of the patient when a legal representative is set up. This matches Art. 12 para. 1 EGDG (patient under 14 or
   lacking capacity of judgement), but not Art. 12 para. 2 EGDG, under which a patient from 14 years exercises the
   rights in parallel with the legal representative until majority.
5. **Representative.** The Botschaft names granting access rights and dissolving the health dossier as rights a patient
   may give a representative; the requirements catalogue does not list them.
6. **Administration of the community.** Open in the requirements catalogue: whether the administration of the
   community is generally authorized (role right, as in Table 3) or per support case of the patient (a consent per
   mandate). The access token carries the verified community of the administration ([ITI-71](iti-71.html#administrators));
   how administrators are registered in the directory as members of their community is open (see
   [mCSD](iti-mcsd.html#communities-and-military-health-institutions)).
7. **Digital health application.** The requirements catalogue lets a digital health application grant access rights,
   beyond the reading and recording of data foreseen by Art. 11 para. 2 let. c EGDG. The identifier type of the client
   ID (`urn:e-health-suisse:dga-client-id`), the registration of an application with the actions of its admission and
   the mapping of the actions to scopes have to be aligned with the client registration (issue #11).
8. **Military recording.** Military health institutions are marked in the directory with the organization type
   `military` ([mCSD](iti-mcsd.html#communities-and-military-health-institutions)). Art. 14 para. 2 EGDG allows the
   consent to be stored in a military system instead. The requirements catalogue does not list this consent.
9. **Legal basis in `policy.uri`.** The consents reference the profile of their consent type as their rules (R4
    requires `policy` or `policyRule`). Once the EGDG and its ordinances are enacted, the legal basis may be referenced
    instead.
10. **Selected restricted documents.** Whether a release of a document of the level "restricted" extends to its new versions
    (Art. 8 para. 2 EGDG), and what happens to the release when the document is set to "normal". The R4 search
    parameter `data` only covers the root provision, so finding the access rights that release a document with
    [PPQ-5](ppq-5.html) would need a search parameter of this guide.
11. **Change of the managing community.** Whether the EGDG allows the community managing a health dossier to change,
    and who then updates `organization` of the [opening](#consent-opening), which the authorization of the
    administration relies on.
