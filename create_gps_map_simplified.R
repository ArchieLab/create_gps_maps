## This scrip will create the maps that are uploaded used on the maps of the team in the field. 

## It will show different symbols for the groves and waterholes

## you will need a vpn connection to Duke and create a ssh tunnel.
## ssh -L 22222:localhost:5432 DUKE_USERBAME@papio.biology.duke.edu

## You will be prompted to give you babase username and password
source("./code/Rscript/naming_groves_for_phone_simplified.R")

## The final map will be in the main folder
