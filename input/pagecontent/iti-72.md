This section describes the national extension for the Swiss EPR to
the [Incorporate Access Token [ITI-72]](https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72) transaction
defined in the IUA profile published in the IHE IT Infrastructure Technical Framework Trial Implementation “Internet
User Authorization”.

### Scope

This transaction is used to incorporate authorization information into HTTP RESTful transactions.

### Actor Roles

**Actor:** IUA Authorization Client  
**Role:** Authorization component of an HTTP RESTful transaction client.      
**Actor:** IUA Resource Server  
**Role:** Authorization component of an HTTP RESTful transaction server.


This national extension restricts the Actor options of the IUA Trial Implementation to comply to the legal requirements
of the Swiss health record.

This national extension supports the JWT Token option only. The SAML Token and Introspection option allowed from 
the IUA Trial Implementation SHALL NOT be used.

### Referenced Standards

1. [IHE ITI Technical Framework Supplement Internet User Authorization (IUA) Revision 2.5](https://profiles.ihe.net/ITI/IUA/index.html)

### Expected Actions

When receiving a request the Resource Server SHALL: 
1. Verify the signature of the access token using the public key of the IUA Authorization Server that issued it.
2. Introspect the access token and ensure that it has not expired.

The Resource Server SHALL also:
1. Verify that the transaction is permitted by the token's `scope`, as defined in [ITI-71](iti-71.html#message-semantics).
2. Enforce the access rights defined in the holder-specific consent, as specified in [CH PPQm Consent](ppqm-consent.html).

The Resource Server MAY delegate the access decision to a policy enforcement service.

### Security Consideration

IUA Authorization Clients, Authorization Servers and Resource Server actors SHALL use signed JWT access tokens (JWS)
as specified in [ITI-71](iti-71.html#security-consideration). Unsigned JWT access tokens SHALL NOT be used. The JSON Web
Encryption (JWE) serialization SHALL NOT be used.

When receiving requests of transactions where the EPR-SPID is provided in the IUA token and in the transaction body,
the Resource Server SHALL verify that the `patient_id` attribute of the access token corresponds to the 
patient referenced in the resource request.

The actors SHALL support the _traceparent_ header handling, as defined in [Appendix: Trace Context](tracecontext.html).