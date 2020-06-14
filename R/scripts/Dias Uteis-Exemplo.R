# clear all
rm(list = ls())

# carrega biblioteca
library(bizdays)

# mostra que ja existe um dataset com os ferioados da ambima
head(holidaysANBIMA)

date = "2013-01-01"

# Cria calendario ANBIMA
calendar = bizdays::create.calendar("ANBIMA", holidays = holidaysANBIMA, weekdays=c("saturday", "sunday"))

# Verifica se é um dia util
bizdays::is.bizday(date, calendar)

# ajusta para o proximo dia util
bizdays::adjust.next(date, calendar)

# Exemplo NTN-F
dtVcmto = as.Date("2025-01-01")

# data de referencia
dtRef = Sys.Date()

# sequencia
diasPgto = rev(seq(from=dtVcmto, to=dtRef, by="-6 months"))
bizdays::is.bizday(diasPgto, calendar)


# Ajusta para o proximo dia util
diasPgto.ajusted = bizdays::adjust.next(diasPgto, calendar)
print(diasPgto.ajusted)

# Dias uteis até as datas de pagamento
wdays = bizdays::bizdays(from = dtRef, to=diasPgto.ajusted, calendar)
print(wdays)

