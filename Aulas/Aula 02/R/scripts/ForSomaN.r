ForSomaN = function (N) {
  
  ## Inicializa as variaveis
  soma = 0;
  
  ## Loop for
  for (i in 1:N) {
    ## Incrementa a soma
    soma = soma + i;
  }
  ## Retorna a soma
  return(soma);  
}