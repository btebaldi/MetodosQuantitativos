source("./lib/BACEN-TSMS-WebService.r")

series = c(20539, 20540, 20541);

data = TSMSGetSeries(series)

install.packages("ggplot2")

installed.packages()

is.installed('XML') 

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 

is.installed('httr') 
