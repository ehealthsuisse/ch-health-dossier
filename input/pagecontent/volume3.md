
Annex 2 EPRO-FDHA, chapter 2.10 defines the audit requirements for the EPR.
 
There are four different categories of Audit Events in the context of the EPR :

<ol type="a">
    <li>
        Document management (e.g., a document has been uploaded to the EPR of a patient or a list of document metadata has been retrieved).
    </li>
    <li>
        Policy management (e.g., a patient has given a healthcare professional access rights to his EPR).
    </li>
    <li>
        Access Patient Audit Record Repository by a patient or representative (a patient viewed the Audit Trail for the Audit Record Repository).
    </li>
    <li>
        Notification of the patient about the entry of healthcare professionals into a group.
    </li>
</ol>

While the Access to the Audit Repository, Document and Policy management categories are self-explanatory, the notification 
of the patient about the entry of healthcare professionals into a group may require some explanations. The access management 
of the EPR is based on individuals and groups. Patients assign the access rights either to individual healthcare 
professionals, or to groups of healthcare professionals. All healthcare professionals in a group inherit the 
access rights of the group or of the parent groups, depending on the hierarchy of groups (see [examples](iti-mcsd.html#examples)).
To ensure that patients are aware of the entry of healthcare professionals into a group, the communities shall provide 
the notifications to patients. The notification mechanism is out of scope of this specification. This specification only 
specifies the requirements for the audit trail of the event.

Each category is described as a content profile. These content profiles are based on the AuditEvent Resource, 
[http://hl7.org/fhir/R4/auditevent.html](http://hl7.org/fhir/R4/auditevent.html).

The AuditEvent Resource has [mapping rules to the DICOM audit message format](http://hl7.org/fhir/R4/auditevent-mappings.html#dicom), which allows to map to ATNA.

### Audit Trail Consumption Event Types
The following Audit Trail Consumption Event Types are defined and shall be supported, see [EprAuditTrailConsumptionEventTypes](http://fhir.ch/ig/ch-term/ValueSet/EprAuditTrailConsumptionEventType) from [Codesystem 2.16.756.5.30.1.127.3.10.7](https://fhir.ch/ig/ch-term/CodeSystem-2.16.756.5.30.1.127.3.10.7.html). The types of the document management (`ATC_DOC_...`) and of the policy management (`ATC_POL_...`) are defined in the code system [CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html) instead, which succeeds the document and policy types of that code system. The default confidentiality level (`ATC_POL_DEF_CONFLEVEL`) and the exclusion list (`ATC_POL_INCL_BLACKLIST`, `ATC_POL_EXL_BLACKLIST`) are not used any more.

{:class="table table-bordered"}
| Type | Description | Profile Ref | Opt Community |
| --- | --- | --- | --- |
| ATC_DOC_CREATE | Document upload | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_NEW_VERSION | New version of a document | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_READ | Document retrieval | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_UPDATE_CONFIDENTIALITY | Confidentiality code of a document changed | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_UPDATE_NOTE | Personal note on a document recorded | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_DELETE | Document removal | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_DOC_SEARCH | Document search | [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions) | R |
| ATC_POL_CREATE_AUT_PART_AL | Authorize participants to access level/date | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_UPDATE_AUT_PART_AL | Update access level/date of authorized participants | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_REMOVE_AUT_PART_AL | Remove authorization for participants to access level/date | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_ENA_EMER_USE | Enabling Emergency Access | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_DIS_EMER_USE | Disabling Emergency Access | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_ENA_INDIRECT_AUT | Enabling Indirect Authorization | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_POL_DIS_INDIRECT_AUT | Disabling Indirect Authorization | [Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions) | R |
| ATC_LOG_READ | Accessing Patient Audit Record Repository | [Access Audit Trail Content Profile](#access-audit-trail-content-profile) | R |
| ATC_HPD_GROUP_ENTRY_NOTIFY | Entry of healthcare professionals into a group | [HPD Group Entry Audit Event Content Profile](#hpd-group-entry-audit-event-content-profile) | R, (NP: if not reference community) |

_Table 4: Audit Trail Consumption Event Types_


### Document Audit Event Content Profile

There is no separate content profile for the audit events of the document management anymore. The audit trail of a
patient is built from the audit events which the actors serving the requests record for the document transactions
themselves, see [Audit trail of the document transactions](ch-atc.html#audit-trail-of-the-document-transactions):

{:class="table table-bordered"}
| Event | Transaction | Audit event profile | Example |
| --- | --- | --- | --- |
| Document upload, new version of a document | [ITI-65](iti-65.html) | [CH Audit Event for [ITI-65] Document Recipient](StructureDefinition-ChAuditEventIti65Recipient.html) | [upload](AuditEvent-ChAuditEventIti65RecipientExample.html), [new version](AuditEvent-ChAuditEventIti65RecipientCorrectionExample.html) |
| Document search | [ITI-67](iti-67.html) | [CH Audit Event for [ITI-67] Document Responder](StructureDefinition-ChAuditEventIti67Responder.html) | [search](AuditEvent-ChAuditEventIti67ResponderExample.html) |
| Document retrieval | [ITI-68](iti-68.html) | [CH Audit Event for [ITI-68] Document Responder](StructureDefinition-ChAuditEventIti68Responder.html) | [retrieval](AuditEvent-ChAuditEventIti68ResponderExample.html) |
| Confidentiality code changed, personal note recorded | [CH:MHD-1](ch-mhd-1.html) | [CH Audit Event for [CH:MHD-1] Document Responder](StructureDefinition-ch-mhd-updatedocumentmetadata-audit-responder.html) | [confidentiality code](AuditEvent-ChAuditEventChMhd1ResponderExample.html), [personal note](AuditEvent-ChAuditEventChMhd1ResponderPersonalNoteExample.html) |
| Document removal | [CH:MHD-2](ch-mhd-2.html) | [CH Audit Event for [CH:MHD-2] Document Responder](StructureDefinition-ch-mhd-purgedocument-audit-responder.html) | [removal](AuditEvent-ChAuditEventChMhd2ResponderExample.html) |

_Table 5: Audit events of the document transactions_

### Policy Audit Event Content Profile

There is no separate content profile for the audit events of the policy management anymore. The audit trail of a
patient is built from the audit events which the Policy Repository records for the consent transactions, see
[Audit trail of the consent transactions](ch-atc.html#audit-trail-of-the-consent-transactions):

{:class="table table-bordered"}
| Event | Transaction | Audit event profile | Example |
| --- | --- | --- | --- |
| Consent added | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) | [CH Audit Event for [PPQ-3] Create privacy policy](StructureDefinition-ChAuditEventPpq3Create.html) | [indirect authorization](AuditEvent-ChAuditEventPpq3CreateExample.html) |
| Consent updated | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html) | [CH Audit Event for [PPQ-3] Update privacy policy](StructureDefinition-ChAuditEventPpq3Update.html) | [emergency access excluded](AuditEvent-ChAuditEventPpq3UpdateExample.html) |
| Consent deleted | [PPQ-3](ppq-3.html), [PPQ-4](ppq-4.html), Policy Repository rules caused by a request | [CH Audit Event for [PPQ-3] Delete privacy policy](StructureDefinition-ChAuditEventPpq3Delete.html) | [access right revoked](AuditEvent-ChAuditEventPpq3DeleteExample.html) |
| Consent added by the Policy Repository at the opening | [Policy Repository rules](ppq-3.html#policy-repository-rules) | [CH Audit Event for the addition of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryCreate.html) | [emergency access added](AuditEvent-ChAuditEventPpq3RepositoryCreateExample.html) |
| Consent deleted by the Policy Repository without a user | [Policy Repository rules](ppq-3.html#policy-repository-rules) | [CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html) | [digital health application expired](AuditEvent-ChAuditEventPpq3RepositoryDeleteExample.html) |

_Table 6: Audit events of the consent transactions_


### Access Audit Trail Content Profile

This content profile describes Audit Event related to Accessing the Audit Trail of a Patient from a Patient Audit Record Repository. The following Data Elements shall be provided:

{:class="table table-bordered"}
<table>
	<tbody>
		<tr>
			<td>
				<p><strong>Data Element</strong></p>
			</td>
			<td>
				<p><strong>Description</strong></p>
			</td>
			<td>
				<p><strong>Property/Value</strong></p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Event Type</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
			<td>
				<p>Access Audit Trail</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Event Date and Time</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
			<td>
				<p>FHIR instant</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Participants</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
		</tr>
		<tr>
			<td rowspan="2">
				<p>Initiator</p>
			</td>
			<td>
				<p>Patient</p>
			</td>
			<td>
				<p>Name</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Representative of patient</p>
			</td>
			<td>
				<p>Name<br />UAP-ID or EPR-SPID</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Responsible</p>
			</td>
			<td>
				<p>Patient</p>
			</td>
			<td>
				<p>Name</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Patient</p>
			</td>
			<td>
				<p>Involved patient</p>
			</td>
			<td>
				<p>EPR-SPID</p>
			</td>
		</tr>
	</tbody>
</table>

_Table 7: Access Audit Trail Data Elements_

This content profile defines the access audit trail event, which a community has to provide for a patient’s audit trail. This profile builds on AuditEvent ([http://hl7.org/fhir/R4/auditevent.html](http://hl7.org/fhir/R4/auditevent.html)).   
* [StructureDefinition for Access Audit Trail Event Profile](StructureDefinition-AccessAuditTrailEvent.html)

The mapping from the Access Audit Trail Event Resource to the Data Elements is as follows:   
* [Mapping for Access Audit Trail Event Profile](StructureDefinition-AccessAuditTrailEvent-mappings.html)


#### Example

{:class="table table-bordered"}
| Event | Access Audit Trail |
| Patient | Jakob Wieder-Gesund |
| Timestamp | 22.09.2020 10:47 |
| Participant | Jakob Wieder-Gesund |

_Table 8: Example Log Access (atc-log-read)_

* Example for Access Audit Trail Event Profile: [XML](AuditEvent-atc-log-read.xml.html), [JSON](AuditEvent-atc-log-read.json.html)


### HPD Group Entry Audit Event Content Profile

This content profile describe the Audit Event related to the entry of a healthcare professional into a HPD group for which the patient is notified. The following Data Elements shall be provided:

{:class="table table-bordered"}
<table>
	<tbody>
		<tr>
			<td>
				<p><strong>Data Element</strong></p>
			</td>
			<td>
				<p><strong>Description</strong></p>
			</td>
			<td>
				<p><strong>Property/Value</strong></p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Event Type</p>
			</td>
			<td colspan="2">
				<p>Patient notified of Healthcare Professionals added to a group</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Event Date and Time</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
			<td>
				<p>FHIR instant</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Notification Service</p>
			</td>
			<td>
				<p>&nbsp;</p>
			</td>
			<td>
				<p>Name</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Patient</p>
			</td>
			<td>
				<p>Notified patient</p>
			</td>
			<td>
				<p>EPR-SPID</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Healthcare Professionals</p>
			</td>
			<td>
				<p>Healthcare professionals</p>
			</td>
			<td>
				<p>Name<br />GLN</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Group</p>
			</td>
			<td>
				<p>Group where Healthcare Professionals are added as members</p>
			</td>
			<td>
				<p>Name of Group<br />OID</p>
			</td>
		</tr>
	</tbody>
</table>

_Table 9: HPD Group Entry Audit Event Elements_

This profile defines the content of the HPD group entry audit event. This profile builds on AuditEvent ([http://hl7.org/fhir/R4/auditevent.html](http://hl7.org/fhir/R4/auditevent.html)).   
* [StructureDefinition for HPD Group Entry Audit Event Profile](StructureDefinition-HpdAuditEvent.html)

The mapping from the HPD Group Entry Audit Event Resource to the Data Elements is as follows:   
* [Mapping for HPD Group Entry Audit Event Profile](StructureDefinition-HpdAuditEvent-mappings.html)


#### Example

{:class="table table-bordered"}
| Event | Group entry of healthcare professional: |
| Healthcare professionals | Dr. med. Sabine Musterfrau |
| Timestamp | 10.10.2020 10:05 |
| Participant, Group | Kardiologie Universitätsspital Musterstadt |
| Patient | Jakob Wieder-Gesund |

_Table 10: Example group entry of healthcare professionals_

* Example for HPD Group Entry Audit Event Profile: [XML](AuditEvent-atc-hpd-group-entry-notify.xml.html), [JSON](AuditEvent-atc-hpd-group-entry-notify.json.html)

