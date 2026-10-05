<div markdown="1" class="dragon">
This part of the specification is subject to change and has not yet been adapted to the proposed [EGDG legislation](index.html#introduction).
</div>

### Overview

This profile defines the audit trail consumption requirements a community has to provide for a patient’s audit trail.

The profile CH:ATC defines and precises the actors and Retrieve Audit Event [ITI-81] of the [IHE ITI Supplement Add RESTful Query to ATNA](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf) and defines the content of the Audit Messages. The different types of the Audit Messages are based on the requirements for Document and Access Policy management as well as the entry of healthcare professionals into a group in order to achieve the Swiss regulation needs on the audit trail access by patients. These Audit Event types differ from the Audit Events which have also to be logged according to the ATNA requirements.

{% include img.html img="chatc-overview.png" caption="Figure 1: CH:ATC Overview within the Swiss EPR circle of trust" width="60%" %}

Each community shall provide one endpoint to a Patient Audit Record Repository which can be queried according to the Retrieve Audit Event [ITI-81] RESTful Query transaction. A reference community shall implement a Patient Audit Consumer which will query all Patient Audit Record Repositories, aggregate the results and provide it to the patient.

How the Patient Audit Record Repository generates or collects the specified Audit Events within the community is outside the scope of this profile.


### Actors, Transactions and Content Modules
Figure 2 shows the actors directly involved in the CH:ATC Profile and the relevant transactions between them. If needed for context, other actors that may be indirectly involved due to their participation in other related profiles are shown in dotted lines.

{% include img.html img="chatc-actor-diagram.png" caption="Figure 2: CH:ATC Actor diagram" width="60%" %}

Table 1 lists the transactions for each actor directly involved in the CH:ATC Profile. To claim compliance with this Profile, an actor shall support all required transactions (labeled "R") and may support the optional transactions (labeled "O").

{:class="table table-bordered"}
| Actors | Transactions | Initiator or Responder | Opt | Reference |
| --- | --- | --- | --- | --- |
| Patient Audit Consumer | Retrieve Audit Event [ITI-81] | Initiator | R | [Patient Audit Consumer](#patient-audit-consumer) |
| Patient Audit Record Repository | Retrieve Audit Event [ITI-81] | Responder | R | [Patient Audit Record Repository](#patient-audit-record-repository) |

_Table 1: CH:ATC Profile - Actors and Transactions_

#### Actor Descriptions and Actor Profile Requirements

The actors defined in this profile are based on the [IHE ITI TF-2](https://profiles.ihe.net/ITI/TF/Volume2/index.html) and the [IHE ITI Supplement Add RESTful Query to ATNA](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf) actors. This section documents any additional requirements on the profile’s actors required in the Swiss EPR context.

#### Patient Audit Record Repository

For the actor Patient Audit Record Repository the actor Audit Record Repository in [IHE ITI Supplement Add RESTful Query to ATNA](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf) is relevant.

The Patient Audit Record Repository shall support the Retrieve Audit Message Option from the Audit Record Repository ([IHE ITI Supplement Add RESTful Query to ATNA, chapter 9.2.3](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf)) with the search capabilities as defined in [IHE ITI TF-2, chapter 3.81](https://profiles.ihe.net/ITI/TF/Volume2/ITI-81.html) and the Audit Message Formats defined in [Volume 3 - CH:ATC Audit Event Content Profiles](volume3.html).

#### Patient Audit Consumer

For the actor Patient Audit Consumer the actor Audit Consumer in [IHE ITI Supplement Add RESTful Query to ATNA](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf) is relevant.

The Patient Audit Consumer queries a Patient Audit Record Repository for Audit Events defined by this profile. The Patient Audit Consumer shall support the Retrieve Audit Message Option from the Audit Consumer ([IHE ITI Supplement Add RESTful Query to ATNA, chapter 9.2.3](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf)).

The Patient Audit Consumer should filter duplicate AuditEvents for display (e.g. Document Retrieval Audit Event for the same document access are in multiple Patient Audit Record Repositories, because the requesting and responding community need to make the AuditEvent available).

Subsequent processing like translation of the coded elements into the users preferred language and display of the query result is not defined in this profile.


### Integration Profile Options

{:class="table table-bordered"}
| CH:ATC Actor | Option name |
| --- | --- |
| Patient Audit Consumer | Aggregate Audit Message Option |
| Patient Audit Record Repository | - |

_Table 2: Actors and Options_

The Aggregate Audit Message Option allows the Patient Audit Consumer to aggregate results from multiple Patient Audit Record Repositories. A reference community shall provide at least one Patient Audit Consumer with this Option. If a Patient Audit Consumer implementing this option is unable to obtain audit records from a particular community, the Patient Audit Consumer shall add an OperationOutcome with a severity “warning” and the OID of the non-responding community to the aggregated results.


### Actor Groupings

An actor from this profile (Column 1) shall implement all of the required transactions and/or content modules in this profile <i><strong>in addition to <u>all</u></strong></i> of the requirements for the grouped actor.

{:class="table table-bordered"}
<table>
	<thead>
		<tr>
			<td>
				<p><strong>CH:ATC Actor</strong></p>
			</td>
			<td>
				<p><strong>Grouping Condition</strong></p>
			</td>
			<td>
				<p><strong>Actor to be grouped with</strong></p>
			</td>
			<td>
				<p><strong>Reference</strong></p>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="2">
				<p>Patient Audit Consumer</p>
			</td>
			<td>
				<p>Required</p>
			</td>
			<td>
				<p>IUA - Authorization Client</p>
			</td>
			<td>
				<p><a href="iti-iua.html">IHE ITI Suppl IUA</a></p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Optional</p>
			</td>
			<td>
				<p>CH:CPI - CPI Consumer</p>
			</td>
			<td>
				<p>Amendment 2.3 of Annex 5 EPRO-FDHA</p>
			</td>
		</tr>
		<tr>
			<td rowspan="2">
				<p>Patient Audit Record Repository</p>
			</td>
			<td>
				<p>Required</p>
			</td>
			<td>
				<p>CH:ADR - Authorization Decision Consumer</p>
			</td>
			<td>
				<p>Amendment 2.1 of Annex 5 EPRO-FDHA</p>
			</td>
		</tr>
		<tr>
			<td>
				<p>Required</p>
			</td>
			<td>
				<p>IUA - Resource Server</p>
			</td>
			<td>
				<p><a href="iti-iua.html">IHE ITI Suppl IUA</a></p>
			</td>
		</tr>
	</tbody>
</table>

_Table 3: Actor Grouping_

Section [Security Considerations](#security-considerations) describes the groupings required for security considerations.


### Overview - Use Cases

Activities related to the EPR are audited for specific document and access policy management events as well as entry events of healthcare professionals into a group and stored in the communities.

This profile supports the following Use Cases:   

<ol type="a">
  <li>A patient can request protocols of the activities related to his EPR.</li>
  <li>A patient representative can request a protocol of the activities related to the patients delegated EPR.</li>
</ol>

### Audit trail of the document transactions

For the document transactions the audit trail of a patient is built from the audit events which the actors serving
the requests record for the transactions themselves ([ITI-65](iti-65.html), [ITI-67](iti-67.html),
[ITI-68](iti-68.html), [CH:MHD-1](ch-mhd-1.html) and [CH:MHD-2](ch-mhd-2.html)), and no separate audit event has to be
generated for the audit trail. These audit events replace the Document Audit Event Content Profile of CH:ATC and
carry its information: the user and, for an assistant, the healthcare professional on whose behalf the assistant acts (see
[ITI-20](iti-20.html)), the patient, the document and the type of the event.

The audit events of the document transactions record the document concerned only with its master identifier
(`DocumentReference.masterIdentifier`). The title, the type and the confidentiality code of the document SHALL NOT be
recorded in the audit events, with one exception: where the confidentiality code of a document was changed
(`ATC_DOC_UPDATE_CONFIDENTIALITY`, see [CH:MHD-1](ch-mhd-1.html#security-audit-considerations)), the new
confidentiality code is recorded. An audit consumer which displays the title or the type in the audit trail of a
patient reads them from the DocumentReference; for a purged document only the master identifier is available.

#### Audit event types

The audit events of the document transactions carry, in addition to the code of the transaction, the type of the
event in the audit trail of the patient as a subtype (`AuditEvent.subtype`), from the code system
[CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html). The actor serving the request SHALL
record it, the actor making the request MAY record it. An audit consumer can filter the audit events on these types
with the search parameter `subtype`.

{:class="table table-bordered"}
| Audit event type                 | Event                                      | Transaction                                   |
|----------------------------------|--------------------------------------------|-----------------------------------------------|
| `ATC_DOC_CREATE`                 | Document upload                            | [ITI-65](iti-65.html)                         |
| `ATC_DOC_NEW_VERSION`            | New version of a document                  | [ITI-65](iti-65.html#correction-of-a-published-document) |
| `ATC_DOC_SEARCH`                 | Document search                            | [ITI-67](iti-67.html)                         |
| `ATC_DOC_READ`                   | Document retrieval                         | [ITI-68](iti-68.html)                         |
| `ATC_DOC_UPDATE_CONFIDENTIALITY` | Confidentiality code of a document changed | [CH:MHD-1](ch-mhd-1.html)                     |
| `ATC_DOC_UPDATE_NOTE`            | Personal note on a document recorded       | [CH:MHD-1](ch-mhd-1.html)                     |
| `ATC_DOC_DELETE`                 | Document removal                           | [CH:MHD-2](ch-mhd-2.html)                     |

### Audit trail of the consent transactions

For the consent transactions the audit trail of a patient is built from the audit events which the Policy Repository
records for [PPQ-3](ppq-3.html#security-audit-considerations) and [PPQ-4](ppq-4.html), and for the consents it deletes
or updates itself under the [Policy Repository rules](ppq-3.html#policy-repository-rules). These audit events replace
the Policy Audit Event Content Profile of CH:ATC.

A consent the Policy Repository deletes because of the request of a user, e.g. a delegation derived from a revoked
access right, is recorded with the user of that request as main user and the `traceparent` of that request, so that
the holder sees it as a consequence of that request. A consent it deletes without a user, i.e. the authorization of a
digital health application after three months without access and the consents of a dissolved health dossier, is
recorded with the Policy Repository as initiating agent and the reason of the deletion
([CH Audit Event for the deletion of a consent by the Policy Repository](StructureDefinition-ChAuditEventPpq3RepositoryDelete.html)).

The audit events record the consent concerned with its identifier (`Consent.identifier`), its consent type
(`Consent.category`), its grantee with identifier and display (`Consent.provision.actor.reference`) and the end of its
validity (`Consent.provision.period.end`), as details of the consent entity. The user who added, updated or deleted the
consent is the main user of the audit event.

The audit events carry the type of the event in the audit trail of the patient as a subtype, from the code system
[CH Health Dossier Audit Event Type](CodeSystem-HealthDossierAuditEventType.html). The Policy Repository SHALL record
it, the Policy Source MAY record it:

{:class="table table-bordered"}
| Consent type | Consent added | Consent updated | Consent deleted |
|---|---|---|---|
| [Emergency access](ppqm.html#consent-emergency-access) | `ATC_POL_ENA_EMER_USE` (permit) or `ATC_POL_DIS_EMER_USE` (deny) | `ATC_POL_ENA_EMER_USE` (permit) or `ATC_POL_DIS_EMER_USE` (deny) | `ATC_POL_REMOVE_AUT_PART_AL` |
| [Indirect authorization setting](ppqm.html#consent-indirect-authorization-setting) | `ATC_POL_ENA_INDIRECT_AUT` (permit) or `ATC_POL_DIS_INDIRECT_AUT` (deny) | `ATC_POL_ENA_INDIRECT_AUT` (permit) or `ATC_POL_DIS_INDIRECT_AUT` (deny) | `ATC_POL_REMOVE_AUT_PART_AL` |
| All other consent types | `ATC_POL_CREATE_AUT_PART_AL` | `ATC_POL_UPDATE_AUT_PART_AL` | `ATC_POL_REMOVE_AUT_PART_AL` |
{:class="table table-bordered"}

The emergency access and the indirect authorization setting are only deleted when the health dossier is dissolved.

### Security Considerations
This national extension enforces authentication and authorization of access using the IUA profile as described in [IUA](iti-iua.html).
