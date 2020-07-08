### Part 1
### The original data set is extracted in the working environment.
### The working environment now has UCI HAR Dataset directory and its sub-directories.
TestSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
TestX <- read.table("UCI HAR Dataset/test/X_test.txt")
TestY <- read.table("UCI HAR Dataset/test/y_test.txt")
TrainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
TrainX <- read.table("UCI HAR Dataset/train/X_train.txt")
TrainY <- read.table("UCI HAR Dataset/train/y_train.txt")

### Building each Test and Train data frame in the order of subject, activity and values
TestDF <- data.frame(TestSub, TestY, TestX)
TrainDF <- data.frame(TrainSub, TrainY, TrainX)

### merging the Test and Train data frames into one using join function from plyr package
library(plyr)
MergedDF <- join(TestDF, TrainDF, type = "full")
rm(TestSub, TestY, TestX, TrainSub, TrainY, TrainX, TestDF, TrainDF)


### Part 2
### Determining which column contains measurements for mean and standard deviation
Feat <- read.table("UCI HAR Dataset/features.txt")
cols <- grep("mean\\(\\)|std\\(\\)", Feat[,2])

### selecting the required columns; column 1 is subject ID, column 2 is activity label
MSD_DF <- MergedDF[, c(1, 2, cols+2)]


### Part 3
### Replacing the Y column (activity label which contains 1~6) with actual activity names
### First creating a lookup vector for label-to-activity-name, and then replacing the column
Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
lab <- Labels[,2]
names(lab) <- as.numeric(Labels[,1])
MSD_DF[, 2] <- lab[MSD_DF[, 2]]


### Part 4
### function for converting the feature into descriptive labels
cleanf <- function (f) {
    ### replacing shorthands for time- and frequency-domain
    if (grepl("^t", f)) {
        c <- sub("t", "timedomain", f)
    } else if (grepl("^f", f)) {
        c <- sub("f", "frequencydomain", f)
    }
    
    ### removing non-alphabet and uppercase; replacing shorthand
    c <- gsub("\\(|\\)|\\-", "", c)
    c <- gsub("Body", "body", c)
    c <- gsub("Gravity", "gravity", c)
    c <- gsub("Acc", "accelerometer", c)
    c <- gsub("Gyro", "gyroscope", c)
    c <- gsub("Jerk", "jerk", c)
    c <- gsub("Mag", "magnitude", c)
    if (grepl("X$", f)) {
        c <- sub("X", "xaxis", c)
    } else if (grepl("Y$", f)) {
        c <- sub("Y", "yaxis", c)
    } else if (grepl("Z$", f)) {
        c <- sub("Z", "zaxis", c)
    }
    
    ### indicating if the value is for the mean or std of the signals
    c <- paste0(c, "signal")
    c <- gsub("mean", "", c)
    c <- gsub("std", "", c)
    if (grepl("mean", f)) {
        c <- paste0(c, "mean")
    } else if (grepl("std", f)) {
        c <- paste0(c, "std")
    }
    c
}

### Converting the codified feature names for the mean and std values into descriptive variable names
header <- Feat[,2][cols]
header <- sapply(header, cleanf)
header <- c("subject", "activity", header)
names(MSD_DF) <- header
rm(MergedDF, Feat, Labels, cols, lab, header, cleanf)


### Part 5
library(dplyr)
library(tidyr)

### Using tidyr package, moved feature information into rows
### The data frame is then summarized by subject, activity and feature to evaluate the mean for each permutation
TidyDF <- MSD_DF %>% 
    pivot_longer(-(1:2), names_to="feature", values_to="val") %>%
    group_by(subject, activity, feature) %>%
    summarize(mean = mean(val))

write.table(TidyDF,"Tidy.txt",row.names=FALSE)
