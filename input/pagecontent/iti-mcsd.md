This section specifies Swiss national extensions to Mobile Care Services Discovery (mCSD).
mCSD is [published](https://profiles.ihe.net/ITI/mCSD/index.html) as an IHE ITI Trial Implementation profile.

### Scope

In the Swiss EPR, the mCSD profile ensures that different systems can search for healthcare organizations and
professionals.
It also allows systems to provide updated information about healthcare organizations and professionals.

### Use Cases

A primary system wants to search for healthcare organizations or professionals. It can perform an
[ITI-90](iti-90.html) request with search parameters to get a list of matched resources and retrieve a resource
with its identifier.
It offers an alternative to the HPD ITI-58 transaction, which is SOAP-based.

The _Request Care Services Updates_ [ITI-91] transaction is not used in this national extension.

A primary system wants to provide updated information about its healthcare organizations or professionals to a 
directory.
It can perform a [ITI-130](iti-130.html) request to update a resource.
It offers an alternative to the HPD ITI-59 transaction, which is SOAP-based.

### Actors and Transactions, Content Specifications

<div>
{%include mCSD_actor_diagram.svg %}
</div>
This figure shows the actors directly involved in the _Mobile Care Services Discovery_ Profile and the relevant 
transactions between them.

### Actor Options

The Swiss national extension does not implement the 'Location Distance Option'.

### Required Actor Grouping

This national extension enforces authentication and authorization for access control.
Therefore, actors of this profile must be grouped with actors of other profiles according to the following table:

| Actor                        | Required Grouping        | Optionality | Remark |
|------------------------------|--------------------------|-------------|--------|
| Query Client                 | IUA Authorization Client | R           | -      |
| Data Source                  | IUA Authorization Client | R           | -      |
| Directory (with Feed Option) | IUA Resource Server      | R           | -      |
{:class="table table-bordered"}

<figcaption ID="1">Table 1: Grouping of mCSD actors required by this national extension.</figcaption>

<br/>

### Communities and military health institutions

The access rules of the health dossier depend on two kinds of organizations in the directory (see
[Enforcement of Access Rules](accesscontrol.html)). They are marked with an additional coding of `Organization.type`
from the code system [CH Health Dossier Organization Type](CodeSystem-HealthDossierOrganizationType.html), next to the
type of the health institution:

- `community`: a community managing health dossiers. Its administration (`ADM`) acts only on the health dossiers it
  manages; the IUA Authorization Server verifies the community of an administrator in the directory
  (see [ITI-71](iti-71.html#administrators)) ([example](Organization-Community.html)).
- `military`: a military health institution. Its health professionals may record data only with the consent of the
  holder (Art. 14 para. 2 EGDG, see [CH:PPQm](ppqm.html#consent-military-recording))
  ([example](Organization-MilitaryHealthInstitution.html)).

<div markdown="1" class="stu-note">
To be clarified: how the administrators of a community are registered in the directory as its members. The
[CH mCSD Practitioner](StructureDefinition-CH.mCSD.Practitioner.html) requires a GLN and a qualification, while an
administrator is identified by the administrator ID of the identity provider (`urn:e-health-suisse:administrator-id`).
</div>

### Security Consideration

This national extension enforces authentication and authorization of access to the _Care Services Selective Supplier_
using the IUA profile as described in [IUA](iti-71.html).

### Examples

The examples of this national extension are based on the following structure of health institutions with their
root and sub-organisations and of health professionals:
<img alt="Structure of the example health institutions and health professionals"
     style="max-width:100%"
     src="assets/images/ehealthsuisse_HPD_Structure.png" />
