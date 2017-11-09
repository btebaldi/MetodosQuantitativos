# limpa variaveis antigas
rm(list = ls())

library(gmodels);
library(class)

## Carrega a base de dados
data = read.table("./database/german_credit_2.csv", sep=",", header = TRUE, stringsAsFactors = FALSE);

## Isola a coluna Creditability
colLabelsId = which(colnames(data)=="Creditability");

## Classes
data.classes = data[[colLabelsId]];

## Variables
data = data[,-colLabelsId]

## normallização
for (col in colnames(data)){
  colMax = max(data[[col]]);
  colMin = min(data[[col]]);
  data[[col]] = (data[[col]]-colMin)/(colMax-colMin);
}

summary(data)

## Catagorização
data.classes = ifelse(data.classes==0,"bad","good");

## Seleção das linhas
rowIds = sample(1:nrow(data),size=round(0.6*nrow(data)));

## Base de treinamento
data.train = data[rowIds,];
classes.train = data.classes[rowIds];

## Base de treinamento
data.test = data[-rowIds,];
classes.test = data.classes[-rowIds];

## Classificação
classes.predict = class::knn(train = data.train, test = data.test, cl = classes.train, k=3);

## Confusion Matrix
gmodels::CrossTable(x = classes.test, y = classes.predict, prop.chisq=FALSE)



