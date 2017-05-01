## remove all objects fromt the current workspace
rm(list = ls())

## Load User scripts
source(file = "dev/BuildQueryString.R")
source(file = "dev/GetDataFromGoogleFinance.R")

dataInicio = "2016-01-01"
dataFim = "2016-12-31"

#Datas = as.Date(dataInicio):as.Date(dataFim)



#datetimes = strptime(c(dataInicio, dataFim), format = "%Y-%m-%d")
#range = difftime(dataFim, dataInicio, units = "days")


Datas = seq(as.Date(dataInicio), as.Date(dataFim), by = "days")

DF = data.frame(VALE5 = numeric(length(Datas)))
rownames(DF) =   format(Datas, format = "%Y-%m-%d")

DF[,1 ] = NA


ticker = c("BVMF:CIEL3", "BVMF:VALE5", "BVMF:BBDC4", "BVMF:ITSA4")

joe =  array(
  data = NA,
  dim = c(as.numeric(range), length(ticker)),
  dimnames = NULL
)

for (item in ticker)
{
  X = GetDataFromGoogleFinance(item, "2016-01-01", "2016-12-31")
  
  
  for (i in 1:dim(X)[1])
  {
    print(sprintf("%s - %f", X[i, 1], X[i, "Close"]))
    
    myDate = as.Date(X[i, 1], format="%e-%b-%y")
    
    print(sprintf("%s - %f", myDate, X[i, "Close"]))
    
    DF[as.character( myDate), 1] = X[i, "Close"]
  }
  
}

table(factor(sample(1:6, size = 10, replace = TRUE), levels = 1:6))

joe[, 1] = X$Close
joe




MyDataframe <-
  data.frame(Name = character(10),
             Tickets  = numeric(10))
