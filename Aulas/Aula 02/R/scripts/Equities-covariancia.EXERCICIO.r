## Script que calcula a variância do retornos diários

library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel

## CSN: 34
prices = readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=34, endCol=34, simplify=TRUE);
## ELET6: 41
prices = cbind(prices,readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=41, endCol=41, simplify=TRUE));
## PETR3: 99
prices = cbind(prices,readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=99, endCol=99, simplify=TRUE));
## PETR4: 100
prices = cbind(prices,readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=100, endCol=100, simplify=TRUE));
## VALE5: 132
prices = cbind(prices,readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=132, endCol=132, simplify=TRUE));
## IBOV: 137
prices = cbind(prices,readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=137, endCol=137, simplify=TRUE));


## Calcula o retornos


## Calcula a matriz de covariância

## Calcula a matriz de correlação
