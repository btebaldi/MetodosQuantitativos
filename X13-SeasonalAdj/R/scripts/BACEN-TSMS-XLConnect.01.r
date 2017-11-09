source("../lib/BACEN-TSMS-WebService.r");
library(XLConnect);

## Configuração de Proxy
config = use_proxy(url="tmg.net.bradesco.com.br", port = 80, username = "CORP\\f930131", password = "sun1705", auth = "ntlm");

## Códigos de séries de inflação
codes = c(188,189,190,433);

## Baixa as séries
data = TSMSGetSeries(codes, config = config, startDate="01/01/2005");

head(data);

## Grava em uma planilha existente

## Arquivo
filepath = "../workbooks/WriteWorkbook-v0.1.xlsx";

## PLanilha
sheet = 3;

for (i in 1:length(codes)){
  
  ## Coluna
  col = 2*(i-1)+1;
  
  ## Linha
  row = 1
  
  ## Carrega o workbook
  wb = loadWorkbook(filepath);
  
  
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
  row = row + 3;
  writeWorksheet(wb,data[data$ID==codes[i],c("DATA","VALOR")],sheet,startRow=row,startCol=col,header=FALSE);
  
  ## Save
  saveWorkbook(wb,filepath);  
  
}
