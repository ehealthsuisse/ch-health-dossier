This section describes the national extension for the Swiss EPR to the [Get Access Token [ITI-71]](https://profiles.ihe.net/ITI/IUA/index.html#371-get-access-token-iti-71) transaction
defined in the IUA profile published in the IHE IT Infrastructure Technical Framework Trial Implementation “Internet
User Authorization”.

### Scope

The transaction is used by an IUA Authorization Client (e.g., portal, primary system or "Digitale Gesundheitsanwendung
(dGA)") to pass claims to the IUA Authorization Server and to retrieve an access token which authorizes access to protected
resources of the Swiss EPR.

Depending on the claims made by the IUA Authorization Client, two different flavors of access tokens SHALL be provided
by the IUA Authorization Server:

- Basic Access Token – IUA compliant access token authorizing access to the EPR end-points which are NOT protected by
  the EPR role and attribute based authorization (e.g., for queries to the PIXm endpoints).
- Extended Access Token – IUA compliant access token for the EPR endpoints which are protected by the EPR role and
  attribute based authorization (e.g., for the MHD endpoints).

### Actor Roles

**Actor:** IUA Authorization Client  
**Role:** Communicates claims and optional IdP Token to the IUA Authorization Server and receives JWT access
token.      
**Actor:** IUA Authorization Server  
**Role:** Identifies and authenticates the IUA Authorization Client, verifies signatures and claims, authorizes the access 
on behalf of the user and responds a JWT Access Token to the IUA Authorization Client
to be incorporated into the transactions to access protected resources.

### Referenced Standards

1. [IHE ITI Technical Framework Supplement Internet User Authorization (IUA) Revision 2.3](https://profiles.ihe.net/ITI/IUA/index.html)
2. [SMART Application Launch Framework Implementation Guide Release 2.2.0](http://www.hl7.org/fhir/smart-app-launch/)

### Messages

#### Client Credential Grant Type

This section specifies the client credential grant flow of the IUA Get Access Token transaction.

<div>{% include IUA_ActorDiagram_ITI-71-cc.svg %}</div>
<figcaption ID="10">Figure: Sequence diagram of the transaction.</figcaption>
<br/>

| Step | Action                                                                                                   | Remark                                                  | 
|------|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| 00   | The IUA Authorization Client sends an Get Access Token Request to the IUA Authorization Server endpoint. | See [MessageSemantics](#client-credential-grant-type-1) | 
| 01   | The IUA Authorization Server responds with the access token in the HTML body element.                    | See [Message Semantics](#message-semantics-2)           |
{:class="table table-bordered"}

<figcaption ID="11">Table: Actions in the HTTP sequence of the transaction.</figcaption>

<!-- Done: removed Authorization Code Grant Type -->

#### Get Access Token Request

##### Client Credential Grant Type

###### Trigger Events

A clinical archive system aims to access the EPR to write documents, or a user authenticates in the portal, primary 
system or in a "Digitale Gesundheitsanwendung (dGA)" to access data and Documents in the EPR. 

###### Message Semantics

<!-- DONE: removed client_secret, since client_id and client_secret is in the http auth header, the secret is not in the request --> 

The IUA Authorization Client SHALL send an IUA compliant OAuth 2.1 Token Request for the client credential grant
type with Swiss extensions:
- grant_type (required): The value of the parameter shall be `client_credentials`.
- client_id (required): The ID the IUA Authorization Client is registered at the IUA Authorization Server.
- scope (required): The scope claimed by the IUA Authorization Client, as defined in the table below.
- resource (optional): Single valued identifier of the IUA Resource Server API endpoint to be accessed.
- requested_token_type (optional): If present, the value shall be `urn:ietf:params:oauth:token-type:jwt`.

The Token Request SHALL use the following extension defined in the client-confidential-asymmetric authentication profile
of the [FHIR Backend Service](https://hl7.org/fhir/smart-app-launch/backend-services.html#backend-services) specification. 
- client_assertion_type (required): The value shall be `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.
- client_assertion (required): JWT as defined in [SMART App Launch, Client Authentication: Asymmetric](https://hl7.org/fhir/smart-app-launch/client-confidential-asymmetric.html#client-authentication-asymmetric-public-key). 

<!-- DONE: added id_token field --> 
The Token Request SHALL use the following Swiss extension:
- person_id (optional/required): EPR-SPID identifier of the patient’s record and the patient assigning authority
  formatted in CX syntax, required for requesting extended access token.
- principal (optional/required): The name of the healthcare professional an assistant or a clinical archive system may act on behalf of.
- principal_id (optional/required): The GLN of the healthcare professional an assistant or a clinical archive system may act on behalf of.
- group (optional): The name of the organization or group a healthcare professional or assistant may act on behalf of.
- group_id (optional): The OID of the organization or group a healthcare professional or assistant is acting on behalf of.
- id_token (optional/required): Signed JWT associated with the current user's authenticated session at the Identity Provider.

IUA Authorization Clients SHALL sent the following scope values in the Token Request:

| Scope          | Optionality (Basic/ Extended) | Type                                | Reference           | Remark                                                                                                                                                        |
|----------------|-------------------------------|-------------------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| purpose_of_use | R/R                           | token <sup><a href="#3">3</a></sup> | See sections below. | Value taken from code system 2.16.756.5.30.1.127.3.10.5 of the CH: EPR value set in [FHIR token type](https://www.hl7.org/fhir/search.html#token) format.     |
| subject_role   | R/R                           | token                               | See sections below. | Value taken from code system 2.16.756.5.30.1.127.3.10.1.1.3 of the CH: EPR value set in [FHIR token type](https://www.hl7.org/fhir/search.html#token) format. |
{:class="table table-bordered"}

<sup id="3">3</sup>Token format according FHIR [token type](https://www.hl7.org/fhir/search.html#token).

<figcaption ID="6">Table: Authorization Request’s scope parameter for the client credential flow..</figcaption>

<br/>

<!-- TODO: purpose of use shall be AUTO as defined in the code system 2.16.756.5.30.1.127.3.10.5 of the CH:EPR value set. -->
<!-- TODO: subject role shall be TCU as defined in the code system 2.16.756.5.30.1.127.3.10.1.1.3 of the CH:EPR value set.. -->

The scope parameter of the request MAY claim the following attributes:

- There SHALL be a scope with name `purpose_of_use` in token format. If present, the token SHALL convey the coded value
  of the current transaction’s purpose of use. Allowed values are `NORM` (normal access) and `EMER` (emergency access) from
  code system `2.16.756.5.30.1.127.3.10.5` of the CH:EPR value set (e.g.: `purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5\|NORM`).
- There SHALL be a scope with name `subject_role` in token format. If present, the token SHALL convey the coded value of
  the subject’s role. The value SHALL be either `HCP` (healthcare professional), `ASS` (assistant), `REP` (representative)
  or `PAT` (patient) from code system `2.16.756.5.30.1.127.3.10.6` of the CH:EPR value set (e.g.: `subject_role=urn:oid:
  2.16.756.5.30.1.127.3.10.6\|HCP`).
- IUA Authorization Clients may claim other scopes as defined in the SMART on FHIR specification.

Note: The parameters need to be url encoded, see message examples.

###### Expected Actions

When receiving a Token Request with purpose_of_use set to AUTO and subject_role set to TCU, the Authorization
Server SHALL:

<!-- TODO: No registration with client secret-->
- verify the http message signature.
- identify the IUA Authorization Client with the `client_id`.
- verify, that the IUA Authorization Client was registered during onboarding with the same `client_id` and `client_secret`.
- verify that the `principal_id` matches the GLN of the legal responsible healthcare professional the IUA Authorization
  Client was registered during onboarding.

<!-- Done: copied from auth code flow -->

When retrieving the Token Request, the IUA Authorization Server SHALL verify that the user is authenticated compliant to
the regulations of the Swiss EPR by validating the identity token. 

The IUA Authorization Server SHALL respond with the Token Response only if all checks are successful. If one
of the above checks fails, the IUA Authorization Server SHALL respond with HTTP 401 (Unauthorized) error.

If the person_id is set in the request, the IUA Authorization Server SHALL respond with an Extended Access Token.
The IUA Authorization Server SHALL respond with a Basic Access Token, if the `person_id` is not set.

The IUA Authorization Client SHALL use the access token as defined in the [IUA Incorporate Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction, when performing requests to resources of the Swiss EPR.

The IUA Authorization Client SHALL use the IUA Access Token as defined in [IUA Incorporate Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72)
transaction, when performing requests to resources of the Swiss EPR.


#### Get Access Token Response

##### Message Semantics

The response SHALL either convey a Basic Access Token in JWT format which grants basic access to the EPR (i.e., to
access patient data), or an Extended Access Token to access resources protected by the role and attribute based EPR
authorization (i.e., read and write documents).

###### JSON Web Token Option

The IUA Authorization Server and IUA Resource Server SHALL support the IUA JWT extension with claims as defined in
the following Table.

| JWT Claim (Extension)   | Optionality (Basic/ Extended)   | Remark                                                                    |
|-------------------------|---------------------------------|---------------------------------------------------------------------------|
| subject_name            | R/R                             | The username as text.                                                     | 
| subject_organization    | O/O                             | The name of the user’s organization or institution as text.               |
| subject_organization_id | O/O                             | The OID of the user’s organization in URN notation.                       |
| subject_role            | O/R                             | Code indicating the user role from the EPR Role Code Value Set.           |
| purpose_of_use          | O/R                             | Code indicating the purpose of use from the EPR Purpose Of Use Value Set. |
| person_id               | O/R                             | SHALL be the EPR-SPID of the patients EPR.                                |
{:class="table table-bordered"}

<figcaption id='jwttiua'>Table: Attributes of the IUA Get Access Token response in the JWT extension ihe_iua.</figcaption>  

###### The JWT ch_epr extension

The IUA Authorization Server and IUA Resource Server SHALL support this extension to convey the user's EPR identifier
in the JWT access token of the Get Access Token Response. Its attributes are:

- user_id (required): The EPR subject identifier as defined in the table below.
- user_id_qualifier (required): The subject identifier qualifier as defined in the table below.

||

| user role               | user_id  | user_id_qualifier                             |
|-------------------------|----------|-----------------------------------------------|
| Patient                 | EPR-SPID | urn:e-health-suisse:2015:epr-spid             |        
| Healthcare Professional | GLN      | urn:gs1:gln                                   |        
| Assistent               | GLN      | urn:gs1:gln                                   |        
| Representative          | IdP-ID   | urn:e-health-suisse:representative-id         |        
| Document Administrator  | IdP-ID   | urn:e-health-suisse:policy-administrator-id   |        
| Policy Administrator    | IdP-ID   | urn:e-health-suisse:document-administrator-id |        
{:class="table table-bordered"}

<figcaption>Table: user_id and user_id_qualifier of EPR user.</figcaption>

||

###### The JWT ch_group extension

Groups are the objects used in the access management of the Swiss EPR. Patients and representatives may assign access
rights to groups which typically are sub-organizations of the institutions, but may also cross institution boundaries,
e.g., a tumorboard with healthcare professionals from more than one institution.

The IUA Authorization Server and IUA Resource Server SHALL support this extension in the JWT access token for a list of
groups
a subject of role healthcare professional is a member of. For users of role assistant, the groups SHALL be the groups of
the healthcare professional the assistant is acting on behalf of.

Groups SHALL be wrapped in an `extensions` object with key `ch_group` with a JSON array containing one JSON object
per group with the following attributes:

- id (required): The id of the group. Required for users of role healthcare professional and assistant.
  The id SHALL be an OID in the format of a URN.
- name (required): Name of the group. Required for users of role healthcare professional and assistant.
  The name SHALL be a string.

###### The JWT ch_delegation extension

Delegation is used in the access management of the Swiss EPR to indicate that a user of role Assistant is acting on
behalf of a healthcare professional. The IUA Authorization Server and IUA Resource Server SHALL support this extension
in the JWT access token to identify the healthcare professional (principal) the assistant is acting on behalf of.

Principals SHALL be wrapped in an `extensions` object with key `ch_delegation` and a JSON value
object with attributes:

- principal (optional) Name of the healthcare professional an assistant is acting on behalf of.
- principal_id (optional) GLN of the healthcare professional an assistant is acting on behalf of.

##### Expected Actions

<!-- TODO: copy the business rules from Annex 5 Addendum 1, section 1.6.4.2.4.4 Expected Actions X-Assertion -->
The business rules for the IUA Authorization Server for healthcare professionals, assistants, patient and
representative extension SHALL be the same as for Annex 5 Addendum 1, section 1.6.4.2.4.4 Expected Actions X-Assertion
Provider Extensions.

##### Message Example

A basic JWT access token returned by the IUA Authorization Server and to be used to retrieve patient data may look like:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "aud": "http://pixmResourceServerURL.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Martina Musterarzt"
    },
    "ch_epr": {
      "user_id": "2000000090092",
      "user_id_qualifier": "urn:gs1:gln"
    }
  }
}
```

An extended JWT access token to be used to access patient documents SHALL have the additional attributes of
the `purpose_of_use`, `subject_role` and the EPR-SPID of the patient. It may look like:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "aud": "http://mhdResourceServerURL.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Martina Musterarzt",
      "person_id": "761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO",
      "subject_role": {
        "system": "urn:oid:2.16.756.5.30.1.127.3.10.6",
        "code": "HCP"
      },
      "purpose_of_use": {
        "system": "urn:uuid:2.16.756.5.30.1.127.3.10.5",
        "code": "NORM"
      }
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

An extended JWT access token to be used to access by an assistant acting behalf of a healthcare professional for a
patient SHALL have the additional extension `ch_delegation`:

```json
{
  "iss": "http://issuerAdress.ch",
  "sub": "UserId-bfe8a208-b9d0-4012-b2f5-168b949fc3cb",
  "aud": "http://mhdResourceServerURL.ch",
  "exp": 1587294580,
  "nbf": 1587294460,
  "iat": 1587294460,
  "jti": "c5436729-3f26-4dbf-abd3-2790dc7771a",
  "extensions": {
    "ihe_iua": {
      "subject_name": "Dagmar Musterassistent",
      "person_id": "761337610411353650^^^&2.16.756.5.30.1.127.3.10.3&ISO",
      "subject_role": {
        "system": "urn:oid:2.16.756.5.30.1.127.3.10.6",
        "code": "HCP"
      },
      "purpose_of_use": {
        "system": "urn:uuid:2.16.756.5.30.1.127.3.10.5",
        "code": "NORM"
      }
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

IUA Authorization Clients, IUA Authorization Servers and IUA Resource Server actors SHALL support the JWS (signed)
alternative of the JWT token as specified in the IUA Trial Implementation. To ensure the authenticity and integrity,
the IUA Authorization Server SHALL sign the JWT token with its private key and IUA Resource Servers SHALL verify
the signature of the JWT token with the Authorization Server's public key. The JWE alternative SHALL not be used.

To ensure the authenticity and integrity of the token requests, IUA Authorization Clients SHALL sign requests to the
token endpoint of the IUA Authorization Server with the clients' private key as defined in
`RFC 9421 HTTP Message Signatures`. The signature SHALL cover the entire request content. The IUA Authorization Server 
SHALL verify the requests signature with the clients public key exchanged during the client registration process.

The requests signature SHALL cover the following components of the http message as defined in
`RFC 9421 HTTP Message Signatures`:

- method (required): The http protocol name the value of it SHALL be `POST`.
- target-uri (required): The URI of the IUA Authorization server.
- authorization (required): The value of the Authorization http header.
- content-digest (required): The digest of the http message as defined in `RFC 9530 Digest Fields`.
- created (required): Creation time as a UNIX timestamp value of type Integer.
- expires (required): Expiration time as a UNIX timestamp value of type Integer which SHALL be at max 60 seconds after
  the creation time.
- keyid (optional): The identifier for the key material as a String value.
- tag (optional): An application-specific tag for the signature as a String value which MAY be used to transfer
  additional information.

Token requests SHALL use a http header with name `Signature-Input` the value of it SHALL be one or more metadata
sets with a key uniquely identifying the message signatures within the HTTP message as defined in
`RFC 9421 HTTP Message Signatures`.
There SHALL be at least one signature metadata set created by the IUA Authorization Client, e.g.:

```
Signature-Input: sig1=("@method" "@target-uri" "authorization" "content-digest");created=1764073861;expires=1764073921;keyid="snIZq-_NvzkKV-IdiM348BCz_RKdwmufnrPubsKKyio";tag="fapi-2-request"
```

Token requests SHALL use a http header with name `Signature` the value of it SHALL be one or more message signatures
generated from the signature context of the target message with a key which uniquely identify the message signature
as defined in RFC 9421 `HTTP Message Signatures`. There SHALL be at least one signature created by the
IUA Authorization Client, e.g.:

```
Signature: sig1=:9FaAZovdKmr9LVmwnzyfRED1ws1dX1mZLIgIPTOyBTNi0HkNoLxVipp8ZyGGx6+XP+7WVRh1wNQk9xjunHhZOw==:
```

Token requests SHALL use a http header with name `Content-Digest` the value of it SHALL be the content digest of the
request message with a key indicating the algorithm used as defined in `RFC 9530 Digest Fields`, e.g.:

```
Content-Digest: sha-512=:Lh6fzO9XALiY46o5xVyN9yZloKZ6pLJV0kz+VirU5b6rQd2ii7vrTt4gxe32HRuLtNYG2Kl7CnGwQjjDxQk4yA===:
```

IUA Authorization Server SHALL verify the signature of the token requests as specified in
`RFC 9421 HTTP Message Signatures`.

IUA Authorization Servers SHALL NOT implement any algorithm using a shared key (for example _HMAC_), and they SHALL
implement at least the algorithm 'RSASSA-PKCS1-v1_5 Using SHA-256'.

When receiving requests of transactions where the EPR-SPID is provided in the IUA token and in the transaction body,
the IUA Resource Servers SHALL verify that both are the same.

The actors SHALL support the `traceparent` header handling, as defined in [Appendix: Trace Context](tracecontext.html).

#### Security Audit Considerations

<!-- TODO and to be discussed: for security reasons and might be reasonable to add a ATNA logs to detect attacks, i.e., failed attempts --> 
There is no audit event required for this transaction.
