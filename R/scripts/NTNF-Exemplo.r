# Clear all
rm(list = ls())
# Aula 3
# Prototipo de validacao do modelo de calculo de NTNF

# ---- bibliotecas ----
library(bizdays)

# ---- Sources ----
source("./lib/TPF-Br.r")


dataRef      = as.Date("2008-05-20")

dataVencto   = c(as.Date("2014-01-01"), as.Date("2021-01-01"), as.Date("2023-01-01"), as.Date("2031-01-01"))
dataLiquidacao = c(as.Date("2008-05-21"), as.Date("2020-04-28"), as.Date("2020-04-28"), as.Date("2020-04-28"))
Tir = c(13.66/100, 2.86/100, 4.905/100, 7.9704/100)

for (i in 1:length(Tir)) {
  PU = TPFBrPU(titulo = "NTNF", dataVencto = dataVencto[i], dataLiquidacao = dataLiquidacao[i], TIR = Tir[i])
  cat(sprintf("\nTir: %8.6f = Pu: %9.2f", Tir[i], PU))
}
