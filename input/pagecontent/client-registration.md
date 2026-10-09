<div markdown="1" class="dragon">
This page is work in progress, see [#11](https://github.com/ehealthsuisse/ch-health-dossier/issues/11).
</div>

### Scope

This page describes how an IUA Authorization Client is registered at the IUA Authorization Server, so that it can
request access tokens with [ITI-71](iti-71.html).

In the Swiss Health Dossier, client applications are identified to the authorization server by the `client_id`
client identifier that SHALL be unique to the IUA Authorization Client. The `client_id` is passed to the
IUA Authorization Server during the authorization request stage. The IUA Authorization Server uses the `client_id`
to identify the client application and to determines which scopes are authorized, and therefore what information
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
  with a certificate assigned by the Federal Office of Public Health. This protocol SHALL be used by dossier owner
  to register a digital health application (e.g., a mobile health application).

### Referenced Standards
- [OAuth 2.0 Dynamic Client Registration Protocol (RFC 7591)](https://www.rfc-editor.org/rfc/rfc7591).
- [RFC 7517 JSON Web Key](https://www.rfc-editor.org/info/rfc7517/).

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
| 04  | The Authorization Server registers the client application and reponds with a Client Information Response message.                    |
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
| 06  | The Authorization Server registers the client application and reponds with a Client Information Response message.                    |
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
- *software_statement*: A signed JSON document with a software statement as defined below. Required for dGA, SHALL not be used otherwise.

The `software_statement` SHALL be used by dGA to present client metadata in a way, that the authorization server can 
verify that it’s issued and signed by the Federal Office of Public Health as part of the dGA admission process. 

The `software_statement` contains the following parameter: 
- *software_id*: The unique id of the dGA software.
- *software_version*: The version of the dGA software.
- *client_name*: The name of the dGA software.
- *client_uri*: The URL of the vendor's website. 
- *tos_uri*: The URL of the website displaying the terms of use.
- *iss*: The identifier of the Federal Office for Public Health `2.16.756.5.30.1.129`. 
- *iat*: The unix time stamp the statement was issued by the Federal Office for Public Health.
- *exp*: The unix time stamp of the date the software statement expires. 

##### Expected Actions

<!-- TODO -->

Verify the `id_token` attributes. 

Verify the `id_token` signature. 

Verify that the `id_token` is issued by a accepted identity provider. 

Assign a unique `client_id` for the client app and register the app with the `client_id` and the metadata.

If present, verify that the `software_statement` was issued by the  Federal Office of Public Health as 
part of the dGA admission process and that the current time does not exceed the token expiration date.

##### Message Example

The following listing displays a non-normative example for a Client Registration Request:

```
POST /register HTTP/1.1
Content-Type: application/json
Accept: application/json
Authorization: Bearer ey23f2.adfj230.af32-developer321
Host: server.example.com

{
"client_name":"my dGA",
"token_endpoint_auth_method":"private_key_jwt",
"grant_types":["client_credentials"], 
"scope":"read write",
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
"id_token":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwOi8vY2xp
  ZW50LXNpbXVsYXRvci5vcmciLCJzdWIiOiJCZWFyZXIiLCJhdWQiOiJteS1jbGllbnQtaWQtM
  TIzIiwiZXhwIjoxNzkxMDk1NTk3LCJpYXQiOjE3OTEwOTQ5OTcsIm5vbmNlIjoibi0wUzZfV3
  pBMk1qIiwibmFtZSI6Ik1hcnRpbmEgTXVzdGVybWFubiJ9.tZ9z6QtAPUHdWnWabAAdcS4tVO
  sMlJ86Wokrsd9pSvh7p2FLhyOiRXaPb8_LJIQbwf-EGk2Qlm6O2-7yG8ZMam7grdqvt7Z7liQ
  IK3UFQ4-1lszeYfXgpKSWWzVcvU1a6vW2qK3OdkdoBdf-oe9Md1_wCs8qIBUUr6lZeBrki8EM
  yMjrzqY9VcSoREYH_u8FM6Tq6quGe_91an4SDjOuPqJ6qFWDJR6tnNabt87hqLO4-Bp_UOWWw
  rhmb0yv0MSIhvdiKGXLneCt1KlnYOMQctiXvOolF2RXHNrDGmHN0Vb07P6U2y4itk58pqhcKN
  fuyL86hckdFN4gDxj17Y-NRA",
"software_statement":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2Z0d2FyZV
  9pZCI6Ijg0MDEyLTM5MTM0LTM5MTIiLCJzb2Z0d2FyZV92ZXJzaW9uIjoiMS4yLjUtZG9scGh
  pbiIsImNsaWVudF9uYW1lIjoiUGVyc29uYWwgSGVhbHRoIEFzc2lzdGFudCBBcHAiLCJjbGll
  bnRfdXJpIjoiaHR0cHM6Ly9leGFtcGxlLm9yZy8iLCJ0b3NfdXJpIjoiaHR0cHM6Ly9leGFtc
  GxlLm9yZy90ZXJtcy1vZi1zZXJ2aWNlLyIsImlzcyI6IjIuMTYuNzU2LjUuMzAuMS4xMjkiLC
  JpYXQiOiIxNzg4ODc0Njk1IiwiZXhwIjoiMTg5OTk3NDY5NSJ9.j1YYOVjS9UMzjymbUUw5ve
  V0BB2xqK4rrwJNp6nDTqs" 
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

Upon a successful registration request, the Authorization Server generates a new client ID an returns it to the
client along with metadata associated with the client.

The Client Information Response SHALL contain the following parameters:
- *client_id*: SHALL be a unique ID assigned by the Authorization Server. 
- *client_id_issued_at*: SHALL be the unix time stamp the `client_id` is issued by the Authorization Server.
- *token_ endpoint_ auth_method*: SHALL be `private_key_jwt`.
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
{
"client_id": "a7cf91c3-f0d5-4a22-81c9-5231c8650cc1",
"client_id_issued_at": 1791540118,
"token_endpoint_auth_method": "private_key_jwt",
"grant_types": ["client_credentials"],
"scope": "foo bar"
}
```

