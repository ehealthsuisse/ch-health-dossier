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

<!-- During the registration the client receives its `client_id` and exchanges its public key used for the client authentication and the HTTP message signature of the token request. -->

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
| 01  | The FOPH verifies the dGA software, registers it and issues a certificate to be used for client registration.                        |
| 02  | After installing the dGA software, the user initiates dynamic client registration from the client application.                       |
| 03  | The client application redirects the user to the Identity Provider for user authentication.                                          |
| 04  | The Identity Provider returns an Identity Token for the authenticated user.                                                          |
| 05  | The client application builds the Client Registration Request and sends it to the registration endpoint of the authorization server. |
| 06  | The Authorization Server registers the client application and reponds with a Client Information Response message.                    |
{:class="table table-bordered"}

Table: Sequence for dGA Client Registration

### Messages

#### Client Registration Request

To register, the client sends an HTTP POST to the client registration endpoint with a content 
type of "application/json". The HTTP payload is a JSON document with the requested client metadata.

The Client Registration Request SHALL contain the following parameters:
- *client_name*: SHALL be a speaking name of the client application. 
- *token_ endpoint_ auth_method*: SHALL be `private_key_jwt`. 
- *grant_types*: SHALL be `client_credentials`. 
- *scope*: A list of scopes that the client can use when requesting tokens, formatted as a string of space-separated values.
- *jwks*: A JSON Web Key Set document containing the public keys for client authentication.
- *software_statement*: A signed JSON document with a software statement as defined below. Required for dGA, SHALL not be used otherwise.

The `software_statement` SHALL be used by dGA to present client metadata to the authorization in a way, that the authorization 
server can verify that it’s issued and signed by the Federal Office of Public Health as part of the dGA admission process. 

The `software_statement` contains the following parameter: 
- *software_id*: The unique id of the dGA software.
- *software_version*: The version of the dGA software.
- *client_name*: The name of the dGA software.
- *client_uri*: The URL of the vendor's website. 
- *tos_uri*: The URL of the website displaying the terms of use. 

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
"token_endpoint_auth_method":"client_secret_basic",
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
"software_statement":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzb2Z0d2FyZV
9pZCI6Ijg0MDEyLTM5MTM0LTM5MTIiLCJzb2Z0d2FyZV92ZXJzaW9uIjoiMS4yLjUtZG9scGhp
biIsImNsaWVudF9uYW1lIjoiU3BlY2lhbCBPQXV0aCBDbGllbnQiLCJjbGllbnRfdXJpIjoiaH
R0cHM6Ly9leGFtcGxlLm9yZy8iLCJsb2dvX3VyaSI6Imh0dHBzOi8vZXhhbXBsZS5vcmcvbG9n
by5wbmciLCJ0b3NfdXJpIjoiaHR0cHM6Ly9leGFtcGxlLm9yZy90ZXJtcy1vZi1zZXJ2aWNlLy
J9.X4k7X-JLnOM9rZdVugYgHJBBnq3s9RsugxZQHMfrjCo" 
}
```

Where the `software_statement` payload may look like:

```{json}
{
"software_id": "84012-39134-3912",
"software_version": "1.2.5-dolphin",
"client_name": "Personal Health Assistant App",
"client_uri": "https://example.org/",
"tos_uri": "https://example.org/terms-of-service/"
}
```

#### Client Information Response

<!-- TODO -->


