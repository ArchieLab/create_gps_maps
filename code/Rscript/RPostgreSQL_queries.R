print("If user has no access to the papio server, use the babase queries (../code/babase_queries) to download the data and save it in  (../data/babase)")

## setting up data connection
dbuser <- readline(prompt="Enter babase username: ")
dbpass <- readline(prompt="Enter babase password: ")
dbname <- "babase";
dbhost <- "localhost";
dbport <- "22222"
drv <-dbDriver("PostgreSQL")

##open a connection to the database
con <- dbConnect(drv, host=dbhost, port=dbport, dbname=dbname, user=dbuser, password=dbpass)

## download the data
locations_query <- readQuery("locations.sql")
locations <- data.table(dbGetQuery(con, locations_query))
fwriteQuery(locations)

swerb_data_query <- readQuery("swerb_data.sql")
swerb_data <- data.table(dbGetQuery(con, swerb_data_query))
fwriteQuery(swerb_data)



