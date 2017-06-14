source("../lib/Utils.r")

LoadPackages(c("rpart", "caret", "e1071", "ROCR"))


data = read.table(file="../database/german_credit_2.csv", header = T, sep = ",")
summary(data)

# hist(data[["CreditAmount"]])

# TABELA DE CONTINGENCIA
table(data[["CreditAmount"]], data[["LengthOfCurrentEmployment"]])
table(data[["DurationOfCreditMonth"]], data[["LengthOfCurrentEmployment"]])
table(data[["Creditability"]], data[["LengthOfCurrentEmployment"]])
names(data)


# 1a alternativa, coluna alternativa
data[["CreditabilityClass"]] = NA
data[data[["Creditability"]] == 1,"CreditabilityClass"] = "good"
data[data[["Creditability"]] == 0,"CreditabilityClass"] = "bad"

# apago a coluna
data[["CreditabilityClass"]] = NULL


# 2a alternativa, fazer toda a mudanca em uma unica atribuicao

data[["Creditability"]] = ifelse(data[["Creditability"]]==1, "good", "bad")

data[["CreditAmount"]] = ifelse(data[["CreditAmount"]]<=2500, "0-|2500", ifelse(data[["CreditAmount"]]<=5000, "2500-|5000", "5000+"))

# Ids das observacoes de treinamento
ids = sample(x=1:nrow(data), size = 0.6*nrow(data), replace = F)

# base de treinamento
trainData = data[ids,]
testData = data[-ids,]

trainTree = rpart(Creditability~., data=trainData, method = "class")

plot(trainTree)
text(trainTree, pretty = F, cex=0.6)

# joe=caret::createDataPartition(y = data, p = 0.6, times=1, groups=600 )

# Previsao
testTree.predict = predict(trainTree, testData, type="class")

#  Confusion matrix
table(testData$Creditability, testTree.predict)

caret::confusionMatrix(testTree.predict, testData$Creditability)


# Previsao 
testTree.predict.prob = predict(trainTree, testData, type="prob")




