# Limpa variaveis anteriores
rm(list=ls());

# determina a seed de aleatoriedade
# set.seed(0);

# Carrega as bibliotecas
library(rpart);
library(ROCR);
library(caret);
library(randomForest);

## Carrega a base de dados
data = read.table("./database/german_credit_2.csv",sep=",",header = TRUE, stringsAsFactors = FALSE);

## -- Tratamento dos dados

## -- Separacao da base aleat?ria em base de treinamento e test

## Base de treinamento e base de teste
ids = sort(sample(nrow(data),nrow(data)*0.6));

## Train dataset  
trainData = data[ids,];

## Test dataset
testData = data[-ids,]

## Contrucao do modelo de arvore de descisao

## Monta a arvore de treinamento por classificacao
trainTree = rpart::rpart(Creditability~., data=trainData, method = "anova");

## Plota a arvore de classificacao
plot(trainTree);
text(trainTree, pretty=0 ,cex=0.6)

## Faz a previsao
testTree.predict = predict(trainTree,testData);

## Confusion Matrix
confusionMatrix(ifelse(testTree.predict>0.5,1,0), testData$Creditability);

## Faz a previsao para a ?rvore de decis?o
testTree.prediction = prediction(testTree.predict, testData$Creditability);
testTree.performance = performance(testTree.prediction,"tpr","fpr");
plot(testTree.performance)

## Monta o Modelo de RandomForest

## Monta Floresta a partir da base de treinamento
trainForest = randomForest(Creditability~., data=trainData, importance=TRUE, proximity=TRUE, 
                           ntree=500, keep.forest=TRUE);

## Plota: num.arvores vs error 
plot(trainForest);

## Grafico de importancia das variaveis
varImpPlot(trainForest);

## Faz a previs?o e indica a probabilidade
testForest.predict = predict(trainForest,testData);

## Confusion Matrix
confusionMatrix(ifelse(testForest.predict>0.5,1,0), testData$Creditability);

## Faz a previsao por florestas
testForest.prediction = prediction(testForest.predict, testData$Creditability);
testForest.performance = performance(testForest.prediction,"tpr","fpr");
# plot(testTree.performance)
# plot(testForest.performance,col="Blue",add=TRUE)

testTree.performance.dataframe = data.frame(x = testTree.performance@x.values, y = testTree.performance@y.values)
colnames(testTree.performance.dataframe) = c("x", "y")

testForest.performance.dataframe =data.frame(x = testForest.performance@x.values, y = testForest.performance@y.values)
colnames(testForest.performance.dataframe) = c("x", "y")
write.csv(testForest.performance.dataframe, "filenameExport.csv")

p = ggplot() + 
  geom_line(data = testTree.performance.dataframe, aes(x, y), colour="black") +
  xlab(testTree.performance@x.name) +
  ylab(testTree.performance@y.name) +
  geom_line(data = testForest.performance.dataframe, aes(x, y), colour="blue") 

print(p)