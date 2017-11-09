## Função que calcula o Valor Presente Liquido

VPL = function (cf, r){
  
  v = 0;
  
  for (i in 1:length(cf)){
    
    v = v + cf[i]/((1+r)^(i-1)); 
    
  }
  
  return(v);
}

TIR = function(cf, r0, eps=1e-6, nmax=1e3){
  
  ## Inicia a contador de iterações
  n = 0;
  
  ## Taxa rn
  rn = r0;
  
  ## Calculo auxiliar o VPL(rn)
  VPLn = VPL(cf, rn);
  
  ## Looping principal
  while (abs(VPLn)>eps && n<nmax){
    
    ## Calcula o rn da próxima iteração
    rn1 = rn - VPLn/((VPL(cf, rn+eps)-VPL(cf, rn-eps))/(2*eps));
    
    ## Atualiza o rn
    rn = rn1
    
    ## Incrementa o contador
    n = n + 1;

    ## Calculo do novo auxiliar o VPL(rn)
    VPLn = VPL(cf, rn);
        
  }
  
  ## Verifica se encontrou um valor
  if (abs(VPLn)>eps) rn = NaN;
  
  ## Retorno
  return(rn);
  
}

