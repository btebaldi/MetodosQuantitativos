Abcr.DownloadFile = function(fileName = "IndiceABCR.xls", downloadLocation = "../database/", downloadName = "IndiceABCR.xls")
{
  destination = My.Util.PathCombine(c(downloadLocation, downloadName))
  download.file(Abcr.Url(fileName), destfile = destination, method = "auto", mode = "wb")
}


Abcr.Url = function(fileName)
{
  baseUrl = "http://www.abcr.org.br/Download.ashx"
  completeUrl = paste(c(baseUrl, "?arquivo=", fileName), collapse = "")
  
  return(completeUrl)
}


Abcr.GetData = function(workbook)
{

  wbFullPath = My.Util.PathCombine(c("../database",workbook))
  
  if(!file.exists(wbFullPath))
  {
    stop("Arquivo não encontrado no diretorio database.")
  }
  
  # Carrega o workbook
  wb =  XLConnect::loadWorkbook(wbFullPath);
  
  data = list("Original" =
                list(
                  "BR" = NA,
                  "SP" = NA,
                  "PR" = NA,
                  "RJ" = NA
                ))
  
  ## Leitura dos dados de Brazil
  data$Original$BR = XLConnect::readWorksheet(object = wb,sheet = "(C) Original",
                           header = TRUE, startRow = 3, startCol = 2, endCol = 4);
  

  ## Leitura dos dados de Sao Paulo
  data$Original$SP = XLConnect::readWorksheet(object = wb,sheet = "(C) Original",
                                   header = TRUE, startRow = 3, startCol = 6, endCol = 8);
  
  ## Leitura dos dados de Parana
  data$Original$PR = XLConnect::readWorksheet(object = wb,sheet = "(C) Original",
                                   header = TRUE, startRow = 3, startCol = 10, endCol = 12);
  
  ## Leitura dos dados de Rio de janeiro
  data$Original$RJ = XLConnect::readWorksheet(object = wb,sheet = "(C) Original",
                                   header = TRUE, startRow = 3, startCol = 14, endCol = 16);
  
  # Devolve a serie completa
  return(data)
}