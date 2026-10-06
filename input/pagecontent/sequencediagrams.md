Sample sequence diagrams to illustrate the usage for reading documents as a patient or healthcare professional:

### Patient access from a portal

<div>{% include /3_02_read_pat.svg %}</div>

### User Access from an integrated Primary System to read documents

<div>{% include /3_02_read_hcp.svg %}</div>

### User Access from an integrated Primary System to publish documents

<div>{% include /3_02_write_hcp.svg %}</div>

### Retrieve the EPR-SPID of a patient known by its AHVN13

A Primary System knows the patient by the minimal demographics and the AHVN13 (e.g. from the health insurance card) and
retrieves the EPR-SPID with a [Patient Demographics Match [ITI-119]](iti-119.html) using a basic access token
(see [PDQm use case](iti-pdqm.html#retrieve-the-epr-spid-of-a-patient-known-by-its-social-security-number)).

<div>{% include /3_02_read_pdqm_ahvn13.svg %}</div>

### Writing documents from clinical archives

<div>{% include /3_02_write_tcu.svg %}</div>
