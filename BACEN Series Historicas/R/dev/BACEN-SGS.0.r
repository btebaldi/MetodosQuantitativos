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

# getValor - Get the values of one or more series inside a given period. The result of the search is returned to the client in XML format.
# Parameters:
#   long[] codigosSeries - List(array) of series codes.
# String dataInicio - String that contains the initial date (dd/MM/yyyy).
# String dataFim - String that contains the end date (dd/MM/yyyy).
# Return:
#   String - String that contains the result of the search in XML format.


library(httr);
library(XML);


url = "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS?method=getValor";

soapenv = '<?xml version="1.0" encoding="utf-8"?> <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <soapenv:Body> <getValor xmlns="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS"> <codigosSerie> %s </codigosSerie> <data> %s </data> </getValor> </soapenv:Body> </soapenv:Envelope>';

body = sprintf(soapenv,4606,"01/01/1998");




# .Open "post", sURL, False
# .setRequestHeader "Host", "https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl"
# .setRequestHeader "Content-Type", "text/xml; charset=utf-8"
# .setRequestHeader "soapAction", "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor"
# .setRequestHeader "Accept-encoding", "zip"
# .send sEnv
# xmlDoc.LoadXML .responseText
# End With


# response = POST(url, body = body, add_headers("Host"="https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl","Content-Type"="text/xml; charset=utf-8","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor", "Accept-encoding"="zip"));


# response = POST(url, body = body, content_type_xml(), add_headers("Host"="https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl","soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor", "Accept-encoding"="zip"));


response = POST(url, body = body, content_type_xml(), add_headers("soapAction"="https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS/getValor", "Accept-encoding"="zip"));

xmlstr = content(response, "text",type = "text/xml");

xmlInternalTreeParse(xmlstr)


xmlInternalTreeParse(response);
