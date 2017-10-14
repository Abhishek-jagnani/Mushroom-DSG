mushroom_train = read.csv("C:/Users/Abhishek/Downloads/mushroom_train.csv")
summary(mushroom_train)
table(mushroom_train$class,mushroom_train$gill.spacing)
table(mushroom_train$class,mushroom_train$odor)
table(mushroom_train$class,mushroom_train$habitat)
library(ggplot2)
ggplot(mushroom_train, aes(x = odor, fill = class)) + geom_bar(position = "fill")
ggplot(mushroom_train, aes(x = habitat, fill = class)) + geom_bar(position = "fill")
p= ggplot(mushroom_train,aes(x=stalk.color.below.ring,  
                       y=stalk.color.above.ring,
                       color=class))
library(caTools)
set.seed(3005)
spl = sample.split(mushroom_train$class, SplitRatio = .7)
Train = subset(mushroom_train,spl==T)
Test = subset(mushroom_train,spl==F)

library(e1071)

Model1 = svm(class ~ odor + spore.print.color + ring.type + stalk.surface.below.ring + gill.color + gill.size, data = Train)
pred1 = predict(Model1, newdata = Test)
table(Test$class, pred1)

library(caret)
control = trainControl(method="repeatedcv", number=4, repeats=3)
Final_model = train(class ~ odor + spore.print.color + ring.type + stalk.surface.below.ring + gill.color + gill.size , data=Train, method="glm", preProcess="scale", trControl=control)
pred2 = predict(Final_model, newdata = Test)
table(Test$class, pred2)

mushroom_test = read.csv("C:/Users/Abhishek/Downloads/mushroom_test.csv")
Final_pred = predict(Final_model, newdata = mushroom_test)
mushroom_test$Predictions = Final_pred
dim(mushroom_test)
head(mushroom_test$Predictions, n = 15)
mushroom_predictions = data.frame(Final_pred)
str(mushroom_predictions)
write.csv(mushroom_predictions, 'mushroom_forecast.csv')




