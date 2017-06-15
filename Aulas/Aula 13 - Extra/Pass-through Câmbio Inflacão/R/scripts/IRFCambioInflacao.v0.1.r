## --- Bibliotecas R
library(RODBC);
library(vars);
library(urca);

## --- Programa Principal


## - Carrega os dados
databasefile = "../database/MQA-PassThrough-Database.accdb"

## Abre a conexão com o banco de dados
conn = odbcConnectAccess2007(databasefile);

## Define a Query
query = "select CODE, DT_REFERENCIA, VALOR 
        from SERIES_DEFINICAO, SERIES_DADOS_ECONOMIA 
        where SERIES_DEFINICAO.ID = SERIES_DADOS_ECONOMIA.ID_SERIE and 
        SERIES_DEFINICAO.CODE IN ('IPCA','PTAX','IGPM','IGPDI') and 
        DT_REFERENCIA>#2005-01-01# and DT_REFERENCIA<#2015-01-01#";

## Executa a query
result = sqlQuery(conn,query,stringsAsFactors=FALSE);

## Fecha a conexão com o banco de dados
odbcClose(conn);

## Coloca os dados em uma Data.frame "wide"
data = reshape(result,idvar="DT_REFERENCIA",timevar="CODE",direction="wide")
colnames(data) = gsub(".+\\.(.+)","\\1",colnames(data))

## Transforma a séries em base 100

data[1,"IPCA100"] = 1*(1+data[1,"IPCA"]);
for (i in 2:nrow(data)){
  data[i,"IPCA100"] = data[i-1,"IPCA100"]*(1+data[i,"IPCA"]);
}

## Calcula a primeira diferença
vardata = data.frame(
  DLN_PTAX = diff(log(data[,"PTAX"])),
  DLN_IPCA100 = diff(log(data[,"IPCA100"]))
  );

title = sprintf("Model: %s",paste(colnames(vardata),collapse=";"));

## Teste de raiz unitária
plot(ur.df(log(data[,"IPCA100"]),lags=0,type='trend'));

plot(ur.df(log(data[,"PTAX"]),lags=0,type='trend'));

## Escolha da lag (menor critério de informação)
ic = VARselect(vardata, lag.max=4, type="const");

## Estima o modelo: lag escolhido pelo critério AIC
varmodel = VAR(y=vardata, type= "const", lag.max=3, ic="SC");

summary(varmodel)

## Verificação das raízes
roots = roots(varmodel);

cat("roots:")
roots;

## Teste da correlação serial
varmodel.serial.test = serial.test(varmodel,lags.pt=10,type="PT.asymptotic");
varmodel.serial.test
plot(varmodel.serial.test,names = "DLN_PTAX");
plot(varmodel.serial.test,names = "DLN_IPCA100");

## Teste de Heterocedasticidade
varmodel.arch.test = arch.test(varmodel,lags.multi=5,multivariate.only=TRUE);
varmodel.arch.test

## Teste de Normalidade
varmodel.normality.test = normality.test(varmodel,multivariate.only=TRUE);
varmodel.normality.test

## Test de estabilidade
recusum = stability(varmodel, type = "OLS-CUSUM");
plot(recusum);
fluctuation = stability(varmodel, type = "fluctuation");
plot(fluctuation);

## Impulso Resposta
irf.test = irf(varmodel, impulse = "DLN_PTAX", response="DLN_IPCA100",n.ahead = 10,ortho = TRUE, cumulative = TRUE, boot = TRUE)

plot(irf.test,main=title);

