
## Carrega os dados de um arquivo texto separa do 'tab'

DataLoaderTxt = function(filepath) {
  
  data = read.table(filepath,
                    sep = "\t", dec = ",",
                    header = TRUE,
                    stringsAsFactors=FALSE,
                    na.strings=c(""));
  
  ## Converte para o formato data a coluna de datas
  data[['Date']] = as.Date(data[['Date']],format="%d/%m/%Y");
  
  ## Ordenação
  data = data[order(data[['Date']]),];
  
  ## Altera o nome das colunas eliminado o sufixo dos nomes "Curncy, Index, Govt..."
  colnames(data) = gsub("(\\w+)\\..+","\\1",colnames(data),perl=TRUE);

  ## Retorna os dados
  return(data);
}
