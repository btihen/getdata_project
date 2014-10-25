# Project for Data Collection due: Oct 26th and does the following:
# with the data from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#    1) Merges the training and the test sets to create one data set.
#    2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#    3) Uses descriptive activity names to name the activities in the data set
#    4) Appropriately labels the data set with descriptive variable names. 

#    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

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

###############################################
##  locate and read the test & training data ##
###############################################
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

# get the definition of each activity factor cross-references with the human readable version
activity_file   = file.path( top_data_path, "activity_labels.txt" )
activity_labels = read.csv( activity_file, sep=" ", header=FALSE )

# get the definition of each measurement label
features_file   = file.path( top_data_path, "features.txt" )
feature_labels  = read.csv( features_file, sep=" ", header=FALSE )


# get the data definitions (variables) - data "features.txt"
# read the subjects who generated the data - subject_test.txt or subject_train.txt
# read the activities the subjects performed - y_test.txt or y_train.txt
# read the data generated from each condition of each subject and activity -- X_test.txt or X_train.txt

# create a data set that follows the clean data rules -- so that the data can be analyzed and understood
# 1) one row for each observation
# 2) data is clearly labeled & meaningful (thus usable)
# 3) improper data (out of range & possibly incomplete cases) removed

