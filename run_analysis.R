# Project for Data Collection due: Oct 26th and does the following:
# with the data from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#    1) Merge the training and the test sets to create one data set.
#    2) Extract only the measurements on the mean and standard deviation for each measurement. 
#    3) Use descriptive activity names to name the activities in the data set
#    4) Appropriately labels the data set with descriptive variable names. 
#    5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#####################################
#####################################
## DEFINE THE DATA URL TO DOWNLOAD ##
#####################################
#####################################
## assignment requires the use of the "Human Activity Recognition" data set
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download_date = as.Date(Sys.time())

##################################################
##################################################
## create/prepare data directory and file names ##
## for HUMAN ACTIVITY RECOGNITION data (HAR)    ##
##################################################
##################################################
# define the data location & download file
##########################################
work_name = "."
data_name = "data"
raw_name  = "rawdata"
tidy_name = "tidydata"
unzipped_name = "unzipped"
# define files names
####################
raw_zip_file    = "har-rawdata.zip"
tidy_data_file  = "har-tidydata-summary.txt"
raw_zip_path_file  = file.path( data_name, raw_name, raw_zip_file )
tidy_data_path_file = file.path( data_name, tidy_name, tidy_data_file )
# Create directory structures path names
######################################## 
top_data_path  = file.path( work_name, data_name )
top_raw_path   = file.path( work_name, data_name, raw_name )
top_tidy_path  = file.path( work_name, data_name, tidy_name )
top_unzipped_path = file.path( work_name, data_name, raw_name, unzipped_name )
# create the directory structures
#################################
dir.create( top_data_path )
dir.create( top_raw_path )
dir.create( top_tidy_path )
dir.create( top_unzipped_path )

# download data
download.file( url, raw_zip_path_file, method="curl" )

# unzip the data to the defined data location
unzip( raw_zip_path_file, exdir=top_unzipped_path, overwrite=TRUE )

###################################
##  DETERMINE DATA SET PATH INFO ##
###################################
# aquire data files and path info
file_names = unzip( raw_zip_path_file, list=TRUE)$Name
test_file  = file_names[1]
# decide if data is unpacked into its own data structure & define dataset path
###################################
if ( grepl( "/", test_file ) ) {
  # learn project data structure (find top level) xxxxx/yyyyy
  first_file = strsplit( file_names[1],"/" ) 
  # the first value will have the folder the data unpacked into
  unzipped_folder_name = first_file[[1]][1]
  top_unzipped_rawdata_path = file.path( top_unzipped_path, unzipped_folder_name )
} else { 
  top_unzipped_rawdata_path = top_unzipped_path
}
# defind test and training data paths:
test_data_path = file.path( top_unzipped_rawdata_path, "test" )
train_data_path = file.path( top_unzipped_rawdata_path, "train" )

##################################
## DEFINE ALL FILE PATHS NEEDED ##
##################################
# data definition files
activity_file         = file.path( top_unzipped_rawdata_path, "activity_labels.txt" )
measurements_file     = file.path( top_unzipped_rawdata_path, "features.txt" )
# test data 
test_subjects_file    = file.path( test_data_path, "subject_test.txt" )
test_measures_file    = file.path( test_data_path, "X_test.txt" )
test_activities_file  = file.path( test_data_path, "y_test.txt" )
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
## A) one row for each observation
## B) data is clearly labeled & meaningful (thus usable)
## C) each table has only one kind of variable
## D) with multiple tables, there should be a column that allows data linking
## E) mark or remove improper data (invalid/out of range & possibly incomplete cases)
#################################

######################################
######################################
## REQUIREMENT 4) label the data values ##
######################################
######################################
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
################################
## label the train  data values ##
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


#########################################
#########################################
## REQUIREMENT 1) join the TEST and TRAIN datasets ##
#########################################
#########################################
# combine subject and activity dfs
# should I mark each test row with the the dataset = test
test_df <- cbind(test_subject_df, test_activity_df, test_measures)
# combine subject and activity dfs
# should I mark each training row with the dataset = training
train_df <- cbind(train_subject_df, train_activity_df, train_measures)
# combine all rows into one big data frame
all_data <- rbind( test_df, train_df )


######################################
######################################
## REQUIREMENT 3) human readble activity ##
######################################
######################################
# merge in activity labels (do not create every condition)
all_data <- merge(activity_labels,all_data, by="activity_id", all=FALSE)
## merge messes up the sorting -- so resort grouped by:
## control variable (the subject and then the observed activities) ##
######################################################################
all_data <- all_data[ order( all_data$subject_id, all_data$activity_id ), ]


#############################################################################
#############################################################################
## REQUIREMENT 2) create a dataframe with means and stdev for each measurement ##
#############################################################################
#############################################################################
all_data_names <- colnames(all_data)
# create a patter to match the necessary summary data (means, stddev, subject and activity
##########################################
pattern = "mean|std|subject_id|activity$"
# match the pattern against all data columns using a logical grep
############################################
use_columns <- grepl( pattern, all_data_names, ignore.case=TRUE )
# create a vector that will select the wanted columns
######################################
report_columns = which( use_columns )
# Create a dataframe with just the summary data
#################################################
all_means_n_stddevs <- all_data[ report_columns ]
###################
# re-organize the dataframe into a standard format
# first the subject (control variable first), 
# second the observed_activity of the subject, 
# third->end: recorded measurements summarys from the phone
tidy_summary_means_n_stddevs <- all_means_n_stddevs[ c(2,1,3:length(report_columns) )]


##########################################
##########################################
## REQUIREMENT 5) Report data as a text file ##
##########################################
##########################################
write.table( tidy_summary_means_n_stddevs, file=tidy_data_path_file, row.name=FALSE, sep="," )
