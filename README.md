# Getting And Cleaning Data Course Project
The week 4 project from the Coursera JHU Getting and Cleaning Data Course

## This repo contains the following:
* **run_analysis.R** - this R script performs the analysis of reading in the UCI HAR data and writing out a tidy data set that summarizes the mean() and std() measurements by subject, activity, and measurement. See comments with the R script for details.
    + The script assumes the data files are located in the "./data/UCI HAR Data/" path under the current working directory.
    + The script assumes the data files are already extracted out of the zip file.
    
* **CodeBook.md** - this markdown file describes the fields of the tidysummary.txt output.

* **tidysummary.txt** - this is the actual output from the run_analysis.R script. See CodeBook.md for a description of each field.

## run_analysis.R Overview
* There is only one R script as part of this analysis.
* It takes 0 arguments.
* It performs the following functions:
    + Read in the source data into data frames
    + Combine the test and training data
    + Extract only the measurements/features containing mean() or std()
    + Melt the data down (i.e., convert the measurements/features into rows)
    + Coverted ID values into names (e.g., activityid 1 = WALKING)
    + Rename columns so they are easily understandable
    + Summarize all measurements by subject and activity
    + Write output to file
