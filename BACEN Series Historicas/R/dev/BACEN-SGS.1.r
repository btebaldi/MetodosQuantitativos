## Referencias:
## httr: https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
## Macro Excel: https://dataforthoughts.wordpress.com/2013/12/26/series-temporais-bacen/
## Banco Central: https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/sgsAjudaIng.jsp#SA
## Código em R: https://github.com/arademaker/IR-2011/blob/master/aula-07/roteiro.R


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
body = sprintf(soapenv,paste(sprintf("<number>%d</number>",codigosSeries),collapse=""),"01/01/2011","01/01/2014");



# .Open "post", sURL, False
# .setRequestHeader "Host", "https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl"
# .setRequestHeader "Content-Type", "text/xml; charset=utf-8"
# .setRequestHeader "soapAction", "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor"
# .setRequestHeader "Accept-encoding", "zip"
# .send sEnv
# xmlDoc.LoadXML .responseText
# End With


# response = POST(url, body = body, add_headers("Host"="https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl","Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));


#response = POST(url, body = body, content_type_xml(), add_headers("soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));

#xmlstr = content(response, type="text/xml", encoding = "ISO-8859-1");

#xmlstr = content(response, type="text/xml", encoding = "utf-8");

#response = POST(url, body = body, add_headers("Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));


response = POST(url, body = body, add_headers("Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML", "Accept-encoding"="zip"));

xmlAttrs(response, asText=TRUE)

xmllist = xmlToList(xmlTreeParse(response, asText=TRUE))

xml




doc = xmlInternalTreeParse(response,asText = TRUE);


response = POST(url, body = body, add_headers("Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML"));





xmlstr = content(response, as="text", type="text/xml", encoding="utf-8");

xmlstr = gsub("&lt;", "<", xmlstr);
xmlstr = gsub("&gt;", ">", xmlstr);

xmlTreeParse(xmlstr, asText=TRUE)

xmlContent = xmlTreeParse(response, asText=TRUE, asTree=TRUE)



xmlstr = content(response, as="text", type="text/xml", encoding="utf-8");

xmlstr = content(response);

doc = xmlInternalTreeParse(xmlstr,asText = TRUE)

doc <- xmlInternalTreeParse(xmlstr)

# response = POST(url, body = body, content_type_xml(), add_headers("soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML"));

response = POST(url, body = body, content_type_xml(), add_headers("soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValoresSeriesXML"));


xmlstr = content(response);

doc = xmlInternalTreeParse(response)

doc = content(response);


xmlParse(response)




## Trata o resultado
cleanup = xpathApply(xmlstr,"//SERIE", function(s) {
  id = xmlGetAttr(s, "ID")
  s1 = xmlSApply(s, function(x) xmlSApply(x, xmlValue))
  s1 = t(s1)
  dimnames(s1) = list(NULL, dimnames(s1)[[2]])
  df = as.data.frame(s1, stringsAsFactors=FALSE)
  df$SERIE = id
  print(df)
  return(df);
});
df = Reduce(rbind, cleanup);

## Trata o resultado
cleanup = xpathApply(doc,"//SERIE", function(s) {
  id = xmlGetAttr(s, "ID")
  s1 = xmlSApply(s, function(x) xmlSApply(x, xmlValue))
  s1 = t(s1)
  dimnames(s1) = list(NULL, dimnames(s1)[[2]])
  df = as.data.frame(s1, stringsAsFactors=FALSE)
  df$SERIE = id
  print(df)
  return(df);
});
df = Reduce(rbind, cleanup);


df$data  = as.Date(sapply(strsplit(df$DATA,"/"),function(x) paste(c(x[2:1],1),collapse="-")),"%Y-%m-%d");
df$valor = as.numeric(df$VALOR);
df$serie = factor(df$SERIE);

if(remove.old){
  df$BLOQUEADO = NULL;
  df$SERIE = NULL;
  df$DATA = NULL;
  df$VALOR = NULL;
}

df


