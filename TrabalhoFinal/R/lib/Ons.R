Ons = list(
  DownloadFile = function(fileName = "IndiceABCR.xls",
                          downloadLocation = "../database/",
                          downloadName = "IndiceABCR.xls")
  {
    destination = My.Util.PathCombine(c(downloadLocation, downloadName))
    download.file(
      Abcr.Url(fileName),
      destfile = destination,
      method = "auto",
      mode = "wb"
    )
  },
  
  
  Abcr.Url = function(fileName)
  {
    baseUrl = "http://www.abcr.org.br/Download.ashx"
    completeUrl = paste(c(baseUrl, "?arquivo=", fileName), collapse = "")
    
    return(completeUrl)
  },
  
  
  GetData = function(databaseFile, worksheet)
  {
    databaseFile = "ONS.accdb"
    wbFullPath = My.Util.PathCombine(c("../database", databaseFile))
    
    if(!file.exists(wbFullPath))
    {
      stop("Arquivo não encontrado no diretorio database.")
    }
    
      ## Connect to Excel
      conn = RODBC::odbcConnectAccess2007(wbFullPath)

      ## Carrega os dados de uma planilha
      data = na.exclude(sqlFetch(conn, worksheet, na.strings = c("", "-", "#N/A N/A")))
      
      
      XLConnect::
      
      ## Close connection
      odbcClose(conn)
      
      
      ## Converte para o formato data a coluna de datas
      data[['Date']] = as.Date(data[['Date']])
      
      
      ## Ordenação
      data = data[order(data[['Date']]), ]
      
      
      
      ## Retorna os dados
      return(data)
      
      
    }
    
    
    # Devolve a serie completa
    return(data)
  }
)
