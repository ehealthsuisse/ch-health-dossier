This section describes the national extension for the Health Dossier to the [Get Access Token [ITI-71]](https://profiles.ihe.net/ITI/IUA/index.html#371-get-access-token-iti-71) client credential 
grant type transaction defined in the IUA profile published in the IHE IT Infrastructure Technical Framework Trial 
Implementation “Internet User Authorization”.

### Scope

The transaction is used by an Authorization Client (e.g. primary system, digital health app or clinical archive system) 
to pass claims to the Authorization Server and to retrieve an access token which authorizes access to protected
resources of the Health Dossier.

Depending on the claims made by the Authorization Client, two different flavors of access tokens SHALL be provided
by the Authorization Server:

- Basic Access Token – IUA compliant access token authorizing access to the EPR endpoints which are NOT protected by
  the EPR role and attribute based authorization (e.g., for queries to the PDQm endpoints).
- Extended Access Token – IUA compliant access token for the EPR endpoints which are protected by the EPR role and
  attribute based authorization (e.g., for the MHD endpoints).

### Actor Roles

**Actor:** Authorization Client  
**Role:** Communicates claims and optional IdP Token to the Authorization Server and receives a JWT access token.      
**Actor:** Authorization Server  
**Role:** Identifies and authenticates the Authorization Client, verifies signatures and claims, authorizes the access 
on behalf of the user and responds with a JWT Access Token to the Authorization Client
to be incorporated into the transactions to access protected resources.

### Referenced Standards

1. [IHE ITI Technical Framework Supplement Internet User Authorization (IUA) Revision 2.5](https://profiles.ihe.net/ITI/IUA/index.html)
2. [SMART Application Launch Framework Implementation Guide Release 2.2.0](http://www.hl7.org/fhir/smart-app-launch/)
3. [OpenID Connect Core 1.0 incorporating errata set 2](https://openid.net/specs/openid-connect-core-1_0.html)


### Messages

This section specifies the national extensions for the client credential grant flow of the IUA Get Access Token 
[ITI-71] transaction.

<div>{% include IUA_ActorDiagram_ITI-71-cc.svg %}</div>
<figcaption ID="10">Figure: Sequence diagram of the transaction.</figcaption>

<br/>

| Step | Action                                                                                                   | Remark                                        | 
|------|----------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| 00   | The Authorization Client sends an Get Access Token Request to the Authorization Server endpoint. | See [Message Semantics](#message-semantics)   | 
| 01   | The Authorization Server responds with the access token in the http body.                            | See [Message Semantics](#message-semantics-1) |
{:class="table table-bordered"}

<figcaption ID="11">Table: Actions in the HTTP sequence of the transaction.</figcaption>

<br/>

#### Get Access Token Request

##### Trigger Events

A clinical archive system aims to access the EPR to write documents, or a user authenticates in a primary 
system or in a digital health app to access data and Documents in the EPR. 

##### Message Semantics

The Authorization Client SHALL send an IUA compliant OAuth 2.1 Token Request for the client credential grant
type with Swiss extensions:
- grant_type (required): The value of the parameter shall be `client_credentials`.
- client_id (required): The ID the Authorization Client is registered at the Authorization Server.
- scope (required): The scope claimed by the Authorization Client, as defined below. Required for requesting
  both basic and extended access tokens.
- resource (required): Single valued identifier of the Resource Server API endpoint to be accessed.
- requested_token_type (optional): If present, the value shall be `urn:ietf:params:oauth:token-type:jwt`.
<br/>

The Token Request SHALL use the following extension defined in the client-confidential-asymmetric authentication profile
of the [FHIR Backend Service](https://hl7.org/fhir/smart-app-launch/backend-services.html#backend-services) specification. 
- client_assertion_type (required): The value shall be `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.
- client_assertion (required): JWT as defined in [SMART App Launch, Client Authentication](https://hl7.org/fhir/smart-app-launch/client-confidential-asymmetric.html#client-authentication-asymmetric-public-key).
<br/>

The Token Request SHALL use the following Swiss extension:
- person_id (optional/required): EPR-SPID identifier of the holders’s record and the assigning authority formatted in CX syntax, required for requesting an extended access token.
- principal (optional/required): The name of the healthcare professional an assistant or a clinical archive system may act on behalf of.
- principal_id (optional/required): The GLN of the healthcare professional an assistant or a clinical archive system may act on behalf of.
- group (optional): The name of the organization or group a healthcare professional or assistant may act on behalf of.
- group_id (optional/required): The OID of the organization or group a healthcare professional or assistant is acting
  on behalf of. Required for an administrator (`ADM`): the OID of the community the administrator acts for.
- id_token (optional/required): Signed JWT associated with the current user's authenticated session at the Identity Provider,
  the [Identity Token](openid-connect.html#identity-token) as specified in [OpenID Connect](openid-connect.html). 
<br/>

Authorization Clients SHALL claim the following scopes for both basic and extended access tokens:

- `purpose_of_use`, in FHIR [token format](https://www.hl7.org/fhir/search.html#token).
  The scope SHALL convey the coded purpose of use of the current transaction. Allowed values are `NORM` (normal access)
  and `EMER` (emergency access) from code system `2.16.756.5.30.1.127.3.10.5`
  (see value set [CH Health Dossier Purpose of Use](ValueSet-HealthDossierPurposeOfUse.html)),
  e.g. `purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM`. A technical user (`TCU`) SHALL use `NORM`.
- `subject_role`, in FHIR [token format](https://www.hl7.org/fhir/search.html#token).
  The scope SHALL convey the coded role of the subject. Allowed values from code system
  [CH Health Dossier Role](CodeSystem-HealthDossierRole.html) (`2.16.756.5.30.1.127.3.10.19`) are:
  `PAT` (patient), `REP` (representative), `LEGREP` (legal representative), `HCP` (healthcare professional),
  `ASS` (assistant), `TCU` (technical user, clinical archive) and `ADM` (administration),
  e.g. `subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|HCP`.

In addition, Authorization Clients SHALL claim additional scopes used by Resource Servers to authorize transactions,
as defined in the [SMART on FHIR specification](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html).

The following tables list the additional scopes per application type.

###### Clinical archive systems

Authorization Clients acting as clinical archive systems SHALL claim the scopes in the following table.

| Scopes                                                               | Transactions | Rights                                                                     |
|----------------------------------------------------------------------|--------------|----------------------------------------------------------------------------|
| user/DocumentReference.c user/Binary.c                               | ITI-65       | Create document references and binaries.                                   |
| user/Patient.rs                                                      | ITI-104      | Search and read the holder's demographics data.                            |
| user/Practitioner.rs user/Organization.rs user/PractitionerRole.rs … | ITI-90       | Search and read data on healthcare professionals, groups and institutions. |
{:class="table table-bordered"}

<figcaption ID="archive-scopes">Table: Supported scopes for clinical archive systems.</figcaption>

###### Primary systems

Authorization Clients acting as primary systems SHALL claim the scopes in the following table.

| Scopes                                                               | Transactions           | Rights                                                                           |
|----------------------------------------------------------------------|------------------------|----------------------------------------------------------------------------------|
| user/DocumentReference.cruds user/Binary.cruds                       | ITI-65, ITI-67, ITI-68 | Create, search, read, update and delete document references and binaries.        |
| user/Patient.rs                                                      | ITI-104                | Search and read the holder's demographics data.                                  |
| user/Practitioner.rs user/Organization.rs user/PractitionerRole.rs … | ITI-90                 | Search and read data on healthcare professionals, groups and institutions.       |
| user/Consent.cruds                                                   | PPQ-3, PPQ-5           | Create, search, read, update and delete consents (delegation of access rights).  |
{:class="table table-bordered"}

<figcaption ID="primary-scopes">Table: Supported scopes for primary systems.</figcaption>

###### Digital health applications (dGA)

Authorization Clients acting as digital health applications (dGA) SHALL claim the scopes in the following table.

| Scopes                                                               | Transactions           | Rights                                                                           |
|----------------------------------------------------------------------|------------------------|----------------------------------------------------------------------------------|
| patient/DocumentReference.cruds patient/Binary.cruds                 | ITI-65, ITI-67, ITI-68 | Create, search, read, update and delete document references and binaries.        |
| patient/Patient.rus                                                  | ITI-104                | Search, read and update (contact data and notes) the holder's demographics data. |
| user/Practitioner.rs user/Organization.rs user/PractitionerRole.rs … | ITI-90                 | Search and read data on healthcare professionals, groups and institutions.       |
| patient/Consent.cruds                                                | PPQ-3, PPQ-5           | Create, search, read, update and delete consents (access rights).                |
| patient/AuditEvent.rs                                                | ITI-81                 | Search and read the audit events specified in [CH ATC](iti-81.html).             |
{:class="table table-bordered"}

<figcaption ID="dga-scopes">Table: Supported scopes for digital health applications.</figcaption>

<br/>
Note: The parameters need to be url encoded, see message examples.


##### Expected Actions

The Authorization Server SHALL validate the claims as described in the following sections. If the validation succeeds, 
the Authorization Server SHALL respond with the Token Response defined below. In case the validation fails, the 
Authorization Server SHALL respond with HTTP 401 Unauthorized or HTTP 403 Forbidden error.

When receiving a Token Request, the Authorization Server SHALL:
1. Verify the client authentication JWT as described in [SMART App Launch Client Authentication]().
2. Verify that the Authorization Client was registered with the client_id during onboarding.
3. Determine the application type the Authorization Client was registered as during Client 
   Registration: clinical archive system, primary system or digital health application (dGA).
4. Verify that a scope claim for `purpose_of_use` and `subject_role` is present and accepted for the application type as required in [Message Semantics](https://iti-71.html#message-semantics).
5. Verify that every additional scope claim is listed for that application type in the tables of the [Message Semantics](iti-71.html#message-semantics) section.
6. Verify that both the resource type and the rights (e.g. .c, .rs, .cruds) of each claimed scope 
   match a table entry for that application type. A scope that is not listed for the application 
   type, or that requests more rights than listed, SHALL NOT be granted.

If the Authorization Client is registered as a digital health application, the Authorization Server SHALL additionally:
1. Verify that a software statement is registered for the client_id (see Client Registration).
2. Issue the access token only for the scopes that are both listed in this specification and granted in the software statement.

If the Authorization Client is registered as a digital health application or primary system, the Authorization Server SHALL additionally:
1. Verify that the Authorization Client is authorized to access on behalf of the user. 
2. Issue the access token only for the scopes authorized by the user (see [Security Considerations](iti-71.html#client-authorization)).

If one of the checks above fails, the IUA Authorization Server SHALL respond with HTTP 403 Forbidden.

###### Holders
When receiving a Token Request with `subject_role` set to `PAT`, the Authorization Server SHALL:
1. Verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. Verify that the `id_token` is signed by the identity provider resolved from `iss`.
3. Verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by
   the Identity Provider. 
4. Read the subject identifier `sub` of the id token and resolve it to the SPID of the holder.

###### Representatives
When receiving a Token Request with `subject_role` set to `REP` or `LEGREP`, the Authorization Server SHALL:
1. Verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. Verify that the `id_token` is signed by the identity provider resolved from `iss`.
3. Verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by
   the Identity Provider. 
4. Read the subject identifier `sub` of the id token and resolve it to the ID of the representative.

###### Healthcare Professionals 
When receiving a Token Request with `subject_role` set to `HCP`, the Authorization Server SHALL: 
1. Verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. Verify that the `id_token` is signed by the identity provider resolved from `iss`.
3. Verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by
   the Identity Provider. 
4. If the `id_token` contains the GLN of the healthcare professional, read the GLN from the `id_token`. 
  Otherwise, read the subject identifier `sub` of the id token and resolve it to the GLN of the healthcare professional. 
5. Verify the healthcare professional is registered with the same GLN in the provider directory. 
6. Query the provider directory and resolve the GLN of the healthcare professional to all groups or institutions 
  including all superior groups or institutions up to the root level.

###### Assistants
When receiving a Token Request with `subject_role` set to `ASS`, the Authorization Server SHALL:
1. Verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. Verify that the `id_token` is signed by the identity provider resolved from `iss`.
3. Verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by
   the Identity Provider. 
4. If the `id_token` contains the GLN of the assistant, read the GLN from the `id_token`.
  Otherwise, read the subject identifier `sub` of the id token and resolve it to the GLN of the assistant. 
5. Verify the assistant is registered with the same GLN in the provider directory. 
6. Verify the assistant is authorized to act on behalf of the healthcare professional declared in the 
  `principal_id` claim. 
7. If a `group_id` claim is present, the Authorization Server SHALL verify that the healthcare 
  professional in the `principal_id` claim is a member of the group or institution claimed in the `group_id` attribute 
  of the request. If true, the Authorization Server SHALL resolve the claimed group or institution to all 
  superior groups and institutions up to the root level. 
8. If no `group_id` claim is present, the authorization server SHALL resolve the GLN of the healthcare 
  professional claimed in the `principal_id` to all groups or institutions the healthcare professional is a member 
  of, including all superior groups or institutions up to the root level.

###### Clinical archive systems
When receiving a Token Request from a clinical archive system with `subject_role` set to `TCU`, the
Authorization Server SHALL:
1. Verify that the system has been registered during onboarding as a clinical archive system with a principal.
2. Verify that the `principal_id` matches the GLN of the legally responsible person registered during onboarding.

###### Administrators 
When receiving a Token Request with `subject_role` set to `ADM`, the Authorization Server SHALL:
1. Verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. Verify that the `id_token` is signed by the identity provider resolved from `iss`.
3. Verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by
   the Identity Provider. 
4. Read the subject identifier `sub` of the id token and resolve it to the ID of the administrator. 
5. Verify the administrator is registered with the same ID in the provider directory. 
6. Verify that the organization claimed in `group_id` is registered in the provider directory as a community (organization
  type `community` of [CH Health Dossier Organization Type](CodeSystem-HealthDossierOrganizationType.html)), and that the
  administrator is registered as its member. 
7. Convey the OID and the name of the community in the claims `subject_organization_id` and `subject_organization` of
  the access token. The actors serving the requests use it to restrict the administrator to the health dossiers managed
  by the community (see [Enforcement of Access Rules](accesscontrol.html#administration-of-the-community)).


The access token SHALL carry the `client_id` claim ([RFC 9068](https://www.rfc-editor.org/rfc/rfc9068)), so that the actors serving the requests 
can identify the application and restrict the requests to the actions of the consent (see [Enforcement of Access Rules](accesscontrol.html#digital-health-applications)).

##### Message Example

A token request of a holder sent from a digital health app may look like:

```
POST /token HTTP/1.1
Host: epr.auth-server.com
Content-Type: application/x-www-form-urlencoded
Content-length:313

grant_type=client_credentials
&client_id=<client_id>
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=<signed JWT>
&resource=https%3A%2F%2FresourceServer.com
&scope=purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|PAT patient/DocumentReference.cruds patient/Binary.cruds
&id_token=<signed identity token>
```

A token request of a healthcare professional for an extended access token may look like:

```
POST /token HTTP/1.1
Host: epr.auth-server.com
Content-Type: application/x-www-form-urlencoded
Content-length:376

grant_type=client_credentials
&client_id=<client_id>
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=<signed JWT>
&resource=https%3A%2F%2FresourceServer.com
&id_token=<signed identity token>
&scope=purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|HCP user/Patient.rs user/DocumentReference.cruds user/Binary.cruds
&person_id=761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO 
```

A token request of a clinical archive system for a basic access token, which is requested without `person_id`, e.g.
to record its audit events with [Record Audit Event [ITI-20]](iti-20.html), may look like:

```
POST /token HTTP/1.1
Host: epr.auth-server.com
Content-Type: application/x-www-form-urlencoded
Content-length:276

grant_type=client_credentials
&client_id=<client_id>
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=<signed JWT>
&resource=https%3A%2F%2FresourceServer.com
&principal=<the-principal-name>
&principal_id=<the-principal-id>
&scope=purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|TCU user/DocumentReference.c patient/Binary.c user/Patient.rs
```

A token request of a clinical archive system for an extended access token may look like:

```
POST /token HTTP/1.1
Host: epr.auth-server.com
Content-Type: application/x-www-form-urlencoded
Content-length:340

grant_type=client_credentials
&client_id=<client_id>
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=<signed JWT>
&resource=https%3A%2F%2FresourceServer.com
&principal=<the-principal-name>
&principal_id=<the-principal-id>
&scope=purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|TCU user/DocumentReference.c user/Binary.c user/Patient.rs
&person_id=761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO
```


#### Get Access Token Response

##### Message Semantics

The response SHALL either convey a Basic Access Token in JWT format which grants basic access to the EPR (i.e., to
access holders demographic data), or an Extended Access Token to access resources protected by the role and attribute based EPR
authorization (i.e., read and write documents).

###### JSON Web Token Option

The Authorization Server and Resource Server SHALL support the IUA JWT extension with claims as defined in
the following table:

| JWT Claim (Extension)   | Optionality (Basic/ Extended) | Remark                                                                                                                                                             |
|-------------------------|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| subject_name            | R/R                           | The username as text.                                                                                                                                              | 
| subject_organization    | O/O                           | The name of the user’s organization or institution as text.                                                                                                        |
| subject_organization_id | O/O                           | The OID of the user’s organization in URN notation. Required for the role `ADM`: the OID of the community.                                                         |
| subject_role            | R/R                           | Array of FHIR Coding with exactly one Coding of the user role from the [CH Health Dossier Role](CodeSystem-HealthDossierRole.html) code system.                    |
| purpose_of_use          | R/R                           | Array of FHIR Coding with exactly one Coding of the purpose of use from the [CH Health Dossier Purpose of Use](ValueSet-HealthDossierPurposeOfUse.html) value set. |
| person_id               | O/R                           | SHALL be the EPR-SPID of the holder's EPR.                                                                                                                         |
{:class="table table-bordered"}

<figcaption id='jwttiua'>Table: Attributes of the IUA Get Access Token response in the ihe_iua extension.</figcaption>  

###### The JWT ch_epr extension

The Authorization Server and Resource Server SHALL support this extension to convey the user's EPR identifier
in the JWT access token of the Get Access Token Response. Its attributes are:

- user_id (required): The EPR subject identifier as defined in the table below.
- user_id_qualifier (required): The subject identifier qualifier as defined in the table below.

<br/>

| user role                       | user_id           | user_id_qualifier                     | 
|---------------------------------|-------------------|---------------------------------------|
| Holder (`PAT`)                  | EPR-SPID          | urn:e-health-suisse:2015:epr-spid     |                                                                      
| Healthcare Professional (`HCP`) | GLN               | urn:gs1:gln                           |                                                                      
| Assistant (`ASS`)               | GLN               | urn:gs1:gln                           |                                                                      
| Representative (`REP`)          | Representative ID | urn:e-health-suisse:representative-id |                                                                      
| Legal Representative (`LEGREP`) | Representative ID | urn:e-health-suisse:representative-id |                                                                      
| Administration (`ADM`)          | GLN               | urn:e-health-suisse:administrator-id  |                                                                     
| Clinical Archive System (`TCU`) | GLN               | urn:gs1:gln                           |
{:class="table table-bordered"}

<figcaption>Table: user id and user id qualifier of EPR users.</figcaption>

<br/>

###### The JWT ch_group extension

Groups are the objects used in the access management of the Health Dossier. Holders and representatives may assign access
rights to groups which typically are sub-organizations of the institutions, but may also cross institution boundaries,
e.g., a tumor board with healthcare professionals from more than one institution.

The Authorization Server and Resource Server SHALL support this extension in the JWT access token for a list of
groups a subject of role healthcare professional is a member of. For users of role assistant, the groups SHALL 
be the groups of the healthcare professional the assistant is acting on behalf of.

Groups SHALL be wrapped in an `extensions` object with key `ch_group` with a JSON array containing one JSON object
per group with the following attributes:

- id (required): The id of the group. Required for users of role healthcare professional and assistant.
  The id SHALL be an OID in the format of a URN.
- name (required): Name of the group. Required for users of role healthcare professional and assistant.
  The name SHALL be a string.

###### The JWT ch_delegation extension

Delegation is used in the access management of the Health Dossier to indicate that a user of role Assistant is acting on
behalf of a healthcare professional. The Authorization Server and Resource Server SHALL support this extension
in the JWT access token to identify the healthcare professional (principal) the assistant is acting on behalf of.

Principals SHALL be wrapped in an `extensions` object with key `ch_delegation` and a JSON value object with attributes:
- principal (optional) Name of the healthcare professional an assistant is acting on behalf of.
- principal_id (optional) GLN of the healthcare professional an assistant is acting on behalf of.

##### Expected Actions

The Authorization Client SHALL use the access token as defined in the [IUA Incorporate Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction, when performing requests to resources of the Health Dossier.

##### Message Example

A basic JWT access token returned by the Authorization Server and to be used to retrieve holder data may look like:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "resource": "http://resourceServer.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "scope": "purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|TCU user/Patient.rs",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Martina Musterarzt",
      "subject_role": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.19",
          "code": "HCP"
        }
      ],
      "purpose_of_use": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.5",
          "code": "NORM"
        }
      ]
    },
    "ch_epr": {
      "user_id": "2000000090092",
      "user_id_qualifier": "urn:gs1:gln"
    }
  }
}
```

An extended JWT access token to be used to access the documents of a holder SHALL have the additional attributes of
the `purpose_of_use`, `subject_role` and the EPR-SPID of the holder. It may look like:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "resource": "http://resourceServer.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "scope": "purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|TCU user/DocumentReference.cruds user/Binary.cruds",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Martina Musterarzt",
      "person_id": "761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO",
      "subject_role": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.19",
          "code": "HCP"
        }
      ],
      "purpose_of_use": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.5",
          "code": "NORM"
        }
      ]
    },
    "ch_epr": {
      "user_id": "2000000090092",
      "user_id_qualifier": "urn:gs1:gln"
    },
    "ch_group": [
      {
        "name": "Name of group with id urn:oid:2.2.2.1",
        "id": "urn:oid:2.2.2.1"
      },
      {
        "name": "Name of group with id urn:oid:2.2.2.2",
        "id": "urn:oid:2.2.2.2"
      },
      {
        "name": "Name of group with id urn:oid:2.2.2.2",
        "id": "urn:oid:2.2.2.3"
      }
    ]
  }
}
```

An extended JWT access token to be used to access the documents of a holder by an assistant acting on behalf of a healthcare professional for a
holder SHALL have the additional extension `ch_delegation`:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "resource": "http://resourceServer.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "scope": "purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|TCU user/DocumentReference.cruds user/Binary.cruds",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Dagmar Musterassistent",
      "person_id": "761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO",
      "subject_role": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.19",
          "code": "ASS"
        }
      ],
      "purpose_of_use": [
        {
          "system": "urn:oid:2.16.756.5.30.1.127.3.10.5",
          "code": "NORM"
        }
      ]
    },
    "ch_epr": {
      "user_id": "2000000090108",
      "user_id_qualifier": "urn:gs1:gln"
    },
    "ch_group": [
      {
        "name": "Name of group with id urn:oid:2.2.2.1",
        "id": "urn:oid:2.2.2.1"
      },
      {
        "name": "Name of group with id urn:oid:2.2.2.2",
        "id": "urn:oid:2.2.2.2"
      },
      {
        "name": "Name of group with id urn:oid:2.2.2.2",
        "id": "urn:oid:2.2.2.3"
      }
    ],
    "ch_delegation": {
      "principal": "Martina Musterarzt",
      "principal_id": "2000000090092"
    }
  }
}
```

#### CapabilityStatement Resource

There are no CapabilityStatement resources defined for this transaction.

### Security Consideration

If a transaction contains the EPR-SPID both in the IUA access token and in the transaction body, the IUA Resource
Server SHALL verify that both values are identical. The Resource Server SHALL reject the request if the values differ.

The actors SHALL support the `traceparent` header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### JWT Signature

Authorization Clients, Authorization Servers, and Resource Servers SHALL support the JSON Web Signature (JWS)
serialization of the JWT access token, as specified in
[IHE ITI Technical Framework Supplement Internet User Authorization (IUA) Revision 2.5](https://profiles.ihe.net/ITI/IUA/index.html)

To ensure the integrity and authenticity of the access token:
1. The Authorization Server SHALL sign the JWT with its private key.
2. The Resource Server SHALL verify the signature using the public key of the Authorization Server that issued the token.

Unsigned JWT access tokens SHALL NOT be used. The JSON Web Encryption (JWE) serialization SHALL NOT be used. Since
Revision 2.5 IUA no longer requires the JWT access token to be signed; the signature remains required for the Health Dossier.

Resource Servers SHALL reject any request whose access token signature validation fails.

#### Client Authentication

To authenticate Access Token requests, the Authorization Client SHALL include a client assertion in the form
of a signed JSON Web Token (JWT) in each request to the token endpoint, as defined in
[SMART App Launch Client Authentication: Asymmetric](https://hl7.org/fhir/smart-app-launch/client-confidential-asymmetric.html#authenticating-to-the-token-endpoint

The Authorization Server SHALL validate the client assertion by:
1. Verifying the signature against a public key registered for the client, and
2. Verifying the claims as required by the referenced SMART App Launch specification (e.g., iss, sub, aud, exp, and jti).

The Authorization Server SHALL reject the Access Token request if validation fails.

#### Client Authorization

The Authorization Server SHALL provide a user interface that allows a user to authorize an instance of their 
primary system or digital health application (dGA) to access the health dossier on the user’s behalf.

The Authorization Server SHALL provide an HTTP endpoint that accepts a `client_id` as a request parameter. 
An Authorization Client MAY redirect the user to this endpoint to start the User Authorization.

When receiving a request, tha Authorization Server SHALL:
1. Require the user to authenticate at one of the identity providers accepted for the health dossier.
2. Resolve the application type (primary system or digital health application) from the client_id of the 
Authorization Client, as registered during Client Registration.
3. Present to the user the application type and the scopes the application may be granted. The presented scopes 
SHALL be limited to the scopes that are listed for the application type in the tables of the Message Semantics section. 
For digital health applications, the presented scopes SHALL additionally be limited to the scopes granted in the 
digital health application software statement registered for the client_id.
4. Allow the user to confirm or decline the authorization.
5. Store the authorization decision of the user (the user, the client_id and the authorized scopes) as a user-specific setting.

When responding to a Token Request from a primary system or digital health application, the IUA Authorization Server 
SHALL verify that a stored authorization of the user exists for the `client_id`, and SHALL issue the access token 
only for authorized scopes as specified in [Message Semantics](iti-71.html#expected-actions))

#### Security Audit Considerations

There is no audit event required for this transaction.