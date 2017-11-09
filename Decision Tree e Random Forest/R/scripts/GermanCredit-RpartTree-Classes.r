# Limpa variaveis anteriores
rm(list=ls());

# determina a seed de aleatoriedade
set.seed(0);

# Carrega as bibliotecas
library(rpart);
library(ROCR);
library(caret);

## Carrega a base de dados
data = read.table("./database/german_credit_2.csv", sep=",", header = TRUE, stringsAsFactors = FALSE);

## -- Tratamento dos dados

## Criacao da classe nominal
data$Creditability = ifelse(data$Creditability==1,"good","bad");

## Categorizacao do 'Credit Amount'
data$CreditAmount = (ifelse(data$CreditAmount<=2500,'0-2500',ifelse(data$CreditAmount<=5000,'2600-5000','5000+')))

## -- Separacao da base aleat?ria em base de treinamento e test

## Base de treinamento e base de teste
ids = sort(sample(nrow(data),nrow(data)*0.6));

## Train dataset  
trainData = data[ids,];

## Test dataset
testData = data[-ids,]

## Contrucao do modelo

## Monta a arvore de treinamento por classificacao
trainTree = rpart(Creditability~., data=trainData, method="class");

trainTree2 = rpart(Creditability~AccountBalance+DurationOfCreditMonth+PaymentStatusOfPreviousCredit+
                    CreditAmount+ValueSavingsOrStocks+Guarantors+DurationInCurrentAddress+
                    Age+ConcurrentCredits+Occupation+NoOfDependents,
                  data=trainData, method="class");


## Plota a arvore de classificacao
plot(trainTree);
text(trainTree, pretty=0 ,cex=0.6)

plot(trainTree2);
text(trainTree2, pretty=0 ,cex=0.6)

## Faz a previsao
testTree.predict = predict(trainTree,testData,type='class');
  
## Confusion Matrix a funcao table (.)
table(testTree.predict, testData$Creditability);

## Confusion Matrix a funcao confusionMatrix(.)
cfmatrix = confusionMatrix(testTree.predict, testData$Creditability);

print(cfmatrix)

## Previsao com probabilidades
testTree.predict.prob = predict(trainTree,testData,type='prob');

testTree2.predict.prob = predict(trainTree2,testData,type='prob');


## Confusion Matrix
tablePredict = table(ifelse(testTree.predict.prob[,2]>0.5,"good","bad"), testData$Creditability);

print(tablePredict)
print(tablePredict/sum(tablePredict))

## Faz a previsao por florestas
testTree.prediction = ROCR::prediction(testTree.predict.prob[,2], testData$Creditability);
testTree.performance = ROCR::performance(testTree.prediction,"tpr","fpr");
plot(testTree.performance)

testTree2.prediction = ROCR::prediction(testTree2.predict.prob[,2], testData$Creditability);
testTree2.performance = ROCR::performance(testTree2.prediction,"tpr","fpr");
plot(testTree2.performance, col='red',add=TRUE)




