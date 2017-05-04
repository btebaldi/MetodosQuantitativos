ValorPresenteFluxo = function(CF,DU, r, base=252)
{
  return(sum( CF/((1+r)^(DU/base))));
}