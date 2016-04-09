#' ---
#' title: "Getting And Cleaning Data"
#' author: "André Campos"
#' date: "April 4th, 2016"
#' ---

# A few useful constants
ZIP_FILE = "projectData.zip"
DATASET_DIR = "UCI HAR Dataset"
DOWNLOAD_URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Check dependencies
if (!require("data.table")) install.packages("data.table")
if (!require("dplyr")) install.packages("dplyr")

# prepeare the data to be understandable
# list of available features 
columns <- read.table("features.txt", header = F, stringsAsFactors = F)[,2]
activities_labels <- fread("activity_labels.txt", header = F, col.names = c("Id", "Activity"))

#'
#' Execute basic operations like downloading the experiment data set 
#' and change the working dir to the dataset root folder. 
#'
prepareDataset <- function() {
  # Download data  If the data is not available, this script will download it automatically 
  if(!dir.exists(DATASET_DIR)) {
    download.file(url = DOWNLOAD_URL, destfile = ZIP_FILE)
    # in case the zip is changed 
    unzip(ZIP_FILE, overwrite = T, exdir = DATASET_DIR) 
  }
  setwd(DATASET_DIR)
}

#'
#' Gets the file path for each kind of data
#' @param The context of the files: "test" or "train"
#' @param the file name: "X", "y" or "subject"
#' @example filePath("text", "X") returns: test/X_test.txt
#' 
filePath <- function(context, fileName) {
  # For instance: test/X_test.txt or train/X_train.txt
  paste(context,"/",fileName,"_",context, ".txt", sep = "") 
}

#'
#' @details Loads the data following the standard defined
#' @param The context of the files: "test" or "train"
#' 
loadDataByContext <- function(context) {
  # using the standard, loads the file paths
  data_file     <- filePath(context, "X") 
  activity_file <- filePath(context, "y") 
  
  # load test data using pre loaded columns
  # using fread because time is precious :) 
  data <- fread(data_file, header = F, col.names = columns)
  
  # Requirement: 
  # 2) Extracts only the measurements on the mean and standard deviation for each measurement.
  # applying a grep over only columns containing mean and std strings
  # Notice it only considers the columns with mean() and std(). 
  data <- data[,
               grep("(mean\\(\\)$|std\\(\\)$)", columns), # only mean() and std()
               with = F]
  
  # Requirement: 
  # 3) Uses descriptive activity names to name the activities in the data set
  # First load the activities file for this context. 
  # This data is numeric and not descriptive
  activities <- fread(activity_file, header = F, col.names = c("Id"))
  # merge activities (numeric) with its descriptive labels
  activities <- merge(activities, activities_labels, by = "Id")
  
  # finally add the set of classified activities to the dataset
  data <- data[,Activity:=activities$Activity]
    
  return(data)
}


