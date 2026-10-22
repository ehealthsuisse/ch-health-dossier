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
It can perform an [ITI-130](iti-130.html) request to update a resource.
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
| Query Client                 | IUA Authorization Client | R           | `TCU` allowed for [ITI-90](iti-90.html) |
| Data Source                  | IUA Authorization Client | R           | `TCU` allowed for [ITI-130](iti-130.html) |
| Directory (with Feed Option) | IUA Resource Server      | R           | -      |
{:class="table table-bordered"}

<figcaption ID="1">Table 1: Grouping of mCSD actors required by this national extension.</figcaption>

<br/>

### Communities and military health institutions

The access rules of the health dossier depend on two kinds of organizations in the directory (see
[Enforcement of Access Rules](accesscontrol.html)). They are marked in `Organization.type`:

- Community: a community managing health dossiers is marked with the code `community` of the code system
  [CH Health Dossier Organization Type](CodeSystem-HealthDossierOrganizationType.html) (slice `type:community` of
  [CH mCSD Organization](StructureDefinition-CH.mCSD.Organization.html)).
- Military health institution: a military health institution is marked with the SNOMED CT code
  `722172003` *Military health institution (environment)* of the value set
  [DocumentEntry.healthcareFacilityTypeCode](http://fhir.ch/ig/ch-term/ValueSet/DocumentEntry.healthcareFacilityTypeCode).

### Security Consideration

This national extension enforces authentication and authorization of access to the _Care Services Selective Supplier_
using the IUA profile as described in [IUA](iti-71.html).

### Examples

The examples of this national extension are based on the following structure of health institutions with their
root and sub-organizations and of health professionals:
<img alt="Structure of the example health institutions and health professionals"
     style="max-width:100%"
     src="assets/images/ehealthsuisse_HPD_Structure.png" />
