################################################################################
#
# Titanic: Machine Learning from Disaster
#
# author:      Dominik Koch
# version:     -
# created at:  16.12.2015
# last update: 16.12.2015
# source:      https://www.kaggle.com/c/titanic
#
################################################################################

# TODO

# weighting: http://mlr-org.github.io/mlr-tutorial/release/html/train/index.html
# imputation age:

library(mlr)

### Import data ----------------------------------------------------------------

df.train <- read.csv("data/train.csv")
submission <- read.csv("data/test.csv")

# df.test$Survived <- 0
# df <- rbind(df.train,df.test)

### Data preparation -----------------------------------------------------------

# df.train$Cabin <- NULL
# df.train$Name <- NULL
# df.train$PassengerId <- NULL

df.train$Age[is.na(df.train$Age)] <- -1
df.train$Fare[is.na(df.train$Fare)] <- median(df.train$Fare, na.rm = TRUE)
df.train$Embarked[df.train$Embarked==""] = "S"
df.train$Sex <- as.factor(df.train$Sex)
df.train$Embarked <- as.factor(df.train$Embarked)
df.train$Survived <- as.factor(df.train$Survived)

submission$Age[is.na(submission$Age)] <- -1
submission$Fare[is.na(submission$Fare)] <- median(submission$Fare, na.rm = TRUE)
submission$Embarked[submission$Embarked==""] = "S"
submission$Sex <- as.factor(submission$Sex)
submission$Embarked <- as.factor(submission$Embarked)

### Create task ----------------------------------------------------------------

classif.task <- makeClassifTask(id = "titanic", data = df.train, target = "Survived", positive = 1)
classif.task

str(getTaskData(classif.task))
summary(getTaskData(classif.task))

classif.task <- dropFeatures(classif.task, c("Cabin","Name","PassengerId","Ticket"))

### Construct learner ----------------------------------------------------------

classif.lrn <- makeLearner("classif.randomForest", predict.type = "prob", fix.factors.prediction = TRUE)
classif.lrn

classif.lrn$par.set

### Training a learner ---------------------------------------------------------

mod = train(classif.lrn, classif.task)
getLearnerModel(mod)

### Predicting outcomes --------------------------------------------------------

pred <- predict(mod, newdata = submission)
pred

# getConfMatrix(pred)

### Adjusting the threshold ----------------------------------------------------

# d = generateThreshVsPerfData(pred, measures = list(fpr, fnr, mmce))
# plotThreshVsPerf(d)

### Evaluation -----------------------------------------------------------------

getDefaultMeasure(classif.task)
#performance(pred, measures = list(mmce, acc))

### Generate submission --------------------------------------------------------

submission$Survived <- getPredictionResponse(pred)
submission <- submission[,c("PassengerId","Survived")]

write.csv(submission, file = "submission/2015-12-17_RandomForest.csv", row.names = FALSE, quote = FALSE)

