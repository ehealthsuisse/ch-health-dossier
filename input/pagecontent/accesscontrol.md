### Enforcement of Access Rules

Access to a health dossier is granted by the holder of the dossier. Holders define the access rights for their
health dossier, and may authorize health professionals, health institutions and connected digital health
applications, exclude access in medical emergencies, and appoint a representative acting on their behalf.

Health professionals and health institutions may view data of a health dossier only in the context of a treatment 
and only where the holder has granted them the corresponding right. Where the holder gave consent 
outside the Health Dossier system, the health professional or health institution SHALL confirm the receipt of that consent 
in the health dossier. In medical emergencies, health professionals and health institutions may access the health dossier 
without a granted right, unless the holder has excluded emergency access.

Health professionals and health institutions record treatment relevant data in the health dossier, unless the holder
has declared that the data of a specific treatment shall not be recorded.

Every actor serving a request of the Health Dossier API SHALL evaluate and enforce these rules individually for each
request, before any data is created, updated, returned or otherwise disclosed. The decision SHALL take into account:

- the authenticated identity, the role, the organization and the purpose of use of the requester, as conveyed in the
  access token (see [Get Access Token [ITI-71]](iti-71.html));
- for health professionals and health institutions, their entry in the directory of health professionals and health
  institutions (see [Find Matching Care Services [ITI-90]](iti-90.html)) and the treatment context they assert;
- the access rights in effect for the patient concerned, including those defined by a representative;
- the confidentiality level of the data concerned.

A request that is not permitted SHALL be rejected. Data the requester is not authorized to see SHALL NOT be included
in a response.

How the decision is reached, computed by the serving actor itself or obtained from a separate authorization decision
service, is out of scope of this specification.
