## Referencias:
## httr: https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
## Macro Excel: https://dataforthoughts.wordpress.com/2013/12/26/series-temporais-bacen/
## Banco Central: https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/sgsAjudaIng.jsp#SA
## Código em R: https://github.com/arademaker/IR-2011/blob/master/aula-07/roteiro.R
## Como Trabalhar com XML em R: http://www.informit.com/articles/article.aspx?p=2215520

# getValor - Get the value of series in a given date (dd/MM/yyyy).
# Parameters:
#   long codigoSerie - Code of the series.
# String data - String that contains the date (dd/MM/yyyy) of the value to be searched.
# Return:
#   BigDecimal - Object that contains the value.

# getValoresSeriesXML - Get the values of one or more series inside a given period. The result of the search is returned to the client in XML format.
# Parameters:
#   long[] codigosSeries - List(array) of series codes.
# String dataInicio - String that contains the initial date (dd/MM/yyyy).
# String dataFim - String that contains the end date (dd/MM/yyyy).
# Return:
#   String - String that contains the result of the search in XML format.


library(httr);
library(XML);


url = "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS?method=getValoresSeriesXML";

#soapenv = '<?xml version="1.0" encoding="utf-8"?> <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <soapenv:Body> <getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS"> <codigosSeries> %s </codigosSeries> <dataInicio> %s </dataInicio> <dataFim> %s </dataFim> </getValoresSeriesXML> </soapenv:Body> </soapenv:Envelope>';
#body = sprintf(soapenv,4606,"01/01/1998","01/01/1999");
# 
# 
# 
# 
# soapenv = '<?xml version="1.0" encoding="utf-8"?>
# <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#   <soapenv:Body>
#     <getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS">
#       <codigosSeries> %s </codigosSeries>
#       <dataInicio> %s </dataInicio>
#       <dataFim> %s </dataFim>
#     </getValoresSeriesXML>
#   </soapenv:Body>
# </soapenv:Envelope>';


# <myFavoriteNumbers
# SOAP-ENC:arrayType="xsd:int[2]">
#   <number>3</number>
#   <number>4</number>
#   </myFavoriteNumbers>
  


# soapenv = '<?xml version="1.0" encoding="utf-8"?>
# <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#   <soapenv:Body>
#     <getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS">
#       <codigosSeries> <number>4606</number> <number>4607</number> </codigosSeries>
#       <dataInicio> %s </dataInicio>
#       <dataFim> %s </dataFim>
#     </getValoresSeriesXML>
#   </soapenv:Body>
# </soapenv:Envelope>';
# body = sprintf(soapenv,"01/01/2011","01/01/2014");



codigosSeries = c(4606,4607);
soapenv = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><getValoresSeriesXML xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS"><codigosSeries> %s </codigosSeries><dataInicio> %s </dataInicio> <dataFim> %s </dataFim> </getValoresSeriesXML> </soapenv:Body> </soapenv:Envelope>';
body = sprintf(soapenv,paste(sprintf("<number>%d</number>",codigosSeries),collapse=""),"01/01/2011","01/01/2012");

# .Open "post", sURL, False
# .setRequestHeader "Host", "https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl"
# .setRequestHeader "Content-Type", "text/xml; charset=utf-8"
# .setRequestHeader "soapAction", "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor"
# .setRequestHeader "Accept-encoding", "zip"
# .send sEnv
# xmlDoc.LoadXML .responseText
# End With

response = POST(url, body = body, add_headers("Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));

## Envelope com o conteúdo do SOAP
xmlSOAPEnvelope = xmlRoot(xmlParse(response, asText=TRUE));

## Valor do Node "getValoresSeriesXMLReturn" = codigo xml com o resultado da query
xmlData = xmlRoot(xmlParse(xmlValue(xmlSOAPEnvelope[["Body"]][["getValoresSeriesXMLResponse"]][["getValoresSeriesXMLReturn"]]), asText=TRUE));

## Número de Series
nSeries = xmlSize(xmlData);

## Lembrar na hora de criar as funções
## output = c("data.frame","lista","xml")
## convertDates = TRUE texto para data: verifica o formato dd/aaaa ou aa/mm/aaaa


## DataFrame com o output
dataSeries = list();

for (i in 1:nSeries){
  
  ## Cada serie será uma lista
  dataSeries[[i]] = list();
  
  ## ID da serie
  dataSeries[[i]][["ID"]] = xmlAttrs(xmlData[[i]])[["ID"]];
  
  ## Número de ITEMs da serie
  nElements = xmlSize(xmlData[[i]]);
  dataSeries[[i]][["VALOR"]] = array(NA,nElements);
  dataSeries[[i]][["DATA"]] = array(NA,nElements);
  for (j in 1:nElements){
    dataSeries[[i]][["VALOR"]][j] = as.numeric(xmlValue(xmlData[[i]][[j]][["VALOR"]]));
    dataSeries[[i]][["DATA"]][j] = xmlValue(xmlData[[i]][[j]][["DATA"]]);
  }
}





