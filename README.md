#ReadMe.md for Course Project "Getting and Cleaning Data" Coursera April 2015
##R. Ballard

This Analysis was performed to parse the raw USCI   HAR dataset into a more summarized form. Below is a list of steps taken to derive the summarized table from the original data.

1. The packages plyr, and data.table are used. Please ensure they are functionally installed before proceeding with steps.

2. First the Test data was read and formatted.
  +The data was first read as seperate vectors
  +Then an empty data frame was created
  +The data was combined so that the features list is the column names, and the activity factors we as well as user identifiers were appended columnwise.
3. These steps were replicated for the Training data.
4. The two data frames were merged row-wise.
5. A subset of the data frame was created using only the columns measuring means or standard deviations, and the activity and subject identifiers.
6. The data frame was converted to a data table and the subject identifier and activity label were named as Key Variables
7. Averages were found for each column based on subject and activity. the new table has been saved as, "subject_activity_averages.txt", it is tab-delimited and there is a header on the table.