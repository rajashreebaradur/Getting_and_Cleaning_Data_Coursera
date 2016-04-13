## Preparation of the material for the activities ##

# Set the current working directory
setwd("~/Coursera/Getting_and_Cleaning_Data_Coursera/Course_Project")
currentwd <- getwd()

# Download the data files
library(httr)
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "data.zip"
if(!file.exists(destfile)){
        print("Downloading data files..")
        download.file(fileurl, destfile)
}

# Unzip and create folders for data files and results
data_folder <- "UCI HAR Dataset"
results_folder <- "Activity Results"
if(!file.exists(data_folder)){
        print("Extracting data files..")
        unzip(destfile, list = FALSE, overwrite = TRUE)
}

if(!file.exists(results_folder)){
        print("Creating results folder..")
        dir.create(results_folder)
}

# Convert text files to data frames
data_tables <- function(filename, cols = NULL){
        print(paste("Getting table:", filename))
        data_files <- paste(data_folder, filename, sep = "/")
        data <- data.frame()
        if(is.null(cols)){
                data <- read.table(data_files, sep = "", stringsAsFactors = F)
        }
        else {
                data <- read.table(data_files, sep = "", stringsAsFactors = F, col.names = cols)
        }
        data
}

# Check features of the data_tables
features <- data_tables("features.txt")