## Script que calcula a variância do retornos diários
library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel

## Carrega a matriz de preços
prices = readWorksheet(wb, sheet = 1, header=TRUE, startRow=1, startCol=1);

## Vetor de ações de interesse


## Calcula o retornos


## Calcula a matriz de covariância


## Calcula a matriz de correlação

