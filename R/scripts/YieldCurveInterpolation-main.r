## Descri??o:
## - Script para testar a fun??o de c?lculo de dias uteis
## - script para testar a interpolacao da curva de juros
rm(list = ls())

## --- Bibliotecas do R
# library(XLConnect); ## Instalar pacote se necessario [Tools] [Install packages...]
library(bizdays);
library(ggplot2)

## --- Bibliotecas do Usu?rio
source("./lib/MetQuantLib_v2.r");

## --- Programa Principal


## -- Carrega as informa??es da curva ----
source("./scripts/BBG-MarketData_DataLoader.r")
 
 
 
## Carregar o arquivo workbook excel
# wb = loadWorkbook("../database/BBG-MarketData.v0.1.xlsx");

## Ler o conte?do da planilha

## Data de referencia. celula B1
# refDate = readWorksheet(wb,sheet="YieldCurve",
#                         startRow = 1, startCol = 2, 
#                         endRow = 1, endCol = 2, 
#                         header = FALSE, 
#                         useCachedValues = TRUE);

## Por padrao traz um data.frame 1x1 com a data. Vamos transformar no tipo 'Date'
# refDate = as.Date(refDate[1,1]);

## Verificacao
cat(sprintf("Ref Date: %s\n",refDate));

## Carrega dos dados da curva. celula B4 (canto esquerdo superior)
# yiedlCurve = readWorksheet(wb,sheet="YieldCurve",
#                         startRow = 4, startCol = 2, 
#                         header  = TRUE, 
#                         useCachedValues = TRUE);

## -- Teste de intepola??o
## Datas para teste
dates = as.Date(c("2018-05-15","2018-05-22","2018-06-06","2018-06-20","2018-07-18",
                  "2018-09-13","2019-01-24","2019-10-10","2021-03-19","2022-05-02"));


## Dias ?teis
calendar = create.calendar("ANBIMA",holidaysANBIMA,weekdays = c("saturday","sunday"));
wdays = bizdays(from=refDate, to=dates, calendar);


for (i in 1:length(dates)) {

  ## Interpola utilizando Constrained Cubic Spline
  yield = CCSpline(yiedlCurve$WorkDays, yiedlCurve$Yield, wdays[i]);
  
  ## Verifica??o
  ## Index da data imediatamente a data simulada. Datas ordenadas e TRUE==1 FALSE==0
  idx = sum(yiedlCurve[,"WorkDays"]<wdays[i]);
  
  cat(sprintf("Vertice anterior:\t%s %.4f%%\n",as.Date(yiedlCurve[[idx,"Maturity"]]),yiedlCurve[[idx,"Yield"]]*100));
  cat(sprintf("Interpolação:\t\t%s %.4f%%\n",dates[i],yield$y_star*100));
  cat(sprintf("Vertice posterior:\t%s %.4f%%\n\n",as.Date(yiedlCurve[[idx+1,"Maturity"]]),yiedlCurve[[idx+1,"Yield"]]*100));
  
  # myPlot = myPlot + geom_point(data = yield, aes(x_star, y_star), colour = "red")
}

yield = CCSpline(yiedlCurve$WorkDays, yiedlCurve$Yield, 1:2900);

ggplot(yiedlCurve) + geom_point(aes(x=WorkDays, y=Yield)) +
  geom_line(data = yield, aes(x_star, y_star), colour = "red")






  


