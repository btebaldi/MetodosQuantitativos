source("../lib/Utils.r")

source("../lib/IpeaData.R")
source("../lib/Abcr.r")

My.Util.ValidadeWorkStructure(stopOnWarning = F)

My.Util.LoadPackages(c("XLConnect", "xml2", "rvest", "RODBC"))

x1 =IpeaData.GetPim(withYearMonthCol = T)
View(x1)

# Abcr.DownloadFile()
x2 = Abcr.GetData(workbook = "IndiceABCR.xls")
View(x2$Original$BR)


# Ons$

