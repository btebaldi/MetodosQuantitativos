# Aula 2
# Clear all
rm(list = ls())

## Script que calcula a variancia do retornos diarios
# library(XLConnect);
library(readxl)
library(dplyr)


## Abre a planilha de dados
## Carrega os dados do Excel
wb <- read_excel("./database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx")

head(wb)

## Vetor de acoes de interesse
equities = c("CSNA3","ELET6","PETR3","PETR4","VALE5","IBOV");

wb.equities = wb %>% select(equities);

## Calcula o retornos
for (col in equities) {
  col_ret = paste(col, "ret", sep = "_")
  col_log = paste(col, "log", sep = "_")
  wb.equities[, col_log] = log(wb.equities[[col]])
  wb.equities[, col_ret] = wb.equities[[col_log]] - lag(wb.equities[[col_log]])
}


## Calcula a matriz de covariancia
ret_mat = wb.equities %>% select(paste(equities, "ret", sep = "_")) %>% slice(-1) %>% as.matrix()

covariancia = cov(ret_mat)
print(covariancia)

## Calcula a matriz de correlacao
correlacao = cor(ret_mat)
print(correlacao)
