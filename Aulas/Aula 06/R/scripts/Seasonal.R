install.packages("httr")
install.packages("XML")
install.packages("RCurl")
install.packages("lubridate")
install.packages("XLConnect")
install.packages("seasonal")
install.packages("seasonalview")


source(file = "../lib/BACEN-TSMS-WebService.r");

## Packages R
library(seasonal);
library(seasonalview);
library(lubridate);
# library(lubridate);

codes = 188;

startDate = as.Date("2012-01-01");

data = TSMSGetSeries(codes, startDate = startDate);

head(data)

# criar o objeto TS
data.ts  =ts(data=data[["VALOR"]], start = c(year(startDate), month(startDate)),
             frequency = 12);

## Seasonal
data.seas = seas(data.ts);
plot(data.seas)

seasonalview::view(data.seas)

spec = list(arima.model="(1 0 1)(1 0 0)", outlier=NULL)
data.seas = seas(data.ts, list = spec);
final(data.seas)
    