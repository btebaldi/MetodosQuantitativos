## Script que calcula a vari�ncia do retornos di�rios
library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel

## Carrega a matriz de pre�os
prices = readWorksheet(wb, sheet = 1, header=TRUE, startRow=1, startCol=1);

## Vetor de a��es de interesse


## Calcula o retornos


## Calcula a matriz de covari�ncia


## Calcula a matriz de correla��o

