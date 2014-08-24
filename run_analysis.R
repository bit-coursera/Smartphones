## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


if (!require("data.table")) install.packages("data.table")
if (!require("reshape2")) install.packages("reshape2")

require("data.table")
require("reshape2")

# Load: descriptions
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# cut measurements to the mean and standard deviation
extract_features <- grepl("mean\\(\\)|std\\(\\)", features)
features <- features [extract_features]

# Load test data.
x <- read.table("./UCI HAR Dataset/test/x_test.txt")[,extract_features]
y <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

data <- cbind(subject, activity_labels[y[,1]], x)

# Load train data.
x <- read.table("./UCI HAR Dataset/train/x_train.txt")[,extract_features]
y <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

data <- rbind(data,
              cbind(subject, activity_labels[y[,1]], x))


# setting labels
names(data) = c("subject","activity_label",as.vector(features))

# create tidy data set with the average of each variable for each activity and each subject.

melt_data = melt(data=data, id=c("subject", "activity_label"))
tidy_data   = dcast(melt_data, subject + activity_label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt",row.name=FALSE)
