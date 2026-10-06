### Scope

This transaction is used by the Policy Source to add, update, or delete a single consent of a health dossier.
Correspondingly, the following HTTP methods SHALL be supported: `POST`, `PUT`, and `DELETE`.

### HTTP Method POST

<figure>
  {% include PPQm-3_post_actor_diagram.svg %}
  <figcaption>Figure 2: PPQ-3: HTTP Method POST</figcaption>
</figure>

#### Trigger Event

The Policy Source uses HTTP method `POST` to add a new consent to the Policy Repository, e.g. when the holder
authorizes a health professional (see the use cases per [consent type](ppqm.html#consent-types)).

#### Request Message

The request body SHALL represent a single Consent resource compliant to the
[CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) profile and to the profile of its consent type. The Policy
Source SHALL assign a new UUID as `Consent.identifier`.

The request SHALL be sent to `[baseUrl]/Consent`.

#### Expected Actions

Upon receiving the HTTP POST request, the Policy Repository SHALL:
- Authorize the request as described in [Authorization](#authorization).
- Validate the Consent resource contained in the request body as described in [Validation](#validation). In
  particular, it SHALL be validated that no consent with the same identifier exists.
- Persist the Consent and apply the [Policy Repository rules](#policy-repository-rules).
- Create a PPQ-3 response according to the transaction outcome.

#### Response Message

The PPQ-3 response SHALL be created according to the section
[3.1.0.8](https://hl7.org/fhir/R4/http.html#create) of the FHIR R4 specification.

### HTTP Method PUT

<figure>
  {% include PPQm-3_put_actor_diagram.svg %}
  <figcaption>Figure 3: PPQ-3: HTTP Method PUT</figcaption>
</figure>

#### Trigger Event

The Policy Source uses HTTP method `PUT` to update an existing consent, e.g. when the holder changes the end date of
an access right, or excludes emergency access.

#### Request Message

The request body SHALL represent a single Consent resource compliant to the
[CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) profile and to the profile of its consent type.

The request SHALL be sent to `[baseUrl]/Consent?identifier=[uuid]`.

#### Expected Actions

The Policy Repository SHALL implement the Conditional Update pattern described in section
[3.1.0.4.3](https://hl7.org/fhir/R4/http.html#cond-update) of the FHIR R4 specification.

Upon receiving the HTTP PUT request, the Policy Repository SHALL:
- Authorize the request as described in [Authorization](#authorization), for the stored and the updated consent.
- Validate the Consent resource contained in the request body as described in [Validation](#validation). In
  particular, it SHALL be validated that the identifier is the same as in the HTTP URL, and that the consent type
  (`category`) and the patient are the same as in the stored consent.
- Persist the Consent and apply the [Policy Repository rules](#policy-repository-rules).
- Create a PPQ-3 response according to the transaction outcome.

#### Response Message

The PPQ-3 response SHALL be created according to the section
[3.1.0.4](https://hl7.org/fhir/R4/http.html#update) of the FHIR R4 specification.

###	HTTP Method DELETE

<figure>
  {% include PPQm-3_delete_actor_diagram.svg %}
  <figcaption>Figure 4: PPQ-3: HTTP Method DELETE</figcaption>
</figure>

#### Trigger Event

The Policy Source uses HTTP method `DELETE` to revoke an existing consent, e.g. when the holder revokes an access
right or the authorization of a digital health application.

#### Request Message

The request body SHALL be empty.

The request SHALL be sent to `[baseUrl]/Consent?identifier=[uuid]`.

#### Expected Actions

The Policy Repository SHALL implement the Conditional Delete pattern described in section
[3.1.0.7.1](https://hl7.org/fhir/R4/http.html#3.1.0.7.1) of the FHIR R4 specification.

Upon receiving the HTTP DELETE request, the Policy Repository SHALL:
- Authorize the request as described in [Authorization](#authorization), for the stored consent.
- Validate the request as described in [Validation](#validation).
- Delete the consent referenced in the request and apply the [Policy Repository rules](#policy-repository-rules).
- Create a PPQ-3 response according to the transaction outcome.

#### Response Message

The PPQ-3 response SHALL be created according to the section
[3.1.0.7](https://hl7.org/fhir/R4/http.html#delete) of the FHIR R4 specification.

### Expected Actions Common to All HTTP Methods

#### Authorization

The Policy Repository SHALL authorize the request by the consent type and the role of the requester (`subject_role`
of the access token), as defined in
[Who May Record and Retrieve Which Consent](ppqm.html#who-may-record-and-retrieve-which-consent). In addition, the
Policy Repository SHALL verify that:

- the patient of the consent (`Consent.patient`) is the patient of the access token (`person_id`);
- for the role `ADM`, the community of the administration (`subject_organization_id`) manages the health dossier
  (`Consent.organization` of the [opening](ppqm.html#consent-opening));
- for the roles `HCP` and `ASS`, the health professional the request is made for, or the group or health
  institution in `group_id`, is the grantee of an [indirect authorization](ppqm.html#consent-indirect-authorization),
  and the grantee of the access right a [delegation](ppqm.html#consent-delegation) is derived from;
- the `performer` of the consent corresponds to the requester:

| Role of the requester | `performer` |
|---|---|
| `PAT`, also a digital health application acting for the holder | The holder (EPR-SPID = `person_id`) |
| `REP`, `LEGREP` | The representative or legal representative (representative ID = `user_id`) |
| `HCP`, `ASS` | [Indirect authorization](ppqm.html#consent-indirect-authorization): the holder. [Delegation](ppqm.html#consent-delegation): the health professional (GLN of the health professional the request is made for), or the group or health institution (`group_id`) |
| `ADM` | [Legal representative](ppqm.html#consent-legal-representative): the community or authority. Other consent types, on mandate: the holder |
{:class="table table-bordered"}

Table 1: Performer of the consent by the role of the requester

A digital health application acting for the holder may only add, update or delete
[access rights](ppqm.html#consent-access), and only while a
[digital health application](ppqm.html#consent-digital-health-application) consent with the action `manage-access`
for its client ID is in effect.

The Policy Repository SHALL reject a request that is not authorized with HTTP `403 Forbidden` and an OperationOutcome
with the issue code `forbidden`.

#### Validation

The Policy Repository SHALL validate the Consent against the [CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html)
profile and the profile of its consent type, and SHALL verify the following rules:

| Consent type | Rule |
|---|---|
| All | Except for the opening, a consent can only be added while an [opening](ppqm.html#consent-opening) of the patient is in effect. The identifier, the consent type and the patient of a consent SHALL NOT be changed. |
| [Opening](ppqm.html#consent-opening), [emergency access](ppqm.html#consent-emergency-access), [indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) | At most one consent of each of these types per patient. They are only added and deleted by the Policy Repository, when the health dossier is opened or dissolved (see [Policy Repository rules](#policy-repository-rules)); the emergency access and the indirect authorization setting are updated to the type permit or deny. The `organization` of the opening SHALL be the community managing the health dossier in the Register E-GD. |
| [Access](ppqm.html#consent-access) | The documents released in nested provisions SHALL be documents of the patient. |
| [Indirect authorization](ppqm.html#consent-indirect-authorization) | The [indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) of the patient SHALL be of type permit. |
| [Delegation](ppqm.html#consent-delegation) | The access right in `sourceReference` SHALL be in effect, SHALL grant the action `delegate`, and SHALL have the performer of the delegation, or a group or health institution the performer is a member of, as grantee. The end date of the delegation SHALL NOT be later than the end date of the access right. |
| [Representative](ppqm.html#consent-representative) | The performer SHALL be the holder; a legal representative SHALL NOT appoint a representative. |
| [Digital health application](ppqm.html#consent-digital-health-application) | The client ID SHALL be the one of an admitted digital health application registered at the IUA Authorization Server, and the actions SHALL be within the scopes of its admission. |
| [Military recording](ppqm.html#consent-military-recording) | The grantee SHALL be an organization of the type `military` in the directory (see [mCSD](iti-mcsd.html#communities-and-military-health-institutions)), or a health professional registered as its member. |
{:class="table table-bordered"}

Table 2: Validation rules by consent type

The Policy Repository SHALL reject a request which fails the validation with HTTP `422 Unprocessable Entity` and an
OperationOutcome describing the failed rule, or with HTTP `400 Bad Request` if the resource cannot be parsed.

#### Policy Repository rules

After persisting or deleting a consent, or on an event of the Register E-GD, the Policy Repository SHALL apply the
following rules. The consents the Policy Repository adds, updates or deletes itself are recorded in the audit trail of the holder (see
[Security Audit Considerations](#security-audit-considerations)).

| Event | Rule |
|---|---|
| The health dossier is opened in the Register E-GD, automatically or voluntarily | The [opening](ppqm.html#consent-opening), the [emergency access](ppqm.html#consent-emergency-access) and the [indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) are added, with the type permit, the community managing the health dossier in `organization` and the person or authority who opened the health dossier as `performer`. |
| A [legal representative](ppqm.html#consent-legal-representative) is added | The access rights of the holder are revoked while the legal representative is in effect, and all consents with the holder as `performer` are deleted. |
| An [indirect authorization](ppqm.html#consent-indirect-authorization) is added | The holder is notified. |
| An [access right](ppqm.html#consent-access) is deleted, or its validity ends | The [delegations](ppqm.html#consent-delegation) derived from it are deleted. |
| A [digital health application](ppqm.html#consent-digital-health-application) has not accessed the health dossier for three months | The consent is deleted. |
| A document is purged with [Purge Document [CH:MHD-2]](ch-mhd-2.html) | The document is removed from the nested provisions of the access rights; a nested provision without documents is removed. |
| The health dossier is dissolved in the Register E-GD, on request of the holder or the legal representative or on the death of the holder | All consents of the patient are deleted. |
{:class="table table-bordered"}

Table 3: Policy Repository rules

### Security Considerations

The transaction SHALL be secured by Transport Layer Security (TLS) encryption and server authentication with
server certificates.

The transaction SHALL use client authentication and authorization using an extended access token defined in
[IUA](iti-71.html) conveyed as defined in the
[Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

The **Policy Source** and **Policy Repository** SHALL record an audit event for each operation in the 
transaction according to:

- [CH Audit Event for [PPQ-3] **Create** Privacy Policy](StructureDefinition-ChAuditEventPpq3Create.html)
- [CH Audit Event for [PPQ-3] **Update** Privacy Policy](StructureDefinition-ChAuditEventPpq3Update.html)
- [CH Audit Event for [PPQ-3] **Delete** Privacy Policy](StructureDefinition-ChAuditEventPpq3Delete.html)

The audit events of the Policy Repository build the audit trail of the patient, see
[Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions). The Policy Repository
SHALL record the type of the event in the audit trail as a subtype, and the consent type, the grantee and the end of
the validity of the consent as details of the consent entity
([example for an indirect authorization](AuditEvent-ChAuditEventPpq3CreateExample.html),
[example for the exclusion of emergency access](AuditEvent-ChAuditEventPpq3UpdateExample.html),
[example for a revoked access right](AuditEvent-ChAuditEventPpq3DeleteExample.html)).

The Policy Repository SHALL also record an audit event for every consent it adds, deletes or updates itself under the
[Policy Repository rules](#policy-repository-rules):

- where the rule is applied because of the request of a user, according to the Delete or Update profile above, with
  the user of that request as main user and the `traceparent` of that request: the delegations derived from a revoked
  access right, the consents of the holder deleted when a legal representative is set up, and the access rights
  updated when a document is purged;
- where no user is involved, with the Policy Repository as initiating agent: the consents added when the health dossier
  is opened according to
  [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html)
  ([example for the emergency access](AuditEvent-ChAuditEventPpq3RepositoryCreateExample.html)), and the consents
  deleted according to
  [CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html)
  with the reason of the deletion
  ([example for a digital health application without access for three months](AuditEvent-ChAuditEventPpq3RepositoryDeleteExample.html)):
  `inactivity` for a digital health application without access for three months, `dissolution` and `death` for the
  consents deleted when the health dossier is dissolved.
