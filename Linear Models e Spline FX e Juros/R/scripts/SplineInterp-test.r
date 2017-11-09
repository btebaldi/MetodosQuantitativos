rm(list = ls())

## Ler os dados da planilha
library(XLConnect);

## Source
source("./lib/SplineInterp.r");


## Abrir a workbook
wb = loadWorkbook("./database/CurvaDeJuros.xlsx");

## Ler planilha
yield_data = readWorksheet(wb,"Plan1",startRow=1,startCol=12);

xout = c(100,200,300);

yout = SplineInterp(yield_data[["WorkDays"]], yield_data[["Price"]], xout);

plot(yield_data[["WorkDays"]], yield_data[["Price"]])
lines(xout, yout, col="red")


