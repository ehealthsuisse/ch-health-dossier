### Scope

The patient decides who may access their electronic health dossier (E-GD) and under which
circumstances (Art. 11-16 EGDG). CH:PPQm records each of these decisions as a FHIR Consent resource and defines the
RESTful transactions to add, update, delete and retrieve them.

A Consent describes the decision of the patient for one use case, the consent type. How an actor serving a request of
the Health Dossier API derives the access decision from the consents in effect is out of scope, see
[Enforcement of Access Rules](accesscontrol.html).

### Consent Types

Every Consent conforms to the [CH PPQm Consent](StructureDefinition-ch-ppqm-consent.html) profile and to the profile
of its consent type, given in `Consent.category` (see [HealthDossierConsentType](CodeSystem-HealthDossierConsentType.html)).
The separation of the rights by law and by consent, the common rules, the use case of each consent type and the
authorization by role are specified in [CH PPQm Consent](ppqm-consent.html).

| Consent type | Profile | Decided by (`performer`) | Grantee (`provision.actor`) | Content |
|---|---|---|---|---|
| [Opening](ppqm-consent.html#consent-opening) | [Opening](StructureDefinition-ch-ppqm-consent-opening.html) | Patient, legal representative, canton or community | Patient | Full access of the patient |
| [Emergency access](ppqm-consent.html#consent-emergency-access) | [Emergency Access](StructureDefinition-ch-ppqm-consent-emergency-access.html) | Patient, representative, legal representative | All health professionals | Permit or deny reading "normal" in an emergency |
| [Access](ppqm-consent.html#consent-access) | [Access](StructureDefinition-ch-ppqm-consent-access.html) | Patient, legal representative | Health professional, group or health institution | Read "normal", selected "restricted" documents, optional end date and right to pass on |
| [Indirect authorization](ppqm-consent.html#consent-indirect-authorization) | [Indirect Authorization](StructureDefinition-ch-ppqm-consent-indirect-authorization.html) | Patient, outside the health dossier | Health professional, group or health institution | Read "normal", with evidence |
| [Indirect authorization setting](ppqm-consent.html#consent-indirect-authorization-setting) | [Indirect Authorization Setting](StructureDefinition-ch-ppqm-consent-indirect-authorization-setting.html) | Patient, representative, legal representative | All health professionals | Permit or deny the indirect authorization |
| [Delegation](ppqm-consent.html#consent-delegation) | [Delegation](StructureDefinition-ch-ppqm-consent-delegation.html) | Health professional, group or health institution holding an access right | Health professional, group or health institution | Read "normal" until an end date |
| [Representative](ppqm-consent.html#consent-representative) | [Representative](StructureDefinition-ch-ppqm-consent-representative.html) | Patient | Representative | Confidentiality levels and actions set by the patient |
| [Legal representative](ppqm-consent.html#consent-legal-representative) | [Legal Representative](StructureDefinition-ch-ppqm-consent-legal-representative.html) | Community or authority | Legal representative | All rights of the patient, except appointing a representative |
| [Digital health application](ppqm-consent.html#consent-digital-health-application) | [Digital Health Application](StructureDefinition-ch-ppqm-consent-digital-health-application.html) | Patient, legal representative | Digital health application | Actions (scopes) until an end date |
| [Military recording](ppqm-consent.html#consent-military-recording) | [Military Recording](StructureDefinition-ch-ppqm-consent-military-recording.html) | Patient, legal representative | Military health professional or health institution | Record data |
{:class="table table-bordered"}

Table 1: Consent types

### Actors and Transactions

CH:PPQm comprises the following actors and transactions:

<figure>
  <img src="assets/images/ppqm-actors.svg" alt="CH:PPQm actor diagram"/>
  <figcaption>Figure 1: CH:PPQm actor diagram</figcaption>
</figure>

<br>

**Actor:** Policy Repository<br>
**Role:** Stores the consents of the health dossiers and provides the possibility to add, retrieve, update and delete them<br>

**Actor:** Policy Source<br>
**Role:** Initiates the addition, update and deletion of consents<br>

**Actor:** Policy Consumer<br>
**Role:** Retrieves consents<br>

Table 2 lists the transactions for each actor directly involved in the CH:PPQm Profile. To claim compliance with
this profile, an actor shall support all required transactions (labeled "R") and may support the optional
transactions (labeled "O").

| Actors            | Transactions                              | Optionality | Section             |
|-------------------|-------------------------------------------|-------------|---------------------|
| Policy Repository | Mobile Privacy Policy Feed (PPQ-3)        | R           | [PPQ-3](ppq-3.html) |
|                   | Mobile Privacy Policy Bundle Feed (PPQ-4) | R           | [PPQ-4](ppq-4.html) |
|                   | Mobile Privacy Policy Retrieve (PPQ-5)    | R           | [PPQ-5](ppq-5.html) |
| Policy Source     | Mobile Privacy Policy Feed (PPQ-3)        | O (Note 1)  | [PPQ-3](ppq-3.html) |
|                   | Mobile Privacy Policy Bundle Feed (PPQ-4) | O (Note 1)  | [PPQ-4](ppq-4.html) |
| Policy Consumer   | Mobile Privacy Policy Retrieve (PPQ-5)    | R           | [PPQ-5](ppq-5.html) |
{:class="table table-bordered"}

Table 2: CH:PPQm transactions

Note 1: The actor SHALL support at least one transaction.

The required actor groupings are shown in Table 3:

| Actors            | Actor to be grouped with | Optionality | Remark                                                             |
|-------------------|--------------------------|-------------|--------------------------------------------------------------------|
| Policy Repository | IUA Resource Server      | R           | -                                                                  |
| Policy Source     | IUA Authorization Client | R           | `TCU` not allowed |
| Policy Consumer   | IUA Authorization Client | R           | `TCU` not allowed |
{:class="table table-bordered"}

Table 3: CH:PPQm required actors groupings

### Referenced Standards

- HL7 FHIR standard Release 4: [http://hl7.org/fhir/R4/index.html](http://hl7.org/fhir/R4/index.html)

See also (informative): [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/) follows the same
pattern of use case driven consents with time limits, grants on individual documents and confidentiality levels. The
CH:PPQm actors correspond to the PCF actors as follows: Policy Source to Consent Recorder, Policy Repository to
Consent Registry, and every actor serving a request of the Health Dossier API to Consent Enforcement Point. PPQ-3 and
PPQ-5 correspond to Access Consent [ITI-108]. CH:PPQm does not claim conformance to PCF.

### Security Consideration

This national extension enforces authentication and authorization of access using the IUA profile as described in
[IUA](iti-iua.html).
