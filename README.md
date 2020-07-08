# DataScienceC3W4Project
Data Science Specialization Course 3 Week 4 Getting and Cleaning Data Course Project

The objective of run_analysis.R script is to collect and summarize the "Human Activity Recognition Using Smartphones" Data Set which can be obtained from UCI Machine Learning Repository. This data set contains the accelerometer and gyroscope signal reading from Samsung Galaxy S II smartphone which was worn by 30 volunteers while they were engaging in a variety of physical activity and position. The complete data set and its information can be found from this URL: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Specifically, this script will carry out the following five tasks: read the original data .txt format and merge them into a single table of subject, activity and signal measurement information (part 1); from the signal data, extract only the measurements that are mean or standard deviations (part 2); convert the codified activity labels into descriptive activity names (part 3); convert the codified labels of measurement feature into descriptive feature names (part 4); and finally, summarize the data frame generated from previous steps by subject, activity and feature, and evaluate the mean of the measurement values from each permutation.

To begin with part 1, it is assumed that the source data is downloaded from the UCI Machine Learning Repository and extracted into the current working directory of R, under a directory named 'UCI HAR Dataset.' The original data is broken into 6 parts - the subject (volunteer) label, activity label, and feature measurement, for both test group and train group.

subject_test.txt - the label indicating who the subject (volunteer) was for each of the measurement in the test group
X_test.txt - the actual measurement of various features in the test group
y_test.txt - the label of activity that subject was engaging in for each of the measurement in the test group
subject_train.txt - the label indicating who the subject (volunteer) was for each of the measurement in the train group
X_train.txt - the actual measurement of various features in the train group
y_train.txt - the label of activity that subject was engaging in for each of the measurement in the train group

The .txt files are read into R and constructed into separate data frame for both test group and train group, in the order of subject-activity-measurement. Since both data frames are constructed in the same order and the header does not exist for the original files, the join function from plyr package can be used to merge the test and train data frames together. The resulting data frame object is named MergedDF.

In part 2, only the measurements that are means or standard deviations are extracted. In order to do so, the metadata of the signal measurements are analyzed using regex. The metadata is stored in the file features.txt. The column indices that contain mean and standard deviation was determined by searching for "mean()" or "std()" in the metadata, resulting in 66 column headers. The column indices were then combined with the subject and activity column indices (1 and 2, respectively) to extract from MergedDF data frame, resulting in a smaller data frame called MSD_DF.

In Part 3, a character vector containing activity names was used to convert the activity column codes (1~6) in MSD_DF. This information was contained in activity_labels.txt.

Part 4 requires a function that takes in the codified label of measurement feature (e.g. "tBodyAcc-mean()-X") and returns a more descriptive name (e.g. "time-domain body accelerometer x-axis signal mean" but without space). This function replaces the shorthanded code with actual word, and removes uppercase characters, dashes and parenthesis. The function cleanf was defined for this purpose and run on the metadata character vector used in Part 2. The resulting character vector of descriptive names was then used to label the measurement columns of MSD_DF data frame.

Lastly in Part 5, the MSD_DF data frame was melted using tidyr package, so that the columns of feature names were taken down to data row level and each row contained only one measurement. Then using dplyr package the resulting data frame were summarized by subject - activity - feature, containing only one data point of mean for each variable. Since there are 30 subjects, 6 activities and 66 features, the resulting data frame called TidyDF has dimension of 11880 rows (30*6*66) and 4 columns (subject, activity, feature, mean). This data table is then written in a text file named Tidy.txt.
