# Author: Niels Raes
# DPP Task 1.1 & 1.2 - User story analyses
# Date: March 2021

rm(list = ls(all=T)) # Empty workspace

Sys.getlocale()
Sys.setenv(LC_ALL="en_US.UTF-8")
Sys.getenv()

# ?Rprofile
.libPaths('D:/R/library')
.libPaths() # Defined in Rprofile

setwd("D:/Google Drive/DiSSCo/DiSSCo Prepare Project - DPP/WP1/DPP_T1.1/R_DPP_T1.1") # Set working directory
getwd()
load("D:/Google Drive/DiSSCo/DiSSCo Prepare Project - DPP/WP1/DPP_T1.1/R_DPP_T1.1/userStoryAnalyses.RData")
# save(list=ls(all=TRUE), file="D:/Google Drive/DiSSCo/DiSSCo Prepare Project - DPP/WP1/DPP_T1.1/R_DPP_T1.1/userStoryAnalyses.RData") # save RDATA for later use

library(utf8)
library(xlsx)
library(ggplot2)
library(ggtree) # https://bioconductor.org/packages/release/bioc/html/ggtree.html
# browseVignettes("ggtree")
library(ggdendro)
library(colorspace)
library(ape)
library(dendextend)
library(vegan)

# Load data ####

userStories <- read.xlsx('../DPP task 1.1. Use cases functional demands 20210326.xlsx', sheetName = 'Use cases', stringsAsFactors = FALSE)
head(userStories); dim(userStories) # 999  29
names(userStories)
str(userStories)
userStories <- userStories[, 1:13] # remove empty columns
userStories <- userStories[!is.na(userStories$ID.use.cases), ] # remove empty rows
head(userStories); dim(userStories) # 443  13
userStories <- as.data.frame(apply(userStories, 2, function(x)gsub('\\s+$', '', x)), stringsAsFactors = FALSE) # Remove trailing white spaces
userStories[userStories == '2D images'] <- '2D image'
userStories[userStories == '3D images'] <- '3D image'
userStories[userStories == 'Advanced search funcionality'] <- 'Advanced search functionality'
userStories[userStories == 'Annotation tools'] <- 'Tools for annotation' 
userStories[userStories == 'Digital representation of specimens'] <- '2D image' # Changed after consultation with Heli and Sabine

# demands <- as.vector(userStories[,8])
demands <- unique(c(as.vector(userStories[,8]), as.vector(userStories[,9]), as.vector(userStories[,10]), as.vector(userStories[,11]), as.vector(userStories[,12])))
demands <- sort(na.omit(demands))
demands
demands <- demands[demands != ""] # remove empty value
demands <- as.data.frame(demands)
demands # 35
write.csv(demands, 'demands.csv', row.names = FALSE)

# Manually edited categories

demands <- read.csv('demands_editted.csv', header=TRUE, stringsAsFactors = FALSE)
head(demands); dim(demands) # 35  2
demands <- demands[order(demands$demandsUpdated),]
demands

# Create empty matrix with demands as column names 

x <- matrix(nrow = 1, ncol = dim(demands)[1])
x <- as.data.frame(x)
names(x) <- demands[,2]
names(x)
x

# Merge userStories with demands matrix

userStoriesDemands <- cbind(userStories, x)
head(userStoriesDemands); dim(userStoriesDemands) # 443  48
userStoriesDemands[is.na(userStoriesDemands)] <- 0 # replace NA by 0, otherwise ifelse is not working

# Fill matrix with presence/absence data for demands

i=1
names(userStoriesDemands)

ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_2')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_3')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_4')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_5')] == 'Advanced search functionality'), 1, 0)

for(i in 1:dim(userStoriesDemands)[1]){
  
  # 1. accessPhysical
  userStoriesDemands[i, c('accessPhysical')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Physical access' | userStoriesDemands[i, c('functional_demand_2')] == 'Physical access' | userStoriesDemands[i, c('functional_demand_3')] == 'Physical access' | userStoriesDemands[i, c('functional_demand_4')] == 'Physical access' | userStoriesDemands[i, c('functional_demand_5')] == 'Physical access'), 1, 0)
  
  # 2. data:biochemicalGeochemical
  userStoriesDemands[i, c('data:biochemicalGeochemical')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Biochemical or geochemical data' | userStoriesDemands[i, c('functional_demand_2')] == 'Biochemical or geochemical data' | userStoriesDemands[i, c('functional_demand_3')] == 'Biochemical or geochemical data' | userStoriesDemands[i, c('functional_demand_4')] == 'Biochemical or geochemical data' | userStoriesDemands[i, c('functional_demand_5')] == 'Biochemical or geochemical data'), 1, 0)
  
  # 3. data:distribution
  userStoriesDemands[i, c('data:distribution')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Distribution data' | userStoriesDemands[i, c('functional_demand_2')] == 'Distribution data' | userStoriesDemands[i, c('functional_demand_3')] == 'Distribution data' | userStoriesDemands[i, c('functional_demand_4')] == 'Distribution data' | userStoriesDemands[i, c('functional_demand_5')] == 'Distribution data'), 1, 0)
  
  # 4. data:ecological
  userStoriesDemands[i, c('data:ecological')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Ecological data' | userStoriesDemands[i, c('functional_demand_2')] == 'Ecological data' | userStoriesDemands[i, c('functional_demand_3')] == 'Ecological data' | userStoriesDemands[i, c('functional_demand_4')] == 'Ecological data' | userStoriesDemands[i, c('functional_demand_5')] == 'Ecological data'), 1, 0)
  
  # 5. data:integration
  userStoriesDemands[i, c('data:integration')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Data integration' | userStoriesDemands[i, c('functional_demand_2')] == 'Data integration' | userStoriesDemands[i, c('functional_demand_3')] == 'Data integration' | userStoriesDemands[i, c('functional_demand_4')] == 'Data integration' | userStoriesDemands[i, c('functional_demand_5')] == 'Data integration'), 1, 0)
  
  # 6. data:isotopic
  userStoriesDemands[i, c('data:isotopic')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Isotopic data' | userStoriesDemands[i, c('functional_demand_2')] == 'Isotopic data' | userStoriesDemands[i, c('functional_demand_3')] == 'Isotopic data' | userStoriesDemands[i, c('functional_demand_4')] == 'Isotopic data' | userStoriesDemands[i, c('functional_demand_5')] == 'Isotopic data'), 1, 0)
  
  # 7. data:molecular
  userStoriesDemands[i, c('data:molecular')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Molecular data' | userStoriesDemands[i, c('functional_demand_2')] == 'Molecular data' | userStoriesDemands[i, c('functional_demand_3')] == 'Molecular data' | userStoriesDemands[i, c('functional_demand_4')] == 'Molecular data' | userStoriesDemands[i, c('functional_demand_5')] == 'Molecular data'), 1, 0)
  
  # 8. data:morphological
  userStoriesDemands[i, c('data:morphological')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Morphological data' | userStoriesDemands[i, c('functional_demand_2')] == 'Morphological data' | userStoriesDemands[i, c('functional_demand_3')] == 'Morphological data' | userStoriesDemands[i, c('functional_demand_4')] == 'Morphological data' | userStoriesDemands[i, c('functional_demand_5')] == 'Morphological data'), 1, 0)
  
  # 9. data:security
  userStoriesDemands[i, c('data:security')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Data security' | userStoriesDemands[i, c('functional_demand_2')] == 'Data security' | userStoriesDemands[i, c('functional_demand_3')] == 'Data security' | userStoriesDemands[i, c('functional_demand_4')] == 'Data security' | userStoriesDemands[i, c('functional_demand_5')] == 'Data security'), 1, 0)
  
  # 10. data:traits
  userStoriesDemands[i, c('data:traits')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Ecological data incl. traits' | userStoriesDemands[i, c('functional_demand_2')] == 'Ecological data incl. traits' | userStoriesDemands[i, c('functional_demand_3')] == 'Ecological data incl. traits' | userStoriesDemands[i, c('functional_demand_4')] == 'Ecological data incl. traits' | userStoriesDemands[i, c('functional_demand_5')] == 'Ecological data incl. traits'), 1, 0)
  
  # 11. image
  userStoriesDemands[i, c('image')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Images' | userStoriesDemands[i, c('functional_demand_2')] == 'Images' | userStoriesDemands[i, c('functional_demand_3')] == 'Images' | userStoriesDemands[i, c('functional_demand_4')] == 'Images' | userStoriesDemands[i, c('functional_demand_5')] == 'Images'), 1, 0)
  
  # 12. image:2D
  userStoriesDemands[i, c('image:2D')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == '2D image' | userStoriesDemands[i, c('functional_demand_2')] == '2D image' | userStoriesDemands[i, c('functional_demand_3')] == '2D image' | userStoriesDemands[i, c('functional_demand_4')] == '2D image' | userStoriesDemands[i, c('functional_demand_5')] == '2D image'), 1, 0)
  
  # 13. image:3D
  userStoriesDemands[i, c('image:3D')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == '3D image' | userStoriesDemands[i, c('functional_demand_2')] == '3D image' | userStoriesDemands[i, c('functional_demand_3')] == '3D image' | userStoriesDemands[i, c('functional_demand_4')] == '3D image' | userStoriesDemands[i, c('functional_demand_5')] == '3D image'), 1, 0)
  
  # 14. image:collection
  userStoriesDemands[i, c('image:collection')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Images related to collections' | userStoriesDemands[i, c('functional_demand_2')] == 'Images related to collections' | userStoriesDemands[i, c('functional_demand_3')] == 'Images related to collections' | userStoriesDemands[i, c('functional_demand_4')] == 'Images related to collections' | userStoriesDemands[i, c('functional_demand_5')] == 'Images related to collections'), 1, 0)
  
  # 15. image:label
  userStoriesDemands[i, c('image:label')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Label images' | userStoriesDemands[i, c('functional_demand_2')] == 'Label images' | userStoriesDemands[i, c('functional_demand_3')] == 'Label images' | userStoriesDemands[i, c('functional_demand_4')] == 'Label images' | userStoriesDemands[i, c('functional_demand_5')] == 'Label images'), 1, 0)
  
  # 16. interoperability
  userStoriesDemands[i, c('interoperability')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Interoperability' | userStoriesDemands[i, c('functional_demand_2')] == 'Interoperability' | userStoriesDemands[i, c('functional_demand_3')] == 'Interoperability' | userStoriesDemands[i, c('functional_demand_4')] == 'Interoperability' | userStoriesDemands[i, c('functional_demand_5')] == 'Interoperability'), 1, 0)
  
  # 17. legalAndPolicyFramework
  userStoriesDemands[i, c('legalAndPolicyFramework')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Legal and policy framework' | userStoriesDemands[i, c('functional_demand_2')] == 'Legal and policy framework' | userStoriesDemands[i, c('functional_demand_3')] == 'Legal and policy framework' | userStoriesDemands[i, c('functional_demand_4')] == 'Legal and policy framework' | userStoriesDemands[i, c('functional_demand_5')] == 'Legal and policy framework'), 1, 0)
  
  # 18. metadata
  userStoriesDemands[i, c('metadata')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Metadata' | userStoriesDemands[i, c('functional_demand_2')] == 'Metadata' | userStoriesDemands[i, c('functional_demand_3')] == 'Metadata' | userStoriesDemands[i, c('functional_demand_4')] == 'Metadata' | userStoriesDemands[i, c('functional_demand_5')] == 'Metadata'), 1, 0)
  
  # 19. metadata:collectionLevel
  userStoriesDemands[i, c('metadata:collectionLevel')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Metadata on collection level' | userStoriesDemands[i, c('functional_demand_2')] == 'Metadata on collection level' | userStoriesDemands[i, c('functional_demand_3')] == 'Metadata on collection level' | userStoriesDemands[i, c('functional_demand_4')] == 'Metadata on collection level' | userStoriesDemands[i, c('functional_demand_5')] == 'Metadata on collection level'), 1, 0)
  
  # 20. metadata:recordLevel
  userStoriesDemands[i, c('metadata:recordLevel')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Metadata on record level' | userStoriesDemands[i, c('functional_demand_2')] == 'Metadata on record level' | userStoriesDemands[i, c('functional_demand_3')] == 'Metadata on record level' | userStoriesDemands[i, c('functional_demand_4')] == 'Metadata on record level' | userStoriesDemands[i, c('functional_demand_5')] == 'Metadata on record level'), 1, 0)
  
  # 21. referenceSystemStandardLists
  userStoriesDemands[i, c('referenceSystemStandardLists')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Reference system & Standard lists' | userStoriesDemands[i, c('functional_demand_2')] == 'Reference system & Standard lists' | userStoriesDemands[i, c('functional_demand_3')] == 'Reference system & Standard lists' | userStoriesDemands[i, c('functional_demand_4')] == 'Reference system & Standard lists' | userStoriesDemands[i, c('functional_demand_5')] == 'Reference system & Standard lists'), 1, 0)
  
  # 22. searchAdvancedFunctionality
  userStoriesDemands[i, c('searchAdvancedFunctionality')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_2')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_3')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_4')] == 'Advanced search functionality' | userStoriesDemands[i, c('functional_demand_5')] == 'Advanced search functionality'), 1, 0)
  
  # 23. tools:analysis
  userStoriesDemands[i, c('tools:analysis')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for analysis' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for analysis' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for analysis' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for analysis' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for analysis'), 1, 0)
  
  # 24. tools:annotation
  userStoriesDemands[i, c('tools:annotation')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for annotation' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for annotation' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for annotation' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for annotation' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for annotation'), 1, 0)
  
  # 25. tools:clusteringRequests
  userStoriesDemands[i, c('tools:clusteringRequests')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for clustering requests' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for clustering requests' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for clustering requests' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for clustering requests' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for clustering requests'), 1, 0)
  
  # 26. tools:dataAnalysis
  userStoriesDemands[i, c('tools:dataAnalysis')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for data analysis' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for data analysis' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for data analysis' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for data analysis' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for data analysis'), 1, 0)
  
  # 27. tools:dataDiscovery
  userStoriesDemands[i, c('tools:dataDiscovery')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for data discovery' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for data discovery' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for data discovery' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for data discovery' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for data discovery'), 1, 0)
  
  # 28. tools:dataVisualization
  userStoriesDemands[i, c('tools:dataVisualization')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for data visualization' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for data visualization' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for data visualization' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for data visualization' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for data visualization'), 1, 0)
  
  # 29. tools:documentation
  userStoriesDemands[i, c('tools:documentation')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for documentation' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for documentation' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for documentation' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for documentation' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for documentation'), 1, 0)
  
  # 30. tools:downloadDataMetadata
  userStoriesDemands[i, c('tools:downloadDataMetadata')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for downloading data/metadata' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for downloading data/metadata' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for downloading data/metadata' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for downloading data/metadata' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for downloading data/metadata'), 1, 0)
  
  # 31. tools:georeferencing
  userStoriesDemands[i, c('tools:georeferencing')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for geo-referencing' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for geo-referencing' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for geo-referencing' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for geo-referencing' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for geo-referencing'), 1, 0)
  
  # 32. tools:identification
  userStoriesDemands[i, c('tools:identification')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for identification' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for identification' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for identification' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for identification' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for identification'), 1, 0)
  
  # 33. tools:reportingStatistics
  userStoriesDemands[i, c('tools:reportingStatistics')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for reporting & statistics' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for reporting & statistics' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for reporting & statistics' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for reporting & statistics' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for reporting & statistics'), 1, 0)
  
  # 34. tools:restrictAccess
  userStoriesDemands[i, c('tools:restrictAccess')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for limiting access to data' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for limiting access to data' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for limiting access to data' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for limiting access to data' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for limiting access to data'), 1, 0)
  
  # 35. tools:uploading
  userStoriesDemands[i, c('tools:uploading')] <- ifelse((userStoriesDemands[i, c('functional_demand_1')] == 'Tools for uploading' | userStoriesDemands[i, c('functional_demand_2')] == 'Tools for uploading' | userStoriesDemands[i, c('functional_demand_3')] == 'Tools for uploading' | userStoriesDemands[i, c('functional_demand_4')] == 'Tools for uploading' | userStoriesDemands[i, c('functional_demand_5')] == 'Tools for uploading'), 1, 0)
  
}

head(userStoriesDemands); dim(userStoriesDemands) # 443  48
str(userStoriesDemands)

# Set user category labels ####

table(userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2, useNA = c("ifany"))

userStoriesDemands$userCategoryLabel <- 'a' # Add label
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "1. Research (academic & non-academic, including citizen science)", c('userCategoryLabel')] <- "1. Research"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "2. Collection management", c('userCategoryLabel')] <- "2. Coll. Mgmt"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "3. Technical support (IT & IM)", c('userCategoryLabel')] <- "3. IT & IM"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "4. Policy (institutional, national & international)", c('userCategoryLabel')] <- "4. Policy"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "5. Education (academic & non-academic)", c('userCategoryLabel')] <- "5. Education"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "6. Industry", c('userCategoryLabel')] <- "6. Industry"
userStoriesDemands[userStoriesDemands$CATEGORY.based.on.ICEDIG.T6.2 == "7. External (media & empowerment initiatives)", c('userCategoryLabel')] <- "7. External"

table(userStoriesDemands$userCategoryLabel, useNA = c("ifany"))

head(userStoriesDemands); dim(userStoriesDemands) # 443  49
names(userStoriesDemands)
userStoriesDemands <- userStoriesDemands[,c(1:3,49,4:48)] # reorder columns

write.csv(userStoriesDemands, 'userStoriesDemandsMatrixLS.csv', row.names = FALSE)

# Life Sciences ####

table(userStoriesDemands$LIFE..EARTH.SCIENCES, useNA = c("ifany")) # 126       2     315 

userStoriesLife <- userStoriesDemands[userStoriesDemands$LIFE..EARTH.SCIENCES == 'LS' | userStoriesDemands$LIFE..EARTH.SCIENCES == 'ES / LS',]
head(userStoriesLife); dim(userStoriesLife) # 317  49

table(userStoriesLife$userCategoryLabel, useNA = c("ifany"))
userStoriesLifeMain <- as.data.frame(table(userStoriesLife$userCategoryLabel))
userStoriesLifeMain
userStoriesLifeMain <- userStoriesLifeMain[order(userStoriesLifeMain$Freq, decreasing=T),]
userStoriesLifeMain
barplot(userStoriesLifeMain$Freq)
dev.off()
p <- ggplot(data=userStoriesLifeMain, aes(x=Var1, y=Freq, fill=Freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + theme(axis.title.x = element_blank())
ggsave("userStoriesLifeMainCategory.png")

# Select all duplicate records including original
duplicateRecords <- userStoriesLife[duplicated(userStoriesLife[, 15:49]),]
duplicateRecords
dim(duplicateRecords) # 151  49 duplicate records

# Life Sciences - Cluster analysis ####

matrix <- as.matrix(userStoriesLife[, 15:49])
matrix[1:6,1:10]
dim(matrix) # 317  35
is.na(matrix)
matrix[is.na(matrix)] <- 0
rowSums(matrix)
barplot(table(rowSums(matrix), useNA = 'ifany'))
numberDemandsLifeSciences <- as.data.frame(table(rowSums(matrix), useNA = 'ifany'))
p <- ggplot(data=numberDemandsLifeSciences, aes(x=Var1, y=Freq, fill=Freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.title.x = element_blank()) + ggtitle("Number of demands - LS") +  theme(plot.title = element_text(hjust = 0.5))
ggsave("numberDemandsLifeSciences.png")

colSums(matrix)
demandsLifeScience <- as.data.frame(colSums(matrix))
demandsLifeScience
row.names(demandsLifeScience)
demandsLifeScience$demand <- row.names(demandsLifeScience)
names(demandsLifeScience)[1] <- 'freq'
head(demandsLifeScience); dim(demandsLifeScience)
demandsLifeScience <- demandsLifeScience[order(demandsLifeScience$freq, decreasing=T),]
demandsLifeScience <- demandsLifeScience[, c(2,1)]
rownames(demandsLifeScience) <- NULL # remove row names
head(demandsLifeScience); dim(demandsLifeScience)

write.csv(demandsLifeScience, 'demandsLifeScience.csv', row.names = FALSE)

dev.off()
p <- ggplot(data=demandsLifeScience, aes(x=reorder(demand, -freq), y=freq, fill=freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + theme(axis.title.x = element_blank()) + ggtitle("Demands LS user stories (n=317)") +  theme(plot.title = element_text(hjust = 0.5))
ggsave("demandsLifeScience.png")

# Distance matrix - From: https://stats.stackexchange.com/questions/86318/clustering-a-binary-matrix

# d = dist(matrix, method = "binary")
d = vegdist(matrix, method="jaccard", binary=T)
hc = hclust(d, method="average") # UPGMA
plot(hc)
# From: http://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning
plot(hc, hang = -1, cex = 0.25)

# p <- ggdendrogram(hc)
# print(p)
# p + geom_label(label.size = 0)
# p + geom_text(size=10)
# p + geom_text(check_overlap = TRUE)
# ggdendrogram(hc, size = 0.5)
# ggdendrogram(hc, rotate = TRUE, theme_dendro = FALSE)

str(hc)
hcd <- as.dendrogram(hc)  # hierarchical cluster dendrogram
str(hcd)
# Default plot
plot(hcd, type = "rectangle", ylab = "Height", horiz = F)
plot(hc, type = "rectangle", ylab = "Height", horiz = F)
head(userStoriesLife)
plot(hcd, type = "rectangle", ylab = "Height", horiz = F, cex= 0.1)

# https://cran.r-project.org/web/packages/dendextend/vignettes/introduction.html

# Cut cluster tree

k=13
hcdk <- cutree(hc, k) # hierarchical cluster dendrogram with k groups
hcdk # clustergroup assignment
plot(hc, hang = -1, cex = 0.3, labels = hcdk)

x <- hcd %>% labels
x # user story ID

dend <- hc
labels(dend) <- paste(x, userStoriesLife[x, c('userCategoryLabel')], sep="-")
pdf("dendrogramLife.labels.pdf", width=10, height=5)
dend %>% as.dendrogram %>% set("branches_k_color", k = k) %>% set("branches_lwd", 1) %>% set("labels_col", k=k) %>% set("labels_cex", 0.2) %>% plot(main = "DiSSCo user stories cluster graph - Life Sciences")
dev.off()

# Heatmap Life Sciences ####

names(userStoriesLife)

colors = rainbow_hcl(k)
plot(as.phylo(hc), hang = -1, cex = 0.6, labels = hcdk, tip.color = colors[hcdk])
heatmap(matrix, Rowv = hcd)
heatmap(matrix, Rowv = hcd, labRow = userStoriesLife$userCategoryLabel)
heatmap(matrix, Rowv = hcd, labRow = hcdk, cexRow = 0.5)

pdf("heatmapLife.pdf", width=9, height=7)
# heatmap(matrix, Rowv = hcd, labRow = hcdk, cexRow = 0.3, cexCol = 0.5)
# heatmap(matrix, vegdist(matrix, method="jaccard", binary=T), Rowv = hcd, labRow = paste(x, userStoriesLife[x, c('userCategoryLabel')], sep="-"), cexRow = 0.2, cexCol = 0.8, margin=c(11, 5)) #, margin=c(5,10)
heatmap(matrix, vegdist(matrix, method="jaccard", binary=T), Rowv = hcd, labRow = "", cexCol = 0.8, margin=c(11, 5)) #, margin=c(5,10)
dev.off()

# Earth Sciences ####

table(userStoriesDemands$LIFE..EARTH.SCIENCES, useNA = c("ifany")) # 126 315

userStoriesEarth <- userStoriesDemands[userStoriesDemands$LIFE..EARTH.SCIENCES == 'ES' | userStoriesDemands$LIFE..EARTH.SCIENCES == 'ES / LS',]
head(userStoriesEarth); dim(userStoriesEarth) # 128  49

table(userStoriesEarth$userCategoryLabel, useNA = c("ifany"))
userStoriesEarthMain <- as.data.frame(table(userStoriesEarth$userCategoryLabel))
userStoriesEarthMain
userStoriesEarthMain <- userStoriesEarthMain[order(userStoriesEarthMain$Freq, decreasing=T),]
userStoriesEarthMain
barplot(userStoriesEarthMain$Freq)
dev.off()
p <- ggplot(data=userStoriesEarthMain, aes(x=Var1, y=Freq, fill=Freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + theme(axis.title.x = element_blank())
ggsave("userStoriesEarthMainCategory.png")

# Select all duplicate records including original
duplicateRecordsEarth <- userStoriesEarth[duplicated(userStoriesEarth[, 15:49]),]
duplicateRecordsEarth
dim(duplicateRecordsEarth) # 56  49 duplicate records

# Earth Sciences - Cluster analysis ####

matrixEarth <- as.matrix(userStoriesEarth[, 15:49])
matrixEarth[1:6,1:10]
dim(matrixEarth) # 128  35
is.na(matrixEarth)
matrixEarth[is.na(matrixEarth)] <- 0

colSums(matrixEarth)
demandsEarthScience <- as.data.frame(colSums(matrixEarth))
demandsEarthScience
row.names(demandsEarthScience)
demandsEarthScience$demand <- row.names(demandsEarthScience)
names(demandsEarthScience)[1] <- 'freq'
head(demandsEarthScience); dim(demandsEarthScience)
demandsEarthScience <- demandsEarthScience[order(demandsEarthScience$freq, decreasing=T),]
demandsEarthScience <- demandsEarthScience[, c(2,1)]
rownames(demandsEarthScience) <- NULL # remove row names
head(demandsEarthScience); dim(demandsEarthScience) # 35  2

noDemand <- demandsEarthScience[demandsEarthScience$freq == 0, c('demand')]
noDemand # Column names that have value zero

demandsEarthScience <- demandsEarthScience[demandsEarthScience$freq != 0, ]
head(demandsEarthScience); dim(demandsEarthScience) # 29  2

write.csv(demandsEarthScience, 'demandsEarthScience.csv', row.names = FALSE)

dev.off()
p <- ggplot(data=demandsEarthScience, aes(x=reorder(demand, -freq), y=freq, fill=freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + theme(axis.title.x = element_blank()) + ggtitle("Demands ES user stories (n=128)") +  theme(plot.title = element_text(hjust = 0.5))
ggsave("demandsEarthScience.png")

# Remove columns without demand (6 cols)
matrixEarth <- as.data.frame(matrixEarth)
dim(matrixEarth) # 128  35
matrixEarth <- matrixEarth[, ! names(matrixEarth) %in% noDemand]
dim(matrixEarth) # 128  29
matrixEarth <- as.matrix(matrixEarth)
str(matrixEarth)

rowSums(matrixEarth)
barplot(table(rowSums(matrixEarth), useNA = 'ifany'))
numberDemandsEarthSciences <- as.data.frame(table(rowSums(matrixEarth), useNA = 'ifany'))
p <- ggplot(data=numberDemandsEarthSciences, aes(x=Var1, y=Freq, fill=Freq)) + geom_bar(stat="identity")
# p + theme(axis.title.x = element_blank())
p + theme(axis.title.x = element_blank()) + ggtitle("Number of demands - ES") +  theme(plot.title = element_text(hjust = 0.5))
ggsave("numberDemandsEarthSciences.png")

# Distance matrix - From: https://stats.stackexchange.com/questions/86318/clustering-a-binary-matrix

dEarth = vegdist(matrixEarth, method="jaccard", binary=T)
hcEarth = hclust(dEarth, method="average") # UPGMA
plot(hcEarth)
# From: http://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning
plot(hcEarth, hang = -1, cex = 0.5)

pEarth <- ggdendrogram(hcEarth)
print(pEarth)
pEarth + geom_label(label.size = 0.5)
pEarth + geom_text(size=10)
pEarth + geom_text(check_overlap = TRUE)
ggdendrogram(hcEarth, size = 0.5)
ggdendrogram(hcEarth, rotate = TRUE, theme_dendro = FALSE)

str(hcEarth)
hcdEarth <- as.dendrogram(hcEarth)  # hierarchical cluster dendrogram
str(hcdEarth)
# Default plot
plot(hcdEarth, type = "rectangle", ylab = "Height", horiz = F)
plot(hcEarth, type = "rectangle", ylab = "Height", horiz = F)
head(userStoriesEarth)
plot(hcdEarth, type = "rectangle", ylab = "Height", horiz = F, cex= 0.1)

# https://cran.r-project.org/web/packages/dendextend/vignettes/introduction.html

# Cut cluster tree
k=9
hcdkEarth <- cutree(hcEarth, k) # hierarchical cluster dendrogram with k groups
hcdkEarth # clustergroup assignment
plot(hcEarth, hang = -1, cex = 0.6, labels = hcdkEarth)

x <- hcdEarth %>% labels
x

dendEarth <- hcEarth
labels(dendEarth) <- paste(x, userStoriesEarth[x, c('userCategoryLabel')], sep="-")
pdf("dendrogramEarth.labels.pdf", width=10, height=5)
dendEarth %>% as.dendrogram %>% set("branches_k_color", k = k) %>% set("branches_lwd", 2) %>% set("labels_col", k=k) %>% set("labels_cex", 0.5) %>% plot(main = "DiSSCo user stories cluster graph - Earth Sciences")
dev.off()

# heatmap Earth ####

names(userStoriesEarth)

colors = rainbow_hcl(k)
plot(as.phylo(hcEarth), hang = -1, cex = 0.6, labels = hcdkEarth, tip.color = colors[hcdkEarth])
heatmap(matrixEarth, vegdist(matrixEarth, method="jaccard", binary=T), Rowv = hcdEarth, labRow = "", cexCol = 0.8, margin=c(11, 5)) #, margin=c(5,10), cexRow = 0.3

pdf("heatmapEarth.pdf", width=9, height=7)
# heatmap(matrixEarth, Rowv = hcdEarth, labRow = hcdkEarth, cexRow = 0.3, cexCol = 0.5)
heatmap(matrixEarth, vegdist(matrixEarth, method="jaccard", binary=T), Rowv = hcdEarth, labRow = "", cexCol = 0.8, margin=c(11, 5))
dev.off()