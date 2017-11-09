## Source
source("../lib/BACEN-TSMS-WebService.r");

## Packages R
library(seasonal);
library(seasonalview);
library(lubridate);


## Código da série
codes = 188;
codes = 433;

## Data de Inicio
startDate = as.Date("2012-01-01");

## Buscar os dados
data = TSMSGetSeries(codes,startDate=startDate);

## Criar o objeto ts
data.ts = ts(data[["VALOR"]],start = c(year(startDate),month(startDate)), frequency = 12);

## Seasonal
spec = list(arima.model="(1 0 1)(1 0 0)",outlier = NULL);

## Ajuste sazonal
data.seas = seas(data.ts)
data.seas = seas(data.ts, list=spec);
final(data.seas);
original(data.seas)
plot(data.seas);
view(data.seas);
summary(data.seas);

