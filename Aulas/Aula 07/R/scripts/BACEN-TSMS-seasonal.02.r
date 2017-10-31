source("../lib/BACEN-TSMS-WebService.r");
library(XLConnect);
library(seasonal);
library(lubridate);

## Configuração de Proxy
# config = use_proxy(url="tmg.net.xxxxx.com.br", port = 80, username = "xxxxxx", password = "xxxxx", auth = "basic");
config = NULL;

## Códigos de séries de inflação
codes = c(433,188,189,190);

## Baixa as séries
data = TSMSGetSeries(codes, config = config, startDate="01/01/2014");

## Faz o ajuste sazonal e armazena na planilha

## Arquivo
filepath = "../workbooks/BACEN-seasonal-v0.1.xlsx";

## PLanilha
sheet = "seasonal";


for (i in 1:length(codes)){

  ## Data Inicial da Time Series ("ts")
  startDate = min(data[data$ID==codes[i],"DATA"]);
  
  ## Dados para criar a série
  x = data[data$ID==codes[i],"VALOR"];
  
  ## Criação da Time Series
  x.ts = ts(x, frequency = 12, start = c(year(startDate),month(startDate)));
  
  ## Ajustre
  x.ts.seas = seas(x.ts);
  
  print(summary(x.ts.seas));
  
  ## Valores após o ajute sazonal
  x.seas = final(x.ts.seas);
  
  ## Grava em uma planilha existente
  
  ## Carrega o workbook
  wb = loadWorkbook(filepath);
  
  ## Coluna
  col = 3*(i-1)+1;

  ## Linha
  row = 1

  ## Grava a série original
  
  ## Header
  writeWorksheet(wb,"ID",sheet,startRow=row,startCol=col,header=FALSE);
  writeWorksheet(wb,codes[i],sheet,startRow=row,startCol=col+1,header=FALSE);
  row = row + 1;
  writeWorksheet(wb,"Start Date",sheet,startRow=row,startCol=col,header=FALSE);
  writeWorksheet(wb,min(data[data$ID==codes[i],"DATA"]),sheet,startRow=row,startCol=col+1,header=FALSE);
  row = row + 1;
  writeWorksheet(wb,"End Date",sheet,startRow=row,startCol=col,header=FALSE);
  writeWorksheet(wb,max(data[data$ID==codes[i],"DATA"]),sheet,startRow=row,startCol=col+1,header=FALSE);
  row = row + 1;
  writeWorksheet(wb,"Last Update",sheet,startRow=row,startCol=col,header=FALSE);
  writeWorksheet(wb,Sys.time(),sheet,startRow=row,startCol=col+1,header=FALSE);
  
  ## Grava o data frame completo
  row = row + 2;
  df = data[data$ID==codes[i],c("DATA","VALOR")];
  df[["VALOR.SA"]] = as.numeric(x.seas);
  
  ## Escreve
  writeWorksheet(wb,df,sheet,startRow=row,startCol=col,header=TRUE);
  
  ## Grava
  saveWorkbook(wb,filepath);  
}
