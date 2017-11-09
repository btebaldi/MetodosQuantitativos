# limpa variaveis antigas
rm(list = ls())

## Carrega a base de dados
source("./lib/DataLoader.r");
source("./lib/Teo.Knn.R");

# Carrega as livrarias
library(ggplot2)
library(ggforce)

# Carrega os dados
data = DataLoadTXT("./database/KNN-NotasDisciplinas.v0.1.txt");

data.subset = data[, c("matematica","historia")];

pointsclass = GetClassification(data = data.subset, k = 4, dynamicCenter = T)

centers = as.data.frame(pointsclass$centers)

ggplot() +
geom_point(data=as.data.frame(data.subset), aes(x=matematica, y=historia), colour = factor(pointsclass$classif[,1])) +
  geom_circle(aes(x0=matematica, y0=historia, r=radius), data=centers, color=6) +
  coord_fixed() +
  geom_point(data=as.data.frame(centers), aes(x=matematica, y=historia), colour = 6, shape = 2);


