RaizesQuadratica = function(a, b, c){
  
  ## Estrutura de retorno
  x = array(NaN,c(length(a),2));
  
  ## Looping principal
  for (i in 1:length(a)) {
    
    ## Calcula o delta
    delta = b[i]^2 - 4*a[i]*c[i];
    
    ## Calcula as raízes
    if (delta==0){
      
      x[i,1] = -b[i]/(2*a[i]);     
      
    } else{      
      
      if (delta > 0) {
        x[i,1] = (-b[i]-delta^(1/2))/(2*a[i]);
        x[i,2] = (-b[i]+delta^(1/2))/(2*a[i]);
      }
    }
  }  
  
  return(x); 
}