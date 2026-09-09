This section specifies Swiss national extensions to the Mobile Access to Health Documents (MHD), which is [published](https://profiles.ihe.net/ITI/MHD/index.html) as an IHE ITI Trial Implementation profile.

The national extensions adds an additional transaction from the Document Source to the Document Recipient. 

### Scope  
An Health App can query, retrieve or publish data to/from the Health Dossier API using the transaction of the MHD profile. 
An Health App can Update Document Metadata for a published document with this national extension.  

###	Use Cases  
In addition to the Document Sharing Use Case for MHD the national extension defines the following Use Cases:

#### Healthcare professional corrects a published document
A healthcare professional or a health institution has published a document that contains incorrect data. The correction is made by publishing a new version of the document with the correct data; the incorrect document is neither overwritten nor removed, it remains accessible in the health dossier so that the correction stays traceable for the patient. How the corrected document is published is described in [ITI-65](iti-65.html#correction-of-a-published-document).

#### Document published in the health dossier of the wrong person
A healthcare professional or a health institution has published a document in the health dossier of the wrong person. Such a document is not corrected by a new version but has to be deleted, and the healthcare professional or the health institution which published it has to request its deletion itself. How the deletion is requested is described in [CH:MHD-1](ch-mhd-1.html#requesting-the-deletion-of-a-document).

#### Patient changes confidentiality code of a document
A patient wants to change the confidentiality code of one of his documents. The patient updates the confidentiality code in the Health App and the Health App submits the updated metadata through the Health API. 

#### Patient adds a personal note to a document
A patient and the healthcare professional or the health institution which published a document do not agree on the correctness of the data in that document, or the healthcare professional or the health institution which published it is no longer practising. The patient can then record a personal note on the document. The note is recorded with the metadata of the document, the document itself and its data stay unchanged and no new version of the document is published. How the note is recorded is described in [CH:MHD-1](ch-mhd-1.html#recording-a-personal-note).

#### Patient deletes a document
A patient wants a document of their health dossier to be deleted. The patient can have any document deleted, the ones they recorded themselves as well as the ones a healthcare professional or a health institution published, and a deleted document is irrevocably removed and afterwards no longer accessible in the health dossier. How the deletion is requested is described in [CH:MHD-1](ch-mhd-1.html#requesting-the-deletion-of-a-document).

###	Actors and Transactions  

<div>
{%include MHD_actor_diagram.svg %}
</div>
This figure shows the actors directly involved in the _Mobile Access to Health Documents_ Profile and the relevant 
transactions between them.

The Find Document Lists [[ITI-66]](https://profiles.ihe.net/ITI/MHD/ITI-66.html) transaction defined in [MHD](https://profiles.ihe.net/ITI/MHD/index.html) SHALL not be made available in this context.

### Actor options  

Options that can be selected for each actor in this profile, are listed in the table below. 

{:class="table table-bordered"}
| Actor                                         | Option Name               | Optionality  |
|-----------------------------------------------|---------------------------|-------------|
| Document Source                               | Health Dossier Metadata   | R           |
| Document Recipient                            | Health Dossier Metadata   | R           |
| Document Source                               | ITI-65 FHIR Documents Publish | R       |
| Document Recipient                            | ITI-65 FHIR Documents Publish | R       |

<figcaption ID="1">Table 1: Actor options.</figcaption>


#### Health Dossier Metadata Option

Metadata as defined in [CH MHD DocumentReference](StructureDefinition-ch-mhd-documentreference.html) SHALL be supported by the Document Source and Document Recipient.

#### ITI-65 FHIR Documents Publish Option

The [ITI-65 FHIR Documents Publish Option](https://profiles.ihe.net/ITI/MHD/index.html) SHALL be supported by the Document Source and Document Recipient, so that a FHIR document can be published as a FHIR document Bundle resource and does not have to be converted to a base64 encoded Binary resource. How a FHIR document is published is described in [ITI-65](iti-65.html#publishing-a-fhir-document).

### Required Actor Groupings  
This national extension enforces authentication and authorization for access control. Therefore actors of this profile SHALL be grouped with actors of other profiles according to the following table: 


{:class="table table-bordered"}
| Actor                                         | Required Grouping         | Optionality | Remark                                                             |
|-----------------------------------------------|---------------------------|-------------|--------------------------------------------------------------------|
| Document Recipient                            | IUA Resource Server       | R           | -                                                                  |
| Document Responder                            | IUA Authorization Client  | R           | -                                                                  |
| Document Source                               | IUA Authorization Client  | R           | Workflow Initiator Option or Technical User Option                 |
| Document Consumer                             | IUA Authorization Client  | R           | Workflow Initiator Option                                          |

<figcaption ID="2">Table 2: Grouping of MHD actors required by this national extension.</figcaption>

###	Process Flow
For the process flow of this profile and its interplay with the other profiles see [sequence diagrams](sequencediagrams.html). 

### Security Consideration
This national extension enforces authentication and authorization of access to the Document Recipient and Document Responder using the IUA profile as described in [IUA](iti-71.html#expected-actions-1).
