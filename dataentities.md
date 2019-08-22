
For ELViS we need to know about the institution, collection, facilities, persons/expert involved with the institution.

These are the entities we need:

##Institution 


* inst_id 
* inst_code
* inst_name  
* country 
* address        
* home_url       
* collection_summary 
* facilities

## Collection 

* coll_id 
* inst_id        
* coll_name       
* coll_code       
* coll_size       
* collection_type 
* coll_status     
* coll_url

## Facilities 

* facility_id 
* facility_type
* facility_description 
* inst_id

## Specimen 

* specimen_id
* coll_id
* inst_id
* scientific_name

## Genebank 

* accession_id 
* scientific_name
* specimen_voucher
* molecule_type

## Person 
* personal_id
* name
* email
* inst_id

## Publication 
* publication_id
* specimen_id 
* inst_id 
* personal_id


##Relationship 

InstA has CollectionB 
CollectionB contains SpecimenX