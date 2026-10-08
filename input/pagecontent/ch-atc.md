### Overview

CH:ATC (Audit Trail Consumption) defines how the patient, their representatives and the
administration retrieve the audit trail of the health dossier: who processed which data of the health dossier on which
day. It constrains the [Retrieve ATNA Audit Event [ITI-81]](iti-81.html) transaction of the IHE
[RESTful ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html) profile.

The audit trail is derived from the audit events which the actors serving the requests record for the transactions
themselves, see [Volume 3](volume3.html). No separate audit events are
recorded for the audit trail. The Patient Audit Record Repository returns them masked to the day, an assistant only
with the role, and without duplicates, see [Expected Actions of ITI-81](iti-81.html#expected-actions).

### Actors, Transactions and Content Modules

Table 1 lists the transactions for each actor directly involved in the CH:ATC Profile. To claim compliance with this
Profile, an actor SHALL support all required transactions (labeled "R").

| Actors | Transactions | Initiator or Responder | Opt | Reference |
| --- | --- | --- | --- | --- |
| Patient Audit Consumer | Retrieve ATNA Audit Event [ITI-81] | Initiator | R | [ITI-81](iti-81.html) |
| Patient Audit Record Repository | Retrieve ATNA Audit Event [ITI-81] | Responder | R | [ITI-81](iti-81.html) |
{:class="table table-bordered"}

Table 1: CH:ATC Profile - Actors and Transactions

#### Patient Audit Record Repository

The Patient Audit Record Repository is the Audit Record Repository of
[RESTful ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html) with the Retrieve Audit Message Option. It provides
the audit trail of the health dossiers with the search capabilities defined in [ITI-81](iti-81.html).

#### Patient Audit Consumer

The Patient Audit Consumer is the Audit Consumer of [RESTful ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html)
with the Retrieve Audit Message Option. It retrieves the audit trail of a health dossier for the patient, a
representative, a legal representative or the administration acting on the mandate of the patient (see
[Enforcement of Access Rules](accesscontrol.html)).

The translation of the coded elements into the preferred language of the user and the display of the audit trail are
not defined in this profile. The Patient Audit Consumer SHALL NOT display `recorded` as a time of day, since the time
is masked to the day (see [Expected Actions of ITI-81](iti-81.html#expected-actions)).

### Required Actor Groupings

This national extension enforces authentication and authorization for access control. Therefore actors of this profile
SHALL be grouped with actors of other profiles according to the following table:

| Actor | Required Grouping | Optionality | Remark |
|---|---|---|---|
| Patient Audit Record Repository | IUA Resource Server | R | - |
| Patient Audit Consumer | IUA Authorization Client | R | `TCU` not allowed |
{:class="table table-bordered"}

Table 2: Grouping of CH:ATC actors required by this national extension

### Use Cases

This profile supports the following use cases:

<ol type="a">
  <li>The patient retrieves the audit trail of their health dossier.</li>
  <li>A representative or a legal representative retrieves the audit trail of the health dossier of the patient they represent.</li>
  <li>The administration of the community retrieves the audit trail on the mandate of the patient, e.g. to answer a question of the patient.</li>
</ol>

### Content of the audit trail

The events of the audit trail, their types and the audit events they are derived from are defined in
[Volume 3](volume3.html): [Audit Trail Consumption Event Types](volume3.html#audit-trail-consumption-event-types),
[Audit trail of the document transactions](volume3.html#audit-trail-of-the-document-transactions),
[Audit trail of the consent transactions](volume3.html#audit-trail-of-the-consent-transactions) and
[Audit trail of the access to the audit trail](volume3.html#audit-trail-of-the-access-to-the-audit-trail).

### Security Considerations

This national extension enforces authentication and authorization of access using the IUA profile as described in [IUA](iti-iua.html).
