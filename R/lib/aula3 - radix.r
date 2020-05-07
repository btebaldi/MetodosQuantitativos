# Aula 3 - Exemplo de criar função
# funcao que calcula a raiz de um numero.
# criada como exemplo educacional



# clear all
rm(list = ls())


#  ---- Funcoes

raiz = function(x, radix = 2) {
  return(x^(1/radix))
}


#  ----  Programa principal
raiz(81, 3)
