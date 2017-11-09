library(RODBC);


## Função Carregada dados de um arquivo arquivo de dados separado por ';'
DataLoaderFileCSV = function (filepath) {
  
  ## Numero de linhas
  nlines = length(readLines(filepath));
  
  ## Lê os dados
  data = read.table(filepath,
                    header = TRUE, sep = ";", dec = ",",
                    stringsAsFactors=FALSE,
                    nrows = (nlines-2),
                    check.names = FALSE,
                    strip.white = TRUE,
                    na.strings=c("-"));
  
  ## Converte a coluna Dates para o formato Data
  data[['Data']] = sprintf("01/%s",data[['Data']]);
  data[['Data']] = as.Date(data[['Data']],format="%d/%m/%Y");
  
  ## Altera o nome das colunas eliminando os sufixos
  colnames(data)= gsub("(\\w+).*","\\1",colnames(data));
  
  ## Força a conversão
  for(i in 2:ncol(data)){
    if (class(data[1,i])!="numeric"){
      data[,i] = as.numeric(gsub("\\.","",data[,i]));
    }
  }
  
  ## Retorna o dataframe com os dados lidos
  return(data);
  
}

## Carrega os dados do arquivo
DataInsert = function(conn, data){
  
  log = list(inserted=0,updated=0)
  
  ## Primeira coluna é sempre 'Data'
  for (i in 2:ncol(data)){
    
    ## Seleciona do dicionário o ID_SERIE, MULTIPLO e TABELA_DADOS
    query = sprintf("select ID_SERIE, MULTIPLO, TABELA_DADOS from SERIES_DIC_BACEN, SERIES_DEFINICAO where CODIGO=%s AND SERIES_DIC_BACEN.ID_SERIE=SERIES_DEFINICAO.ID",colnames(data)[i]);
    resultset = sqlQuery(conn,query);
    
    ## Insere as linha
    if (nrow(resultset)>0){
      for (j in 1:nrow(data)){
        if (!is.na(data[j,i])){
          query = sprintf("insert into %s (ID_SERIE,DT_ATUALIZADAO,DT_REFERENCIA,VALOR) values (%d,%s,%s,%f)",
                          resultset[1,"TABELA_DADOS"],resultset[1,"ID_SERIE"],quote(Sys.Date()),quote(data[j,"Data"]),
                          data[j,i]*resultset[1,"MULTIPLO"]);
          sqlQuery(conn,query);
          
          log$inserted = log$inserted +1;
        }
      }
    } else {
      cat(sprintf("ERRO: Série não encontrada: ",colnames(data)[i])); 
    }
  }
  
  return(log);
  
}

## Carrega os dados do arquivo
DataUpdateOrInsert = function(conn, data){
  
  log = list(inserted=0,updated=0)
  
  ## Para cada SERIE (ou coluna)
  
  ## Primeira coluna é sempre 'Data'
  for (i in 2:ncol(data)){
    
    ## Seleciona do dicionário o ID_SERIE, MULTIPLO e TABELA_DADOS
    query = sprintf("select ID_SERIE, MULTIPLO, TABELA_DADOS from SERIES_DIC_BACEN, SERIES_DEFINICAO where CODIGO=%s AND SERIES_DIC_BACEN.ID_SERIE=SERIES_DEFINICAO.ID",colnames(data)[i]);
    resultset = sqlQuery(conn,query);
    
    ## Insere as linha
    if (nrow(resultset)>0){
      for (j in 1:nrow(data)){
        if (!is.na(data[j,i])){
          ## Tenta fazer o update
          query = sprintf("update %s set VALOR=%f, DT_ATUALIZADAO=#%s# where ID_SERIE=%d and DT_REFERENCIA=#%s#",
                          resultset[1,"TABELA_DADOS"],data[j,i]*resultset[1,"MULTIPLO"],Sys.Date(),
                          resultset[1,"ID_SERIE"],data[j,"Data"]);
          
          result = sqlQuery(conn,query, errors=FALSE);
          
          if (result!=-1) {
            log$updated = log$updated + 1;
          } else {  
            ## Tenta fazer o insert
            query = sprintf("insert into %s (ID_SERIE,DT_ATUALIZADAO,DT_REFERENCIA,VALOR) values (%d,%s,%s,%f)",
                            resultset[1,"TABELA_DADOS"],resultset[1,"ID_SERIE"],quote(Sys.Date()),quote(data[j,"Data"]),
                            data[j,i]*resultset[1,"MULTIPLO"]);
            result = sqlQuery(conn,query);
            
            log$inserted = log$inserted + 1;
          }
        }
      }
    } else {
      cat(sprintf("ERRO: Série não encontrada: ",colnames(data)[i])); 
    }
  }
  
  return(log);
  
}


