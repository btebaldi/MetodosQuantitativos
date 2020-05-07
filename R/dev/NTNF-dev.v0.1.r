# Aula 3
# Prototipo de validacao do modelo de calculo de NTNF


# ---- bibliotecas
library(bizdays)

# (1) Dados de entrada ----
dataRef      = as.Date("2008-05-20")
dataVencto   = as.Date("2014-01-01")
dataLiquidacao = as.Date("2008-05-21")
valorNominal = 1000

TIR = 0.136600
# Dias_uteis
# Calendario


# (2) Eventos de pagamento ----
dataPagmentos = rev(seq(from = dataVencto, to = dataLiquidacao, by = "-6 months"))

calendar = create.calendar("ANBIMA",
                           holidays = holidaysANBIMA,
                           weekdays = c("saturday", "sunday"))
dataPagmentos.efetivo = bizdays::adjust.next(dataPagmentos, calendar)
diasUteis = bizdays::bizdays(from = dataLiquidacao, to = dataPagmentos.efetivo, cal = calendar)

diasUteis

vffluxoCxJuros = rep(1.1 ^ 0.5 - 1, length(dataPagmentos.efetivo) - 1)
vffluxoCxFinal = 1.1 ^ 0.5

vffluxoCx = c(vffluxoCxJuros, vffluxoCxFinal)
vffluxoCx = round(vffluxoCx * valorNominal, 5)

bt = data.frame(dataPagmentos, vffluxoCx, diasUteis)

truncar = function(x, n) {
  return(trunc(x * 10 ^ n) / 10 ^ n)
}

VPL = function (cf, r, t) {
  v = 0
  
  
  # for (i in 1:length(cf)){
  
  # v = v + cf[i]/((1+r)^(t[i]-1));
  r2 = (1 + TIR) ^ truncar(28 / 252, 14)
  # cat(sprintf("1 %.7f\n", r2))
  
  # r2 =trunc(r2*1e6)/1e6
  
  # cat(sprintf("2 %.7f\n", r2))
  
  
  v =  cf / ((1 + TIR) ^ truncar(t / 252, 14))
  
  # bt$vffluxoCx / r2
  
  # }
  
  return(v)
  
}

a = VPL(bt$vffluxoCx, TIR, bt$diasUteis)
a = round(a, 9)
cat(sprintf("2 %.10f\n", a))

b = sum(a)
cat(sprintf("2sss %.10f\n", truncar(b, 6)))

# (48.80885/48.119371611)^(1/28)

# (2) calculo de eventos de pagamento
# Fluxo futuro
# Valor presente dos fluxos
# fazer a soma

rm(list = ls())

source("./dev/TituloPublicoFederalBr-dev.r")

dataRef      = as.Date("2008-05-20")
dataVencto   = as.Date("2014-01-01")
dataLiquidacao = as.Date("2008-05-21")

PU = TPFBrPU(titulo = "NTNF", dataVencto = dataVencto, dataLiquidacao = dataLiquidacao, TIR = 13.66/100)
cat(sprintf("%.7f", PU))



dataVencto   = as.Date("2021-01-01")
dataLiquidacao = as.Date("2020-04-28")

PU = TPFBrPU(titulo = "NTNF", dataVencto = dataVencto, dataLiquidacao = dataLiquidacao, TIR = 2.86/100)
cat(sprintf("%.7f", PU))


dataVencto   = as.Date("2023-01-01")
dataLiquidacao = as.Date("2020-04-28")

PU = TPFBrPU(titulo = "NTNF", dataVencto = dataVencto, dataLiquidacao = dataLiquidacao, TIR = 4.905/100)
cat(sprintf("%.7f", PU))



dataVencto   = as.Date("2031-01-01")
dataLiquidacao = as.Date("2020-04-28")

PU = TPFBrPU(titulo = "NTNF", dataVencto = dataVencto, dataLiquidacao = dataLiquidacao, TIR = 7.9704/100)
cat(sprintf("%.7f", PU))


