<div markdown="1" class="dragon">
This page is work in progress.
</div>

### Scope

Access to data in the health dossier requires that the requesting user is identified.

The actors participating in the health dossier may use different identifiers to represent the identity of a user. E.g. 
an identity provider assigns an identifier to the user after identity proofing, while the reference to holders 
in clinical documents uses a sectoral identifier issued by the Central Compensation Office (CCO). These identifiers must 
be linked to one another so that a user is uniquely and consistently identified across all actors.

This section specifies:
- the identifiers used by each actor;
- the relationship between each identifier and the user role (e.g., holder, healthcare professional);
- the rules by which identifiers are linked or matched to each other.


#### Subject Identifier issued by Identity Provider

The identity provider issues an identifier to the user after identification as part of enrollment. The identity provider 
uses this identifier internally to identify the user. It is never presented to clients and is therefore out of scope 
of this specification.

The health dossier requires the identity provider to present an identifier to client applications after authentication. 
To support single sign-on and cross-application identification, this identifier SHALL be persistent 
(see [OpenID Connect](openid-connect.html)).

The identity provider SHALL convey the persistent identifier as the Subject Identifier in the `sub` claim of the 
`id_token`, together with the user’s demographic data and any optional additional identifiers 
(see [OpenID Connect](openid-connect.html#identity-token)).

To identify the user in the health dossier, the Subject Identifier issued by the identity provider MUST be converted 
to the identifier used in the health dossier. For this purpose, a client that accesses data in the health dossier 
shall present the `id_token` with the [Get Access Token](iti-71.html#message-semantics) request. 

#### Identifier mapping

When receiving a Get Access Token request, the Authorization Server shall resolve the Subject Identifier issued by the 
Identity Provider to a role dependent identifier used in the health dossier as described in 
[Get Access Token](iti-71.html#expected-actions).

Depending on the users' role, the IUA Authorization Server queries one of the databases for the mapping from
the Subject Identifier and the identifier used in the health dossier. For instance, the database used for holder 
and representatives may be the Master Patient Index, or the Provider Directory for health professionals, assistants 
and community administrators. The details of the implementation are left to the vendor of the health information system 
and are therefore out of scope of this specification.

The IUA Authorization Server responds the health dossier identifier in the access token of the Get Access Token 
response as described in [Get Access Token](iti-71.html#the-jwt-ch_epr-extension).

Since clients must present the access token with every access to the services of the health dossier, the services 
know the identity of the user for all requests and use it to enforce access rights. For example, the health dossier 
identifier is used in the consent resources, which define the access rights of the 
user (see [PPM Consent](ppqm-consent.html)).

#### Health Dossier Identifier and Issuer

The following table lists the identifiers used in the health dossier and their issuers: 

| user role               | health dossier identifier | issuer                            |
|-------------------------|---------------------------|-----------------------------------|
| Holder                  | EPR-SPID                  | Central Compensation Office (CCO) |
| Healthcare Professional | GLN                       | refdata                           |
| Assistant               | GLN                       | refdata                           |
| Administrator           | GLN                       | refdata                           |
| Representative          | Representative ID         | health dossier information system |
| Legal Representative    | Representative ID         | health dossier information system |
{:class="table table-bordered"}

<figcaption>Table: User role, health dossier identifier and issuer.</figcaption>

##### Holder

Holder are identified with the active national identifier (EPR-SPID) issued by the Central Compensation Office (CCO). 
This identifier shall be used to identify the patient in all transactions, the document metadata and the consent resources. 

This impacts the FHIR API in the following way:
- All references to patients are made by the identifier EPR-SPID. 
- The FHIR APIs support of the patient logical identifier as a query parameter (e.g. MHD, CH:PPQm). 
- Resources are profiled that a logical reference with the EPR-SPID identifier is provided.

##### Healthcare Professionals

Healthcare Professionals are identified with a Global Location Number (GLN) issued by [refdata](https://www.refdata.ch/de/partner/abfrage/partner-refdatabase-gln). 

This impacts the FHIR API in the following way:
- All references to healthcare professionals are made by the GLN.
- The FHIR APIs support of the GLN as a query parameter (e.g. CH:mCSD).
- Resources are profiled that a logical reference with the GLN identifier is provided.

##### Assistants

Assistants which act on behalf of an healthcare professional or an institution, are identified with a  
Global Location Number (GLN) issued by [refdata](https://www.refdata.ch/de/partner/abfrage/partner-refdatabase-gln).

Assistants are identified with their GLN in the provider directory only. The GLN indicates the assistant’s relation 
to the healthcare professional, group, or institution on whose behalf the assistant acts. Assistants are never 
identified by their GLN in document metadata or consent resources, since they inherit the access rights of the 
healthcare professional, group, or institution on whose behalf they act.

##### Administrators

The Administrator role applies to all employees of the community and may perform tasks on behalf of holder, 
healthcare professionals and institutions (see [PPQm Consent](ppqm-consent.html#consent-community-mandate)). 
Administrators are identified with their Global Location Number (GLN) issued by [refdata](https://www.refdata.ch/de/partner/abfrage/partner-refdatabase-gln).

This impacts the FHIR API in the following way:
- All references to administrators are made by the GLN.
- The FHIR APIs support of the GLN as a query parameter (e.g. CH:mCSD).
- Resources are profiled that a logical reference with the GLN identifier is provided.

##### Representatives

Holders may appoint representatives who may access the health dossier on their behalf. Holders may restrict the 
access rights of representatives to certain transactions (see [PPQm Consent](ppqm-consent.html#consent-representative)).
Representatives may be private persons, who may themselves be holders of a health dossier, as well as healthcare 
professionals or assistants. Representatives are identified by an identifier issued by the health dossier 
information system.

This impacts the FHIR API in the following way:
- All references to representatives are made by the representative id issued by the health dossier information system.
- The FHIR APIs support of the representative id as a query parameter.
- Resources are profiled that a logical reference with the representative id is provided.

##### Legal Representative

The cantons may appoint representatives who may access the health dossier on behalf of the holder. Legal 
representatives are identified by an identifier issued by the health dossier information system.

The impact on the FHIR API is the same as for representatives.  

##### Groups and Institutions

