---
title: "CodeBook"
author: "Gregg Tyson"
date: "February 24, 2018"
output: html_document
---

## tidysummary.txt

The tidy data set (tidysummary.txt) contains the following fields/columns:

* **subjectid**: this is the ID that represents the subject/particpant performing the activity. The values range from 1 to 30.

* **activityname**: this is the name of the activity that was performed. There are 6 possible values:
    + *WALKING*
    + *WALKING_UPSTAIRS*
    + *WALKING_DOWNSTAIRS*
    + *SITTING*
    + *STANDING*
    + *LAYING*

* **measurement**: this is the measurement that was recorded during the activity. From the original data set, only the measurements containing mean() or std() were included in this analysis (per the instructions). There are 66 measurements for each activity for each participant. The measurements represent the accelerometer and gyroscope 3-axial raw signals. All values have been normalized and bounded within [-1,1].

* **average**: this is the average/mean as calculated for each measurement for each activity and each subject.


## Transformations

The original data was transformed as follows during the analysis:

* The test and traning data were joined together
* Subject, activity, and measurement data were joined together
* Only measurements containing "mean()" or "std()" were extracted for further analysis
* The activityIDs and measurement variables were replaced with meaningful names (e.g., activityid 1 = WALKING)
* The column names were replaced with meaningful names
* The data was summarized to calculate the average/mean by subject, activity, and measurement

## UCI HAR Data Set 

The original data set was obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It contains the following:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

More information can be found at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

