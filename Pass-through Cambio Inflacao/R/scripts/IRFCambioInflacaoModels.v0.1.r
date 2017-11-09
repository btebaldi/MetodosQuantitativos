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
        SERIES_DEFINICAO.CODE IN ('PTAX','IPCA','IGPM','IGPDI','IPA','IPCATR','IPCANOTR') and 
        DT_REFERENCIA>#2005-01-01# and DT_REFERENCIA<#2015-01-01#";

## Executa a query
result = sqlQuery(conn,query,stringsAsFactors=FALSE);

## Fecha a conexão com o banco de dados
odbcClose(conn);

## Coloca os dados em uma Data.frame "wide"
data = reshape(result,idvar="DT_REFERENCIA",timevar="CODE",direction="wide")
colnames(data) = gsub(".+\\.(.+)","\\1",colnames(data))

## Data frame utilizado nos modelos
vardata = data.frame(LN_PTAX=log(data[["PTAX"]]));

## Transforma a séries em base 100
series = c('IPCA','IGPM','IGPDI','IPA','IPCATR','IPCANOTR');
for (i in 1:length(series)) {
  name = sprintf("LN_%s100",series[i])
  vardata[[name]] = cumprod(1+data[[series[i]]]); 
}

## Calcula a primeira diferença
for (colName in colnames(vardata)){
  name = sprintf("D%s",colName)
  vardata[[name]] = c(NA,diff(vardata[[colName]]));
}

## Elimina a primeira linha
vardata = vardata[-1,];


models = list(
  DLN_PTAX_IPCA = c("DLN_PTAX","DLN_IPCA100")
);

models = list(
  DLN_PTAX_IPCA = c("DLN_PTAX","DLN_IPCA100"),
  DLN_PTAX_IGPM = c("DLN_PTAX","DLN_IGPM100"),
  DLN_PTAX_IPA = c("DLN_PTAX","DLN_IPA100"),
  LN_PTAX_IPCA = c("LN_PTAX","LN_IPCA100"),
  LN_PTAX_IGPM = c("LN_PTAX","LN_IGPM100"),
  LN_PTAX_IPA = c("LN_PTAX","LN_IPA100"),
  DLN_PTAX_IPCA_IGPM = c("DLN_PTAX","DLN_IPCA100","DLN_IGPM100"),
  LN_PTAX_IPCA_IGPM = c("LN_PTAX","LN_IPCA100","LN_IGPM100")
  );


saveIt = TRUE;

for (name in names(models)){
  
  title = sprintf("Model: %s",name);
  
  ## cat(sprintf("%s\n",title));
  
  if (saveIt) {
    ## Saida do texto
    filetxt = sprintf("../output/%s.txt",name);    
    sink(filetxt, append=FALSE, type = "output");
    
    ## Saida das figuras
    filepdf = sprintf("../output/%s.pdf",name);
    pdf(file=filepdf, onefile = TRUE);
    
  }
  
  ##cat(sprintf("%s\n",title));
  
  
  ## Dados que serão utilizados
  datamodel = vardata[,models[[name]]];
  
  ## Teste de raiz unitária
  for (i in 1:ncol(datamodel)){
    plot(ur.df(datamodel[,i],lags=0,type='trend'));    
  }
  
  ## Escolha da lag (menor critério de informação)
  ic = VARselect(datamodel, lag.max=4, type="const");
  
  summary(ic);
    
  ## Estima o modelo: lag escolhido pelo critério AIC
  varmodel = VAR(y=datamodel, type= "const", lag.max=3, ic="SC");
  
  summary(varmodel)
  
  ## Verificação das raízes
  roots = roots(varmodel);
  
  ## cat("roots:")
  roots;
  
  ## Teste da correlação serial
  varmodel.serial.test = serial.test(varmodel,lags.pt=10,type="PT.asymptotic");
  varmodel.serial.test
  for (i in 1:ncol(datamodel)){
    plot(varmodel.serial.test, names = colnames(datamodel)[i]);    
  }  
  
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
  
  irf.test = irf(varmodel, impulse = colnames(datamodel)[1], response=colnames(datamodel)[-1],n.ahead = 10,ortho = TRUE, cumulative = TRUE, boot = TRUE)
  
  plot(irf.test,main=title);
  
  
  if (saveIt) {
    sink();
    dev.off()
  }
}

