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

* r   -- data analysis software (http://www.r-project.org/)
* git -- source control software (http://git-scm.com/downloads)
* access to git hub
* access to the command line interface


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
* then you can view the summary data (in r) by typing:
  `tidy_summary_means_n_stddevs`
* or you can leave r
  `quit()`
* and view the resulting summary data in the file:
  `data/tidydata/har-tidydata-summary.txt`
  this is in a CSV format and uses a TXT extension to ensure compatibility with coursera's website (to upload this file)

## CODE LOGIC




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


