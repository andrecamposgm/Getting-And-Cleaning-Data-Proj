---
title: "Data Science: CodeBook for Getting and Cleaning Data Project"
autor: "André Campos andreloc@gmail.com"
date: "Saturday, April 07, 2016"
output: html_document
---

#Description

## Objective 
 One of the review criteria in this project is the creation of this code book. 

 This code book describes the variables, the data, and the transformations or work that you performed to clean up the data called CodeBook.md

## Running the project  

To run run the code, basically load the source as described below: 

    source("run_analisys.R")
   
## Final structure of tidy data

The operations executed in method getDescriptiveColNames renamed the columns approprietly to generate the following self explainable list of variables in the tidy data. 

     [1] "Actifity"                                         
     [2] "Subject"                                          
     [3] "Time Body Accelerometer Magnitude -Mean"          
     [4] "Time Body Accelerometer Magnitude -SD"            
     [5] "Time GravityAccelerometer Magnitude -Mean"        
     [6] "Time GravityAccelerometer Magnitude -SD"          
     [7] "Time Body Accelerometer JerkMagnitude -Mean"      
     [8] "Time Body Accelerometer JerkMagnitude -SD"        
     [9] "Time Body Gyroscope Magnitude -Mean"              
    [10] "Time Body Gyroscope Magnitude -SD"                
    [11] "Time Body Gyroscope JerkMagnitude -Mean"          
    [12] "Time Body Gyroscope JerkMagnitude -SD"            
    [13] "Frequency Body Accelerometer Magnitude -Mean"     
    [14] "Frequency Body Accelerometer Magnitude -SD"       
    [15] "Frequency Body  Accelerometer JerkMagnitude -Mean"
    [16] "Frequency Body  Accelerometer JerkMagnitude -SD"  
    [17] "Frequency Body  Gyroscope Magnitude -Mean"        
    [18] "Frequency Body  Gyroscope Magnitude -SD"          
    [19] "Frequency Body  Gyroscope JerkMagnitude -Mean"    
    [20] "Frequency Body  Gyroscope JerkMagnitude -SD"      


## Source code definitions
Below is described each code block inside the run_analisys.R. 
 
### Dependencies

This project only uses data.table project. This source code below makes sure the dependecy is available, if not, it will install it automatically. 

    # Check dependencies
    if (!require("data.table")) {
      install.packages("data.table")
      library("data.table")
    }
    
### Constant and Variables
Define basic constants and variables 

    # A few useful constants
    ZIP_FILE = "projectData.zip"
    DATASET_DIR = "UCI HAR Dataset"
    DOWNLOAD_URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    columns <- NULL
    activities_labels <- NULL
    
### Method Definitions
The second part has the declaration of the methods that will be explained in detail below. 

-- Execute basic operations like downloading the experiment data set and change the working dir to the dataset root folder. Download data if the data directory is not available yet or the current dir is not the data set dir

    prepareEnvironment <- function() {
      if(basename(getwd()) == DATASET_DIR) {
        message(paste("The current dir is already:", DATASET_DIR))
        return() # we're good. The working dir is already our dataset dir
      }
      if(!dir.exists(DATASET_DIR)) {
        message(paste("Downloading the file and unziping in:", DATASET_DIR))
        # unfortunaly the dataset dir does not exist. Let's download and unzip the file
        download.file(url = DOWNLOAD_URL, destfile = ZIP_FILE)
        unzip(ZIP_FILE, overwrite = T) 
      } 
      # set the working dir to the dataset
      setwd(DATASET_DIR)
    }

-- Load Features and 

    loadColumnsAndActivities <- function(){
      # prepeare the data to be understandable
      # list of available features 
      columns <<- read.table("features.txt", header = F, stringsAsFactors = F)[,2]
      activities_labels <<- fread("activity_labels.txt", header = F, col.names = c("Id", "Activity"))
    }
    
-- Gets the file path for each kind of data. For instance: filePath("text", "X") returns: test/X_test.txt

    filePath <- function(context, fileName) {
      # For instance: test/X_test.txt or train/X_train.txt
      paste(context,"/",fileName,"_",context, ".txt", sep = "") 
    }

-- The main code block. It loads and merges the basic structures including appropriate labels and the subjects

    loadDataByContext <- function(context) {
      # using the standard, loads the file paths
      data_file     <- filePath(context, "X") 
      activity_file <- filePath(context, "y") 
      subject_file  <- filePath(context, "subject")
      
      # load test data using pre loaded columns
      # using fread because time is precious :) 
      data <- fread(data_file, header = F, col.names = columns)
      # load subject files and bind the column to the data set
      subjects <- fread(subject_file, header = F, col.names = c("Subject"))
      
      # Requirement: 
      # 2) Extracts only the measurements on the mean and standard deviation for each measurement.
      # applying a grep over only columns containing mean and std strings
      # Notice it only considers the columns with mean() and std(). 
      columnIndexForMeanAndStd <- grep("(mean\\(\\)$|std\\(\\)$)", columns)
      # subset the dataset
      data <- data[,columnIndexForMeanAndStd, with = F]
      
      # Requirement: 
      # 3) Uses descriptive activity names to name the activities in the data set
      # First load the activities file for this context. 
      # This data is numeric and not descriptive
      activities <- fread(activity_file, header = F, col.names = c("Id"))
      # merge activities (numeric) with its descriptive labels
      activities <- merge(activities, activities_labels, by = "Id")
      
      # finally add the set of classified activities to the dataset
      data <- data[,Activity := activities$Activity]
      
      # column bind the subjects
      data <- data[,Subject := subjects$Subject]
        
      return(data)
    }
    
-- Rename variables in the data set in order to have descriptive variable names

    getDescriptiveColNames <- function(colNames) {
      colNames <- gsub("std\\(\\)", "SD", colNames)
      colNames <- gsub("mean\\(\\)", "Mean", colNames)
      colNames <- gsub("^t", "Time ", colNames)
      colNames <- gsub("^f", "Frequency ", colNames)
      colNames <- gsub("Acc", "Accelerometer ", colNames)
      colNames <- gsub("Gyro", "Gyroscope ", colNames)
      colNames <- gsub("Mag", "Magnitude ", colNames)
      colNames <- gsub("BodyBody", "Body ", colNames) 
      colNames <- gsub("Body", "Body ", colNames) 
      return(colNames)
    }


### Main code block
The third part of the source is the list of actions accomplishing the objectes

-- A few basic steps: make sure the data set is downloaded unziped and it is the current working dir

      prepareEnvironment()
    
-- load column names and activity labels 

      loadColumnsAndActivities()
    
-- Load data sets: Objectives 2 and 3

      test_data  <- loadDataByContext("test")
      train_data <- loadDataByContext("train")
    
-- Merges training and test data sets: Objective 1

    mergedData <- rbindlist(list(test_data, train_data)) 
    
-- Rename variables: Objective 4 

    descriptiveColNames <- getDescriptiveColNames(names(mergedData))
    names(mergedData)   <- descriptiveColNames
    
-- Finally, the objective 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    tidyData <- with(mergedData, aggregate(mergedData[,1:18, with = F], 
                                     by = list(Actifity = Activity, Subject = Subject), 
                                     FUN = mean ))
    write.table(tidyData, "../tidy_data.txt")

