## Clear workspace
rm(list=ls())

#file.edit("Rsetup_source.R")
#source("./code/Rscript/Rsetup_source.R")
#shell("start cmd @cmd /k ssh -L 22222:localhost:5432 daj23@papio.biology.duke.edu")

# install (if needed) and open the following packages
packages <- c("cowplot",
              "tidyverse",
              "data.table",
              "DBI",
              "lubridate",
              "rgdal",
              "RPostgreSQL",
              "sp",
              "sqldf")            


## install packages if needed and open libaries
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())), dependencies = TRUE)  
}
lapply(packages, require, character.only = TRUE, warn.conflicts = TRUE, quietly = FALSE)


print("If user has no access to the papio server, use the babase queries (../code/babase_queries) to download the data and save it in  (../data/babase)")

## setting up data connection
dbuser <- readline(prompt="Enter babase username: ")
dbpass <- readline(prompt="Enter babase password: ")
dbname <- "babase";
dbhost <- "localhost";
dbport <- "22222"
drv <-dbDriver("PostgreSQL")

##open a connection to the database
babase <- dbConnect(drv, host=dbhost, port=dbport, dbname=dbname, user=dbuser, password=dbpass)

locations <- data.table(dbGetQuery(con = babase, "SELECT swerb_gws.type, swerb_gws.loc, swerb_gw_loc_data.date, swerb_gw_loc_data.xysource,  altname, 
       start, finish,
       swerb_gw_locs.x, swerb_gw_locs.y, swerb_gw_loc_data.notes
FROM swerb_gw_loc_data
INNER JOIN swerb_gws
ON swerb_gws.loc = swerb_gw_loc_data.loc
INNER JOIN swerb_gw_locs
ON swerb_gw_locs.loc = swerb_gw_loc_data.loc AND swerb_gw_locs.date = swerb_gw_loc_data.date;"))


locations[, date := ymd(date)]
setorder(locations, date)                          ## set order 
locations[, x := as.integer(x)]                    ## make the x as number
locations[, y := as.integer(y)]                    ## make the y as number
locations[, name := loc]                           ## make the y as number

locations_coords <- locations[,c("x", "y"), with = FALSE]
locations_data <- locations[, -c("x","y"), with = FALSE]
locations_data$sym[locations_data$type == 'G' ] <- 'Circle, Green'
locations_data$sym[locations_data$type == 'W' ] <- 'Circle, Blue'

locations_mat <- as.matrix(locations_coords)
locations_points <- SpatialPoints(coords = locations_mat)
locations_spdf <- SpatialPointsDataFrame(locations_points, data=locations_coords)
locations_spdf@data <- cbind(locations_spdf@data, locations_data)
proj4string(locations_spdf) <- NA_character_
proj4string(locations_spdf) <- CRS("+init=EPSG:32737")

#proj4string(locations_spdf) <- CRS("+proj=longlat")
locations_spdf_WGS84 <- spTransform(locations_spdf, CRS("+init=epsg:4326"))

writeOGR(locations_spdf_WGS84, "locations.gpx",
         dataset_options="GPX_USE_EXTENSIONS=yes",layer="waypoints",driver="GPX", overwrite_layer = T)

print("The map was created")
