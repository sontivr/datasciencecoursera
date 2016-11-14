library(data.table)
library(dplyr)
library(stringr)


# This script has to be run from the directory that has "UCI HAR Dataset"
# 
# GIVEN:
# You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 
# # Ignoring files from test/Inertial Signals/ and train/Inertial Signals/
#

# Note on descriptive names:
# Please note the column names for all measures have been changed to use descriptive names before writing the final data set out
#  . I have retained the measure name in mixed case for readability
#     and at the same time I didn't want to expand it as it would make the column names too long
#  . I have followed 3-word rule for measures.
#    {measure_type} measure_name [measure_component_if_exists]
#    EX: mean fBodyGyro Z
#  . I left the prefix (f or t that indicates the domain) to the measure name as it is in the interest of keep the variable names short
#
# 1. Merge the training and the test sets to create one data set.
#    a. Read activity labels into a data frame
#    b. Read subjects into a data frame
#    c. Read test data sets 
#    d. Read train data sets
#    e. Combine/rbind test and train data sets 
# 
# read activity labels
activity_labels.df<-read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
activity_labels<-tbl_df(activity_labels.df)
# set column names
names(activity_labels)<-c("activityno", "activity")
#
# 3. Uses descriptive activity names to name the activities in the data set
# add activityname column for descriptive names for activities
activity_labels<-mutate(activity_labels, activityname = str_to_title(gsub("_", " ", activity)))
#
# read features
features.df<-read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
features<-tbl_df(features.df)
# set column names
names(features)<-c("featureno", "feature")
#
# read files from test
y_test.df<-read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
y_test<-tbl_df(y_test.df)
X_test.df<-read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
X_test<-tbl_df(X_test.df)
subject_test.df<-read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
subject_test<-tbl_df(subject_test.df)
#
#
# read files from train
y_train.df<-read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
y_train<-tbl_df(y_train.df)
X_train.df<-read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
X_train<-tbl_df(X_train.df)
subject_train.df<-read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
subject_train<-tbl_df(subject_train.df)
#
# Combine test and train data sets
subject <- rbind(subject_test, subject_train)
y <- rbind(y_test, y_train)
X <- rbind(X_test, X_train)
# set column names 
names(subject)<-c("subject")
y<-inner_join(y, activity_labels, by = c("V1" = "activityno"))
names(y)[1] <- c("activityno") 
names(X) <- as.vector(features$feature)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Drop columns that don't have mean or std
X[grep("mean|std",names(X), invert = TRUE)] <- NULL

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# get average of 
by.activityname<-y["activityname"]
by.subject<-subject["subject"]
finalDF<-aggregate(X, by = list(by.activityname$activityname, by.subject$subject), mean)
# set column names
names(finalDF)[1] <- c("activity")
names(finalDF)[2] <- c("subject")

# 4. Appropriately label the data set with descriptive variable names.
# Change to descriptive variable names
newnames<-gsub("^([tf])([a-zA-Z]*)-([a-zA-Z]+())([-]?[A-Z]?)", "\\3 \\1\\2 \\4", names(finalDF))
newnames<-gsub("(.*)(\\(\\)-?|\\(\\)?)(.*)", "\\1\\3", newnames)
names(finalDF)<-str_trim(newnames)

# Write final data set to a file
write.table(finalDF, file = "finaldataset.txt", row.names = FALSE)


