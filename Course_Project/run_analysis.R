## Preparation of the material for the activities ##

# Set the current working directory
setwd("~/Coursera/Getting_and_Cleaning_Data_Coursera/Course_Project")
currentwd <- getwd()

# Download the data files
library(httr)
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "data.zip"
if(!file.exists(destfile)){
        #print("Downloading data files..")
        download.file(fileurl, destfile)
}

# Unzip and create folders for data files and results
data_folder <- "UCI HAR Dataset"
results_folder <- "Activity Results"
if(!file.exists(data_folder)){
        #print("Extracting data files..")
        unzip(destfile, list = FALSE, overwrite = TRUE)
}

if(!file.exists(results_folder)){
        #print("Creating results folder..")
        dir.create(results_folder)
}

# Convert text files to data frames
data_tables <- function(filename, cols = NULL){
        #print(paste("Getting table:", filename))
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

# Read the data and build tables
read_data <- function(type, features) {
        subject_data <- data_tables(paste(type, "/", "subject_", type, ".txt", sep = ""), "id")
        x_data <- data_tables(paste(type, "/", "X_", type, ".txt", sep = ""), features$V2)
        y_data <- data_tables(paste(type, "/", "y_", type, ".txt", sep = ""), "activity")
        return(cbind(subject_data, x_data, y_data))
}

# Check the data
test <- read_data("test", features)
train <- read_data("train", features)

# Save the results in the results_folder
save_results <- function(data, name) {
        results_file <- paste(results_folder, "/", name, ".csv", sep = "")
        write.csv(data, results_file)
}

## Required activities ##

# 1. Merges the training and the test sets to create one data set
library(plyr)
data <- rbind(train, test)
data <- arrange(data, id)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
mean_and_std <- data[, c(1, 2, grep("std", colnames(data)), grep("mean", colnames(data)))]
save_results(mean_and_std, "mean_and_std")

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- data_tables("activity_labels.txt")

# 4. Appropriately labels the data set with descriptive variable names
data$activity <- factor(data$activity, levels = activity_labels$V1, labels = activity_labels$V2)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_dataset <- ddply(mean_and_std, .(id, activity = data$activity), function(x){ colMeans(x[, -c(1:2)]) })
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep = "")
save_results(tidy_dataset, "tidy_dataset")
