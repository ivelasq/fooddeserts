#Libraries
library(plyr)
library(gmt)

#Grocery Store Data
grocery <- read.csv("Grocery_Stores_-_2013.csv")
grocery_loc <- grocery[c(8,15,16)]
  
##Community Areas (CA) Centroids
centroids <- read.csv("centroids.csv")

####CA Longitudes
x <- centroids$geometry_pos
y <- regexpr('-{1,50}.{1,50}', x, TRUE)
z <- regexpr(',', x, TRUE)-1
ca_long <- substr(x,y, z)

####CA Latitudes
a <- centroids$geometry_pos
b <- regexpr(',{1,50}.{1,50}', a, TRUE)+1
c <- regexpr(',0', a, TRUE)-1
ca_lat <- substr(a,b,c)

##Data for merging
centroids <- as.data.frame(cbind(centroids, ca_lat, ca_long))
centroids_loc <- centroids[c(4,9,10)]
centroids_loc <- rename(centroids_loc, c("pri_neigh"="COMMUNITY.AREA.NAME"))
library(dplyr)
centroids_loc <- mutate_each(centroids_loc, funs(toupper))
centroids_loc$ca_lat <- as.numeric(centroids_loc$ca_lat)
centroids_loc$ca_long <- as.numeric(centroids_loc$ca_long)

##Merge CA Centroids and Grocery Store Data
grocery_loc <- merge(grocery_loc, centroids_loc, by = "COMMUNITY.AREA.NAME" )

##Calculate distances between centroid and CA grocery stores
dist <- geodist(grocery_loc$LATITUDE, grocery_loc$LONGITUDE, grocery_loc$ca_lat, grocery_loc$ca_long, units="km")
grocery_dist <- as.data.frame(cbind(grocery_loc, dist))

##Find minimum distance from centroid to a grocery store
grocery_min <- grocery_dist %>% group_by(COMMUNITY.AREA.NAME) %>% slice(which.min(dist))

plot(grocery_min$dist)

#Income Data (because why not)
income <- read.csv("Census_Data_-_Selected_socioeconomic_indicators_in_Chicago__2008___2012.csv")
percap <- income[c(2,8)]
percap <- mutate_each(percap, funs(toupper))
percap$PER.CAPITA.INCOME <- as.numeric(percap$PER.CAPITA.INCOME)

grocery_min <- merge(grocery_min, percap, by = "COMMUNITY.AREA.NAME" )

plot(grocery_min$PER.CAPITA.INCOME, grocery_min$dist)

write.csv(grocery_min, file = "grocery_min.csv")
