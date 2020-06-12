# Aula 2
## Script que calcula a variancia do retorno diario de VALE5

# clear all
rm(list = ls())

# library(XLConnect);
library(readxl)
library(dplyr)

## Abre a planilha de dados
wb <- read_excel("./database/BBG-BMFBOVESPA-Equities-PX_LAST.xlsx")

# mostra um preview da tabela
head(wb)

# Seleciona a coluna VALE5
wb.vale <- wb %>% dplyr::select(VALE5)

# Calcula o retornos
wb.vale$log = log(wb.vale$VALE5)
wb.vale$ret = wb.vale$log - dplyr::lag(wb.vale$log)

# Calcula a volatilidade
vale.var = var(wb.vale$ret, na.rm = T)
cat(sprintf("Volatilidade de: %f", vale.var^0.5))
