<div markdown="1" class="dragon">
This page is work in progress, see [#11](https://github.com/ehealthsuisse/ch-health-dossier/issues/11).
</div>

### Scope

This page describes how an IUA Authorization Client is registered at the IUA Authorization Server, so that it can
request access tokens with [ITI-71](iti-71.html).

In the Swiss Health Dossier, client applications are identified to the authorization server by the `client_id`
client identifier that SHALL be unique to the IUA Authorization Client. The `client_id` is passed to the
IUA Authorization Server during the authorization request stage. The IUA Authorization Server uses the `client_id`
to identify the client application and to determine which scopes are authorized, and therefore what information
is displayed to the end user in the specific client application.

This section explains how a client application obtains its client_id and registers the metadata the IUA Authorization
Server requires, such as valid redirect URIs, scopes, and client authentication means (e.g., the public keys used for
client authentication).

This specification covers two different protocols for client registration:
* User Authorized Client Registration: A dynamic client registration variant, where the request is authorized by a natural
  person which is authenticated at an accepted Identity Provider for the Swiss Health Dossier. This protocol SHALL be
  used by healthcare professionals or assistants to register a primary system or a clinical archive system.
* dGA Client Registration: A dynamic client registration variant where the request is authorized by a natural
  person which is authenticated at an accepted Identity Provider for the Swiss Health Dossier and the dGA is identified
  with a software statement assigned by the Federal Office of Public Health. This protocol SHALL be used by dossier owner
  to register a digital health application (e.g., a mobile health application).

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
| 01  | The user initiates dynamic client registration from the client application.                                                          |
| 02  | The client application redirects the user to the Identity Provider for user authentication.                                          |
| 03  | The Identity Provider returns an Identity Token for the authenticated user.                                                          |
| 04  | The client application builds the Client Registration Request and sends it to the registration endpoint of the authorization server. |
| 05  | The Authorization Server registers the client application and responds with a Client Information Response message.                   |
{:class="table table-bordered"}

Table: Sequence for User Authorized Client Registration

#### dGA Client Registration

<div style="width: 80%;">
{% include ClientRegistration-dGA.svg %}
</div>
Figure: Sequence diagram for dGA Client Registration 


| SEQ | Description                                                                                                                          |
|-----|--------------------------------------------------------------------------------------------------------------------------------------|
| 01  | The FOPH verifies the dGA software, registers it and issues a software statement to be used for client registration.                 |
| 02  | After installing the dGA software, the user initiates dynamic client registration from the client application.                       |
| 03  | The client application redirects the user to the Identity Provider for user authentication.                                          |
| 04  | The Identity Provider returns an Identity Token for the authenticated user.                                                          |
| 05  | The client application builds the Client Registration Request and sends it to the registration endpoint of the authorization server. |
| 06  | The Authorization Server registers the client application and responds with a Client Information Response message.                   |
{:class="table table-bordered"}

Table: Sequence for dGA Client Registration

### Messages

#### Client Registration Request

##### Message Semantics

To register, the client sends an HTTP POST to the client registration endpoint with a content 
type of "application/json". The HTTP payload is a JSON document with the requested client metadata.

The Client Registration Request SHALL contain the following parameters:
- *client_name*: SHALL be a human-readable name of the client to be presented to the end-user. 
- *token_ endpoint_ auth_method*: SHALL be `private_key_jwt`. 
- *grant_types*: SHALL be `client_credentials`. 
- *scope*: SHALL be the list of scopes that the client can use when requesting tokens, formatted as a string of space-separated values.
- *jwks*: SHALL be the JSON Web Key Set document containing the public keys for client authentication.
- *id_token*: SHALL be the signed JWT with the identity token issued by the Identity provider. 
- *software_statement*: A signed JSON document with a software statement as defined below. Required for dGA, SHALL NOT be used otherwise.

The `software_statement` SHALL be used by dGA to present client metadata in a way, that the authorization server can 
verify that it’s issued and signed by the Federal Office of Public Health as part of the dGA admission process. 

The `software_statement` contains the following parameter: 
- *software_id*: The unique id of the dGA software.
- *software_version*: The version of the dGA software.
- *client_name*: The name of the dGA software.
- *client_uri*: The URL of the vendor's website. 
- *tos_uri*: The URL of the website displaying the terms of use.
- *iss*: The identifier of the Federal Office of Public Health `2.16.756.5.30.1.129`. 
- *iat*: The unix time stamp the statement was issued by the Federal Office of Public Health.
- *exp*: The unix time stamp of the date the software statement expires. 

##### Expected Actions

<!-- TODO -->

Verify the `id_token` attributes. 

Verify the `id_token` signature. 

Verify that the `id_token` is issued by an accepted identity provider. 

Assign a unique `client_id` for the client app and register the app with the `client_id` and the metadata.

If present, verify that the `software_statement` was issued by the Federal Office of Public Health as 
part of the dGA admission process and that the current time does not exceed the expiration date.

Verify the `software_statement` signature. 

##### Message Example

The following listing displays a non-normative example for a Client Registration Request:

```
POST /register HTTP/1.1
Content-Type: application/json
Accept: application/json
Host: server.example.com

{
"client_name":"Personal Health Assistant App",
"token_endpoint_auth_method":"private_key_jwt",
"grant_types":["client_credentials"], 
"scope":"foo bar",
"jwks":{"keys": [{
    "e": "AQAB", 
    "n": "nj3YJwsLUFl9BmpAbkOswCNVx17Eh9wMO-_AReZwBqfaWFcfG
        HrZXsIV2VMCNVNU8Tpb4obUaSXcRcQ-VMsfQPJm9IzgtRdAY8NN8Xb7PEcYyk
        lBjvTtuPbpzIaqyiUepzUXNDFuAOOkrIol3WmflPUUgMKULBN0EUd1fpOD70p
        RM0rlp_gg_WNUKoW1V-3keYUJoXH9NztEDm_D2MQXj9eGOJJ8yPgGL8PAZMLe
        2R7jb9TxOCPDED7tY_TU4nFPlxptw59A42mldEmViXsKQt60s1SLboazxFKve
        qXC_jpLUt22OC6GUG63p-REw-ZOr3r845z50wMuzifQrMI9bQ",
   "kty": "RSA"
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
"software_statement":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0
  NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTc5MTY0NTA1N
  30.VN3Yh2nVujqLIELAlIFilHKcavsfrzYj0AwQ51_wz6PGDqFX1GGd8hRt01sxzZ6yZJ3vu0
  gQ6Voe9AK9LcZnxLeoByjMiotHwpDUriCbs0d8v0wwi4gcYAoh67c_joFR9RRRHCf2abyrHWa
  uhRDrHuxwRgib8IX3w3-fxU5yAQgzxgzTPDW_c5BBm9FxTJgS1eSjdIlhMiK1aqAvpeRdjMwm
  B9JItnhAtikJ1xqVHHy0I-xdukBJyYOm5sG3RbH3EqW5o_9nHJYK472892XkkxLC7Cl5QMWpP
  zH2qhVtXlTxplPacYMIy7jjfM9XNnuq8c_XJtd14o3H9d9qppVaew" 
}
```

Where the `software_statement` payload may look like:

```{json}
{
"software_id": "84012-39134-3912",
"software_version": "1.2.5-dolphin",
"client_name": "Personal Health Assistant App",
"client_uri": "https://example.org/",
"tos_uri": "https://example.org/terms-of-service/", 
"iss": "2.16.756.5.30.1.129", 
"iat": 1788874695, 
"exp": 1899974695
}
```

#### Client Information Response

##### Message Semantics

Upon a successful registration request, the Authorization Server generates a new client ID and returns it to the
client along with metadata associated with the client.

The Client Information Response SHALL contain the following parameters:
- *client_id*: SHALL be a unique ID assigned by the Authorization Server. 
- *client_id_issued_at*: SHALL be the unix time stamp the `client_id` is issued by the Authorization Server.
- *token_endpoint_auth_method*: SHALL be `private_key_jwt`.
- *grant_types*: SHALL be `client_credentials`.
- *scope*: SHALL be the list of scopes that the client can use when requesting tokens, formatted as a string of space-separated values.


##### Expected Actions

The Authorization Client SHALL register the `client_id` and the response metadata and use the information for the 
future Token Requests to the Authorization Server.  

##### Message Example

The following listing displays a non-normative example for a Client Information Response:

```
HTTP/1.1 201 Created
Content-Type: application/json
Cache-Control: no-store
Pragma: no-cache

{
"client_id": "a7cf91c3-f0d5-4a22-81c9-5231c8650cc1",
"client_id_issued_at": 1791540118,
"token_endpoint_auth_method": "private_key_jwt",
"grant_types": ["client_credentials"],
"scope": "foo bar"
}
```

