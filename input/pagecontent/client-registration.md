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

### Dynamic Client Registration

During the registration the client receives its `client_id` and exchanges its public key used for the client
authentication and the HTTP message signature of the token request.



