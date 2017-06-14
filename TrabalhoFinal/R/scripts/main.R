source("../lib/Utils.r")

LoadPackages(c("XLConnect", "RCurl", "ecoseries", "XML", "xml2", "rvest"))
 
# Produção industrial - indústria geral - quantum - índice (média 2002 = 100)
x = ecoseries::series_ipeadata(1506214698, periodicity = c("M"))
View(x$serie_1506214698)
x$serie_1506214698$data


# Produção industrial - indústria geral - quantum - índice (média 2012 = 100)
x2 = ecoseries::series_ipeadata(1056104108, periodicity = c("M"))
View(x2)


library(rvest)
theurl <- "http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=1506214698&module=M"
file<-read_html(theurl)
tables<-html_nodes(file, "table")
table1 <- html_table(tables[4], fill = TRUE)
View(table1)

html = read_html(theurl)

View(html)
head(html)

con = url(theurl)
htmlCode=readLines(con)
close(con)
htmlCode
xmlRoot(xmlParse(htmlCode, asText = T))



ff=XML::readHTMLTable(theurl)

inputs = 1506214698



thepage = readLines("http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=1506214698&module=M")


theurl = getURLContent("http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=1506214698&module=M" )
tables <- readHTMLTable(thepage)

View(tables$grd_DXMainTable)

j=xmlParse(thepage, asText = T)

node = xml2::as_xml_document(pagina)


  pagina = xml2::read_html("http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=1506214698&module=M")
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


# joe2=rvest::html_nodes(x=joe, xpath="//table")
# 
# print(joe2[2])
# 
# print(rvest::html_text(joe[1]))
# 
# dados=pagina %>%
#   rvest::html_nodes(".dxgvDataRow") %>%
#   rvest::html_text()
# 
# 
# dados=gsub("\r\n\t\t\t", "", dados)
# #dados=gsub("[[:punct:]]","",dados)
# 
# if (periodicity == "D"){
#   data=substr(dados, 1, 10)
#   valor=substr(dados, 11, 100)
# } else if (periodicity == "Y"){
#   data=substr(dados, 1, 4)
#   valor=substr(dados, 5, 100)
# } else if (periodicity == "M"){
#   data=substr(dados, 1, 7)
#   valor=substr(dados, 8, 100)
# } else { stop("Wrong periodicity. This field accepts 'Y', 'M' or 'D' as arguments.")}
# 
# valor = gsub("\\.", "", valor)
# valor = gsub(",", ".",valor)
# valor = as.numeric(valor)
# dat = tibble::tibble(data,valor)
# dat = dat[stats::complete.cases(dat),]
# 
# return(dat)
