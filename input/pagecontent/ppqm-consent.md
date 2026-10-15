This page specifies the consents of [CH:PPQm](ppqm.html): the rules common to all consent types, the use case and
content of each consent type, and which role may record and retrieve which consent.

### Rights by Law and Rights by Consent

The EGDG separates the rights that follow from the law from the rights the holder grants:

- **Rights by law** need no consent. The holder has full access to the health dossier (Art. 11 para. 1 EGDG).
  Health professionals and health institutions record treatment-relevant data (Art. 14 para. 1 EGDG), and correct or
  destroy the data they recorded (Art. 8 EGDG), together with the members of their group or institution. Assistants
  act on behalf of a health professional or health institution (Art. 26 and 28 EGDG). The administration of the
  community maintains the directory entries of its members (Art. 15 para. 2 EGDG). These rights are enforced from the
  role in the access token, the directory and the authorship of a document.
- **Rights by consent** are granted by the holder, or by a person acting for the holder (Art. 11 para. 2-5, Art. 12,
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
  to which access is granted individually are listed in a nested `provision.provision` with `data.meaning = instance`, each referenced
  by its master identifier (`DocumentReference.masterIdentifier`) in `data.reference.identifier`.
- The further rights granted are listed in `provision.action` (see
  [HealthDossierConsentAction](CodeSystem-HealthDossierConsentAction.html)).
- Grantees and performers are referenced by identifier only, with the identifier type of the access token
  (`user_id_qualifier`, see [ITI-71](iti-71.html)): EPR-SPID for the holder, GLN for a health professional, the
  organization ID for a group, health institution, community or authority, the representative ID for a
  representative or legal representative, and the client ID for a digital health application.

### Consent Types

#### Opening {#consent-opening}

The health dossier is opened automatically by the canton when the holder does not object, or voluntarily on request of
the holder or the legal representative with explicit consent (Art. 20-22 EGDG). The Register E-GD records the
opening and the community managing the health dossier.

When the Register E-GD records the opening, the Policy Repository adds the following consents itself, with the
person or authority who opened the health dossier as `performer` (the holder or the legal representative for a
voluntary opening, the canton for an automatic opening, see
[Policy Repository rules](ppq-3.html#policy-repository-rules)):

- [Opening](StructureDefinition-ch-ppqm-consent-opening.html) with the holder as grantee and the community managing
  the health dossier in `organization` ([example](Consent-PpqmConsentOpeningExample.html)),
- [Emergency access setting](#consent-emergency-access-setting) with type permit
  ([example](Consent-PpqmConsentEmergencyAccessSettingExample.html)),
- [Indirect authorization setting](#consent-indirect-authorization-setting) with type permit
  ([example](Consent-PpqmConsentIndirectAuthorizationSettingExample.html)).

When the health dossier is dissolved, on request of the holder or the legal representative or on the death of the
holder, the Policy Repository deletes all consents of the holder.

#### Emergency access setting {#consent-emergency-access-setting}

In a medical emergency, health professionals, their assistants and the members of groups and health institutions may
read the documents of the confidentiality level "normal" without an access right, with the purpose of use
emergency (Art. 13 para. 3 EGDG). The holder may exclude emergency access at any time, and allow it again (Art. 11
para. 2 let. b EGDG).

The holder authenticates in the portal and opens the emergency access setting. To exclude emergency access, the portal
updates the [Emergency access setting](StructureDefinition-ch-ppqm-consent-emergency-access-setting.html) consent created at the
opening to type deny with the Mobile Privacy Policy Feed (PPQ-3) transaction
([example](Consent-PpqmConsentEmergencyAccessSettingExcludedExample.html)); to allow it again, it updates the consent to type
permit. A representative may change the setting if the holder granted the action `configure-emergency-access`.

Rules for the serving actors: a health professional, group or health institution that already holds an access right
is processed with that access right, not as an emergency access, and the audit event records the purpose of use `NORM`
(see [Emergency access](accesscontrol.html#emergency-access)). The holder is notified when an emergency access is
activated, once for a sequence of emergency accesses of the same health professional or assistant.

#### Access for a health professional, group or health institution {#consent-access}

The holder authorizes a health professional, a group of health professionals or a health institution to read the
documents of the confidentiality level "normal" (Art. 11 para. 2 let. a, Art. 13 para. 1 EGDG). The holder
authenticates in the portal, opens the access settings, searches the health professional, group or health institution
in the directory and selects it. The holder optionally sets an end date, selects whether the grantee may pass on the
access right, and selects documents of the confidentiality level "restricted" the grantee may read as well.

A representative with the action `manage-access`, or the legal representative, may grant access rights in the same
way. The portal adds an [Access](StructureDefinition-ch-ppqm-consent-access.html) consent with the Mobile Privacy Policy
Feed (PPQ-3) or the Mobile Privacy Policy Bundle Feed (PPQ-4) transaction, with:

- the GLN of the health professional, or the organization ID of the group or health institution, as grantee,
- the action `read`, and `delegate` if the grantee may pass on the access right,
- the level "normal" in `provision.securityLabel`,
- a nested provision per selected document of the level "restricted", with the master identifier of the document.

Examples: [health professional with a restricted document and the right to pass on](Consent-PpqmConsentAccessHcpExample.html),
[health institution for a hospital stay](Consent-PpqmConsentAccessInstitutionExample.html).

Every health professional and assistant registered in the directory as member of an authorized group or health
institution inherits the access right. The holder revokes the access right by deleting the consent.

#### Indirect authorization {#consent-indirect-authorization}

The holder may give a health professional or health institution a consent outside the health dossier, e.g. orally in
a practice. The health professional or health institution confirms the receipt of that consent in the health dossier
(Art. 11 para. 3, Art. 13 para. 2 EGDG).

The health professional or an assistant authenticates in the primary system and records an
[Indirect authorization](StructureDefinition-ch-ppqm-consent-indirect-authorization.html) consent with the Mobile
Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentIndirectAuthorizationExample.html)):

- the holder as `performer` and the time the consent was given in `dateTime`,
- the health professional, or the group or health institution, the consent was given to as grantee; not the assistant
  who records it,
- the action `read` and the level "normal"; an indirect authorization grants no further rights,
- the end date in `provision.period.end`, at most 60 days after the date the holder gave the consent,
- evidence of the consent in `source[x]` or `verification`. This guide does not specify the form of the evidence, e.g.
  a scan of the signed form or the signature captured on a tablet in `source[x]`, or a verification with the holder
  (e.g. a one-time code sent to the holder) in `verification`.

Rules for the Policy Repository: it rejects the consent while the
[Indirect authorization setting](#consent-indirect-authorization-setting) is of type deny. The holder is notified of
every indirect authorization.

#### Indirect authorization setting {#consent-indirect-authorization-setting}

The holder may exclude the indirect authorization at any time, and allow it again (Art. 11 para. 3 EGDG). The
exclusion takes precedence over consents the holder gave outside the health dossier: when the setting is updated to
type deny, the Policy Repository deletes the [indirect authorizations](#consent-indirect-authorization) of the holder.
They are not restored when the indirect authorization is allowed again.

The portal updates the [Indirect authorization setting](StructureDefinition-ch-ppqm-consent-indirect-authorization-setting.html)
consent created at the opening to type deny, or back to type permit, with the Mobile Privacy Policy Feed (PPQ-3)
transaction. A representative may change the setting if the holder granted the action
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

The holder appoints a representative and sets the representative's rights (Art. 11 para. 5 EGDG). The holder
authenticates in the portal, enters the representative and selects the confidentiality levels the representative may
read and the actions the representative may take:

| Action | Right |
|---|---|
| `read` | Search and view the documents of the confidentiality levels in `provision.securityLabel` |
| `delete` | Purge documents |
| `edit-metadata` | Change the confidentiality level of a document and record a comment |
| `edit-contact` | Add contact data to the personal data of the holder in the index of holders |
| `read-audit-trail` | View the audit trail |
| `configure-emergency-access` | Exclude and allow emergency access |
| `configure-indirect-authorization` | Exclude and allow the indirect authorization |
| `manage-access` | Grant and revoke [access rights](#consent-access) of health professionals, groups and health institutions |
{:class="table table-bordered"}

Table 1: Actions a holder may grant a representative

A representative may always view the directory of health professionals and health institutions and the personal data
of the holder in the index of holders.

The portal adds a [Representative](StructureDefinition-ch-ppqm-consent-representative.html) consent with the Mobile
Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentRepresentativeExample.html)). A representative
may not appoint a further representative, and a legal representative may not appoint a representative (Art. 12 para. 1
EGDG).

#### Legal representative {#consent-legal-representative}

A legal representative exercises the rights of a holder who is a minor or lacks the capacity of judgement (Art. 12
EGDG). The administration of the community records the legal representative on the instruction of the competent
authority, never the holder.

The administration authenticates in the portal and adds a
[Legal representative](StructureDefinition-ch-ppqm-consent-legal-representative.html) consent with the Mobile Privacy
Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentLegalRepresentativeExample.html)), with the community or
the authority as `performer` and the instruction of the authority in `source[x]`. The legal representative has all
rights of the holder, except appointing a representative; the rights are not listed in the consent.

Rules for the Policy Repository: when a legal representative is set up, the access rights of the holder are revoked,
and all consents the holder took (with the holder as `performer`) are deleted.

#### Digital health application {#consent-digital-health-application}

The holder authorizes an admitted digital health application to access the health dossier on the holder's behalf
(Art. 11 para. 2 let. c, Art. 16 EGDG), for a chosen period, and selects what the application may do:

| Action | Right |
|---|---|
| `read` | Search and view the documents of the confidentiality levels in `provision.securityLabel` |
| `record` | Provide documents |
| `delete` | Purge documents |
| `edit-metadata` | Change the confidentiality level of a document and record a comment |
| `read-demographics` | View the personal data of the holder in the index of holders |
| `edit-contact` | Add contact data to the personal data of the holder in the index of holders |
| `read-directory` | View the directory of health professionals and health institutions |
| `manage-access` | Grant and revoke [access rights](#consent-access) of health professionals, groups and health institutions |
{:class="table table-bordered"}

Table 2: Actions a holder may grant a digital health application

The portal adds a [Digital health application](StructureDefinition-ch-ppqm-consent-digital-health-application.html)
consent with the Mobile Privacy Policy Feed (PPQ-3) transaction
([example](Consent-PpqmConsentDigitalHealthApplicationExample.html)), with the client ID of the application as
grantee.

The digital health application is an IUA Authorization Client acting for the authenticated holder; it is not a
grantee of its own. The IUA Authorization Server issues an access token to the application only while the holder has
a session with a recognized identity provider, and only with the scopes covered by the actions of the consent. With
the action `manage-access`, the application acts as Policy Source for the access rights of the holder.

Rules for the Policy Repository: the holder may revoke the authorization at any time by deleting the consent. The
consent is deleted automatically after three months without access by the application.

#### Recording by military health professionals {#consent-military-recording}

Unlike civilian health professionals, military health professionals and health institutions record data in the
health dossier only with the consent of the holder (Art. 14 para. 2 EGDG). The holder authenticates in the portal,
searches the military health professional or health institution in the directory and selects it. The portal adds a
[Military recording](StructureDefinition-ch-ppqm-consent-military-recording.html) consent with the action `record`
with the Mobile Privacy Policy Feed (PPQ-3) transaction ([example](Consent-PpqmConsentMilitaryRecordingExample.html)).
The consent grants no right to read; reading requires an [access right](#consent-access).

#### Community mandate {#consent-community-mandate}

The community managing the health dossier processes the content or the settings of the health dossier on behalf of
the holder only on the mandate (Auftrag) of the holder (Art. 15 para. 1 and Art. 31 para. 1 EGDG), e.g. when the
holder asks the support of the community for help. The mandate is given to the community, per support case and
limited in time; the employees of its administration the community designates (Art. 15 para. 3 EGDG) act on it with the
role `ADM`.

The holder or the legal representative adds the mandate in the portal, or the administration records the mandate it
received, e.g. by phone or with a signed form, with the Mobile Privacy Policy Feed (PPQ-3) transaction. The
[Community mandate](StructureDefinition-ch-ppqm-consent-community-mandate.html) consent has
([example](Consent-PpqmConsentCommunityMandateExample.html)):

- the holder or the legal representative who gave the mandate as `performer`,
- the community managing the health dossier as grantee,
- the end date of the support case in `provision.period.end`,
- where the administration records it, evidence of the mandate in `source[x]` or `verification`.

While the mandate is in effect, the administration has all rights of the holder; the rights are not listed in the
consent. The administration ends the mandate when the support case is closed by deleting the consent, and the holder
may revoke it at any time.

### Who May Record and Retrieve Which Consent

The Policy Repository authorizes each request by the consent type and the role of the user in the access token, as
shown in Table 3. C = create, R = retrieve, U = update, D = delete.

| Consent type | `PAT` | `REP` | `LEGREP` | `HCP` | `ASS` | `ADM` |
|---|---|---|---|---|---|---|
| Opening | <samp>  R    </samp> | <samp>  R    </samp> | <samp>  R    </samp> | – | – | <samp>  R    </samp> (1, 3) |
| Emergency access setting | <samp>  R U  </samp> | <samp>  R U  </samp> (2) | <samp>  R U  </samp> | – | – | <samp>  R U  </samp> (3) |
| Access | <samp>C R U D</samp> (4) | <samp>C R U D</samp> (2) | <samp>C R U D</samp> | <samp>  R    </samp> (5) | <samp>  R    </samp> (5) | <samp>C R U D</samp> (3) |
| Indirect authorization | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>C R    </samp> (6) | <samp>C R    </samp> (6) | <samp>  R   D</samp> (3) |
| Indirect authorization setting | <samp>  R U  </samp> | <samp>  R U  </samp> (2) | <samp>  R U  </samp> | – | – | <samp>  R U  </samp> (3) |
| Delegation | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>  R   D</samp> | <samp>C R U D</samp> (7) | <samp>C R U D</samp> (7) | <samp>  R   D</samp> (3) |
| Representative | <samp>C R U D</samp> | <samp>  R    </samp> (8) | – | – | – | <samp>C R U D</samp> (3) |
| Legal representative | – | – | <samp>  R    </samp> | – | – | <samp>C R U D</samp> |
| Digital health application | <samp>C R U D</samp> | – | <samp>C R U D</samp> | – | – | <samp>  R   D</samp> (3) |
| Military recording | <samp>C R U D</samp> | – | <samp>C R U D</samp> | <samp>  R    </samp> (5) | – | <samp>C R U D</samp> (3) |
| Community mandate | <samp>C R U D</samp> | – | <samp>C R U D</samp> | – | – | <samp>C R   D</samp> (9) |
{:class="table table-bordered"}

Table 3: Authorization of the CH:PPQm transactions by consent type and role

Notes:

1. The Policy Repository adds the opening, the emergency access setting and the indirect authorization setting itself when the
   health dossier is opened, and deletes all consents when it is dissolved (see [Opening](#consent-opening)).
2. Create, update and delete only if the holder granted the representative the respective action:
   `configure-emergency-access` for the emergency access setting, `configure-indirect-authorization` for the indirect
   authorization setting, `manage-access` for access rights.
3. While a [community mandate](#consent-community-mandate) of the holder is in effect (Art. 15
   para. 1 EGDG).
4. Also a digital health application acting for the holder, with the action `manage-access`.
5. Consents in which the health professional, or a group or health institution the health professional or assistant
   is a registered member of, is the grantee.
6. If the indirect authorization setting is of type permit.
7. Delegations derived from an access right of the health professional, or of a group or health institution the
   health professional or assistant is a registered member of, with the action `delegate`.
8. The consent appointing the representative.
9. The administration adds a mandate it received with evidence of the mandate, and deletes it when the support case
   is closed.

The role `TCU` is not allowed. Requests of the role `ADM` are only allowed for health dossiers managed by the community
of the administration (`Consent.organization` of the opening).
