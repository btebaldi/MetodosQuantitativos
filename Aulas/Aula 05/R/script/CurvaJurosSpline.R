cat("\014")
rm(list = ls())

# Xl Connect tools > install packages
library(XLConnect)

## carregar o workbook
wb = loadWorkbook(filename = "../database/BBG-CurvaDeJurios.xlsx")

## ler a planilha
data1 = readWorksheet(object = wb, sheet = "Juros Valores", header = T, 
                     startRow = 0, startCol = 0, useCachedValues = T)

plot(data1$DU, data1$Taxa, type = "l")


## Cria uma funcao
mySpline = splinefun(data1$DU, data1$Taxa)

DUs = c(1500)

taxa_inter = mySpline(DUs)

plot(data1$DU, data1$Taxa, type = "l")
points(DUs, taxa_inter)


# Crian Spline
spline_obj = spline(x=data1$Du, y=data1$Taxa, xout = DUs);

