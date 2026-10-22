<div markdown="1" class="dragon">
This page is work in progress.
</div>

### Scope

Access to data in the health dossier requires that the requesting user is identified.

The actors participating in the health dossier MAY use different identifiers to represent the identity of a user. E.g. 
an identity provider assigns an identifier to the user after identity proofing, while the logical reference to patients 
in clinical documents uses a sectoral identifier issued by the Central Compensation Office CCO. These identifiers MUST be 
linked to one another so that a user is uniquely and consistently identified across all actors.

This section specifies:
- the identifiers used by each actor;
- the relationship between each identifier and the user role (e.g., holder, healthcare professional);
- the rules by which identifiers are linked or matched to each other.


#### Identifier issued by Identity Provider

Identity provider issue an identifier after identification of the user as part of the enrollment. This identifier is 
used by the identity provider to internally identify the user, but is never presented to clients and therefore out of 
scope. 

In the health dossier we require the identity provider to present an identifier to client applications after 
authentication in the identity token. To support single sign an cross application identification, the identifier 
presented to the client applications SHALL be persistent (see [OpenID Connect](openid-connect.html)). 










#### -----------------------------------------------------------------------------------------------------------------

#### Holder Identifier

Each patient has one active national identifier (EPR-SPID) which shall be used to identify the patient in transactions.
This impacts the FHIR API in the following way:

#### logical reference for patients and health care professionals, contained resources

- No addressable patient resources: All references to patients are made by the identifier EPR-SPID since there is no
  national master patient which could be referenced. This is the reason that IHE PIXm and PDQm with the $match
  transaction have been selected and not IHE MHDS/PMIR. Systems may store the EPR-SPID.
  Therefore, FHIR APIs require the support of the patient logical identifier as a query parameter (e.g. MHD, CH:PPQm)
  and the resources are profiled that a logical reference with the EPR-SPID identifier have to be provided.
- The same principle applies for health care professionals, they are identified by the GLN number and references to
  them need to include also the logical reference from other resources (e.g. DocumentReference).
- Information which has to be provided and has no own identity in the Health Dossier (e.g., as author and organization name in
  document publishing) are represented as contained resources.


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
To be clarified: the identity provider only delivers the subject identifier (`sub`) of the identity token, never the
`user_id_qualifier`, which the IUA Authorization Server sets according to the role. For patients and healthcare
professionals the Authorization Server resolves `sub` to an identifier which exists independently (EPR-SPID, GLN). For
representatives, legal representatives and the administration no such identifier is defined: where the representative
ID and the administrator ID come from, and how they are linked to the `sub` of the identity provider, is open. If an
identity provider issues pairwise subject identifiers per client, `sub` is not stable across IUA Authorization Clients.
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