<div markdown="1" class="dragon">
This page is work in progress, see [#11](https://github.com/ehealthsuisse/ch-health-dossier/issues/11).
</div>

### Scope

This page describes how an IUA Authorization Client is registered at the IUA Authorization Server so that it can
request access tokens with [ITI-71](iti-71.html).

In the Swiss Health Dossier, the IUA Authorization Server identifies each client application by its `client_id`.
The `client_id` SHALL be unique to the IUA Authorization Client. The client passes it to the IUA Authorization
Server in every Token Request. The IUA Authorization Server uses the `client_id` to identify the client application
and to determine which scopes are authorized.

This page explains how a client application obtains its `client_id` and registers the metadata the IUA Authorization
Server requires, such as the requested scopes and the public keys used for client authentication.

This specification covers two variants of dynamic client registration. In both, the request is authorized by a natural
person who is authenticated at an Identity Provider accepted for the Swiss Health Dossier.

- *User Authorized Client Registration:* SHALL be used by healthcare professionals or assistants to register
  a primary system or a clinical archive system.
- *dGA Client Registration:* SHALL be used by dossier owners to register a digital health application
  (dGA, e.g., a mobile health application). In addition, the dGA is identified by a software statement issued by the
  Federal Office of Public Health (FOPH).

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
  space-separated values.
- *jwks*: SHALL be the JSON Web Key Set containing the public keys for client authentication.
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

##### Expected Actions

Upon receiving the registration request, the Authorization Server SHALL:

1. verify the attributes and the signature of the `id_token`, and confirm that it was issued by an accepted
   Identity Provider;
2. if a `software_statement` is present, verify that it was issued by the FOPH as part of the dGA admission process.
   That means checking that `iss` matches the FOPH identifier, verifying the signature with the FOPH's public key,
   and checking that the current time does not exceed `exp`.

If all checks succeed, the Authorization Server SHALL assign a unique `client_id` to the client application and
register the application with this `client_id`, the user ID from the `id_token`, and the submitted metadata,
including the public keys for client authentication.

If a check fails, the Authorization Server SHALL reject the request with an error response as defined in
[RFC 7591, Section 3.2.2](https://www.rfc-editor.org/rfc/rfc7591#section-3.2.2), e.g., `invalid_client_metadata`, `invalid_software_statement` or 
`unapproved_software_statement`.

##### Message Example

The following listing displays a non-normative example of a Client Registration Request:

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
"software_statement":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2Z0d2FyZV9p
  ZCI6Ijg0MDEyLTM5MTM0LTM5MTIiLCJzb2Z0d2FyZV92ZXJzaW9uIjoiMS4yLjUtZG9scGhpb
  iIsImNsaWVudF9uYW1lIjoiUGVyc29uYWwgSGVhbHRoIEFzc2lzdGFudCBBcHAiLCJjbGllbn
  RfdXJpIjoiaHR0cHM6Ly9leGFtcGxlLm9yZy8iLCJ0b3NfdXJpIjoiaHR0cHM6Ly9leGFtcGx
  lLm9yZy90ZXJtcy1vZi1zZXJ2aWNlLyIsImlzcyI6IjIuMTYuNzU2LjUuMzAuMS4xMjkiLCJp
  YXQiOjE3ODg4NzQ2OTUsImV4cCI6MTg5OTk3NDY5NX0.uWal3hRgns3g6tIdH_C3uKS2IFh4h
  jXNZ_BWjC9pHHzklrk1XSPfLfPbiyfMJ5GeOkhghz_vHhmkQnbtZmSq9TzA4j42C_uV0tX3Yx
  A2OqcTOXQCWxaX6TZupPlftoI9G1QXXMEmaoxfEC90baCOulhSKkV9L-sARKJUdPeKegml9o8
  wBaZDhvS80U1fIC6LrG2D7p9oHvjFS8BuMVdF0GfueQhncCPkz7Mbn4Mqlyh0srpFsFE8vaOb
  qZ1w3QKEGBJpfYeVRV9hqBh9XIYLZwgReEb7WXH6kkGqoDArQlUadi8ihewiTuzY8qGrjbark
  1m64as6bq3OOLFbMeo2RA" 
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
- *jwks*: SHALL be the JSON Web Key from the request.

##### Expected Actions

The Authorization Client SHALL store the `client_id` and the metadata returned in the registration response, and
SHALL use them in all subsequent Token Requests to the Authorization Server.

##### Message Example

The following listing displays a non-normative example for a Client Information Response:

```
HTTP/1.1 201 Created
Content-Type: application/json
Cache-Control: no-store
Pragma: no-cache

{
"client_id": "a7cf91c3-f0d5-4a22-81c9-5231c8650cc1",
"client_name":"Personal Health Assistant App",
"client_id_issued_at": 1791540118,
"token_endpoint_auth_method": "private_key_jwt",
"grant_types": ["client_credentials"],
"scope": "foo bar", 
"jwks":{"keys": [{
    "e": "AQAB", 
    "n": "nj3YJwsLUFl9BmpAbkOswCNVx17Eh9wMO-_AReZwBqfaWFcfG
        HrZXsIV2VMCNVNU8Tpb4obUaSXcRcQ-VMsfQPJm9IzgtRdAY8NN8Xb7PEcYyk
        lBjvTtuPbpzIaqyiUepzUXNDFuAOOkrIol3WmflPUUgMKULBN0EUd1fpOD70p
        RM0rlp_gg_WNUKoW1V-3keYUJoXH9NztEDm_D2MQXj9eGOJJ8yPgGL8PAZMLe
        2R7jb9TxOCPDED7tY_TU4nFPlxptw59A42mldEmViXsKQt60s1SLboazxFKve
        qXC_jpLUt22OC6GUG63p-REw-ZOr3r845z50wMuzifQrMI9bQ",
   "kty": "RSA"
   }]}
}
```

