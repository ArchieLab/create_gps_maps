## Clear workspace
rm(list=ls())

# install (if needed) and open the following packages
packages <- c("cowplot",
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

## Download here package from github if needed and open the library for relative links
if ("here" %in% rownames(installed.packages()) == FALSE){
  if("devtools" %in% rownames(installed.packages()) == FALSE) install.packages("devtools") 
  devtools::install_github("krlmlr/here")
}
library(here)
#packrat::set_opts(external.packages = c("formatR"))

## create a current date variable
current_date <- format(Sys.time(), "%Y%m%d")

## set folder directories
code_folder <- here::here("code")
query_folder <- here::here("code/babase_queries/")
Rscript_folder <- here::here("code/Rscript/")
data_folder <- here::here("data")
data_babase_folder <- here::here("data/babase/")
data_babase_folder_current_date <- paste(here::here("data/babase/"), "/",current_date, sep="")
data_R_folder <- here::here("data/R")
data_R_folder_current_date <- paste(here::here("data/R"), "/",current_date, sep="")

## create directories if they do not excist
if (!file.exists(data_folder)) system("cmd.exe", input =paste('mkdir ', '"',  data_folder, '"', sep=""))
if (!file.exists(data_R_folder)) system("cmd.exe", input =paste('mkdir ', '"',  data_R_folder, '"', sep=""))
if (!file.exists(data_R_folder_current_date)) system("cmd.exe", input =(paste('mkdir ', '"',  data_R_folder_current_date, '"', sep="")))
if (!file.exists(data_babase_folder)) system("cmd.exe", input =paste('mkdir ', '"',  data_babase_folder, '"', sep=""))
if (!file.exists(data_babase_folder_current_date)) system("cmd.exe", input = paste('mkdir ', '"',  data_babase_folder_current_date, '"', sep=""))
  

## some data manipulation functions
## function to read babase queries stored in query_folder 
readQuery<-function(file) {
  query_text <- readLines(paste(query_folder, file, sep="/"))
  query_code <- query_text[-(grep("--", query_text))]
  paste(query_code, collapse = " ")
}

## A current version is saved in the main folder and backup files are saved under the data that the datya  was downloaded.  
fwriteQuery<-function(data.table) {
  data.name <- substitute(data.table)
  fwrite(x = data.table, file=paste(data_babase_folder, "/",data.name , ".csv", sep=""))
  fwrite(x= data.table, file=paste(data_babase_folder_current_date, "/", data.name, "_", current_date, ".csv", sep=""))
}

## load data
load_babase_data <- function(dataset) data.table(read.csv(paste(data_babase_folder, "/", dataset,".csv", sep=""), header=TRUE, na.strings=""))
