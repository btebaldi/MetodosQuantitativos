# limpa variaveis antigas
rm(list = ls())

## Carrega a base de dados
source("./lib/DataLoader.r");

# Carrega os dados
data = DataLoadTXT("./database/KNN-NotasDisciplinas.v0.1.txt");


# Define os centros
# Os centros sera:
#   (1) Melhor nota de matematica e pior nota de historia
#   (2) Mediana de Matematica com o mediana de historia.
#   (3) Pior nota de matematica e melhor nota de historia
centers = array(NA,c(3,2));
colnames(centers) = c("matematica","historia");
rownames(centers) = c("melhores_matematica","media","melhores_historia");

centers["melhores_matematica",] = c(max(data[,"matematica"]), min(data[,"historia"]));
centers["media",] = c(median(data[,"matematica"]), median(data[,"historia"]));
centers["melhores_historia",] = c(min(data[,"matematica"]), max(data[,"historia"]));

# Busca o melhor aluno de matematica
i = which(data[,"matematica"]==max(data[,"matematica"]))[1];
centers["melhores_matematica",] = data[i,colnames(centers)];
centers["media",] = c(5,5);

# Busca o melhor aluno de historia
i = which(data[,"historia"]==max(data[,"historia"]))[1];
centers["melhores_historia",] = data[i,colnames(centers)];

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
points(centers,pch=20,col="red");
abline(a=0,b=1,col="red");
abline(a=5,b=1,col="red");
abline(a=-5,b=1,col="red");


# Para cada aluno
for (i in 1:nrow(data))
{
  # vetor de distancias euclidianas
  d = array(0,c(1,3));
  
  for (j in 1:nrow(centers)){
    d[j] = (sum((data[i,colnames(centers)] - centers[j,])^2))^(1/2);
  }
  
  ## Classificação
  classif[i] = which(d==min(d));
  
  ## Atuliza o centro com o novo membro
  centers[classif[i],] = (centers[classif[i],] + data[i,colnames(centers)])/2;
}

plot(data[,colnames(centers)],col=classif,pch=classif,xlim=c(0,10),ylim=c(0,10));
points(centers,pch=1+nrow(centers),col="red");
points(data[classif==3,colnames(centers)],pch=5,col="blue");


colMeans(data)

