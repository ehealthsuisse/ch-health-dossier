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

##### Healthcare Professional

Healthcare Professionals are identified with the Global Location Number (GLN) issued 
by [refdata](https://www.refdata.ch/de/partner/abfrage/partner-refdatabase-gln). 

This impacts the FHIR API in the following way:
- All references to healthcare professionals are made by the GLN.
- The FHIR APIs support of the GLN as a query parameter (e.g. CH:mCSD).
- Resources are profiled that a logical reference with the GLN identifier is provided.

##### Assistant

Assistants which act on behalf of an healthcare professional or an institution, are identified with the 
Global Location Number (GLN) issued by [refdata](https://www.refdata.ch/de/partner/abfrage/partner-refdatabase-gln).

Assistants are identified with their GLN in the provider directory only. The GLN indicates the assistant’s relation 
to the healthcare professional, group, or institution on whose behalf the assistant acts. Assistants are never 
identified by their GLN in document metadata or consent resources, since they inherit the access rights of the 
healthcare professional, group, or institution on whose behalf they act.

##### Administrator

##### Representative

##### Legal Representative

##### Groups and Institutions


<br/>





#### -----------------------------------------------------------------------------------------------------------------


#### Representative ID and administrator GLN
The identity provider only delivers the subject identifier (`sub`) of the identity token. For patients, healthcare
professionals and assistants the IUA Authorization Server resolves it to an identifier which exists independently of
the identity provider (e.g., EPR-SPID, GLN). For representatives, legal representatives and administrators the identifiers
are issued as follows:

- Representative ID: the Health Dossier system SHALL issue a representative ID when a
  [representative](ppqm-consent.html#consent-representative) or a [legal representative](ppqm-consent.html#consent-legal-representative) consent is added. The identity of the
  representative is proven by the patient who appoints the representative, the identity of the legal representative by
  the instruction of the authority. The representative ID is a local identifier of the Health Dossier system with the
  qualifier `urn:e-health-suisse:representative-id`. It identifies the grantee of the consent, a `RelatedPerson` of the
  patient, which represents the relation between the representative and the patient.
- Administrator GLN: an administrator SHALL have a GLN. The administrator is registered with the GLN in the provider
  directory as a member of the community (see [mCSD](iti-mcsd.html#communities-and-military-health-institutions)).

The IUA Authorization Server SHALL keep the link between the issuer `iss` and the subject identifier `sub` of the
identity token and the representative ID or the GLN of the administrator. The link is set at the first login of the
representative or administrator, once the IUA Authorization Server has verified that the person who logs in is the
person the ID was issued for. A login with a further identity provider, or after a change of the identity provider, adds
a link to the same ID; it SHALL NOT issue a new ID.

<div markdown="1" class="stu-note">
To be clarified:
- how the IUA Authorization Server verifies at the first login that the person who logs in is the representative or
  administrator the ID was issued for (e.g. with an activation code handed out when the ID is issued).
- whether a person who represents several patients has one representative ID or one per patient.
- if an identity provider issues pairwise subject identifiers per client, `sub` is not stable across IUA Authorization
  Clients, and the link is needed per client.
</div>

<div markdown="1" class="stu-note">
To be clarified: how the administrators of a community are identified and registered in the directory as its members.
The [CH mCSD Practitioner](StructureDefinition-CH.mCSD.Practitioner.html) requires a GLN and a qualification, which an
administrator may not have. The identity provider only delivers the subject identifier (`sub`) of the identity token;
the IUA Authorization Server resolves it to an administrator ID, which it conveys in the access token with the
qualifier `urn:e-health-suisse:administrator-id` (see [ITI-71](iti-71.html#the-jwt-ch_epr-extension)). Where this
administrator ID comes from, and how it is linked to the `sub` of the identity provider, is not defined yet.
To be clarified: the [CH mCSD Practitioner](StructureDefinition-CH.mCSD.Practitioner.html) requires a qualification,
which an administrator may not have.
</div>