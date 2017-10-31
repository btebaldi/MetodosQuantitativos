workbook = "../../workbooks/test.xlsx"

sheet = "sesonal";


series = list(
  "IPCA" = list(
    ID = 433,
    startDate = Sys.Date() - 5 * 365,
    seas.spec = list(arima.model = "(1 0 1)(1 0 0)", outlier =
                       NULL)
  ),
  
  "INPC" = list(
    ID = 188,
    startDate = Sys.Date() - 5 * 365,
    seas.spec = list()
  ),
  
  "IGPM" = list(
    ID = 189,
    startDate = Sys.Date() - 5 * 365,
    seas.spec = list(arima.model = "(1 0 1)(1 0 0)")
  )
)
