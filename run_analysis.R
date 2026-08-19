library(dplyr)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
sub_all <- rbind(sub_train, sub_test)

features <- read.table("UCI HAR Dataset/features.txt")
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
x_all <- x_all[, mean_std_indices]
names(x_all) <- features[mean_std_indices, 2]

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
y_all[, 1] <- activities[y_all[, 1], 2]
names(y_all) <- "activity"

names(sub_all) <- "subject"
all_data <- cbind(sub_all, y_all, x_all)

names(all_data) <- gsub("^t", "time", names(all_data))
names(all_data) <- gsub("^f", "frequency", names(all_data))
names(all_data) <- gsub("-mean\\(\\)", "Mean", names(all_data))
names(all_data) <- gsub("-std\\(\\)", "Std", names(all_data))

tidy_data <- all_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

write.table(tidy_data, "tidy_data.txt", row.name = FALSE)
