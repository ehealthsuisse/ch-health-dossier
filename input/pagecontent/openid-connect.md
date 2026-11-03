### Scope

This national extension defines restrictions and extensions to the 
[OpenID Connect 1.0](https://openid.net/specs/openid-connect-core-1_0.html) authorization code flow to 
retrieve EPR compliant identity tokens used to identify and authenticate users. 

§oidc-1^ch-oidc-identity-provider:Identity Providers **SHALL** provide trusted endpoints for Relying Parties implementing the OpenID Connect 1.0 authorization
code flow fulfilling the requirements defined in this section.§ §oidc-2^ch-oidc-identity-provider:Other flows supported by OpenID Connect **SHALL NOT** be 
supported.§

### Definition of terms 

Relying Party - A Relying Party is understood as any actor that relies on an identity claim provided
by an Identity Provider for user authentication. In the context of the EPR, Relying Parties are in
particular medical information systems and portals for holders and healthcare professionals, which
access data and documents from the EPR.

Identity Provider - An Identity Provider is understood as a legal entity which manages the 
user's primary authentication credentials and issues authenticators and assertions derived from
those credentials. Identity Providers typically operate a Verifier and a Credential Service Provider,
but may delegate the services to other providers on a contractual basis.

Verifier - A verifier is understood as any Actor that corroborates identity information, by verifying the
user's identity and by verifying the user’s possession and control of authenticators using an authentication 
protocol.

Credential Service Provider - A Credential Service Provider is understood as an actor which registers,
verifies and provides assertion attributes of users. The Credential Service Provider typically
operates Registration and Local Registration Authorities, but may delegate the services to other
provider on a contractual basis.

Certificate Authority - Identity provider MAY operate a managed Certificate Authority (CA) that is 
operated according to documented processes detailed in a Certificate Policy (CP) and Certificate Practice
Statement (CPS). The requirements for the CA's processes are defined in [Back-channel Communication](#back-channel-communication). They MAY 
use this Certificate Authority to issue client certificates (mTLS) for Relying Parties. Identity providers 
MAY delegate the service to other providers on a contractual basis. 


### Referenced Standards

- [OpenID Connect Core 1.0 incorporating errata set 2](https://openid.net/specs/openid-connect-core-1_0.html), November 2014.
- [The OAuth 2.0 Authorization Framework, RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749), October 2012
- [JSON Web Signature (JWS), RFC 7515](https://www.rfc-editor.org/info/rfc7515/), May 2015.
- [Proof Key for Code Exchange by OAuth Public Clients (PKCE), RFC 7636](https://www.rfc-editor.org/info/rfc7636/), September 2015
- [JSON Web Token (JWT), RFC 7519](https://www.rfc-editor.org/info/rfc7519/), May 2015.
- [The OAuth 2.0 Authorization Framework: Bearer Token Usage, RFC 6750](https://datatracker.ietf.org/doc/html/rfc6750), October 2012.
- [OpenID Connect RP-Initiated Logout 1.0](https://openid.net/specs/openid-connect-rpinitiated-1_0.html), September 2022.
- [eCH-0048 PKI Certificate Classes standard Version 2.0](https://www.ech.ch/de/ech/ech-0048/2.0), November 2018.

### Sequences

#### User Authentication

<div style="width: 80%;">
{% include OpenID-Auth-code-flow.svg %}
</div>
Figure 1: Authentication Sequence with OpenID Connect 1.0 Authorization Code Flow

| SEQ     | Description                                                                                                                                                                                                                                                                                                     |
|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 01,02   | The user agent attempts to access a resource on the relying party on behalf of the user.                                                                                                                                                                                                                        |
| 03      | The Relying Party presents the list of supported Identity Providers to the user.                                                                                                                                                                                                                                 |
| 04,05   | The user selects an Identity Provider.                                                                                                                                                                                                                                                                          |
| 06      | The Relying Party builds an Authentication Request containing the required request parameters and conveys it to the User Agent with a redirect to the authorization endpoint of the Identity Provider.                                                                                                           |
| 07      | The User Agent sends the Authentication Request to the authorization endpoint via HTTP GET or POST protocol.                                                                                                                                                                                                    |
| 08      | The Identity Provider determines whether the user has a logon security context that meets the default or requested authentication policy requirements. If not, the Verifier interacts with the browser to challenge the user to provide valid credentials.                                                      |
| 09...11 | The Identity Provider communicates with the Authenticator(s) to authenticate the user. The user provides valid credentials and the Identity Provider creates a local logon security context for the user.                                                                                                       |
| 12      | The Identity Provider presents a screen for the user to authorize the Relying Party to retrieve the identity data. This step MAY be omitted if the Relying Party application is a confidential client as defined in the OAuth specification and the user's consent is stored in a policy or after the initial authorization. |
| 13, 14  | The Identity Provider creates an Authentication Response conveying the Authorization Code and sends the Authentication Response to the User Agent with a redirect to the Relying Party.                                                                                                                          |
| 15      | The Relying Party sends the Authorization Code to the Identity Provider in an Access Token Request using HTTP POST protocol and form serialization.                                                                                                                                                            |
| 16      | The Identity Provider validates the request and responds with the Access Token Response conveying the Access and the ID Token.                                                                                                |
| 17      | The Relying Party validates the ID Token and retrieves the user's Subject Identifier.                                                                                                                                                                                                                           |
| 18,19   | Optionally the Relying Party uses the Access Token to retrieve user identity data using the OpenID Connect 1.0 UserInfo protocol.                                                                                                                                                                               |
| 20...22 | The Relying Party returns the requested resource to the user agent.                                                                                                                                                                                                                                             |
{:class="table table-bordered"}

Table 1: Authentication Sequence with OpenID Connect 1.0 Authorization Code Flow

#### Logout

<div>
{% include OpenID-Logout.svg %}
</div>
Figure 2: OpenID Connect Logout Sequence

| SEQ    | Description                                                                                                        |
|--------|--------------------------------------------------------------------------------------------------------------------|
| 01, 02 | The user initiates a logout in the user agent of the Relying Party application.                                    |
| 03, 04 | The Relying Party redirects the user agent with a Logout Request message to the Identity Provider logout endpoint. |
| 05     | The Identity Provider terminates the IdP session.                                                                  |
| 06, 07 | The Identity Provider redirects the user agent to the relying party post logout url.                               |
| 08     | The Relying Party application terminates the user session.                                                         |
{:class="table table-bordered"}

Table 2: OpenID Connect Logout Sequence

### Messages

#### Authentication Request

§oidc-4^ch-oidc-relying-party:The Authentication Request message **SHALL** be used by the Relying Party to
initiate the authentication sequence.§ §oidc-5^ch-oidc-relying-party:The Authentication Request message
**SHALL** be compliant with an OAuth 2.0 Authentication Request message.§

§oidc-6^ch-oidc-relying-party:The Authentication Request **SHALL** contain the following parameters:§
- §oidc-7^ch-oidc-relying-party:*scope*: The value **SHALL** be *openid*.§
- §oidc-8^ch-oidc-relying-party:*response_type*: The value **SHALL** be *code*.§
- §oidc-9^ch-oidc-relying-party:*client_id*: The value **SHALL** be the Client Identifier the Relying 
  Party was registered with at the Identity Provider.§
- §oidc-10^ch-oidc-relying-party:*redirect_uri*: **SHALL** convey the redirection URI the Authentication
  Response **SHALL** be sent to. Its value **SHALL** match one of the
  redirection URIs the Relying Party was registered with at the Identity Provider.§
- §oidc-11^ch-oidc-relying-party:*state*: **SHALL** convey an opaque value used to maintain the state
  between the request and the response to mitigate Cross-Site Request Forgery
  attacks.§
- §oidc-12^ch-oidc-relying-party:*nonce*: **SHALL** convey an opaque string passed through from the
  Authentication Request to the ID Token to mitigate replay attacks.§
- §oidc-76^ch-oidc-relying-party:*code_challenge*: **SHALL** convey the code challenge derived from the code verifier
  using the code challenge method as defined in [PKCE](https://www.rfc-editor.org/info/rfc7636/).§
- §oidc-77^ch-oidc-relying-party:*code_challenge_method*: **SHALL** convey the code challenge method indicator defined
  in [PKCE](https://www.rfc-editor.org/info/rfc7636/). Its value **SHALL** be S256.§

§oidc-13^ch-oidc-identity-provider:The Identity Provider **SHALL** validate the Authentication Request as specified in 
the [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html) specification.§

#### Authentication Response

§oidc-14^ch-oidc-identity-provider:The Authentication Response message **SHALL** be used by the Identity Provider as
response to the Authentication Request message to convey the
authorization code after authenticating the user.§ §oidc-15^ch-oidc-identity-provider:The
Authentication Response message **SHALL** be compliant with an OAuth 2.0
Authentication Response message.§

§oidc-16^ch-oidc-identity-provider:The Authentication Response **SHALL** contain the following parameters:§
- §oidc-17^ch-oidc-identity-provider:*code*: **SHALL** be an OAuth 2.0 compliant authorization code.§
- §oidc-18^ch-oidc-identity-provider:*state*: **SHALL** match the state parameter value of the Authentication Request.§

§oidc-19?^ch-oidc-identity-provider:In case of an error the Identity Provider **SHALL** respond with an HTTP Error as defined
in [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html#AuthError) specification.§

#### Access Token Request

§oidc-20^ch-oidc-relying-party:The Access Token Request message **SHALL** be used by the Relying Party to
resolve the authorization code to the Access and ID Token.§ §oidc-21^ch-oidc-relying-party:The Access
Token Request message **SHALL** be sent via the backchannel.§ §oidc-22^ch-oidc-relying-party:The Access
Token Request message **SHALL** be compliant with an OAuth 2.0 Access Token
Request message.§

§oidc-23^ch-oidc-relying-party:The Access Token Request **SHALL** contain the following parameters:§
- §oidc-24^ch-oidc-relying-party:*grant_type*: The value **SHALL** be authorization_code.§
- §oidc-25^ch-oidc-relying-party:*code*: **SHALL** be the OAuth 2.0 compliant authorization code
  retrieved with the Authentication Response.§
- §oidc-26^ch-oidc-relying-party:*client_id*: **SHALL** be the Client Identifier the Relying
  Party was registered with at the Identity Provider.§
- §oidc-27^ch-oidc-relying-party:*redirect_uri*: **SHALL** be the redirection URI sent with the
  Authentication Request.§
- §oidc-78^ch-oidc-relying-party:*code_verifier*: **SHALL** convey the code verifier value as defined in [PKCE](https://www.rfc-editor.org/info/rfc7636/)
  from which the *code_challenge* of the Authentication Request was derived.§

§oidc-28^ch-oidc-identity-provider:The Identity Provider **SHALL** validate the Access Token Request as follows:§

1. §oidc-79^ch-oidc-identity-provider:The Identity Provider **SHALL** identify the client using the `client_id`.§
2. §oidc-80?^ch-oidc-identity-provider:The Identity Provider **SHALL** authenticate the Relying Party, if the client application is
   registered as a confidential client.§
3. §oidc-81^ch-oidc-identity-provider:The Identity Provider **SHALL** verify that the authorization code was issued to the Relying Party
   in response to an Authentication Request.§
4. §oidc-82^ch-oidc-identity-provider:The Identity Provider **SHALL** verify that the authorization code was not used before.§
5. §oidc-83^ch-oidc-identity-provider:The Identity Provider **SHALL** verify that the value of the `redirect_uri` parameter sent with the
   Access Token Request matches the one sent with the Authentication
   Request.§
6. §oidc-84^ch-oidc-identity-provider:The Identity Provider **SHALL** verify that the value of the `redirect_uri` parameter sent with the
   Access Token Request matches one of the redirect URIs registered
   for the Relying Party.§
7. §oidc-85^ch-oidc-identity-provider:The Identity Provider **SHALL** verify that the `code_verifier` matches the `code_challenge` sent
   with the Authentication Request respecting the S256 code challenge
   method.§

#### Access Token Response

§oidc-29^ch-oidc-identity-provider:The Access Token Response message **SHALL** be used by the Identity Provider to convey
the Access Token and the ID Token to the Relying Party in response to the
Access Token Request.§ §oidc-30^ch-oidc-identity-provider:The Access Token Response message **SHALL** be sent
via the backchannel.§ §oidc-31^ch-oidc-identity-provider:The Access Token Response message **SHALL** be
compliant with an OAuth 2.0 Access Token Response message.§

§oidc-32^ch-oidc-identity-provider:The Access Token Response **SHALL** contain the following parameters:§
- §oidc-33^ch-oidc-identity-provider:*token_type*: The value **SHALL** be Bearer.§
- §oidc-34^ch-oidc-identity-provider:*expires_in --* The Token lifetime in seconds. The value **SHALL** be equal to *300* (5 minutes).§
- §oidc-35^ch-oidc-identity-provider:*access_token*: The value **SHALL** be an OAuth 2.0 compliant access token.§
- §oidc-36^ch-oidc-identity-provider:*id_token*: The value **SHALL** be an Identity Token as defined below.§

§oidc-37?^ch-oidc-identity-provider:In case of an error the Identity Provider **SHALL** respond a HTTP Error as defined
in [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html#TokenErrorResponse) specification.§

##### Message Example

```
HTTP/1.1 200 OK
Content-Type: application/json
{
  "token_type": "Bearer",
  "expires_in": 300,
  "access_token": "e4205d40-ac65-42b5-9327-4d7cecc08dd6",
  "id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc..."
}
```

#### Identity Token

§oidc-38^ch-oidc-identity-provider:The Identity Token **SHALL** be used by the Identity Provider to convey the Subject Identifier to the Relying 
Party.§ §oidc-39^ch-oidc-identity-provider:The Identity Token **SHALL** be compliant with the JSON Web Token and [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html#IDToken) specification.§

§oidc-40^ch-oidc-identity-provider:Identity Tokens **SHALL** be cryptographically signed using [JSON Web Signature](https://www.rfc-editor.org/info/rfc7515/).§ 

§oidc-41^ch-oidc-identity-provider:The Identity Token **SHALL** contain the following parameters:§
- §oidc-42^ch-oidc-identity-provider:*iss*: The value **SHALL** be a unique identifier of the Identity Provider as URL.§
- *sub*: The Subject Identifier of the user.
- §oidc-43^ch-oidc-identity-provider:*aud*: The value **SHALL** be the Client Identifier the Relying Party is registered at the Identity Provider.§
- §oidc-44^ch-oidc-identity-provider:*exp*: The time restricting the lifetime of the token. The value **SHALL** be equal to the current time plus 5 minutes.§
- *iat*: The time the token was issued by the Identity Provider.
- §oidc-45^ch-oidc-identity-provider:*nonce*: The value **SHALL** match the *nonce* value of the Authentication Request.§
- §oidc-46^ch-oidc-identity-provider:*jti*: The value **SHALL** be a unique identifier of the ID Token.§

§oidc-47^ch-oidc-identity-provider:The Subject Identifier attribute **SHALL** be persistent and **SHALL** be unique for the combination of the 
Subscriber and the Identity Provider.§ §oidc-48^ch-oidc-identity-provider,ch-oidc-relying-party:The Subject Identifier **SHALL** be confidential and never presented to the user or 
third party systems.§

The Identity Token MAY contain a session identifier in a *sid* attribute, if the Identity Provider 
supports per session logout.

§oidc-49^ch-oidc-relying-party:The Identity Token MAY contain other claims which **SHALL** be ignored by the Relying Party.§

§oidc-50^ch-oidc-relying-party:The Relying Parties **SHALL** validate Identity Tokens as follows:§

1. §oidc-86^ch-oidc-relying-party:The Relying Party **SHALL** verify that the unique identifier of the Issuer matches the one registered for the Identity Provider.§
2. §oidc-87^ch-oidc-relying-party:The Relying Party **SHALL** verify that the value of the *aud* parameter matches the Client Identifier of the Relying Party.§
3. §oidc-88^ch-oidc-relying-party:The Relying Party **SHALL** validate the signature according to [JSON Web Signature](https://www.rfc-editor.org/info/rfc7515/) using the algorithm specified in the JWT *alg* Header Parameter.§
4. §oidc-89^ch-oidc-relying-party:The Relying Party **SHALL** verify that the Identity Token is not expired and the current time is later than or equal to the time the token was issued by the Identity Provider.§
5. §oidc-90^ch-oidc-relying-party:The Relying Party **SHALL** verify that a *nonce* claim is present and its value matches the one that was sent in the Authentication Request.§

##### Message Example

```
{
  "iss": "http://client-simulator.org",
  "sub": "16d83c5e85c3",
  "aud": "rp-client-id",
  "exp": 1788875295,
  "iat": 1788874695,
  "nonce": "n-0S6_WzA2Mj",
  "jti": "ba43b960-ac25-437e-970a-f74031874c64"
}
```

#### UserInfo Request

§oidc-51^ch-oidc-relying-party:The UserInfo Request message **SHALL** be used by the Relying Party to retrieve identity data of the user from the Credential
Service Provider via the backchannel.§ §oidc-52^ch-oidc-relying-party:The UserInfo Request message **SHALL**
be compliant to the [OpenID Connect 1.0 UserInfo Request](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo) message.§

§oidc-53^ch-oidc-relying-party:The Relying Party **SHALL** send the Access Token in the HTTP Authorization header field as Bearer Token as defined 
in [OAuth 2.0 Authorization Framework: Bearer Token Usage](https://www.rfc-editor.org/info/rfc6750/).§

##### Message Example

The following listing displays a non-normative example for a UserInfo request with the access token in the 
http authorization header: 

```
 GET /userinfo HTTP/1.1
  Host: server.example.com
  Authorization: Bearer SlAV32hkKG
```

#### UserInfo Response

§oidc-54^ch-oidc-identity-provider:The UserInfo Response message **SHALL** be used by the Credential Service Provider to respond with the identity data of the user to
UserInfo Requests from the Relying Party using back-channel communication.§ §oidc-55^ch-oidc-identity-provider:The UserInfo Response message **SHALL** be a JSON Web Token
(JWT) compliant to the [OpenID Connect 1.0 UserInfo Response message](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo).§

§§oidc-56^ch-oidc-identity-provider:The UserInfo Response **SHALL** contain the parameters sub, first_name, family_name, gender and birthdate^The UserInfo Response **SHALL** contain the following parameters:

- *sub*: The subject identifier of the user.
- *first_name*: The first name of the user.
- *family_name*: The family name of the user.
- *gender*: The user's coded gender with the value from the value set EprGender (2.16.756.5.30.1.127.3.10.1.25).
- *birthdate*: The user's date of birth as ISO 8601-1:2019 formatted string.

§§

§oidc-57?^ch-oidc-identity-provider:If the Identity Provider delivers the GLN of healthcare professionals or assistants, the UserInfo Response 
**SHALL** contain a *gln* parameter conveying the GLN of healthcare professionals and assistants.§

Identity Providers MAY provide other identity claims as defined in 
the [OpenID Connect 1.0 Core](https://openid.net/specs/openid-connect-core-1_0.html) specification.

§oidc-58?^ch-oidc-identity-provider:In case of an error the Identity Provider **SHALL** respond a HTTP Error as defined in [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html#UserInfoError) specification.§

§oidc-59^ch-oidc-identity-provider:The UserInfo response message **SHALL** be signed using recommended cryptographic signature standards.§ §oidc-60^ch-oidc-relying-party:The signature of the UserInfo response message **SHALL** be validated by the Relying Party.§

##### Message Example

The following listing displays a (non-normative) example for the payload conveyed with the UserInfo response as signed JWT:
```
  {
   "sub": "248289761001",
   "first_name": "Maria",
   "family_name": "Mustermann",
   "gender": "F", 
   "birthdate": "1998-07-25", 
   "gln": "9801000050702" 
  }
```

#### Logout Request

§oidc-61^ch-oidc-relying-party:The *LogoutRequest* message **SHALL** be used by the Relying Party to initiate a logout of the user at the 
Identity Provider.§

§oidc-62^ch-oidc-relying-party:*LogoutRequest* messages **SHALL** be used by the Relying Party to redirect the User Agent to the Identity 
Provider compliant with the [OpenID Connect RP-Initiated Logout 1.0](https://openid.net/specs/openid-connect-rpinitiated-1_0.html) specification and 
the requirements defined in this section.§

§oidc-63^ch-oidc-relying-party:A *LogoutRequest* message **SHALL** convey the following parameters:§
- §oidc-64^ch-oidc-relying-party:*id_token_hint*: **SHALL** convey the Identity Token previously issued by the Identity Provider.§
- §oidc-65^ch-oidc-relying-party:*state*: **SHALL** convey an opaque value used to maintain the state
   between the request and the response to mitigate Cross-Site Request Forgery attacks.§

§oidc-66^ch-oidc-identity-provider:The Logout Request MAY contain other parameters which **SHALL** be ignored by the Identity Provider.§

§oidc-67^ch-oidc-identity-provider:The Identity Provider **SHALL** validate *LogoutRequest* messages by verifying that the Identity Token was 
issued by the Identity Provider for the requesting Relying Party and the user.§

##### Message Example

The following listing displays a non-normative example for a Logout Request sent by the Relying Party 
to redirect the user agent to the logout URL of the Identity Provider with the required *id_token_hint* 
and *state* and an optional *post_logout_redirect_uri*:

```
HTTP/1.1 301 Moved Permanently
Location: https://idp.com/logout?id_token_hint=eyJhbGciOiJIUz...&state=14424&post_logout_redirect_uri=https://relying-party.com/redirect
```

### Security Considerations

#### Front-channel Communication

§oidc-68^ch-oidc-identity-provider:The User Agent and the Identity Provider **SHALL** communicate through an authenticated and protected channel using 
TLS 1.2 or higher.§ §oidc-69^ch-oidc-identity-provider:The Identity Provider **SHALL** identify and authenticate itself towards the User Agent with class 2
X.509 certificates issued by a trusted certificate service provider according to ZertES; 
SR 943.03 and listed by the Swiss Accreditation Service (SAS).§

#### Back-channel Communication

§oidc-70^ch-oidc-identity-provider,ch-oidc-relying-party:The Identity Provider **SHALL** communicate with Relying Parties through an authenticated
and protected back-channel using TLS 1.2 or higher for access token and user info requests and
responses.§ 

§oidc-71^ch-oidc-identity-provider:The Identity Provider **SHALL NOT** use redirects through an intermediary user agent (e.g., Web Browser) to send requests
to Relying Parties.§

§oidc-72^ch-oidc-identity-provider:The Identity Provider **SHALL** identify and authenticate itself towards the Relying Parties with class 2
X.509 certificates issued by a trusted certificate service provider according to ZertES; SR 943.03 and listed by the Swiss
Accreditation Service (SAS).§

§oidc-73^ch-oidc-identity-provider,ch-oidc-relying-party:Identity Provider **SHALL** identify and authenticate the Relying Parties by using mutual TLS (mTLS) or the 
*private_key_jwt* option defined in 
the [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication) 
specification.§

§oidc-74^ch-oidc-relying-party:The Relying Party **SHALL** use a certificate issued by a Certificate Authority (CA) that is operated according to 
documented processes detailed in a Certificate Policy (CP) and Certificate Practice Statement (CPS) for 
digital signatures or the mTLS client certificate.§ 

§oidc-75^ch-oidc-identity-provider:The CA's processes **SHALL** meet the requirements of class 1 certificates defined within 
the [eCH-0048 PKI Certificate Classes standard Version 2.0](https://www.ech.ch/de/ech/ech-0048/2.0).§ This 
Certificate Authority (CA) MAY be operated by the Identity Provider or MAY be delegated by the Identity Provider 
to a provider on a contractual basis.



