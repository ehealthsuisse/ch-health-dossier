<div markdown="1" class="dragon">
This page is work in progress.
</div>

### Scope

This page describes ...

###### Representative ID and administrator GLN
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
