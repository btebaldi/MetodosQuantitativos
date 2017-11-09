
source("../lib/BACEN-TSMS-WebService.r");

## Séries a serem coletadas
series = c(20539,20540,20541);
series = c(4606,4607);

## Modo 01: Várias séries de uma vez

## Chamada de datas como strings
data = TSMSGetSeries(series,startDate="01/01/2012",endDate="01/01/2014");

## Chamada com datas como datas
data = TSMSGetSeries(series,startDate=as.Date("2012-01-01"),endDate=as.Date("2014-01-01"));

data = TSMSGetSeries(series);
print(data);

## Modo 02: Uma série de cada vez

for(i in 1:length(series)){
  
  ## Chamada de datas como strings
  ## data = TSMSGetSeries(series[i],startDate="01/01/2012",endDate="01/01/2014");
  
  ## Chamada com datas como datas
  ## data = TSMSGetSeries(series[i],startDate=as.Date("2012-01-01"),endDate=as.Date("2014-01-01"));
  
  ## Chamada com valores default para datas
  data = TSMSGetSeries(series[i]);
  
  print(data);
}






