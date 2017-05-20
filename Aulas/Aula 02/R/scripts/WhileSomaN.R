WhileSomaN = function (N) {
  
  ## Inicializa as variaveis
  i = 1;
  soma = 0;
  
  ## Loop While
  while (i <= N) {
    ## Incrementa a soma
    soma = soma + i;
    ## Incrementa o contador
    i = i + 1;
  }
  ## Retorna a soma
  return(soma);  
}