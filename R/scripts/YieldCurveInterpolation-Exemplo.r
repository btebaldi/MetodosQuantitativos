## Descricao:
## - Script para testar a funcao de calculo de dias uteis
## - script para testar a interpolacao da curva de juros
rm(list = ls())

## --- Bibliotecas do R ----
library(bizdays);
library(ggplot2)

# --- Bibliotecas do Usuario ----
source("./lib/CubicSpline.r");
source("./scripts/BBG-MarketData_DataLoader.r")

## Verificacao
cat(sprintf("Ref Date: %s\n",refDate));

## -- Teste de intepolacao
## Datas para teste
dates = as.Date(c("2018-05-15","2018-05-22","2018-06-06","2018-06-20","2018-07-18",
                  "2018-09-13","2019-01-24","2019-10-10","2021-03-19","2022-05-02"));


## Dias Uteis
calendar = create.calendar("ANBIMA",holidaysANBIMA,weekdays = c("saturday","sunday"));
wdays = bizdays(from=refDate, to=dates, calendar);


for (i in 1:length(dates)) {

  ## Interpola utilizando Constrained Cubic Spline
  yield = CCSpline(yiedlCurve$WorkDays, yiedlCurve$Yield, wdays[i]);
  
  ## Verificacao
  ## Index da data imediatamente a data simulada. Datas ordenadas e TRUE==1 FALSE==0
  idx = sum(yiedlCurve[,"WorkDays"]<wdays[i]);
  
  cat(sprintf("Vertice anterior:\t%s %.4f%%\n",as.Date(yiedlCurve[[idx,"Maturity"]]),yiedlCurve[[idx,"Yield"]]*100));
  cat(sprintf("Interpolação:\t\t%s %.4f%%\n",dates[i],yield$y_star*100));
  cat(sprintf("Vertice posterior:\t%s %.4f%%\n\n",as.Date(yiedlCurve[[idx+1,"Maturity"]]),yiedlCurve[[idx+1,"Yield"]]*100));
  
  # myPlot = myPlot + geom_point(data = yield, aes(x_star, y_star), colour = "red")
}

min.grid = range(yiedlCurve$WorkDays)[1]
max.grid = range(yiedlCurve$WorkDays)[2]


yield = CCSpline(yiedlCurve$WorkDays, yiedlCurve$Yield, min.grid:max.grid);

ggplot(yiedlCurve) + geom_point(aes(x=WorkDays, y=Yield)) +
  geom_line(data = yield, aes(x_star, y_star), colour = "red")






  


