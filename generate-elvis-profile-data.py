#!/usr/bin/python
# coding: latin-1
###########################################################
#   A simple JSON parser 
#   using Bloodhound API 
#   to generate data for ELViS
#
#   generate-elvis-profile-data.py, v0.5 Sharif Islam, July 18, 2019
#
#
########################################################
import urllib2, json
import os 
import sys 

if len (sys.argv) != 2 :
    print "Usage: python "+sys.argv[0] + " <ORCID>"
    print "!!! Please provide a valid ORCID !!!"
    sys.exit (1)

def main(): 
 orcid          =  str(sys.argv[1])
 bhoundsrvr     = 'https://bloodhound-tracker.net/'
 specimenjson   = bhoundsrvr + sys.argv[1] + '/' + 'specimens.json'
 url            = urllib2.urlopen(specimenjson)
 data           = json.load(url)

  
 # Based on the ORCID we need 
 # the specimens identified by the person
 # For recorded we need another data item 

 idf  = data["@reverse"]['identified']
 i=0
 while i < len(idf):
      occurrenceID    = idf[i]['occurrenceID']
      institutionCode = idf[i]['institutionCode']
      catalogNumber   = idf[i]['catalogNumber']
      scientificName  = idf[i]['scientificName']
      gbif            = idf[i]['sameAs']
      # PRINT 
      print scientificName,occurrenceID,institutionCode,catalogNumber,gbif
      i += 1 

if __name__ == '__main__':
  main()
