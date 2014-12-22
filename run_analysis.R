install.packages("data.table")
library(data.table)

# extracting all the files
test <- read.table("./test/X_test.txt",header=FALSE)
test_act <- read.table("./test/Y_test.txt", sep="", header=FALSE)
test_sub <- read.table("./test/subject_test.txt", sep="", header=FALSE)

train <- read.table("./train/X_train.txt",header=FALSE)
train_act <- read.table("./train/Y_train.txt", sep="", header=FALSE)
train_sub <- read.table("./train/subject_train.txt", sep="", header=FALSE)

# 2.Uses descriptive activity names to name the activities in the data set
act_label <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
test_act$V1 <- factor(test_act$V1,levels=act_label$V1,labels=act_label$V2)
train_act$V1 <- factor(train_act$V1,levels=act_label$V1,labels=act_label$V2)

# 4.Appropriately labels the data set with descriptive variable names
features <- read.table("./features.txt",header=FALSE,colClasses="character")
colnames(test)<-features$V2
colnames(train)<-features$V2
colnames(test_act)<-"Activity"
colnames(train_act)<-"Activity"
colnames(test_sub)<-"Subject"
colnames(train_sub)<-"Subject"

# 1.Merges the training and the test sets to create one data set
test_full <- cbind(test, test_act, test_sub)
train_full <- cbind(train, train_act, train_sub)
full <- rbind(test_full, train_full)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement
full_mean<-sapply(full,mean,na.rm=TRUE) #activity is not a quantity => NA
full_sd<-sapply(full,sd,na.rm=TRUE)

# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_independant <- data.table(full)
tidy_data <- tidy_independant[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy_data,file="tidy_data.txt",sep=",",row.names = FALSE)