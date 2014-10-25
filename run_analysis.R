# Project for Data Collection due: Oct 26th and does the following:
# with the data from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#    1) Merges the training and the test sets to create one data set.
#    2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#    3) Uses descriptive activity names to name the activities in the data set
#    4) Appropriately labels the data set with descriptive variable names. 

#    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","data/har.zip",method="curl")

# collect the data
work_dir = "."
data_dir = "data"
data_zip = "har.zip"
# zip_path = "data/har.zip"
zip_path = file.path(data_dir, data_zip)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download_date = as.Date(Sys.time())
# dir.create(file.path( ".", "data")
dir.create( file.path(work_dir,data_dir) )
download.file( url, zip_path, method="curl")
file_names = unzip( zip_path, list=TRUE)$Name
unzip( zip_path, exdir=data_dir, overwrite=TRUE )
