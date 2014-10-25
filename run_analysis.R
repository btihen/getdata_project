# Project for Data Collection due: Oct 26th and does the following:
# with the data from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#    1) Merge the training and the test sets to create one data set.
#    2) Extract only the measurements on the mean and standard deviation for each measurement. 
#    3) Use descriptive activity names to name the activities in the data set
#    4) Appropriately labels the data set with descriptive variable names. 
#    5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","data/har.zip",method="curl")

##############################################
## define the data location & download file ##
##############################################
work_path = "."
data_path = "data"

# human activity recognition (har)
download_file = "har.zip"
download_path = file.path(data_path, download_file)

# assignment requires the use of the "Human Activity Recognition" data set
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download_date = as.Date(Sys.time())

# create/prepare data location
dir.create( file.path( work_path, data_path) )

# download data
download.file( url, download_path, method="curl" )

# unzip the data to the defined data location
unzip( download_path, exdir=data_path, overwrite=TRUE )

###################################
##  DETERMINE DATA SET PATH INFO ##
###################################
# aquire data files and path info
file_names = unzip( download_path, list=TRUE)$Name
test_file  = file_names[1]

# decide if data is unpacked into its own data structure & define dataset path
if ( grepl( "/", test_file ) ) {

  # learn project data structure (find top level) xxxxx/yyyyy
  first_file = strsplit( file_names[1],"/" ) 

  # the first value will have the folder the data unpacked into
  project_path = first_file[[1]][1]
  top_data_path = file.path( data_path, project_path )
} else { 
  top_data_path = data_path
}
# defind test and training data paths:
test_data_path = file.path( top_data_path, "test" )
train_data_path = file.path( top_data_path, "train" )

##################################
## DEFINE ALL FILE PATHS NEEDED ##
##################################
# data definition files
activity_file   = file.path( top_data_path, "activity_labels.txt" )
measurements_file   = file.path( top_data_path, "features.txt" )
# test data 
test_subjects_file   = file.path( test_data_path, "subject_test.txt" )
test_measures_file   = file.path( test_data_path, "X_test.txt" )
test_activities_file = file.path( test_data_path, "y_test.txt" )
# training data
train_subjects_file   = file.path( train_data_path, "subject_train.txt" )
train_measures_file   = file.path( train_data_path, "X_train.txt" )
train_activities_file = file.path( train_data_path, "y_train.txt" )


################################
## READ DATA SETS DEFINITIONS ##
################################
# get the definition of each activity factor cross-references with the human readable version
activity_labels = read.csv( activity_file, sep=" ", header=FALSE )

# get the definition of each measurement label
measurement_labels  = read.csv( measurements_file, sep=" ", header=FALSE )

# Read test data files
test_subjects    = read.csv( test_subjects_file, header=FALSE )
test_activities = read.csv( test_activities_file, header=FALSE )
test_measures   = read.table( test_measures_file, header=FALSE, strip.white=TRUE )

# Read train data files
train_subjects   = read.csv( train_subjects_file, header=FALSE )
train_activities = read.csv( train_activities_file, header=FALSE )
train_measures   = read.table( train_measures_file, header=FALSE, strip.white=TRUE )

################################
## TIDY THE DATA SETS 
##
## create a data set that follows the tidy data rules -- so that the data can be analyzed and understood
## 1) one row for each observation
## 2) data is clearly labeled & meaningful (thus usable)
## 3) remove improper data (out of range & possibly incomplete cases)
#################################

# Add proper labels to data frame values
colnames(activity_labels)[1] <- "activity_id"
colnames(activity_labels)[2] <- "activity"

# add proper labels to the measurements
colnames( measurement_labels)[1] <- "measurement_id"
colnames( measurement_labels)[2] <- "measurement_label"

################################
## label the test data values ##
################################
# label each of the test measurement columns
for ( i in 1:nrow(measurement_labels) ) {
  colnames(test_measures)[i] <- as.character(measurement_labels$measurement_label[i])
}
# create data frames and label columns
test_subject_df = data.frame(test_subjects)
colnames(test_subject_df)[1] <- "subject_id"
# create labels for the test activity df
test_activity_df <- data.frame(test_activities)
colnames(test_activity_df)[1] <- "activity_id"

#######################################################
## Join the test data values into a single dataframe ##
#######################################################
# combine subject and activity dfs
test_df <- cbind(test_subject_df, test_activity_df)
# merge in activity labels (do not create every condition)
test_df <- merge(test_df, activity_labels, by="activity_id", all=FALSE)
# sort it into the the same order as the original data -- by subject id
test_df <- test_df[ order( test_df$subject_id ), ]
# re-order the data fram with subject_id first and activity_label last
test_df <- test_df[c(2,1,3)]
# add in the measturement data
test_df <- cbind(test_df, test_measures)


################################
## label the train data values ##
################################
# label each of the train measurement columns
for ( i in 1:nrow(measurement_labels) ) {
  colnames(train_measures)[i] <- as.character(measurement_labels$measurement_label[i])
}
# create data frames and label columns
train_subject_df = data.frame(train_subjects)
colnames(train_subject_df)[1] <- "subject_id"
# create labels for the train activity df
train_activity_df <- data.frame(train_activities)
colnames(train_activity_df)[1] <- "activity_id"

#######################################################
## Join the train data values into a single dataframe ##
#######################################################
# combine subject and activity dfs
train_df <- cbind(train_subject_df, train_activity_df)
# merge in activity labels (do not create every condition)
train_df <- merge(train_df, activity_labels, by="activity_id", all=FALSE)
# sort it into the the same order as the original data -- by subject id
train_df <- train_df[ order( train_df$subject_id ), ]
# re-order the data fram with subject_id first and activity_label last
train_df <- train_df[c(2,1,3)]
# add in the measturement data
train_df <- cbind(train_df, train_measures)


##############################################
## 1) join the tidy TEST and TRAIN datasets ##
##############################################
