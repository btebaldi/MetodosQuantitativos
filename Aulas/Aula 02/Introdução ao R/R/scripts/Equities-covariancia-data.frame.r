## Script que calcula a variância do retornos diários
library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel

## Carrega a matriz de preços
prices = readWorksheet(wb, sheet = 1, header=TRUE, startRow=1, startCol=1);

## Vetor de ações de interesse
equities = c("CSNA3","ELET6","PETR3","PETR4","VALE5","IBOV");

## Calcula o retornos
returns = log(prices[1:(nrow(prices)-1),equities]/prices[2:nrow(prices),equities]);

## Calcula a matriz de covariância
cov(returns)

## Calcula a matriz de correlação
cor(returns)
