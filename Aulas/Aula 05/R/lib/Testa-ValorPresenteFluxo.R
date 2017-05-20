#getwd();

## Carrega as bibliotecas do R
library(XLConnect)

## Carrega bibliotecas do usuario
source(file = "../lib/ValorPresenteFluxo.R")


## Load Config
myWorkbook = "../../workbook/ValorPresenteFluxo-Teste.xlsx";
mySheet="Fluxo"

DU=readWorksheetFromFile(myWorkbook,
                         sheet=mySheet,
                         region = "D8:D19",
                         useCachedValues = T)[[1]];

CF=readWorksheetFromFile(myWorkbook,
                         sheet=mySheet,
                         region = "E8:E19",
                         useCachedValues = T)[[1]];

r=readWorksheetFromFile(myWorkbook,
                        sheet=mySheet,
                        region = "B6",
                        useCachedValues = T,
                        header=F)[[1]];


## testa funcao
VP = ValorPresenteFluxo(CF,DU,r)
VP


list = c(2,3,6,5,9,8,7)

for (item in list){
  cat(item)
  
}