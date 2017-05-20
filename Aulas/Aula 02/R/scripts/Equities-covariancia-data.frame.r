## Script que calcula a vari�ncia do retornos di�rios
library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel

## Carrega a matriz de pre�os
prices = readWorksheet(wb, sheet = 1, header=TRUE, startRow=1, startCol=1);

## Vetor de a��es de interesse
equities = c("CSNA3","ELET6","PETR3","PETR4","VALE5","IBOV");

## Calcula o retornos
returns = log(prices[1:(nrow(prices)-1),equities]/prices[2:nrow(prices),equities]);

## Calcula a matriz de covari�ncia
cov(returns)

## Calcula a matriz de correla��o
cor(returns)
