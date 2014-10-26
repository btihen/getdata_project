getdata_project
===============

## Overview

This project downloads the Human Activity Recognition (HAR) data 
and creates a summary CSV file of:
* each subject_id (control variable)
* the subject's observed activity
* followed by summary measurements (means and standard deviations) 

The data was collected by a smartphone (Samsung Galaxy S II) attached to the subject's waist.


## REQUIREMENTS

* **r**   -- data analysis software (http://www.r-project.org/ downloads at: http://cran.r-project.org/)
* **git** -- source control software (http://git-scm.com/ downloads at: http://git-scm.com/downloads)
* access to **github** -- a webbased git repository (https://github.com/btihen/getdata_project)
* access to the **command line interface**


## USAGE

* open command line terminal
* download this git repository -- type: 

  `git clone https://github.com/btihen/getdata_project.git`

* move into the downloaded directory -- type:

  `cd getdata_project`

* start R -- type:

  `r`

* run the r code -- type:

  `source("run_analysis.R")`

  Ignore Warning messages: related to In dir.create(top_data_path) if you run this code more than once.

* View the summary data (in r) by typing:

  `tidy_summary_means_n_stddevs`

* or you can leave r

  `quit()`

* and view the resulting summary data in the file:

  `data/tidydata/har-tidydata-summary.txt`

  this is in a CSV format and uses a TXT extension to ensure compatibility with coursera's 
  website (to upload this file)


## CODE LOGIC

**PREPARATION** 
* define the data url
* define the project file and directory structures

  `getdata_project`   _(seen in the code as `.`)_
  
  `|`
  
  `-> README.md`      _(the location of this file -- describing the project and the code)_
  
  `|` 
  
  `-> codebook.md`    _(the location of the description of the data)_
  
  `|`
  
  `-> run_analysis.R` _(the location of the code being described in this section)_
  
  `|`
  
  `-> data`           _(top level for all data files)_
  
     `|`


     `-> tidydata`    _(top level for all tidy data)_

     `|  |`

     `|  -> har-tidydata-summary.txt`  _(location of required summary file)_

     `|`

     `-> rawdata`   _(top level for all raw data)_

       `|`

        `-> har-rawdata.zip` _(location of the downloaded raw data file -- still in zipped format)_

       `|`

        `-> unzipped`  _(location for the unzipped raw data files)_

* create the directory structures  

  **NOTE:** the code doesn't check to see if the folders are already created --
  which creates a harmless warning if run multiple times).

* download the raw data into the proper location
* unzip the raw data into the proper location
* discover where the raw data is unpacked (did it unpack into its own clean directory structure?)
* create the full filepaths to where the raw data has been unpacked 

**READ THE RAW DATA**
* read the activity_labels (key) -- so the activity observed can be read in human readable format 
  -- **activity_labels.txt**
* read the data labels (the data doesn't have headers) -- **features.txt**
* read the **TEST** data

  **NOTE:** this file is not indexed -- the order is very important to match the subject_id, observed subject activity and associated phone measurements

  * read the subject_id's for the test data -- **test/subject_test.txt**
  * read the phone recorded measurements for the test data -- **test/X_test.txt** 
  * read the observed subject activities for the test data -- **test/y_test.txt**

* read the **TRAINING** data -- the same as the test data (except **test** is replaced with **train**)

**REQUIREMENT 4** -- ensure each variable is labeled in the final summary data frame

Doing this at the start for each data frame to make it hard to make mistakes -- normally one prefers to read in data with headers -- doing this at the start simulates this.

* the measurement labels come from the features.txt file 

  (used a for loop to take the feature labels and add it to the measurement_df$Name)

* subject data is converted to a data frame and named subject_id
* activity data is converted to a data frame and named acitivity_id
* MERGE THE subject, activity and measurement data frames for both test and training data
  this is straightforward using cbind: 

 `test_df <- cbind(test_subject_df, test_activity_df, test_measures)`
 
 `train_df <- cbind(train_subject_df, train_activity_df, train_measures)`

 doing this as soon as possible to ensure that the data order doesn't change since the data isn't indexed.

**REQUIREMENT 1** -- MERGE the TEST and TRAINING data

  this is straightforward using: 
  
  `all_data <- rbind( test_df, train_df )`


**REQUIREMENT 3** -- Add READABLE activity labels

  this is straightforward using merge to match the activity_labels against the activity_id:

  `all_data <- merge(activity_labels,all_data, by="activity_id", all=FALSE)`
  
  THIS MUST BE DONE AFTER MERGING the dataframes (subject, activity and measurements) as merge CHANGES the order of the data and without an index the data would be impossible to align after a merge.


**REQUIREMENT 2** -- CREATE a tidy summary data frame with just means and standard deviations for each observation

  Identify the appropriate columns and use that to extract the correct data into a new summary data frame

* extract the list of column names

  `all_data_names <- colnames(all_data)`

* created a grep pattern to match mean, std, subject and activity (without the id)

  `pattern = "mean|std|subject_id|activity$"`

* apply grepl and which to create a vector of the required column names

  `use_columns <- grepl( pattern, all_data_names, ignore.case=TRUE )`

  `report_columns = which( use_columns )`

* generate the new summary data frame with the appropriate data:

  `all_means_n_stddevs <- all_data[ report_columns ]`

* finally reorder the data so that:
  * first column is the control variarble (the subject)
  * second column is the recorded subject activity (in human readable format)
  * remaining columns is the recorded summary data from the smartphone

  `tidy_summary_means_n_stddevs <- all_means_n_stddevs[ c(2,1,3:length(report_columns) )]`

**REQUIREMENT 5**-- Write the summary data frame to a file
 
  done using:

  `write.table( tidy_summary_means_n_stddevs, file=tidy_data_path_file, row.name=FALSE, sep="," )`

  this creates a csv file, but gave it a TXT extension to ensure compatibility with the coursera website.


## DATA EXPLAINED

see the codebook: (https://github.com/btihen/getdata_project/blob/master/codebook.md)


## DATA SOURCE

The data comes from:

  `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

This data is from the project at:

  `http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`

Which is from the original source:

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - UniversitÃ  degli Studi di Genova, Genoa I-16145, Italy.
> activityrecognition '@' smartlab.ws
> www.smartlab.ws
> 
> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


