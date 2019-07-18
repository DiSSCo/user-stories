## Minimum data for ELViS

### Problem and Goals 

ELViS will handle various visit, loan, and digitisation requests. In order to do that it needs at least three types of datasets: 
1. Institutional data (location, description, facilities etc) 
2. Researcher/expert profile data 
3. Collection Index. 

In this test and example, we focus on 1) and 2). The collectin index prototype is currently [under construction](http://nsidr.org/). 

The main goal is to gather and link relevant information for various authoritative data sources (such as GBIF, CETAF). 

We also need to verify the data coming from different sources. For example, trusted data provider list? 

### Requirements 
(and related user stories) 

1. Provide researcher/expert/staff profile 

https://github.com/DiSSCo/user-stories/issues/82 'Know who is in charge of the collection'

2. Borrower profile 

https://github.com/DiSSCo/user-stories/issues/10
https://github.com/DiSSCo/user-stories/issues/26 'Assess and validate the request for registration'

3. Search and query by name, ORCID 
https://github.com/DiSSCo/user-stories/issues/138 'Search for experts'
4. Link the person with the institution. 
6. Link the person with various research output (such as publication, specimen identification). 
6. Provide facility data 

https://github.com/DiSSCo/user-stories/issues/90 'Indicate what facilities one like to use during a visit'
https://github.com/DiSSCo/user-stories/issues/6 'Visit a relevant institution for a schedule/taxonomic group'

### Criteria for authoritative data providers and on criteria for people profiles

* Minimum items needed: Linkable ID, name, description. 
* API (if not API some way to import/export data)
* Standard parsable output (such as JSON, csv) 
* Linkable items (such as institutionCode, occurrenceID, facility id, lab id, ORCID). 
* For People profile we need 
   - Linkable institutionCode
   - Verification method? Trust? 
   - Speciality, expertise (such as how many publications, research topic etc). 
 * Data Verification method? Trust?  
### Constraints 

1. Not all data sources provide API. 
2. How do we link different sources? What to link. For example, 'Institution code' in GBIF and CETAF are not the same. 

### Test, sample data 

Steps: 

1. Using the [Bloodhound](https://bloodhound-tracker.net/) web service grab a list of public profile (includes ORCID and Wikidata Identifiers) 
2. For each of these profile we get a json data (grabbed from GBIF) dump regarding the specimen record associated with that person. 
For example, [https://bloodhound-tracker.net/0000-0001-7618-5230/specimens.json](https://bloodhound-tracker.net/0000-0001-7618-5230/specimens.json) provides us with a list of recods associated with an ORCID. Using a simple python json parser we can generated a item like this which links to a specific gbif record. 



```
identifiedBy|Shorthouse, D.
decimalLatitude|56.839
occurrenceID|urn:catalog:UASM:UASM329573
family|Linyphiidae
countryCode|CA
sameAs|https://gbif.org/occurrence/769279710
country|Canada
institutionCode|University of Alberta Museums (UAM)
catalogNumber|UASM329573
typeStatus|None
collectionCode|UASM
eventDate|2004-07
decimalLongitude|-118.340
scientificName|Oreonetides vaginatus
dateIdentified|2010
year|None
recordedBy|Pinzon, J.
@id|https://gbif.org/occurrence/769279710
@type|PreservedSpecimen
```

Ideally we want to link the 'institutionCode' (UASM) to GBIF registry which has an unique id: [https://www.gbif.org/grscicoll/institution/fb10ac30-e517-4f2b-8d11-c6be465c38a5](https://www.gbif.org/grscicoll/institution/fb10ac30-e517-4f2b-8d11-c6be465c38a5)

And bring the facilities data from [CETAF](https://cetaf.org/research_passport). 


* How many laboratories are in use in your institution? 
   - List of laboratories 
* Number of permanent exhibitions 
   - List of permanent exhibitions  
   - Exhibition URL 
   - Number of recent exhibitions 
   - Recent Temporary Exhibitions 
   - Number of current exhibitions 
   - Current Temporary Exhibitions 
   - Number of future exhibitions 
   - Future exhibitions
