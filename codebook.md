# Codebook for getdata_project

An explanation of the raw data, summary data, valid measurements and variable units -- take from the raw data **README.txt**

**SETUP**

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


DATA DESCRIPTION
================

##OVERVIEW

This is a complex data set with raw data and processed information.

I have done my best to collect and organize the information contained in the data's README.txt and features_info.txt into a single coehesive document

## Data Described in Summary data

This includes:

* **subjects** -- a group of 30 volunteers within an age bracket of 19-48 years. **Its range is from 1 to 30.**
* **activities** -- each subject performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone on the waist.   The experiments have been video-recorded to label the observed activities manually. **Its range is from 1 to 6.**
* **Calculted Values** - processed "features" from subjects were wearing a "Samsung Galaxy S II" on the waist.  The summary data contains only the calculated mean values and the associated standard deviations.  (An overview of the raw data and feature processing is presented below).

## RAW DATA
There are TWO basic type of measurements -- each measured along 3 axis (XYZ)
* **Acceleration (Acc)** - in units of gravity 'g' 
* **Gryoscopic (Gryo)** -- in units of radians/sec

## FEATURES (Calculated info)

There are many (561 features), however, there are serveral type of calcalations (often merged into a single value), so I am including only ability to identify these they include: 

**Three data types**
* **time domain signals** -- _prefixed with 't'_ -- were captured at a constant rate of 50 Hz.
* **fast-fourier-transforms (FFT)** -- _prefixed with 'f' to indicate frequency domain signals_
* **angle** -- _prefixed with 'angle'_ (in radians)

**Four Calculated features**
* **Body** 
  * body_acc  --  The body acceleration signal obtained by subtracting the gravity from the total acceleration.
  * body_gyro --  The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.
* **Jerk** -- derived in time to obtain Jerk signals -- this calculation is unclearn and I cannot find more information
* **Magnitude** -- magnitude of these three-dimensional signals were calculated using the Euclidean norm

**Notes** -- Features are normalized and bounded within [-1,1].


## PROCESSING

**RAW DATA**

* Time domain signals were captured at a constant rate of 50 Hz. 
* Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 
* The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

**CALCULATED FEATURES**

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


## DATA SETS

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

## INCLUDED FILES

* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

