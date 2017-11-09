library(XLConnect);
source("../lib/BACEN-TSMS-WebService.r");


## Carregar o arquivo de configuração
source("../conf/Series-SetorExterno.conf.r");

for(i in 1:length(series)){
  
  print(series[[i]]$name);
  
  ## Baixo a séries
  data = TSMSGetSeries(series[[i]]$id,
                       startDate = series[[i]]$startDate,
                       endDate = series[[i]]$endDate);
 
  ## Carregar o Woorkbook
  wb = loadWorkbook(series[[i]]$workbook);
    
  ## Verificar se a planinha existe
  if (!existsSheet(wb,series[[i]]$worksheet)){
    ## Se não existir temos que criar
    createSheet(wb,series[[i]]$worksheet);
  }
  
  header = data.frame();
  header[1,"campo"] = "Nome:";
  header[1,"valor"] = series[[i]]$name;
  header[2,"campo"] = "ID:";
  header[2,"valor"] = series[[i]]$id;
  header[3,"campo"] = "Data Inicial:";
  header[3,"valor"] = format(series[[i]]$startDate,"%d/%m/%Y");
  header[4,"campo"] = "Data Final:";
  header[4,"valor"] = format(series[[i]]$endDate,"%d/%m/%Y");

  ## Escreve o header na planilha
  writeWorksheet(wb,data=header,sheet=series[[i]]$worksheet,header=FALSE,startRow=1,startCol=1);
  
  ## Escreve a series de dados
  writeWorksheet(wb,data=data[,-3],sheet=series[[i]]$worksheet,header=TRUE,startRow=nrow(header)+1,startCol=1);
  
  ## Gravar o workbook
  saveWorkbook(wb);

  print(data)
}