# limpa variaveis antigas
rm(list = ls())

## Carrega a base de dados
source("./lib/DataLoader.r");

# Carrega os dados
data = DataLoadTXT("./database/KNN-NotasDisciplinas.v0.1.txt");

head(data)

index = which(colnames(data)=="matematica", arr.ind = T);
data.classes = ifelse(data[,index] >=6,"Aprovado","Recuperacao");
data.classes[data[,index] < 3] = "Reprovado";
data.classes = factor(data.classes)

data.subset = data[,-index]

summary(data.subset)

## Base de treinamento e base de teste
ids = sort(sample(nrow(data.subset),nrow(data.subset)*0.7));

train.data = data.subset[ids,]
test.data = data.subset[-ids,]

train.data.classes = data.classes[ids]
test.data.classes = data.classes[-ids]

knn.1 =  knn(train.data, test.data, train.data.classes, k=1)
knn.2 =  knn(train.data, test.data, train.data.classes, k=2)
knn.5 =  knn(train.data, test.data, train.data.classes, k=5)
knn.10 = knn(train.data, test.data, train.data.classes, k=10)

table(knn.1, test.data.classes)
table(knn.2, test.data.classes)
table(knn.5, test.data.classes)
table(knn.10, test.data.classes)
