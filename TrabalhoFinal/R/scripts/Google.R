## remove all objects fromt the current workspace
rm(list = ls())

## Load User scripts
source(file = "dev/BuildQueryString.R")
source(file = "dev/GetDataFromGoogleFinance.R")

dataInicio = "2016-01-01"
dataFim = "2016-12-31"

# Inicializo as datas
Datas = seq(as.Date(dataInicio), as.Date(dataFim), by = "days")

# Inicializo os tickers
ticker = c("BVMF:CIEL3", "BVMF:VALE5", "BVMF:BBDC4", "BVMF:ITSA4")


# Inicializo o Dataframe 
DF = matrix(NA, nrow = length(Datas), ncol = length(ticker))
rownames(DF) = format(Datas, format = "%Y-%m-%d")
colnames(DF) = ticker 


# Busco dados
for (item in ticker)
{
  X = GetDataFromGoogleFinance(item, dataInicio, dataFim)

  for (nContador in 1:dim(X)[1])
  {
    myDate = as.Date(X[nContador, 1], format="%e-%b-%y")
    DF[as.character(myDate), item] = X[nContador, "Close"]
  }
  
}

# Determino uma matriz de retornos
#retorno = na.omit(DF)
#ret3 = apply(retorno, 2, scale, scale=FALSE, center=TRUE) 
#colMeans(ret3 )
#(t(ret3) %*% ret3)/(dim(ret3)[1]-1)


# Calculo matriz de variancia e covariancia
var(DF, na.rm = T)

DF_limpo = na.omit(DF)
retorno = diff(DF_limpo)/DF_limpo[-dim(DF_limpo)[1],]

var(retorno)
cor(retorno)

