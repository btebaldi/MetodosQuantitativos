# Aula 2
# Clear all
rm(list = ls())

## Script que calcula a vari?ncia do retornos di?rios
# library(XLConnect);
library(readxl)
library(dplyr)


## Abre a planilha de dados
# wb = loadWorkbook("../database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx");
wb <- read_excel("./database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx")

head(wb)
## Carrega os dados do Excel

## Carrega a matriz de pre?os
# prices = readWorksheet(wb, sheet = 1, header=TRUE, startRow=1, startCol=1);


## Vetor de a??es de interesse
equities = c("CSNA3","ELET6","PETR3","PETR4","VALE5","IBOV");

wb.equities = wb %>% select(equities);

## Calcula o retornos
for (col in equities) {
  col_ret = paste(col, "ret", sep = "_")
  col_log = paste(col, "log", sep = "_")
  wb.equities[, col_log] = log(wb.equities[[col]])
  wb.equities[, col_ret] = wb.equities[[col_log]] - lag(wb.equities[[col_log]])
}


## Calcula a matriz de covari?ncia
ret_mat = wb.equities %>% select(paste(equities, "ret", sep = "_")) %>% slice(-1) %>% as.matrix()

# Ones = matrix(1, nrow = nrow(ret_mat), ncol = 1)
# C = diag(nrow(ret_mat)) - (1/nrow(ret_mat))* Ones%*%t(Ones)
# 
# ret_mat.center = C %*% ret_mat
# cov_1 = (t(ret_mat.center) %*% ret_mat.center) * (1/(nrow(ret_mat)-1))
covariancia = cov(ret_mat)
print(covariancia)

## Calcula a matriz de correlacao
correlacao = cor(ret_mat)
print(correlacao)
