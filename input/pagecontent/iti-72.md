This section describes the national extension for the Swiss Health Dossier to
the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction
defined in the IUA profile published in the IHE IT Infrastructure Technical Framework Trial Implementation “Internet
User Authorization”.

### Scope

This transaction is used to incorporate authorization information into HTTP RESTful transactions.

### Actor Roles

**Actor:** Authorization Client  
**Role:** Authorization component of an HTTP RESTful transaction client.      
**Actor:** Resource Server  
**Role:** Authorization component of an HTTP RESTful transaction server.


This national extension restricts the Actor options of the IUA Trial Implementation to comply with the legal requirements
of the Health Dossier.

This national extension supports the JWT Token option only. The SAML Token option and the Token Introspection option
of the IUA Trial Implementation SHALL NOT be used.

### Referenced Standards

1. [IHE ITI Technical Framework Supplement Internet User Authorization (IUA) Revision 2.5](https://profiles.ihe.net/ITI/IUA/index.html)

### Expected Actions

When receiving a request, the Resource Server SHALL: 
1. Verify the signature of the access token using the public key of the Authorization Server that issued it.
2. Validate the access token and ensure that it has not expired (`exp`) and is already valid (`nbf`).
3. Verify that the `aud` claim of the access token contains the base URL of the Resource Server.
4. Verify that the `person_id` of the access token identifies the holder of the health dossier the request refers to,
   if the request refers to a health dossier. The Resource Server SHALL reject the request if they differ.

The Resource Server SHALL also:
1. Verify that the transaction is permitted by the token's `scope`, as defined in [ITI-71](iti-71.html#message-semantics).
2. Enforce the access rights defined in the holder-specific consent, as specified in [CH PPQm Consent](ppqm-consent.html).

The Resource Server MAY delegate the access decision to a policy enforcement service.

### Security Consideration

Authorization Clients, Authorization Servers and Resource Servers SHALL use signed JWT access tokens (JWS)
as specified in [ITI-71](iti-71.html#security-consideration). Unsigned JWT access tokens SHALL NOT be used. The JSON Web
Encryption (JWE) serialization SHALL NOT be used.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).
