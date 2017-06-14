library(RODBC);

## Carrega os dados de um arquivo texto separa do 'tab'

DataLoaderTxt = function(filepath) {
  
  data = read.table(filepath,
                    sep = "\t", dec = ",",
                    header = TRUE,
                    check.names=FALSE,
                    stringsAsFactors=FALSE,
                    na.strings=c(""));
  
  ## Converte para o formato data a coluna de datas
  data[['Date']] = as.Date(data[['Date']],format="%d/%m/%Y");
  
  ## Ordenação
  data = data[order(data[['Date']]),];
  
  ## Altera o nome das colunas eliminado o sufixo dos nomes "Curncy, Index, Govt..."
  colnames(data) = gsub("(\\w+)\\s.+","\\1",colnames(data),perl=TRUE);
  
  ## Retorna os dados
  return(data);
}


library(RODBC);

## Arquivos de funÃ§Ãµes para a carga de dados

## Loader a partir de planilha Excel ----

DataLoaderExcel = function(filepath, worksheet) {
  
  ## Connect to Excel
  conn = odbcConnectExcel2007(filepath);
  
  ## Carrega os dados de uma planilha
  data = na.exclude(sqlFetch(conn, worksheet, na.strings=c("","-","#N/A N/A")));
    
  ## Close connection
  odbcClose(conn);

  ## Converte para o formato data a coluna de datas
  data[['Date']] = as.Date(data[['Date']]);
  
  ## Ordenação
  data = data[order(data[['Date']]),];
  
    
  ## Retorna os dados
  return(data);
  
}





