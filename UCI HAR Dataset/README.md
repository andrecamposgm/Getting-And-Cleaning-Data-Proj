---
title: "Data Science: Getting and Cleaning Data "
autor: "André Campos andreloc@gmail.com"
date: "Saturday, April 07, 2016"
output: html_document
---

## Introduction
This file explains the whole context of this project and how the scripts in it are connected in order to create tidy data from the provided data set. 

## Project Main Files
* [README.md](README.md) - This current file. It explains how all of the scripts work and how they are connected 
* [CodeBook.md](CodeBook.md) - A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data
* [run_analysis.R](run_analysis.R) - The R code which performs all clean-up work

## Business Context
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Project Objectives 
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

### Review Criteria
1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4. The README that explains the analysis files is clear and understandable.
5. The work submitted for this project is the work of the student who submitted it.

### Main Data Project Objectives
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set. 
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

## Executing the project 
Below is the set of instructions to execute this project: 

    setwd("path/to/the/project")
    source("run_analisys.R")

Where "path/to/the/project" refers to folder in which this project was downloaded. 

> Notice the folder it is not necessary to download the project from the provided URL. 
the [run_analisys.R](Script File) does all the hard work for you if the file does not exists already.

After execution, a file "tidy_data.txt" will be generated. 
You will be able to load and visualize that file using the following command: 

    data <- read.table("tidy_data.txt", header = TRUE)
    View(data)
    

