##Problem Statement
Combine various authoratative data sources (for institute profile. people profile, collection catalog etc.)

ELViS needs to know various institutional information such as facilities, equipments, and labs. Currently there are several authoratative sources for this. How do we link and combine the data to create a single usable data source for ELViS? 

##Proof of Concept 

Using a simple [GraphQL server](https://github.com/guilouro/simple-graphql-server) we can query different types of data structures (or API endpoints). This can done using common REST methonds however the schema and type approach (see below) provides more flexibility and control. There is also a way to create Interface that creates abstraction for different data types. 

##Server Setup 
Install a simple [GraphQL server](https://github.com/guilouro/simple-graphql-server). This is locally accessible via [http://localhost:3000/graphiql](http://localhost:3000/graphiql). 

##Data
I created two json files. Basically those are my data sources for this experiment. 
One grabbed from GBIF and one created manually based on CETAF facility data. At the moment we are using datasets that describe similar entities but there are no links. 

GBIF: 

Assume we get a sample data from GBIF that looks like this: 

```
{
  "key": "490b5a6a-f62f-4fbc-83f4-432e3153f7a6",
  "code": "NNM",
  "name": "National Museum of Natural History, Naturalis",
  "description": "NNM is an historical acronym and is no longer used. For zoological collections, please refer to RMNH; geological collections use RGM, and botanical collections use L.",
  "active": false,
  "homepage": "http://www.naturalis.nl",
  "institutionalGovernance": "FEDERAL",
  "numberSpecimens": 0,
  "indexHerbariorumRecord": false,
  "createdBy": "GRBIO",
  "modifiedBy": "registry-migration-grbio.gbif.org",
  "created": "2013-04-24T08:55:00.000+0000",
  "modified": "2018-11-15T10:23:01.527+0000"
    
}

```

Now, assume [CETAF](https://cetaf.org/research_passport?q=node/1982) data describes various information about a lab in this format. 

```
{
        "id": 1982,
        "name": "Naturalis Biodiversity Center",
        "City": "Leiden", 
        "Country": "Netherlands",
        "lab": [
            {
                "scope": "Geology lab", 
                "detail": "Geology lab: micro raman, Xray, Faxitron, FITR en UV spectrofotometer, Orbis XRF;"
            },
          {
                "scope": "Morphology lab",
                "detail": "Morphology lab: micro Ct scan, TEM, FEG-SEM-EDS, low vacuum SEM;"
            }, 
          { 
                "scope": "DNA barcoding",
                "detail": "DNA barcoding facility: for high throughput genotyping, extraction and pipetting robots;"
          }
         ]
}
```

In GraphQL we define various types and schemas: 

```
type CetafFacility  {
    id: Int
    name: String
    City: String
    Country: String
    lab: [Lab]
}

type GbifInstitution { 
   key: String 
   name: String 
   homepage: String
 }
 type Lab {
    scope: String
    detail: String
}
```
And we define our Query type in one place: 

```
	type Query {
    searchgbif(code: String): GbifInstitution
    cetaffacility(id: Int): CetafFacility
    allcetafFacilities: [CetafFacility]
    allGbifInstitutions: [GbifInstitution]
    totalcetafFacilities: Int
    totalGbifInstitutions: Int
}
```

We have to write an app for the resolver. Here's an example in node.js 

```
const resolvers = {
    Query: {
        searchname: () => {name}, 
        searchgbif: (_, args) => allgbifinstitutions.find(searchgbif => searchgbif.code === args.code),
        cetaffacility: (_, args) => cetaffacilities.find(cetaffacility => cetaffacility.id === args.id),
        totalcetafFacilities: () => cetaffacilities.length, 
        allGbifInstitutions: () => allgbifinstitutions,
        totalGbifInstitutions: () => allgbifinstitutions.length,
        allcetafFacilities: () => cetaffacilities,
    }
}
```

Now, we use a graphQL client (such as graphiql) to resolver these queries. 

Our first query (provides the GBIF code and cetaf code) [of course the link here is known by us but this is to simply things]


```
{
  searchgbif (code: "BHUPM")
  {
     name
    key
    homepage
  }
cetaffacility(id: 1965) {
  id
  name
}
}
```

Result (based on the json files we described above) 

```

  "data": {
    "searchgbif": {
      "name": "Museum für Naturkunde Berlin",
      "key": "2bea4bb3-e0fa-46be-88fb-e311b23804e8",
      "homepage": "http://www.naturkundemuseum-berlin.de"
    },
    "cetaffacility": {
      "id": 1965,
      "name": "Museum für Naturkunde - Leibniz-Institut für Evolutions- und Biodiversitätsforschung"
    }
  }
}
```

Return all the institute names 

Query: 

```
{
  allcetafFacilities {
    id
    name
  }
  allGbifInstitutions
  { key 
  name 
  }
}

```
Result 

```
{
  "data": {
    "allcetafFacilities": [
      {
        "id": 1965,
        "name": "Museum für Naturkunde - Leibniz-Institut für Evolutions- und Biodiversitätsforschung"
      },
      {
        "id": 1982,
        "name": "Naturalis Biodiversity Center"
      }
    ],
    "allGbifInstitutions": [
      {
        "key": "490b5a6a-f62f-4fbc-83f4-432e3153f7a6",
        "name": "National Museum of Natural History, Naturalis"
      },
      {
        "key": "2bea4bb3-e0fa-46be-88fb-e311b23804e8",
        "name": "Museum für Naturkunde Berlin"
      }
    ]
  }
}
```

There is a way to combine these search in one query. 

 

