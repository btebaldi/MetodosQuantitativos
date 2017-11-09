# Algoritmo (versão 02): Atualização dos Centros
# 1) Identificar os centros ou pontos de referência dos grupos
# 2) Para aluno:
#   2.1) Calcular a distância para o centro do grupo
# 2.2) Classificar o aluno de acordo com a menor distância
# 2.3) Atualizar o centros com os novos membros

# limpa variaveis antigas
rm(list = ls())

## Carrega a base de dados
source("./lib/DataLoader.r");

data = DataLoadTXT("./database/KNN-NotasDisciplinas.v0.1.txt");

# Scatterplot Matrices
pairs(data);

# Correlation, Variance and Covariance
cor(data);

# Calcula medias
medias = apply(data,1,mean);

# Ordena os dados pelas medias
data = data[order(medias),];

# Imprime no console as medias
print(cbind(data,medias[order(medias)]));

# gera um plot de matematica contra historia
plot(data[,c("matematica","historia")],xlim=c(0,10),ylim=c(0,10));
abline(a=0,b=1,col="red");
abline(a=5,b=1,col="red");
abline(a=-5,b=1,col="red");

# Define os centros
# Os centros sera:
#   (1) Melhor aluno de matematica
#   (2) Média de Matematica com o média de historia.
#   (3) Melhor aluno de historia
centers = array(NA,c(3,2));
colnames(centers) = c("matematica","historia");
rownames(centers) = c("melhores_matematica","media","melhores_historia");

#  Busca o melhor aluno de matematica
i = which(data[,"matematica"]==max(data[,"matematica"]))[1];
centers["melhores_matematica",] = data[i,colnames(centers)];

centers["media",] = c(5,5);

#  Busca o melhor aluno de historia
i = which(data[,"historia"]==max(data[,"historia"]))[1];
centers["melhores_historia",] = data[i,colnames(centers)];


plot(data[,colnames(centers)],xlim=c(0,10),ylim=c(0,10));

## Para cada aluno calcula a distancia
classif = array(NA, nrow(data));
for (i in 1:nrow(data)){
  
  # vetor de distancias euclidianas
  d = array(0,c(1,3));
  
  # para o aluno atual calcula a distancia dos centros
  for (j in 1:nrow(centers))
  {
    d[j] = ( sum( (data[i,colnames(centers)] - centers[j,])^2) )^(1/2);
  }
  
  ## Classificação
  # classsifica o aluno de acordo com a menor distancia do centro
  classif[i] = which(d==min(d));
}


plot(data[,colnames(centers)],col=classif,pch=classif,xlim=c(0,10),ylim=c(0,10));
points(centers, pch=20, col="red");
abline(a=0,b=1,col="red");
abline(a=5,b=1,col="red");
abline(a=-5,b=1,col="red");
