## Carregar biblioteca do R
library(XLConnect);

## Carregar bibliotcas user
source("../lib/ValorPresenteFluxo.r")

## Configucoes

workbook = "../../workbooks/ValorPresenteFluxo-Teste.xlsx";

sheet = "Fluxo";

DU = readWorksheetFromFile(workbook, sheet=sheet,
                           region="D8:D19",
                           useCachedValues=TRUE)[[1]];

CF = readWorksheetFromFile(workbook, sheet=sheet,
                           region="E8:E19", 
                           useCachedValues=TRUE)[[1]];

r = readWorksheetFromFile(workbook, 
                          sheet=sheet, 
                          region="B6:B6", 
                          header=FALSE, 
                          useCachedValues=TRUE)[[1]];

VP = ValorPresenteFluxo(CF,DU,r)


### Alternatiova

df = readWorksheetFromFile(workbook, sheet=sheet, 
                           region="A8:E19", 
                           useCachedValues=TRUE);

DU = df[["DU"]];

CF = df[["Valor.Futuro"]];

r = readWorksheetFromFile(workbook, sheet=sheet, region="B6:B6", header=FALSE, useCachedValues=TRUE)[[1]];


a = 10
str = "abc"

cat(sprintf("o numero a=%d a string str = %s de novo %d\n",a,str,a))





