# run_analysis takes 0 arguments.

# The function reads the UCI HAR Dataset and does the following:
#       1. Merges the training and the test sets to create one data set.
#       2. Extracts only the measurements on the mean and standard deviation for each measurement.
#       3. Uses descriptive activity names to name the activities in the data set
#       4. Appropriately labels the data set with descriptive variable names.
#       5. From the data set in step 4, creates a second, independent tidy data set with the average 
#          of each variable for each activity and each subject.
#
# Assumptions:
#       - The set of data files is store in the "./data/UCI HAR Data/" path under the current working directory
#       - The set of data files is already extracted out of the zip file

run_analysis <- function() {
        
        # loaded needed libraries
        library(dplyr)
        library(tidyr)
        library(reshape2)
        
        # ===============================================================
        # Import data
        # ===============================================================
        print(paste0("Looking for data files in: ", getwd(), "/data/UCI HAR Dataset/"))
        print(paste0("Reading data..."))
        flush.console()
        
        # read files into data frames and explicitly name columns where needed so they don't have to be renamed later
        activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names=c("activityid", "activityname"))
        features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE, col.names=c("featureid", "featurename"))
        
        subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names=c("subjectid"))
        subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names=c("subjectid"))
        
        xtest <- read.table("./data/UCI HAR Dataset/test/x_test.txt")
        xtrain <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
        
        ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names=c("activityid"))
        ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names=c("activityid"))
        
        # ===============================================================
        # 1. Merge the training and the test sets to create one data set.
        # ===============================================================
        print(paste0("Merging training and test data..."))
        flush.console()
        
        # Join test and train subject data
        subjectall <- rbind(subjecttest, subjecttrain)
        
        # Add a new column called 'datasourcepartition' that represents which group the data was in (test or train). 
        # This is done in case we ever wanted to segment the data based on these values
        xtest <- mutate(xtest, datasourcepartition='test')
        xtrain <- mutate(xtrain, datasourcepartition='train')
        
        # Join test and train feature (aka - measurement) data
        xall <- rbind(xtest, xtrain)
        # convert datasourcepartition to factor
        xall$datasourcepartition <- as.factor(xall$datasourcepartition)
        
        # Join test and train y (aka - activity) data
        yall <- rbind(ytest, ytrain)
        
        # Combine x/measurement, subject data, and y/activity together
        # dplyr's 'mutate' function is used here instead of 'merge' because everything stays in the orignal indexed order
        # (unlike merge which might shuffle the data around)
        widedata <- mutate(xall, subjectid=subjectall$subjectid, activityid=yall$activityid)
        
        # Reorder columns in a more logical way (subject, activity, source, measurements/V1:V561)
        widedata <- select(widedata, subjectid, activityid, datasourcepartition, V1:V561)
        
        # ==========================================================================================
        # 2. Extract only the measurements on the mean and standard deviation for each measurement.
        # ==========================================================================================
        print(paste0("Extracting mean() and std() measurements only; melting data to long (not wide) form..."))
        flush.console()
        
        # Select only the V1/V2/etc columns where the measurements included either mean() or std() in the name,
        # based on a grep from the features data
        widedata <- select(widedata, subjectid, activityid, datasourcepartition, paste0("V",grep("mean\\(\\)|std\\(\\)", features$featurename)))
        
        # Melt the data so the V1/V2/etc columns become rows
        # Since measure.vars is blank, melt uses all non id.vars as the measure vars (so all the V1, V2, etc columns)
        # Melting in this way is one step toward making the data more tidy ("each observation forms a row")
        longdata <- melt(widedata, id.vars=c("subjectid", "activityid", "datasourcepartition"))
        
        # =========================================================================
        # 3. Use descriptive activity names to name the activities in the data set
        # =========================================================================
        print(paste0("Translating activity and measurement IDs into actual names..."))
        flush.console()
        
        # these are similar to vlookup in Excel
        longdata$activityid <- activitylabels$activityname[match(longdata$activityid, activitylabels$activityid)]
        longdata$variable <- features$featurename[match(sub("V","",longdata$variable), features$featureid)]
        
        # =====================================================================
        # 4. Appropriately label the data set with descriptive variable names.
        # =====================================================================
        print(paste0("Renaming columns so they are more descriptive..."))
        flush.console()
        
        longdata <- rename(longdata, activityname = activityid, measurement = variable, measurementvalue = value)
        
        # data validity check: any na values?
        if (sum(is.na(longdata)) > 0) {
                paste("WARNING: NA values in data frame")
        }
        
        # ===============================================================================================
        # 5. From the data set in step 4, create a second, independent tidy data set with the average of 
        # each variable for each activity and each subject.
        # ===============================================================================================
        print(paste0("Creating independent, tidy data set that summarizes the data and writing output to file..."))
        flush.console()
        
        tidysummary <- longdata %>% group_by(subjectid, activityname, measurement) %>% summarize(average = mean(measurementvalue))
        fileoutput <- "./data/tidysummary.txt"
        write.table(tidysummary, file = fileoutput, row.names = FALSE)
        
        print(paste0("Tidy output written to ", fileoutput))
        flush.console()
        return("Done")
}