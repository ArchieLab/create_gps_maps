## This script will create the maps that are uploaded to make maps on the GPS units used by the team in the field.

## It will show different symbols for the groves and waterholes

## you will need a vpn connection to Duke and create a ssh tunnel.
## ssh -L 22222:localhost:5432 DUKE_USERBAME@papio.biology.duke.edu

## You will be prompted to give you babase username and password
source("./code/Rscript/naming_groves_for_phone.R")

## The final map will be in the map folder
## Send the locations.gpx file to Beth
## It also saves a version per date
