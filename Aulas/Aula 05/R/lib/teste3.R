library(XLConnect)

filename = "./database/BACEN-TSMS-database-BASE.xlsx"

wb = loadWorkbook(filename)

sheets = XLConnect::getSheets(wb)



for (item in sheets)
{
  XLConnect::readWorksheet(wb, sheet = item)
  print(item)
    working = T
  # while(working)
  # {
  #   
  #   working = F
  # }
  # 
}




if (a1=="SERIE ID")
{
  print
}

