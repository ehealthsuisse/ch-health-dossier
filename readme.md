# CH Health Dossier

FHIR API to connect to the CH Health Dossier.

### Structure Definitions

To support **conformance** to the IHE profiles, the following validation mechanisms are added in this implementation guide:
* The CH Health Dossier profiles check the conformity to the corresponding IHE profile using constraints if it cannot be derived (`conformsTo`)
* The examples are validated against both profiles (CH Health Dossier & IHE) (listed in `meta.profile`)
