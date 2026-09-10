### DSTU1 Release 2026-08-xx

#### Resolved Issues
* IUA
  * Refactored the specification to use the IUA client credential flow for portals, primary systems and digital health apps and convey 
    the Identity Token in in the *id_token* field of the token request. 
  * Add support for client-asymmetric authentication specified in FHIR Backend Service authentication section and is used in the European Health Data Space and UMZH Connect.  
  * Removed the SMART on FHIR standalone and EHR launch option. 
  * Removed the specification of the TCU option, since TCU requests are now a usual requests without a identity token of the user. 
* PDQm
  * Defined mapping for eCH-0215 / 213 (https://github.com/ehealthsuisse/ch-health-dossier/issues/7)
  * Added support for identifying a patient by the minimal demographics and the AHVN13 in ITI-119 to retrieve the EPR-SPID (https://github.com/ehealthsuisse/ch-health-dossier/issues/2)
* PIXm
    * Removed ITI-83 Query (no local-id cross-referencing) 
    * Restricted ITI-104 Feed to allow only update of contact information (revise message), requires extended access token
* MHD Removing Federated Option, Proxy Option and homeCommunityId 
* Fork from [CH EPR FHIR](https://fhir.ch/ig/ch-epr-fhir/5.0.0/), rename to CH Health Dossier