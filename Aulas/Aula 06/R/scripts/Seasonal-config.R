install.packages("httr")
install.packages("XML")
install.packages("RCurl")
install.packages("lubridate")
install.packages("XLConnect")
install.packages("seasonal")
install.packages("seasonalview")

## Packages R
library(seasonal);
library(seasonalview);
library(lubridate);
library(XLConnect);

source(file = "../lib/BACEN-TSMS-WebService.r");
source(file="../conf/IndicePrecos.config.r")

myrow = 0
mycol=0

for(i in 1:length(series))
{
  startDate = series[[i]][["startDate"]]
  
  # baixar a serie
  data = TSMSGetSeries(series[[i]][["ID"]], startDate = startDate)
  
  
  
  # criar o objeto TS
  data.ts  = ts(
    data = data[["VALOR"]],
    start = c(year(startDate), month(startDate)),
    frequency = 12
  )
  
  
  
  spec = series[[i]][["seas.spec"]]
  data.seas = seas(data.ts, list = spec)
  

  data[["VALOR.SA"]]  = as.numeric(final(data.seas))
  
  print (head(final(data.seas)))
  
#abrir a planilha
  wb= XLConnect::loadWorkbook(filename = workbook)
  
  ## escreve header
  myrow=1
  mycol=(3*(i-1))+1

  XLConnect::writeWorksheet(wb, "ID", sheet = sheet,startRow = myrow, startCol = mycol, header = F)
  XLConnect::writeWorksheet(wb, series[[i]][["ID"]], sheet = sheet,startRow = myrow, startCol = mycol+1, header = F)
  
  myrow=myrow+1
  XLConnect::writeWorksheet(wb, "startdate", sheet = sheet,startRow = myrow, startCol = mycol, header = F)
  XLConnect::writeWorksheet(wb, series[[i]][["startDate"]], sheet = sheet,startRow = myrow, startCol = mycol+1, header = F)
  
  myrow=myrow+2
  XLConnect::writeWorksheet(wb, data[,], sheet = sheet,startRow = myrow, startCol = mycol, header = T)

  XLConnect::saveWorkbook(wb)
  
}

for(item in series)
{
  print(item$ID)
  
}


# library(lubridate);



