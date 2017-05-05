DataLoaderTxt = function(filename)
{
  cat("\014")
  ## Ler o arquivo de dados
  Dados = read.table(
    file = filename,
    header = T,
    sep = "\t",
    dec = ",",
    stringsAsFactors = F
  )
  
  # converte para Date
  # as.Date(Dados[,1], format = "%d/%m/%Y")
  
  Dados[["Date"]] = as.Date(Dados[["Date"]], format = "%d/%m/%Y")
  
  # ordenar pela coluna "Date"
  Dados = Dados[order(Dados[["Date"]], decreasing = F)]
  
  ## 
  colnames(Dados)= gsub("(\^.+)\.")
  
  #  order()
  return(Dados)
}
