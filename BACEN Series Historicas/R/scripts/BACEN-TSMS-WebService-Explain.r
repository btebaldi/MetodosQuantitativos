## Biblioteca para baixar series do BACEN Time Series Management System
library(RCurl);
library(httr);
library(XML);


## URL do Webservice
url = "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS?method=getValoresSeriesXML";

## Data para input no 'getValoresSeriesXML'
startDateStr = "01/01/2016";
endDateStr = "01/01/2017";

## Séries de input
codes = c(4606,4607);


## Prepara o corpo da mensagem de request "body"
soapenv = '<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soapenv:Body>
    <getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS">
      <codigosSeries> %s </codigosSeries>
      <dataInicio> %s </dataInicio>
      <dataFim> %s </dataFim>
    </getValoresSeriesXML>
  </soapenv:Body>
</soapenv:Envelope>';

## Corpo do Request
body = sprintf(soapenv,paste(sprintf("<number>%d</number>",codes),collapse=""),startDateStr,endDateStr);

## POST request
response = POST(url, body = body,
                add_headers("Content-Type"="text/xml; charset=utf-8",
                            "soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML",
                            "Accept-encoding"="zip"));

## -- Response

## Envelope com o conteudo do SOAP
xmlSOAPEnvelope = xmlRoot(xmlParse(response, asText=TRUE));

## Valor do Node "getValoresSeriesXMLReturn" = codigo xml com o resultado da query
xmlData = xmlRoot(xmlParse(xmlValue(xmlSOAPEnvelope[["Body"]][["getValoresSeriesXMLResponse"]][["getValoresSeriesXMLReturn"]]),asText=TRUE));


## Parser 
data = TSMSGetSeriesResponseParser(response)
