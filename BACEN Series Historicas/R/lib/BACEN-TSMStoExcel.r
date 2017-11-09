library(XLConnect);
source("../lib/BACEN-TSMS-WebService.r");

BACEN_TSMStoExcel = function(workbook,
                             url = "https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl",
                             ssl.verifypeer = FALSE,
                             verbose = 1){
  
  ## Abre a workbook
  wb = loadWorkbook(workbook);
  
  
  ## Percorrer planilhas
  sheets = getSheets(wb);
  
  ## Para cada planilha
  for (i in 1:length(sheets)){
    
    cat(sprintf("sheet: %s lastRow: %d lastColumn: %d\n",sheets[i],getLastRow(wb,sheets[i]),getLastColumn(wb,sheets[i])));
    
    ## Contador de linhas
    row = 1;
    
    ## Contador de colunas
    col = 1;
    
    ## Verifica se há alguma coisa na planilha para ser lida
    if (getLastRow(wb,sheets[i])>1 && getLastColumn(wb,sheets[i])>1){
      
      ## Lê o par chave/valor da primeira linha do cabeçalho    
      pair = readWorksheet(wb,sheets[i],startRow=row,endRow=row,startCol=col,endCol=col+1,header=FALSE);
      
      ## browser();
      
      ## cat(sprintf("sheet: %s row: %d col: %d cell: %s %s\n",sheets[i],row,col,pair[row,col],pair[row,col+1]));
      
      while(nrow(pair)!=0 && pair[1,1] == "Serie ID") {
        
        ## Inicializa o header      
        header = list();
        
        ## Lê o header até encontrar uma linha em branco
        while(is.character(pair[1,1])) {
          
          ## Acrescenta ao header o par chave/valor
          if (!is.null(pair[1,2])){
            header[[pair[1,1]]] = pair[1,2];   
          } else {            
            header[[pair[1,1]]] = NA;
          }
          
          ## 
          
          ## Incrementa o contador de linhas
          row = row + 1;
          
          ## Lê o par chave/valor da linha seguinte
          pair = readWorksheet(wb,sheets[i],startRow=row,endRow=row,startCol=col,endCol=(col+1),header=FALSE);
          
        }
        
        ## -- Obtem os parâmetros
        
        ## Serie ID
        serieId = header[["Serie ID"]];
        
        ## Data Inicial
        dataInicial = header[["Data Inicial"]];
        
        ## Data Final
        dataFinal = header[["Data Final"]];
        
        ## Verifica se a dataFinal foi informada
        if (is.na(dataFinal)) dataFinal = Sys.Date();
        
        
        ## Debug
        if (verbose>0) {
            cat(sprintf("workbook: %s sheet: %s serieID: %d\n",workbook,sheets[i],serieId));
            print(as.data.frame(header));
            cat("--------------------------------------------\n")
        }        
        
        ## Carrega a séries de dados
        data = TSMSGetSeries(serieId, startDate = as.Date(dataInicial), endDate = as.Date(dataFinal));
        
        ## Verifica se há conteúdo no range e limpa se houver
        tmp = readWorksheet(wb,sheets[i],startRow=row+2,startCol=col,endCol=(col+1),header=FALSE);
        if (nrow(tmp)!=0) clearRange(wb,sheets[i],c(row+2,col,row+2+nrow(tmp),col+1));
        
        ## Grava os dados da série
        writeWorksheet(wb,xlformat(data[,c("data","valor")]),sheets[i],startRow=row+2, startCol=col, header=FALSE);
        
        ## Grava a data de atuallização
        writeWorksheet(wb,xlformat(Sys.time()),sheets[i],startRow=which(names(header)=="Update"), startCol=col+1, header=FALSE);
        
        ## Grava a atualização
        saveWorkbook(wb);
        
        ## Reinicia na primeira linha
        row = 1;
        
        ## Incrementa o col
        col = col + 2;
        
        ## Lê o par chave/valor da primeira linha da coluna seguinte
        pair = readWorksheet(wb,sheets[i],startRow=row,endRow=row,startCol=col,endCol=(col+1),header=FALSE);
        
      }
      
    }  
  }
  return(1);
}


## Um "wrapper" para garantir que o formato de datas e de tempo será inserido corretamente
xlformat = function(x){
  if (length(x)>0){
    if (class(x[1])[1]=="Date") {
      x = format(x,"%Y-%m-%d");
    } else if (class(x[1])[1]=="POSIXct"){
      x = format(x,"%Y-%m-%d %H:%M:%S");
    } else if (class(x[1])[1]=="data.frame"){
      for (col in colnames(x)) x[[col]] = xlformat(x[[col]]);
    }  
  }
  return(x);
}