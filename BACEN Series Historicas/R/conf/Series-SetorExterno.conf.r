series = list(
    list(name="Transações correntes - mensal - saldo",
        id=22701,
        startDate = as.Date("2010-01-01"),
        endDate = Sys.Date(),
        workbook = "../database/BACEN-TSMS-database-conf.xlsx",
        worksheet = "saldo"),
    list(name="Transações correntes - mensal - receita",
         id=22702,
         startDate = as.Date("2011-01-01"),
         endDate = Sys.Date(),
         workbook = "../database/BACEN-TSMS-database-conf.xlsx",
         worksheet = "receita"),
    list(name="Transações correntes - mensal - despesa",
         id=22703,
         startDate = as.Date("2012-01-01"),
         endDate = Sys.Date(),
         workbook = "../database/BACEN-TSMS-database-conf.xlsx",
         worksheet = "despesa")
  );