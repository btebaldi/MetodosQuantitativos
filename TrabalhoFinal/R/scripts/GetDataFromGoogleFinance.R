GetDataFromGoogleFinance = function(ticker, startdate, enddate)
{
  if (length(ticker) > 1 || length(startdate) > 1 ||
      length(enddate) > 1)
  {
    stop("Funcao funciona apenas para um parametro")
  }
  
  site = "http://www.google.com/finance/historical"
  key = c("startdate", "enddate", "output", "q")
  value = c(startdate, enddate, "csv", ticker)
  
  BuildQueryString(site, key, value)
  x = read.csv(url(BuildQueryString(site, key, value)))
  
  return(x)
  
}