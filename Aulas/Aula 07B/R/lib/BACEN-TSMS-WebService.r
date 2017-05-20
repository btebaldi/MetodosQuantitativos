## Biblioteca para baixar s?ries do BACEN Time Series Management System

## Exemplo de chamada com Configuração de Proxy
## config = use_proxy(url="myproxy.tmg.br", port = 80, username = "[DOMAIN\\]USERNAME", password = "PASSWORD", auth = "basic ou [basic,ntlm,...]");
## Baixa as séries
## data = TSMSGetSeries(codes, config = config);


library(httr);
library(XML);

TSMSGetSeries = function(codes, startDate = as.Date("2016-01-01"), endDate = Sys.Date(),
                        output = c("data.frame","list","xml"),
                        parseDates = TRUE,
                        url = "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS?method=getValoresSeriesXML",
                        ssl.verifypeer = FALSE, config=list()) {
  
  ## - Tratamentop dos argumentos da chamada da funÃ§Ã£o
  
  ## Trada os datas para a chamada da funcao
  startDateStr = ifelse(class(startDate)=='Date',format(startDate,"%d/%m/%Y"),startDate);
  endDateStr = ifelse(class(endDate)=='Date',format(endDate,"%d/%m/%Y"),endDate);
  
  ## -- Request
  
  ## Prepara o corpo da mensagem de request "body"
  soapenv = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS"><codigosSeries> %s </codigosSeries><dataInicio> %s </dataInicio> <dataFim> %s </dataFim> </getValoresSeriesXML> </soapenv:Body> </soapenv:Envelope>';
  body = sprintf(soapenv,paste(sprintf("<number>%d</number>",codes),collapse=""),startDateStr,endDateStr);

  ## POST request
  response = POST(url, config=config, body = body, add_headers("Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));

  return(TSMSGetSeriesResponseParser(response, output=output[1], parseDates=parseDates));
  
}
  
TSMSGetSeriesResponseParser = function(response, output=c("data.frame","list","xml"), parseDates = TRUE){
  
  ## -- Response
  
  ## Envelope com o conte?do do SOAP
  xmlSOAPEnvelope = xmlRoot(xmlParse(response, asText=TRUE));
  
  ## Valor do Node "getValoresSeriesXMLReturn" = codigo xml com o resultado da query
  xmlData = xmlRoot(xmlParse(xmlValue(xmlSOAPEnvelope[["Body"]][["getValoresSeriesXMLResponse"]][["getValoresSeriesXMLReturn"]]), asText=TRUE));

  if (output[1] == "xml"){
    
    data = xmlData;

  } else {
    
    ## N?mero de Series
    nSeries = xmlSize(xmlData);
  
    if (output[1] == "data.frame") {
      
      ## Dataframe para as S?ries
      data = NULL;
      
      ## Percorre cada Serie
      for (i in 1:nSeries){
        
        ## ID da serie
        id = xmlAttrs(xmlData[[i]])[["ID"]];
        
        ## Datas/Periodos
        ## N?mero de ITEMs de cada Serie
        nItens = xmlSize(xmlData[[i]]);
        values = array(NA,nItens);
        dates = array(NA,nItens);
        for (j in 1:nItens){
          values[j] = as.numeric(xmlValue(xmlData[[i]][[j]][["VALOR"]]));
          dates[j] = xmlValue(xmlData[[i]][[j]][["DATA"]]);
        }
        
        ## Parse das Dates
        if (parseDates) dates = TSMSDateParser(dates);
        
        ## Atribui ao data.frame
        if (is.null(data)){
          data = data.frame(ID = id, DATA = dates, VALOR = values);
        } else {
          data = rbind(data,data.frame(ID = id, DATA = dates, VALOR = values));          
        }
      }
      
    } else if (output[1] == "list") {
      
      ## Lista de S?ries
      data = list();

      ## Percorre cada Serie
      for (i in 1:nSeries){
        ## Cada serie ser? uma lista
        data[[i]] = list();
        
        ## ID da serie
        data[[i]][["ID"]] = xmlAttrs(xmlData[[i]])[["ID"]];
        
        ## N?mero de ITEMs de cada Serie
        nItens = xmlSize(xmlData[[i]]);
        data[[i]][["VALOR"]] = array(NA,nItens);
        data[[i]][["DATA"]] = array(NA,nItens);
        for (j in 1:nItens){
          data[[i]][["VALOR"]][j] = as.numeric(xmlValue(xmlData[[i]][[j]][["VALOR"]]));
          data[[i]][["DATA"]][j] = xmlValue(xmlData[[i]][[j]][["DATA"]]);
        }
        
        ## Parse das Dates
        if (parseDates) data[[i]][["DATA"]] = TSMSDateParser(data[[i]][["DATA"]]);
      }
    } else if (output == "xml"){

      data = xmlData;
      
    }
    
  }
  
  ## Retorna o conte?do das s?ries
  return(data);
   
}

## Funcao Auxiliar para converter datas de texto para datas
TSMSDateParser = function(txtDate){
   if (class(txtDate[1])=="Date"){
    date = txtDate;
  } else if (is.character(txtDate)) {
    date = as.Date(sapply(strsplit(txtDate,"/"),function(x) {
        if (length(x)<3) x = c(1,x);
        paste(x[3:1],collapse="-");
      }),"%Y-%m-%d");
  }
  return(date)
}