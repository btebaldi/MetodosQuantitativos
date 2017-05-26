source("../lib/BACEN-TSMS-WebService.r");
library(XLConnect);
library(seasonal);
library(lubridate);
library(seasonalview);

## Configuração de Proxy
# config = use_proxy(url="tmg.net.xxxxx.com.br", port = 80, username = "xxxxxx", password = "xxxxx", auth = "basic");
config = NULL;

## Códigos de séries de inflação
# codes = c(188,189,190,433);

codes = 433;


## Baixa as séries
data = TSMSGetSeries(codes, config = config, startDate="01/01/2005");


startDate = min(data[["DATA"]]);
data.ts = ts(data[["VALOR"]], frequency = 12, start = c(year(startDate),month(startDate)));

data.seas = seas(data.ts);
data.seas = seas(data.ts,arima.model = "(0 1 1)(0 1 1)");

view(data.seas)

## Especificando
spec = list("arima.model" = "(0 1 1)(0 1 1)", "outlier"=NULL, "regression.aictest" = "td");
data.seas = seas(data.ts,list = spec);
print(final(m));
print(original(m)); 

## NA handling
# data.seas = seas(data.ts, na.action = na.omit))    # no NA in final series
# data.seas = seas(data.ts, na.action = na.exclude)) # NA in final series
# data.seas = seas(data.ts, na.action = na.fail))    # fails

## Funções de extração de dados
final(m) 
predict(m)   
original(m) 
resid(m) 
coef(m)
fivebestmdl(m)
out(m)                  # the X-13 .out file (see ?out, for details)
spc(m)                  # the .spc input file to X-13 (for debugging)
