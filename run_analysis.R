##Course Project Getting and Cleaning Data Coursera April 2015
##R. Ballard
setwd("Course Project")
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="fitbitDataset",method="curl",extra="-k")
install.packages("plyr")
install.packages("data.table")

library(data.table)
library(plyr)




#####################Reading and Formatting of Test Set Begins####################
#X_test set
X_test_path<-"Course Project/UCI HAR Dataset/test/X_test.txt"
X_test<-read.table(file=X_test_path)

#y labels for test set
y_test_path<-"Course Project/UCI HAR Dataset/test/y_test.txt"
y_test<-read.table(file=y_test_path)

#subjects for test set
subject_test_path<-"Course Project/UCI HAR Dataset/test/subject_test.txt"
subject_test<-read.table(file=subject_test_path)

#features labels
features_path<-"Course Project/UCI HAR Dataset/features.txt"
features<-read.table(features_path)
features_vector<-features[,2]


#This creates an empty data table, then binds the X_Test data to the newly 
#created table, and assigns the features names to the columns of the table.
test_data<-data.table()
test_data<-cbind(X_test)
colnames(test_data)<-features_vector

#This appends the y_test values to the data table, and assigns the column name "Activity Label".
test_data[,"Activity Label"]<-y_test

#This appends the subject number information to the data table
test_data[,"Subject Number"]<-subject_test

#########################Reading and Formatting of Training Set Begins########################

#X_train set
X_train_path<-"Course Project/UCI HAR Dataset/train/X_train.txt"
X_train<-read.table(file=X_train_path)

#y labels for train set
y_train_path<-"Course Project/UCI HAR Dataset/train/y_train.txt"
y_train<-read.table(file=y_train_path)

#subjects for train set
subject_train_path<-"Course Project/UCI HAR Dataset/train/subject_train.txt"
subject_train<-read.table(file=subject_train_path)

#features labels
features_path<-"Course Project/UCI HAR Dataset/features.txt"
features<-read.table(features_path)
features_vector<-features[,2]


#This creates an empty data table, then binds the X_Train data to the newly 
#created table, and assigns the features names to the columns of the table.
train_data<-data.table()
train_data<-cbind(X_train)
colnames(train_data)<-features_vector

#This appends the y_test values to the data table, and assigns the column name "Activity Label".
train_data[,"Activity Label"]<-y_train

#This appends the subject number information to the data table
train_data[,"Subject Number"]<-subject_train


##############COMBINING TEST AND TRAIN DATA########

#This creates a new data table for the combined data sets,
#then appends the two data sets to the newly created table row-wise.
combined_data<-data.table()
combined_data<-rbind(test_data,train_data)

########################Subsetting Data############
#Determining Features pertaining to mean
mean_features_indexes<-grep("mean",features_vector)
mean_features<-features_vector[mean_features_indexes]

#Determining Features pertaining to std
std_features_indexes<-grep("std",features_vector)
std_features<-features_vector[std_features_indexes]

#Determining Activity and Subject column indexes
label_indexes<-match(x=c("Activity Label","Subject Number"),names(combined_data))


#Subsets Combined Data based on columns containing mean or std
combined_data.subMeanStd<-combined_data[,c(mean_features_indexes,std_features_indexes,label_indexes)]
colnames(combined_data.subMeanStd)[1:79]<-paste(colnames(combined_data.subMeanStd)[1:79],"(avg)")


#Create list of Activity Labels
activity_labels_path<-"Course Project/UCI HAR Dataset/activity_labels.txt"
activity_labels<-read.table(file=activity_labels_path)
activity_numbers<-as.character(activity_labels[,1])
activity_names<-as.character(activity_labels[,2])


##Rename Activity Labels with descriptive entries instead of numeric values
combined_data.subMeanStd$"Activity Label"<-as.factor(combined_data.subMeanStd[,"Activity Label"])
combined_data.subMeanStd$"Activity Label"<-mapvalues(combined_data.subMeanStd$"Activity Label",from=activity_numbers,to=activity_names)



#Converts subset dataframe to Data Table, sets Subject Number and Activity Label as key values
MeanStd<-data.table(combined_data.subMeanStd)
#Sets Key Columns
keycols<-c("Subject Number","Activity Label")
setkeyv(MeanStd,keycols)


#Gets Means of Column values by subject and activity
grouped<-MeanStd[,lapply(.SD,mean), by = key(MeanStd)]
write.table(grouped,"subject_activity_averages.txt",sep="\t")
