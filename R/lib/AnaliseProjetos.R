# Retoorna o VPL de um fluxo de caixa com pagamentos at-the-end
VPL = function (cf, r){
  return(sum(cf/(1+r)^(0:(length(cf)-1))))
}



# Retorna a TIR de um projeto
TIR = function(cf, r0, eps=1e-6, nmax=1e3){
  
  Ncont = 0
  
  # Faz o processo de interacao enquanto nao chegou na resposta desejada
  while (Ncont < nmax && abs(VPL(cf, r0)) >= eps) {
    
    # Calcula a derivada numerica do VPL
    d_vpl = (VPL(cf, r0 + eps)- VPL(cf, r0 - eps))/(2*eps)
    
    # Calcula o proximo ponto para interacao
    r0 = r0 - VPL(cf, r0)/d_vpl 
    
    # Atualiza o contador
    Ncont = Ncont+1 
  }
  
  # retorna o valor calculado.
  return(r0)
  
}
