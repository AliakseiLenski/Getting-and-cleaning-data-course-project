
library(data.table)
rawData <- "getdata_projectfiles_UCI HAR Dataset.zip"

## Download and unzip the dataset:
if (!file.exists(rawData)){
  rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(rawDataUrl, rawData, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(rawData) 
}

## Read Activity and Feature Labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt") 

## Read Test data

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

## Read Train data

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

## Merging data 

test  <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)

## Combine test and train sets into full data set

fullSet <- rbind(test, train)

## Subset, keeeping mean, std columns; also keep subject, activity columns

allNames <- c("subject", "activity", as.character(features$V2))
meanStdColumns <- grep("subject|activity|[Mm]ean|std", allNames, value = FALSE)
reducedSet <- fullSet[ ,meanStdColumns]

## Use indexing to apply activity names to corresponding activity number

names(activity_labels) <- c("activityNumber", "activityName")
reducedSet$V1.1 <- activity_labels$activityName[reducedSet$V1.1]

## Use series of substitutions to rename varaiables

reducedNames <- allNames[meanStdColumns]    # Names after subsetting
reducedNames <- gsub("mean", "Mean", reducedNames)
reducedNames <- gsub("std", "Std", reducedNames)
reducedNames <- gsub("gravity", "Gravity", reducedNames)
reducedNames <- gsub("[[:punct:]]", "", reducedNames)
reducedNames <- gsub("^t", "time", reducedNames)
reducedNames <- gsub("^f", "frequency", reducedNames)
reducedNames <- gsub("^anglet", "angleTime", reducedNames)
names(reducedSet) <- reducedNames   # Apply new names to dataframe

## Create tidy data set

tidyDataset <- reducedSet

write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)

