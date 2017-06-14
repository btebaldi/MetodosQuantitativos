
x = read.csv("../../Downloads/ipeadata[10-06-2017-03-29].txt")

library(XLConnect)
library(RCurl)


fn="http://www.abcr.org.br/Download.ashx?arquivo=IndiceABCR.xls"

download.file(fn,"../Pedro Silveira/database/teste.xls","auto",mode = "wb")


# wb = XLConnect::loadWorkbook(fn)
# 
# XLConnect::readTable(wb, 3)
