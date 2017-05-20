## Script que calcula a variância do retorno diário de VALE5

library(XLConnect);


## Abre a planilha de dados
wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");

## Carrega os dados do Excel: Linhas 2:fim Colunas: 132 ("EB")
prices = readWorksheet(wb, sheet = 1, header=FALSE, startRow=2, startCol=132, endCol=132, simplify=TRUE)

## Calcula o retornos
returns = log(prices[1:(length(prices)-1)]/prices[2:length(prices)]);

## Calcula a volatilidade
vol = sd(returns);
