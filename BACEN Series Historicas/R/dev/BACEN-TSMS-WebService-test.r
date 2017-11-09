source("../lib/BACEN-TSMS-WebService.r");

## Códigos a serem consultados
codes = c(4606,4607);

## Retorno Default como um 'data.frame'
data = TSMSGetSeries(codes);

## Retorno Default como um 'data.frame'
data = TSMSGetSeries(codes, output="data.frame");

## Retorno Default como um 'list'
data = TSMSGetSeries(codes, output="list");

## Retorno Default como um 'xml'
data = TSMSGetSeries(codes, output="xml");

## Chamada de datas como strings
data = TSMSGetSeries(codes,startDate="01/01/2012",endDate="01/01/2014");

## Chamada com datas como Dates
data = TSMSGetSeries(codes,startDate=as.Date("2012-01-01"),endDate=as.Date("2014-01-01"));