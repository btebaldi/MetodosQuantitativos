# xml2 rvest
IpeaData.GetSerie = function (numeroSerieIpeaData)
{
  pagina = xml2::read_html(IpeaData.SerieUrl(numeroSerieIpeaData))
  MainTable=rvest::html_nodes(pagina, css=c(".dxgvTable"))
  TableRows = rvest::html_children(MainTable)
  TableDivisions = rvest::html_children(TableRows)
  
  Textos = rvest::html_text(TableDivisions)
  
  i=1
  while(i <= length(Textos))
  {
    if(i==1)
    {
      data = data.frame("Col1"=NA, "Col2"=NA)
      colnames(data) = c(gsub("\r\n\t+", "", Textos[i]), gsub("\r\n\t+", "", Textos[i+1]))
    }  else
    {
      data[(i-1)/2, 1] = gsub("\r\n\t\t+", "", Textos[i])
      
      valor = gsub("\\.", "", Textos[i+1])
      valor = gsub(",", ".",valor)
      data[(i-1)/2, 2] = as.numeric(valor)
    }
    i = i+2
  }
  
  return(data)
}

IpeaData.SerieUrl = function(numeroSerieIpeaData)
{
  baseUrl = "http://www.ipeadata.gov.br/ExibeSerie.aspx"
  completeUrl = paste(c(baseUrl, "?serid=", numeroSerieIpeaData), collapse = "")
  
  return(completeUrl)
}

IpeaData.GetPim = function(withYearMonthCol = F)
{
  # Produção industrial - indústria geral - quantum - índice (média 2002 = 100)
  pimAntiga = IpeaData.GetSerie(1506214698)
  
  # Produção industrial - indústria geral - quantum - índice (média 2012 = 100)
  pimNova = IpeaData.GetSerie(1056104108)
  
  # Determino uma serie unica para a PIM utilizando a mesma taxa de crescimento
  txPimAntiga = pimAntiga[-1,2]/pimAntiga[-nrow(pimAntiga),2]

  # Localizo a data de primeira publicacao da serie nova na serie antiga
  idx = pimAntiga[,1]==pimNova[1,1]
  
  # tamanho da serie a ser calculada a partir da serie antiga
  size = which(idx)-1
  
  # Crio o dataframe de retorno
  data = data.frame("Data" = NA, "Valor"=matrix(NA, nrow = (size+nrow(pimNova)), ncol = 1))

  # Busco os valores de Data da serie Antiga
  data[1:size,1]=pimAntiga[1:size,1]
  
  # Busco os valores de Data e da PIM da serie Nova
  data[(size+1):(size+nrow(pimNova)),]=pimNova[,]
  
  # Faz o calculo de variacao da PIM retroativo
  i=size
  while(i > 0)
  {
    data[i, 2] = data[i + 1, 2] / txPimAntiga[i]
    
    i = i - 1
  }
  
  if(withYearMonthCol)
  {
   data[,"Year"] = as.numeric(regmatches(data[,1], regexpr("^\\d{4}", data[,1])))
   data[,"month"] = as.numeric(regmatches(data[,1], regexpr("\\d{2}$", data[,1])))
  }
  
  # Devolve a serie completa
  return(data)
}