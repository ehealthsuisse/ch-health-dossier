### DSTU1 Release 2026-08-xx

#### Resolved Issues
* PDQm
  * Defined mapping for eCH-0215 / 213 (https://github.com/ehealthsuisse/ch-health-dossier/issues/7)
  * Added support for identifying a patient by the minimal demographics and the AHVN13 in ITI-119 to retrieve the EPR-SPID (https://github.com/ehealthsuisse/ch-health-dossier/issues/2)
* PIXm
    * Removed ITI-83 Query (no local-id cross-referencing) 
    * Restricted ITI-104 Feed to allow only update of contact information (revise message), requires extended access token
* MHD 
  * Removing Federated Option, Proxy Option and homeCommunityId 
  * Require Minimal Data based on Health Dossier Metadata Option
  * Replaced the CH:ADR Authorization Decision Consumer grouping in ITI-65,  ITI-67, ITI-68, CH:MHD-1 and ITI-81 with the
    new [Appendix: Enforcement of Access Rules](accesscontrol.html), covering the access rules of the patient and of the
    requesting health professional or health institution
* Fork from [CH EPR FHIR](https://fhir.ch/ig/ch-epr-fhir/5.0.0/), rename to CH Health Dossier