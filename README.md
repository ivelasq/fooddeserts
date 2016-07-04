# fooddeserts

## Synopsis
This is a pet project calculating the minimum distance from the centroid of a Chicago community area to the nearest grocery store.

## Code Example

* grocery.R : R code

* grocery_min : output from R code

* Grocery_Stores_-_2013 : location of grocery stores, pulled from the Chicago Data Portal https://data.cityofchicago.org/Community-Economic-Development/Map-of-Grocery-Stores-2013/ce29-twzt

* Boundaries - Neighborhoods : boundaries of the neighborhoods

* centroids : centroid longitude and latitude, calculated by uploading shape files to http://shpescape.com/ft/upload/#

*  Census_Data_-_Selected_socioeconomic_indicators_in_Chicago__2008___2012: pulled from the Chicago Data Portal

```
##Calculate distances between centroid and CA grocery stores
dist <- geodist(grocery_loc$LATITUDE, grocery_loc$LONGITUDE, grocery_loc$ca_lat, grocery_loc$ca_long, units="km")
grocery_dist <- as.data.frame(cbind(grocery_loc, dist))
 
##Find minimum distance from centroid to a grocery store
grocery_min <- grocery_dist %>% group_by(COMMUNITY.AREA.NAME)
```
