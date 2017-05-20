VPL = function(CF, r)
{
  periodo = 0:(length(CF) - 1)
  
  ## Calcula o valore presente
  VP = CF / ((1 + r) ^ (periodo))
  
  return(sum(VP))
}

TIR = function(CF, r)
{
  params = list(CF = CF, r = r)
  
  root_f(
    f = VPL,
    x0 = r,
    dx = "r",
    eps = 1e-7,
    nmax = 1000,
    providedFunctionParams = params
  )
}
