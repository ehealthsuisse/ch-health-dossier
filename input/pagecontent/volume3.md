The audit trail shows the patient, the representatives and the administration who processed which data of
the health dossier on which day (see [CH:ATC](ch-atc.html)). It is built from the audit events which the actors
serving the requests record for the transactions themselves (see [ITI-20](iti-20.html)); no separate audit events are
recorded for the audit trail. There are three categories of events in the audit trail:

<ol type="a">
    <li>
        Document management, e.g. a document has been uploaded to the health dossier or the documents have been searched
        (see <a href="#audit-trail-of-the-document-transactions">Audit trail of the document transactions</a>).
    </li>
    <li>
        Consent management, e.g. the patient has granted a healthcare professional an access right
        (see <a href="#audit-trail-of-the-consent-transactions">Audit trail of the consent transactions</a>).
    </li>
    <li>
        Access to the audit trail, e.g. the patient has retrieved the audit trail
        (see <a href="#audit-trail-of-the-access-to-the-audit-trail">Audit trail of the access to the audit trail</a>).
    </li>
</ol>

The patient is not informed about changes in the members of a group of healthcare professionals, and no audit event is
provided for them.

The Patient Audit Record Repository returns the audit events with [Retrieve ATNA Audit Event [ITI-81]](iti-81.html)
masked to the day and without duplicates, as [CH Audit Trail Event](StructureDefinition-ChAuditTrailEvent.html) (see
[Expected Actions of ITI-81](iti-81.html#expected-actions)).

### Audit Trail Consumption Event Types

The audit events carry, in addition to the code of the transaction, the type of the event in the audit trail of the
patient as a subtype (`AuditEvent.subtype`), from the code system
[CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html). The actor serving the request SHALL
record it, the actor making the request MAY record it. A Patient Audit Consumer can filter the audit trail on these
types with the search parameter `subtype` (see [ITI-81](iti-81.html)).

The code system succeeds the Audit Trail Consumption event types of the EPR
([Codesystem 2.16.756.5.30.1.127.3.10.7](https://fhir.ch/ig/ch-term/CodeSystem-2.16.756.5.30.1.127.3.10.7.html)). The
codes whose meaning is unchanged keep their value. The document update (`ATC_DOC_UPDATE`) is split into the change of
the confidentiality code and the recording of a personal note, and the new version of a document and the setting of the
indirect authorization are added. The default confidentiality level (`ATC_POL_DEF_CONFLEVEL`), the exclusion list
(`ATC_POL_INCL_BLACKLIST`, `ATC_POL_EXL_BLACKLIST`) and the entry of healthcare professionals into a group
(`ATC_HPD_GROUP_ENTRY_NOTIFY`) are not used any more.

{:class="table table-bordered"}
| Audit event type | Event | Transaction | Audit event profile | Example |
|---|---|---|---|---|
| `ATC_DOC_CREATE` | Document upload | [ITI-65](iti-65.html) | [CH Audit Event for [ITI-65] Document Recipient](StructureDefinition-ChAuditEventIti65Recipient.html) | [upload](AuditEvent-ChAuditEventIti65RecipientExample.html) |
| `ATC_DOC_NEW_VERSION` | New version of a document | [ITI-65](iti-65.html#correction-of-a-published-document) | [CH Audit Event for [ITI-65] Document Recipient](StructureDefinition-ChAuditEventIti65Recipient.html) | [new version](AuditEvent-ChAuditEventIti65RecipientCorrectionExample.html) |
| `ATC_DOC_SEARCH` | Document search | [ITI-67](iti-67.html) | [CH Audit Event for [ITI-67] Document Responder](StructureDefinition-ChAuditEventIti67Responder.html) | [search](AuditEvent-ChAuditEventIti67ResponderExample.html) |
| `ATC_DOC_READ` | Document retrieval | [ITI-68](iti-68.html) | [CH Audit Event for [ITI-68] Document Responder](StructureDefinition-ChAuditEventIti68Responder.html) | [retrieval](AuditEvent-ChAuditEventIti68ResponderExample.html) |
| `ATC_DOC_UPDATE_CONFIDENTIALITY` | Confidentiality code of a document changed | [CH:MHD-1](ch-mhd-1.html) | [CH Audit Event for [CH:MHD-1] Document Responder](StructureDefinition-ch-mhd-updatedocumentmetadata-audit-responder.html) | [confidentiality code](AuditEvent-ChAuditEventChMhd1ResponderExample.html) |
| `ATC_DOC_UPDATE_NOTE` | Personal note on a document recorded | [CH:MHD-1](ch-mhd-1.html) | [CH Audit Event for [CH:MHD-1] Document Responder](StructureDefinition-ch-mhd-updatedocumentmetadata-audit-responder.html) | [personal note](AuditEvent-ChAuditEventChMhd1ResponderPersonalNoteExample.html) |
| `ATC_DOC_DELETE` | Document removal | [CH:MHD-2](ch-mhd-2.html) | [CH Audit Event for [CH:MHD-2] Document Responder](StructureDefinition-ch-mhd-purgedocument-audit-responder.html) | [removal](AuditEvent-ChAuditEventChMhd2ResponderExample.html) |
| `ATC_POL_CREATE_AUT_PART_AL` | Consent added, all consent types except the emergency access and the indirect authorization setting | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), [Policy Repository rules](ppq-3.html#policy-repository-rules) (opening) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html), [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html) | [indirect authorization](AuditEvent-ChAuditEventPpq3CreateExample.html) |
| `ATC_POL_UPDATE_AUT_PART_AL` | Consent updated, all consent types except the emergency access and the indirect authorization setting | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) | [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html) | |
| `ATC_POL_REMOVE_AUT_PART_AL` | Consent deleted, all consent types | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), [Policy Repository rules](ppq-3.html#policy-repository-rules) | [CH Audit Event for [PPQ-3] Delete privacy policy](StructureDefinition-ChAuditEventPpq3Delete.html), [CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html) | [access right revoked](AuditEvent-ChAuditEventPpq3DeleteExample.html), [digital health application expired](AuditEvent-ChAuditEventPpq3RepositoryDeleteExample.html) |
| `ATC_POL_ENA_EMER_USE` | [Emergency access](ppqm.html#consent-emergency-access) added or updated with type permit | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), [Policy Repository rules](ppq-3.html#policy-repository-rules) (opening) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html), [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html), [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html) | [emergency access added](AuditEvent-ChAuditEventPpq3RepositoryCreateExample.html) |
| `ATC_POL_DIS_EMER_USE` | [Emergency access](ppqm.html#consent-emergency-access) added or updated with type deny | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html), [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html) | [emergency access excluded](AuditEvent-ChAuditEventPpq3UpdateExample.html) |
| `ATC_POL_ENA_INDIRECT_AUT` | [Indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) added or updated with type permit | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), [Policy Repository rules](ppq-3.html#policy-repository-rules) (opening) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html), [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html), [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html) | |
| `ATC_POL_DIS_INDIRECT_AUT` | [Indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) added or updated with type deny | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html), [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html) | |
| `ATC_LOG_READ` | Access to the audit trail | [ITI-81](iti-81.html) | [CH Audit Event for [ITI-81] Patient Audit Record Repository](StructureDefinition-ChAuditEventIti81Repository.html) | [audit trail retrieved by the patient](AuditEvent-ChAuditEventIti81RepositoryExample.html) |

_Table 1: Audit Trail Consumption Event Types_

### Audit trail of the document transactions

For the document transactions the audit trail of a patient is built from the audit events which the actors serving
the requests record for the transactions themselves ([ITI-65](iti-65.html), [ITI-67](iti-67.html),
[ITI-68](iti-68.html), [CH:MHD-1](ch-mhd-1.html) and [CH:MHD-2](ch-mhd-2.html)). These audit events replace the
Document Audit Event Content Profile of the EPR and carry its information: the user and, for an assistant, the
healthcare professional on whose behalf the assistant acts (see [ITI-20](iti-20.html)), the patient, the document and
the type of the event.

The audit events of the document transactions record the document concerned only with its master identifier
(`DocumentReference.masterIdentifier`). The title, the type and the confidentiality code of the document SHALL NOT be
recorded in the audit events, with one exception: where the confidentiality code of a document was changed
(`ATC_DOC_UPDATE_CONFIDENTIALITY`, see [CH:MHD-1](ch-mhd-1.html#security-audit-considerations)), the new
confidentiality code is recorded. A Patient Audit Consumer which displays the title or the type in the audit trail of
a patient reads them from the DocumentReference; for a purged document only the master identifier is available.

### Audit trail of the consent transactions

For the consent transactions the audit trail of a patient is built from the audit events which the Policy Repository
records for [PPQ-3](ppq-3.html#security-audit-considerations) and [PPQ-4](ppq-4.html), and for the consents it adds,
deletes or updates itself under the [Policy Repository rules](ppq-3.html#policy-repository-rules). These audit events
replace the Policy Audit Event Content Profile of the EPR. The Policy Repository SHALL record the type of the event in
the audit trail, the Policy Source MAY record it. The types follow from the consent type and the type of the provision
(permit or deny), see [Table 1](#audit-trail-consumption-event-types); the emergency access and the indirect
authorization setting are only deleted when the health dossier is dissolved.

A consent the Policy Repository deletes because of the request of a user, e.g. a delegation derived from a revoked
access right, is recorded with the user of that request as main user and the `traceparent` of that request, so that
the patient sees it as a consequence of that request. A consent it deletes without a user, i.e. the authorization of a
digital health application after three months without access and the consents of a dissolved health dossier, is
recorded with the Policy Repository as initiating agent and the reason of the deletion
([CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html)).
The consents the Policy Repository adds when the health dossier is opened are recorded with the Policy Repository as
initiating agent as well
([CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html)).

The audit events record the consent concerned with its identifier (`Consent.identifier`), its consent type
(`Consent.category`), its grantee with identifier and display (`Consent.provision.actor.reference`) and the end of its
validity (`Consent.provision.period.end`), as details of the consent entity. The user who added, updated or deleted the
consent is the main user of the audit event.

### Audit trail of the access to the audit trail

The access to the audit trail is recorded by the Patient Audit Record Repository for every
[ITI-81](iti-81.html#security-audit-considerations) request, whoever made it: the patient, a representative, a legal
representative or the administration
([CH Audit Event for [ITI-81] Patient Audit Record Repository](StructureDefinition-ChAuditEventIti81Repository.html)).
These audit events replace the Access Audit Trail Content Profile of the EPR. The Patient Audit Consumer records the
request as well
([CH Audit Event for [ITI-81] Patient Audit Consumer](StructureDefinition-ChAuditEventIti81Consumer.html)) and MAY
record the type `ATC_LOG_READ`, as the actors making the requests of the other transactions.
