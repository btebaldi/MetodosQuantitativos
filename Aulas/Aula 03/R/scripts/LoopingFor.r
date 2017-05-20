ForSomaN = function(N){
  
  soma = 0;
  
  for (i in 1:N){
    
    cat(sprintf("valor de i = %d soma = %d\n", i, soma))
    soma = soma + i;
  }
  
  return(soma);
  
}

ForSomaLista = function(lista){
  
  soma = 0;
  
  for (i in 1:length(lista)){
    
    cat(sprintf("valor de lista[%d] = %d atual soma = %d\n", i, lista[i], soma))
    
    soma = soma + lista[i];
    
    cat(sprintf("valor de lista[%d] = %d atulizada soma = %d\n", i, lista[i], soma))
    
    
  }
  
  return(soma);
  
}


