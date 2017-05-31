

Baskara = function(coeffs) {
  
  ## Estrutra para guardar dados
  roots = array(NaN,c(nrow(coeffs),2));
  
  
  ###browser();
  
  ## Percorre as equacoes
  for (i in 1:nrow(coeffs)){
    
    ## Print
    # print(coeffs[i,])
    
    ## Calcular o delta
    delta = coeffs[i,2]^2 - 4*coeffs[i,1]*coeffs[i,3];
    
    ### print(delta);
    
    
    if(delta>0){
      # print("delta positivo");   # debug
      roots[i,1] = (-coeffs[i,2]+(delta^0.5))/(2*coeffs[i,1]);
      roots[i,2] = (-coeffs[i,2]-(delta^0.5))/(2*coeffs[i,1]);
    } else if (delta==0){
      #print("delta negativo");      #debug
      roots[i,1] = -coeffs[i,2]/(2*coeffs[i,1]);
    }

  }
  
  
  ## retorno
  return(roots);
  
  
}