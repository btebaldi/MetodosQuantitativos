

ValorPresenteFluxo = function(CF, DU, r, base = 252){
  
  ## C�lcula o valore presente
  VP = CF/((1+r)^(DU/base));
  
  return(sum(VP));
  
}
