## Source
source("../lib/BACEN-TSMS-WebService.r");

## Packages R
library(seasonal);
library(seasonalview);
library(lubridate);
library(XLConnect);

## Carrega o arquivo de cojnfiguração
source("../conf/IndicePrecos.config.r");

## Variáveis auxiliares
row = 0;
col = 0;

## Para cada série de dados
for (i in 1:length(series)){
  
  ## Data de inicio
  startDate = series[[i]][["startDate"]];
  
  ## Buscar os dados
  data = TSMSGetSeries(series[[i]][["ID"]],startDate=startDate);

  ## Criar o objeto ts
  data.ts = ts(data[["VALOR"]],start = c(year(startDate),month(startDate)), frequency = 12);
  
  ## Fazer o ajuste
  data.seas = seas(data.ts, list=series[[i]][["seas.spec"]]);
  
  ## Incluir a coluna no data.frame
  data[["VALOR.SA"]] = as.numeric(final(data.seas));
  data[["VALOR"]] = as.numeric(data[["VALOR"]]);
  
  ## verificaçao
  print(head(data));
  
  ## Gravar na planilha
  wb = loadWorkbook(workbook);
  
  ## Header
  row = 1;
  col = 3*(i-1)+1;
  
  writeWorksheet(wb,"ID",sheet=sheet, startRow = row, startCol = col, header = FALSE);
  writeWorksheet(wb,series[[i]][["ID"]],sheet=sheet, startRow = row, startCol = col+1, header = FALSE);
  row = row + 1;
  writeWorksheet(wb,"startDate",sheet=sheet, startRow = row, startCol = col, header = FALSE);
  writeWorksheet(wb,series[[i]][["startDate"]],sheet=sheet, startRow = row, startCol = col+1, header = FALSE);
  
  row = row + 2;
  writeWorksheet(wb,data[,-1],sheet=sheet, startRow = row, startCol = col, header = TRUE);

  ## Grava o arquivo
  saveWorkbook(wb);
}
