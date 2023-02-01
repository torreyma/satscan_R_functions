###disable scientific notation###
options(scipen = 999)

###load packages###
library(data.table)

data.table::setDTthreads(1)


##MT: testing this as a non-function. uncomment next line (and matching }) when you want to re-functionize it:
# download_USCB_TIGER_files <- function(FIPS_dt,USCB_TIGER.path){


##MT:  Testing section ####################################################
##MT: -- to be moved to a separate file when it works ####
##MT: These are for calling the functions below, so they shouldn't be here

###specify place to store USCB TIGER files###
USCB_TIGER.path <- file.path(Sys.getenv('HOME'),"DOHMH-local/satscan2022-census-downloads")

###specify data table containing state and county FIPS codes###
FIPS.dt <- data.table(state=rep("36",5),county=c("061","005","047","081","085")) ##MT: creates a 2-column dt with 36 filling one column and the county codes filling the other


###########################################################################


##MT: skip this line until you make it a function:	
##MT:	FIPS.dt <- copy(as.data.table(FIPS_dt))

	###pad state and county codes with leading zeros###
	##MT: these don't do anything on our sample dt since they are already in the right format
	##MT: cept possibly make them numeric.
	FIPS.dt[,state := sprintf("%02d", as.numeric(state))] ##MT: makes state 2 digits with a leading 0
	FIPS.dt[,county := sprintf("%03d", as.numeric(county))] ##MT: makes county 3 digits with a leading 0
	
	FIPS.dt <- unique(FIPS.dt[,c("state","county"),with=FALSE]) ##MT: checks all the columns(?) are unique. Not sure what with=FALSE does

##MT -- original line:	base.URL <- "https://www2.census.gov/geo/tiger/TIGER2019"
##MT: let's try:	
	YEAR  <- "2022" ##MT: adding this variable so the year can be changed easily; leave in function though
	tl_YEAR  <- paste0("tl_",YEAR,"_") ##MT: this format for the year is used in the filename construction in the function calls below.
	base.URL <- paste0("https://www2.census.gov/geo/tiger/TIGER",YEAR)

	old.wd <- getwd() ##MT: save the current wd so it can be restored at the bottom of these this function.

	setwd(USCB_TIGER.path)
	
	###############################
	###download faces shapefiles###
	###############################

	main.URL <- file.path(base.URL,"FACES")
	main.path <- file.path(USCB_TIGER.path,"FACES")

	for (j in 1:nrow(FIPS.dt)){ ##MT: run this on every row in FIPS.dt

		#j <- 1 ##MT: GC had this commented out; something that didn't work 
		
		this.URL <- file.path(main.URL,paste0(tl_YEAR,FIPS.dt[j]$state,FIPS.dt[j]$county,"_faces.zip"))

		file <- basename(this.URL)
		
		###download compressed file###
		download.file(this.URL, file)
		
		###unzip compressed file###
		unzip(file, exdir = file.path(main.path,tools::file_path_sans_ext(file)))
		
		###removed compressed file###
		file.remove(file.path(USCB_TIGER.path,file))
		
	}
	
	cat("USCB TIGER FACES files downloaded.\n")

	invisible(gc())


	###############################
	###download edges shapefiles###
	###############################

	main.URL <- file.path(base.URL,"EDGES")
	main.path <- file.path(USCB_TIGER.path,"EDGES")

	for (j in 1:nrow(FIPS.dt)){

		#j <- 1
		
		this.URL <- file.path(main.URL,paste0(tl_YEAR,FIPS.dt[j]$state,FIPS.dt[j]$county,"_edges.zip"))

		file <- basename(this.URL)
		
		###download commpressed file###
		download.file(this.URL, file)
		
		###unzip compressed file###
		unzip(file, exdir = file.path(main.path,tools::file_path_sans_ext(file)))
		
		###removed compressed file###
		file.remove(file.path(USCB_TIGER.path,file))
		
	}
	
	cat("USCB TIGER EDGES files downloaded.\n")

	invisible(gc())


	################################################################
	###download Topological Faces-Area Landmark Relationship File###
	################################################################

	main.URL <- file.path(base.URL,"FACESAL")
	main.path <- file.path(USCB_TIGER.path,"FACESAL")

	for (j in unique(FIPS.dt$state)){

		#j <- 1
		
		this.URL <- file.path(main.URL,paste0(tl_YEAR,j,"_facesal.zip"))

		file <- basename(this.URL)
		
		###download commpressed file###
		download.file(this.URL, file)
		
		###unzip compressed file###
		unzip(file, exdir = file.path(main.path,tools::file_path_sans_ext(file)))
		
		###removed compressed file###
		file.remove(file.path(USCB_TIGER.path,file))
		
	}
	
	cat("USCB TIGER Topological Faces-Area Landmark relationship files downloaded.\n")

	invisible(gc())

	##############################################
	###download Area Landmark Relationship File###
	##############################################

	main.URL <- file.path(base.URL,"AREALM")
	main.path <- file.path(USCB_TIGER.path,"AREALM")

	for (j in unique(FIPS.dt$state)){

		#j <- 1
		
		this.URL <- file.path(main.URL,paste0(tl_YEAR,j,"_arealm.zip"))

		file <- basename(this.URL)
		
		###download commpressed file###
		download.file(this.URL, file)
		
		###unzip compressed file###
		unzip(file, exdir = file.path(main.path,tools::file_path_sans_ext(file)))
		
		###removed compressed file###
		file.remove(file.path(USCB_TIGER.path,file))
		
	}
	
	cat("USCB TIGER Area Landmark relationship files downloaded.\n")

	invisible(gc())
	
	setwd(old.wd)

	cat("USCB TIGER file download complete.\n")
}



