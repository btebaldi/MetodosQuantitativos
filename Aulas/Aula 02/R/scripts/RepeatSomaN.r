RepeatSomaN = function (N) {
  
  ## Inicializa as variaveis
  i = 1;
  soma = 0;

  ## Loop repeat
  repeat {

    ## Incrementa a soma
    soma = soma + i;
    
    ## Incrementa o contador
    i = i + 1;
    
    if (i>N) break;
  }
  ## Retorna a soma
  return(soma);  
}