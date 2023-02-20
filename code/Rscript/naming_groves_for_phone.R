#file.edit("Rsetup_source.R")
source("./code/Rscript/Rsetup_source.R")
#shell("start cmd @cmd /k ssh -L 22222:localhost:5432 daj23@papio.biology.duke.edu")

## download the data from babase
## You will be promted for your babase usename and password
## There might be a warning related to an unknown postgresql field type.
## This warning can be ignored.
source("./code/Rscript/RPostgreSQL_queries.R") 

## open the location data
locations <- load_babase_data("locations")
locations[, date := ymd(date)]
setorder(locations, date)                          ## set order 
locations[, x := as.integer(x)]                    ## make the x as number
locations[, y := as.integer(y)]                    ## make the y as number
locations[, name := loc]                           ## make the y as number

locations_coords <- locations[,c("x", "y"), with = FALSE]
locations_data <- locations[, -c("x","y"), with = FALSE]
locations_data$sym[locations_data$type == 'G' ] <- 'Circle, Green'
locations_data$sym[locations_data$type == 'W' ] <- 'Circle, Blue'

packages <- c("rgdal",    
              "sp")            

## install packages if needed and open libaries
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())), dependencies = TRUE)  
}
lapply(packages, require, character.only = TRUE, warn.conflicts = TRUE, quietly = FALSE)

locations_mat <- as.matrix(locations_coords)
locations_points <- SpatialPoints(coords = locations_mat)
locations_spdf <- SpatialPointsDataFrame(locations_points, data=locations_coords)
locations_spdf@data <- cbind(locations_spdf@data, locations_data)
proj4string(locations_spdf) <- NA_character_
proj4string(locations_spdf) <- CRS("+init=EPSG:32737")
#proj4string(locations_spdf) <- CRS("+proj=longlat")
locations_spdf_WGS84 <- spTransform(locations_spdf, CRS("+init=epsg:4326"))

map_folder <- here::here("map")
map_folder_current_date <- paste(here::here("map"), "/",current_date, sep="")
if (!file.exists(map_folder)) system("cmd.exe", input =paste('mkdir ', '"',  map_folder, '"', sep=""))
if (!file.exists(map_folder_current_date)) system("cmd.exe", input =paste('mkdir ', '"',  map_folder_current_date, '"', sep=""))

writeOGR(locations_spdf_WGS84, dsn=paste(map_folder, "/", "locations.gpx", sep=""),
         dataset_options="GPX_USE_EXTENSIONS=yes",layer="waypoints",driver="GPX", overwrite_layer = T)

writeOGR(locations_spdf_WGS84, dsn=paste(map_folder_current_date, "/", "locations_" ,current_date, ".gpx", sep=""),
         dataset_options="GPX_USE_EXTENSIONS=yes",layer="waypoints",driver="GPX", overwrite_layer = T)

print("The map was created")
