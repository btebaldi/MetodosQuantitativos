# Aula 3
## --- Script de producao

## ---- Bibliotecas do Usu?rio
source("../lib/TituloPublicoFederalBr.r")


## ---- Programa Principal

## Data de Refer?ncia
dataRef = as.Date("2020-04-28");

## Base de T?tulos
data = data.frame(titulo = c("NTN-F","NTN-F","NTN-F","NTN-F"),
                  dataVencto=c(as.Date("2021-01-01"),as.Date("2023-01-01"),as.Date("2025-01-01"),as.Date("2027-01-01")),
                  TIR = c(0.028600, 0.49050, 0.064684, 0.073385));


for (i in 1:nrow(data)){
  
  PU = TPFBrPU(data[i,"titulo"],dataRef,data[i,"dataVencto"],data[i,"TIR"])
  print(PU)
  
}