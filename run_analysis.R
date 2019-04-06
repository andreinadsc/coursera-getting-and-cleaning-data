filename  <- "dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Read datasets
training_X <- read.table("UCI HAR Dataset/train/X_train.txt")
training_Y <- read.table("UCI HAR Dataset/train/Y_train.txt")
training_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
training <- cbind(training_subject,training_Y,training_X)

test_X <- read.table("UCI HAR Dataset/test/X_test.txt")
test_Y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subject,test_Y,test_X)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

##Activity #1 - Merges the training and the test sets to create one data set.
dataMerge <- rbind(training, test)
featureNames <- as.character(features[, 2])
names(dataMerge) <- featureNames


##Activity #2 - Extracts only the measurements on the mean and standard deviation for each measurement.
matches <- grep("(mean|std)\\(\\)", names(dataMerge))
dataMerge <- dataMerge[, matches]

##Activity #3 - Uses descriptive activity names to name the activities in the data set
activities <- factor(dataMerge[,2], labels=c("Walking",
                                                    "Walking Upstairs", "Walking Downstairs", 
                                                    "Sitting", "Standing", "Laying"))
##Activity #4 - Appropriately labels the data set with descriptive variable names.
names(dataMerge) = gsub('-mean', 'Mean', names(dataMerge))
names(dataMerge) = gsub('-std', 'Std', names(dataMerge))
names(dataMerge) = gsub('[-()]', '', names(dataMerge))
names(dataMerge) <- gsub("BodyBody", "Body", names(dataMerge))
names(dataMerge) <- gsub("^t", "Time", names(dataMerge))
names(dataMerge) <- gsub("^f", "Frequency", names(dataMerge))

newData <- cbind(Subject = dataMerge[,1], Activity = activities, dataMerge[,3:ncol(dataMerge)])

##Activity #5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy = aggregate(newData[,3:ncol(newData)], by=list(Activity = newData$Activity, Subject=newData$Subject), mean)
write.table(tidy, "tidy.txt")
