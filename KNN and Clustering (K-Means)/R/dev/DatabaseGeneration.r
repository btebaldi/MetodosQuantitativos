set.seed(1);

x = array(NA,30);
data = data.frame(matematica=x,fisica=x,portugues=x,historia=x,zoologia=x,botanica=x);

data[["matematica"]]=sort(rnorm(30,5,4),decreasing=TRUE);
data[["fisica"]]=sort(rnorm(30,5,4),decreasing=TRUE);

data[["portugues"]]=sort(rnorm(30,5,4),decreasing=FALSE);
data[["historia"]]=sort(rnorm(30,5,4),decreasing=FALSE);

data[["botanica"]]=c(sort(rnorm(15,5,1),decreasing=FALSE),sort(rnorm(15,5,1),decreasing=TRUE));
data[["zoologia"]]=c(sort(rnorm(15,5,1),decreasing=FALSE),sort(rnorm(15,5,1),decreasing=TRUE));


## Notas maiores que 10
for (r in 1:nrow(data)){
  for (c in 1:ncol(data)){
    data[r,c] = ifelse(data[r,c]>10,10-abs(rnorm(1,0,0.25)),data[r,c]);
    data[r,c] = ifelse(data[r,c]<2,abs(rnorm(1,2,1)),data[r,c]);
  }
}

data = round(data,2);

data= data[order(rnorm(30)),];

data = cbind(nome=sprintf("ALUNO_%02.0f",1:30),data)

summary(data);
apply(data,2,sd)



write.table(data,file="../database/KNN-NotasDisciplinas.v0.1.txt",sep="\t",dec=",",quote=FALSE,row.names=FALSE);


hist(rnorm(10000,0,10),ylim=c(0,5000),xlim=c(-50,50))
hist(rnorm(10000,0,1),ylim=c(0,5000),xlim=c(-50,50))

