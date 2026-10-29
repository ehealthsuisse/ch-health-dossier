### Scope

This page describes how an Authorization Client is registered at the Authorization Server so that it can
request access tokens with [ITI-71](iti-71.html).

In the Swiss Health Dossier, the Authorization Server identifies each client application by its `client_id`.
The `client_id` SHALL be unique to the Authorization Client. The client passes it to the Authorization
Server in every Token Request. The Authorization Server uses the `client_id` to identify the client application
and to determine which scopes are authorized.

This page explains how a client application can use the OAuth dynamic registration protocol to obtain 
its `client_id` and register the metadata, such as the requested scopes and the public keys used for client 
authentication.

This page uses per-instance client registration, meaning each installed instance of a client is registered separately. 
For example, a primary system is registered once for each instance deployed in a practice or institution, and all users 
of that instance share this registration.

This page covers two variants of dynamic client registration. In both, the request is authorized by a natural
person who is authenticated at an Identity Provider accepted for the Swiss Health Dossier.
- *User Authorized Client Registration:* SHALL be used by healthcare professionals or assistants to register
  a primary system.
- *dGA Client Registration:* SHALL be used by holders to register a digital health application
  (dGA, e.g., a mobile health application). In addition, the dGA is identified by a software statement issued by the
  Federal Office of Public Health (FOPH).

Dynamic client registration SHALL NOT be used for clinical archive systems with role `TCU` defined in 
[Internet User Authorization (IUA)](iti-iua.html). For security reasons, such systems require out-of-band 
registration, including additional proofs of identity and authorization.


### Referenced Standards
- [OAuth 2.0 Dynamic Client Registration Protocol (RFC 7591)](https://www.rfc-editor.org/rfc/rfc7591).
- [RFC 7517 JSON Web Key](https://www.rfc-editor.org/info/rfc7517/).
- [RFC 7519: JSON Web Token](https://www.rfc-editor.org/info/rfc7519/).
- [OpenID Connect Core 1.0 incorporating errata set 2](https://openid.net/specs/openid-connect-core-1_0.html).
- [RFC 7523 JSON Web Token (JWT) Profile for OAuth 2.0 Client Authentication and Authorization Grants](https://www.rfc-editor.org/info/rfc7523/).

### Sequences

#### User Authorized Client Registration

<div style="width: 80%;">
{% include ClientRegistration-PS.svg %}
</div>
Figure: Sequence diagram for User Authorized Client Registration

| SEQ | Description                                                                                                                          |
|-----|--------------------------------------------------------------------------------------------------------------------------------------|
| 01  | The user initiates dynamic client registration in the client application.                                                            |
| 02  | The client application redirects the user to the Identity Provider for authentication.                                               |
| 03  | The Identity Provider returns an Identity Token for the authenticated user.                                                          |
| 04  | The client application builds the Client Registration Request and sends it to the registration endpoint of the Authorization Server. |
| 05  | The Authorization Server registers the client application and responds with a Client Information Response.                           |
{:class="table table-bordered"}

Table: Sequence for User Authorized Client Registration

#### dGA Client Registration

<div style="width: 80%;">
{% include ClientRegistration-dGA.svg %}
</div>
Figure: Sequence diagram for dGA Client Registration 

| SEQ | Description                                                                                                                                                             |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 01  | The FOPH verifies and registers the dGA software and issues a software statement for use in client registration.                                                        |
| 02  | After installing the dGA software, the user initiates dynamic client registration in the client application.                                                            |
| 03  | The client application redirects the user to the Identity Provider for authentication.                                                                                  |
| 04  | The Identity Provider returns an Identity Token for the authenticated user.                                                                                             |
| 05  | The client application builds the Client Registration Request, including the software statement, and sends it to the registration endpoint of the Authorization Server. |
| 06  | The Authorization Server registers the client application and responds with a Client Information Response.                                                              |
{:class="table table-bordered"}

Table: Sequence for dGA Client Registration

### Messages

#### Client Registration Request

##### Message Semantics

To register, the client sends an HTTP POST with content type `application/json` to the client registration
endpoint. The payload is a JSON document containing the requested client metadata.

The Client Registration Request SHALL contain the following parameters:
- *client_name*: SHALL be a human-readable name of the client, to be presented to the end user.
- *token_endpoint_auth_method*: SHALL be `private_key_jwt`.
- *grant_types*: SHALL be `client_credentials`.
- *scope*: SHALL be the list of scopes the client can use when requesting tokens, formatted as a string of
space-separated values (see [ITI-71](iti-71.html#message-semantics)).
- *jwks*: SHALL be a JSON Web Key Set (JWKS) containing the public key used for asymmetric client authentication (JWT).
- *id_token*: SHALL be the signed JWT containing the identity token issued by the Identity Provider.
- *software_statement*: A signed JWT containing the software statement defined below. It SHALL be present for 
dGA Client Registration and SHALL NOT be present otherwise.

The software statement allows a dGA to present its client metadata in a way that the Authorization Server can verify
it was issued and signed by the FOPH as part of the dGA admission process.

The software statement contains the following claims:
- *software_id*: The unique ID of the dGA software.
- *software_version*: The version of the dGA software.
- *client_name*: The name of the dGA software.
- *client_uri*: The URL of the vendor's website.
- *tos_uri*: The URL of the page displaying the terms of use.
- *iss*: The identifier of the FOPH, `2.16.756.5.30.1.129`.
- *iat*: The Unix timestamp at which the FOPH issued the statement.
- *exp*: The Unix timestamp at which the software statement expires.
- *scope*: The scope granted by the FOPH for the dGA software and version. 

##### Expected Actions

Upon receiving the registration request, the Authorization Server SHALL:

1. verify that the issuer identifier `iss` matches the issuer identifier of an Identity Provider accepted for the health dossier.
2. verify that the `id_token` is signed by one of the Identity Providers accepted for the health dossier.
3. verify that the `id_token` is not expired and the current time is later than or equal to the time the token was issued by 
the Identity Provider.
4. verify that the user identified by the `id_token` is entitled to the registration variant: a holder or their 
representative for dGA Client Registration, a healthcare professional or assistant for User Authorized Client Registration.
5. if a `software_statement` is present, verify that it was issued by the FOPH as part of the dGA admission process by 
checking that `iss` matches the FOPH identifier, verifying the signature with the FOPH's public key, and checking that 
the current time does not exceed the software statement expiration time `exp`.

If all checks succeed, the Authorization Server SHALL assign a unique `client_id` to the client application and
register the application with this `client_id`, the user ID and the issuer identifier from the `id_token`, and 
the submitted metadata, including the public key for client authentication.

If one of the above checks fails, the Authorization Server SHALL reject the request with an error response as defined in
[RFC 7591, Section 3.2.2](https://www.rfc-editor.org/rfc/rfc7591#section-3.2.2), e.g., `invalid_client_metadata`, `invalid_software_statement` or 
`unapproved_software_statement`.

##### Message Example

The following listing displays a non-normative example of a Client Registration Request (line breaks within values are 
for display purposes only):

```
POST /register HTTP/1.1
Content-Type: application/json
Accept: application/json
Host: server.example.com

{
"client_name":"Personal Health Assistant App",
"token_endpoint_auth_method":"private_key_jwt",
"grant_types":["client_credentials"], 
"scope":"purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|PAT patient/DocumentReference.cruds patient/List.c patient/Binary.cr patient/Bundle.cr",
"jwks":{"keys": [{
    "kid":"1ec50019-0049",
    "kty":"RSA",
    "e":"AQAB",
    "use":"sig",
    "alg":"RS256",
    "n":"mg8wBb_pVkMQrchfTCWd-J1Nnv25N0ors8UI8P46ZFyKAFGTzRI8zlVIqWhPqclfM
        pA8qqGXDvDk5E6wVfJKuIpXvrRfsntWqcKItu49HrnOIk2aH1_AFLyu4z3Hg4pzL_y
        Nbars_-S2QpCIWdYiY8ayOSSlMQopGOa618CqO9YSTb5N_CySuK3GzPmP8MlHYzuJz
        6jM2AEysDQnCByqX5EtolTEa12BWDiqzn4BqzMMepEaZNtxO5iqgxGs-vmIC74ToGU
        HahLuUlzParD2hyHObw7wjYHNIgawrCKUPyx6ibdLwzL85OUCF3MPKTZTNt_UYtVNJ
        F166-WZg5lUZw"
  }]}, 
"id_token":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJpZC1wcm92aWRlci
  IsInN1YiI6ImUyMDVhNmFjLTcxNDItNGYxMC1hMTNlLTJiYmUzZjc2Nzk5MiIsImF1ZCI6ImN
  saWVudC13aXRoLWlkLTEyMzQ1Njc4OSIsImV4cCI6MTc5MTA5NTU5NywiaWF0IjoxNzkxMDk0
  OTk3LCJub25jZSI6Im4tMFM2X1d6QTJNaiIsIm5hbWUiOiJNYXJ0aW5hIE11c3Rlcm1hbm4if
  Q.BsGQ0JPJM5wkUBPtSRvWtY99eYiB6Q8wRSvM0ETYnP559nHyP698PVRBPukDxs17V6e5kz3
  lk-iTU3n3srHxIR8uk55IKOleg9NiK9S1GNINwkiGyREBkrr05aJqhWx_zQiAfV-ilAyXQsR7
  Rwi__HAkY8bNGnZmrJaTIDh75SN7rZPSTyphwLC-0hH49r0AGZh20VP4WovVMTRuNsptOMgUs
  0-0UKxiNdyLaFzzELY0LBrIbQsTlwCIh63CFNWVLb8E93HNUgzEeImm7BVYv3ynBQtRNVdbjr
  b4aFCg1zI7MeSZ4bj2FDlS4Q9PZlHyL6vsGP642BG67Ai48pTR_w",
"software_statement":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImZvcGgtZX
  hhbXBsZS0yMDI2In0.eyJzb2Z0d2FyZV9pZCI6Ijg0MDEyLTM5MTM0LTM5MTIiLCJzb2Z0d2Fy
  ZV92ZXJzaW9uIjoiMS4yLjUtZG9scGhpbiIsImNsaWVudF9uYW1lIjoiUGVyc29uYWwgSGVhbH
  RoIEFzc2lzdGFudCBBcHAiLCJjbGllbnRfdXJpIjoiaHR0cHM6Ly9leGFtcGxlLm9yZy8iLCJ0
  b3NfdXJpIjoiaHR0cHM6Ly9leGFtcGxlLm9yZy90ZXJtcy1vZi1zZXJ2aWNlLyIsImlzcyI6Ij
  IuMTYuNzU2LjUuMzAuMS4xMjkiLCJpYXQiOjE3ODg4NzQ2OTUsImV4cCI6MTg5OTk3NDY5NSwi
  c2NvcGUiOiJwdXJwb3NlX29mX3VzZT11cm46b2lkOjIuMTYuNzU2LjUuMzAuMS4xMjcuMy4xMC
  41fE5PUk0gc3ViamVjdF9yb2xlPXVybjpvaWQ6Mi4xNi43NTYuNS4zMC4xLjEyNy4zLjEwLjE5
  fFBBVCBwYXRpZW50L0RvY3VtZW50UmVmZXJlbmNlLmNydWRzIHBhdGllbnQvTGlzdC5jIHBhdG
  llbnQvQmluYXJ5LmNyIHBhdGllbnQvQnVuZGxlLmNyIn0.KcqnwFjGLFlxKds6LvVdB-iLvV7s
  Gswo_ZK1-NJw597OQkuRca9lv0bHkbS6l_2ydmiqpXKrJD9R5VWLfvDnd9xU_sUOwgV9GpVObV
  t88OJsRmF2MAfGHRJcjAuog4BYO2lxD0OVFDoQJ8HG7yLFb2WpCBcoiOu3y0y7-Sit0WxbMQEO
  oEyyMBbtCPDg_LeVtU8IkRAzXcgqA3-p3FtzBTkxxH68hKMdhRN8r6xsD3bz2CR3yIWljv0zVY
  4E5W4F0I4VVGEz0dCLkSJGPu6kcpuwswrzjklWsbhaf30vDuO3DaY_QAZ-42NHdsDTmwFcqc7O
  yXoPniZ8R3-uCovpxg" 
}
```

Where the `software_statement` payload may look like:

```json
{
"software_id": "84012-39134-3912",
"software_version": "1.2.5-dolphin",
"client_name": "Personal Health Assistant App",
"client_uri": "https://example.org/",
"tos_uri": "https://example.org/terms-of-service/", 
"iss": "2.16.756.5.30.1.129", 
"iat": 1788874695, 
"exp": 1899974695, 
"scope": "purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|PAT patient/DocumentReference.cruds patient/List.c patient/Binary.cr patient/Bundle.cr"
}
```

The software statement of this example is signed with the following example key of the FOPH (JWKS, `kid`
`foph-example-2026`), which can be used to verify the signature. It is an example key only and SHALL NOT be used outside of testing:

```json
{"keys": [{
    "kid":"foph-example-2026",
    "kty":"RSA",
    "e":"AQAB",
    "use":"sig",
    "alg":"RS256",
    "n":"vDdrhrS4DOheQN3Sjz6UoVfBIjZS3YZb4tpMz2Nqfb8nrTFMtVnw6GUbT0o4yO8P
        4M069zIV3leaKR5sJMD5PcJSgPMlxg54pENh-f4B58H6foPfcmtHfnuZqucW8lCX
        k3BdAHW3hIbq9B7Kl8k2VHJ-PZFmIgYT3RHzy1JOcQvaNyIRWuOb9pbtfGQI1uwX
        Ujusk9_iGFU_Xb3fYXGyiO2r6mUQVjf7yq9uRa57qrgpuXeEZ6ySmt4ASoAgHFHl
        h1n7Mpk-VqZ5eAWQp0jf3fyQpG5c48tyvQKA6KlzKLjHBhIOzZWIXE6CsDq-mnOW
        XzXljpLLLWcZrIr0qqAaAQ"
  }]}
```

#### Client Information Response

##### Message Semantics

Upon a successful registration request, the Authorization Server generates a new `client_id` and returns it to the
client together with the metadata associated with the client.

The Client Information Response SHALL contain the following parameters:
- *client_id*: SHALL be a unique ID assigned by the Authorization Server.
- *client_name*: SHALL be the client name from the request.  
- *client_id_issued_at*: SHALL be the Unix timestamp at which the Authorization Server issued the `client_id`.
- *token_endpoint_auth_method*: SHALL be `private_key_jwt`.
- *grant_types*: SHALL be `client_credentials`.
- *scope*: SHALL be the list of scopes the client can use when requesting tokens, formatted as a string of
  space-separated values.
- *jwks*: SHALL be the JSON Web Key Set from the request.

##### Expected Actions

The Authorization Client SHALL store the `client_id` and the metadata returned in the registration response, and
SHALL use them in all subsequent Token Requests to the Authorization Server.

##### Message Example

The following listing displays a non-normative example for a Client Information Response (line breaks within values 
are for display purposes only):

```
HTTP/1.1 201 Created
Content-Type: application/json
Cache-Control: no-store
Pragma: no-cache

{
"client_id": "a7cf91c3-f0d5-4a22-81c9-5231c8650cc1",
"client_name":"Personal Health Assistant App",
"client_id_issued_at": 1791095100,
"token_endpoint_auth_method": "private_key_jwt",
"grant_types": ["client_credentials"],
"scope": "purpose_of_use=urn:oid:2.16.756.5.30.1.127.3.10.5|NORM subject_role=urn:oid:2.16.756.5.30.1.127.3.10.19|PAT patient/DocumentReference.cruds patient/List.c patient/Binary.cr patient/Bundle.cr",
"jwks":{"keys": [{
    "kid":"1ec50019-0049",
    "kty":"RSA",
    "e":"AQAB",
    "use":"sig",
    "alg":"RS256",
    "n":"mg8wBb_pVkMQrchfTCWd-J1Nnv25N0ors8UI8P46ZFyKAFGTzRI8zlVIqWhPqclfM
        pA8qqGXDvDk5E6wVfJKuIpXvrRfsntWqcKItu49HrnOIk2aH1_AFLyu4z3Hg4pzL_y
        Nbars_-S2QpCIWdYiY8ayOSSlMQopGOa618CqO9YSTb5N_CySuK3GzPmP8MlHYzuJz
        6jM2AEysDQnCByqX5EtolTEa12BWDiqzn4BqzMMepEaZNtxO5iqgxGs-vmIC74ToGU
        HahLuUlzParD2hyHObw7wjYHNIgawrCKUPyx6ibdLwzL85OUCF3MPKTZTNt_UYtVNJ
        F166-WZg5lUZw"
  }]}
}
```

### Security Consideration 

The Authorization Server SHALL use TLS 1.2 or higher for the dynamic registration endpoint. The Authorization Client 
SHALL verify the Authorization Server’s TLS certificate.

The Authorization Client SHALL provide a JSON Web Key (JWK) that meets the Authorization Server’s requirements. 
The Authorization Server SHALL support, at a minimum, the RS256 algorithm (RSASSA-PKCS1-v1_5 using SHA-256).

If a software statement is used, the Authorization Client SHALL keep it confidential and SHALL NOT present 
it to any party other than the Authorization Server.

This can be achieved, for example, by multi-tier web applications that store the software statement exclusively 
on the server side. A software statement that is statically included in a mobile app binary cannot be treated 
as confidential, because any user can extract it. Mobile apps can nevertheless keep a software statement confidential 
if they obtain it at installation time from an endpoint operated by the vendor, rather than shipping it in the binary
(see related discussion in [RFC 8252 OAuth 2.0 for Native Apps](https://www.rfc-editor.org/info/rfc8252/), Section 8).

#### id token 

The `id_token` in the Client Registration Request identifies the registering user, i.e. the user who performs the 
registration of the client application. The authorization server SHALL use the id_token to verify that:
1. the registering user is a registered health dossier user; and
2. the registering user is authorized to register a client application of the requested type, e.g. a health professional 
registering a primary system or a holder registering a digital health application.

The `id_token` SHALL be used solely for the purpose of authenticating and authorizing the registration. The 
registering user and the end user of the registered client application MAY be different persons. A client 
application registration is therefore not bound to the identity of the registering user for the purpose of later 
data access, and the authorization server SHALL NOT assume that the end user is the registering user. For instance, 
a primary system may be registered by one health professional and subsequently used by other health professionals 
or assistants in the same practice.

#### Client registration and data access

Registration of a client application is a prerequisite for communicating with the health dossier services. A client 
application that has not been registered SHALL NOT be granted access to any health dossier service.

Registration SHALL NOT, by itself, grant access to data in the health dossier. Access to dossier data SHALL be granted 
only if all the following conditions are met:

1. the identity of the current user has been established and verified;
2. the requested operation is within the scopes granted to the current user; and
3. the current user holds the access rights required for the requested data, as configured by the dossier holder.

The authorization server and the health dossier services SHALL evaluate these conditions for each access request. 
If any condition is not met, the request SHALL be rejected.