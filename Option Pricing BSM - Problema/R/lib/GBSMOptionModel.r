

#' Calcula o premio da opcao
#'
#' @param type call or put
#' @param S Preco spot ou futuro do ativo
#' @param X Strike da opcao
#' @param T Tempo 
#' @param Tvol Tempo de colatilidade em porcentagem
#' @param r Taxa livre de risco em capitalizacao continua
#' @param b Custo de carregar a posicao - Capitalizacao continua
#' @param sigma Volatilidade implicida
#'
#' @return premio da opcao
#' @export
#'
#' @examples
GBSMOptionPrice = function(type=c("call","put"), S, X, T, Tvol=NA, r, b=0, sigma){
  
  # Caso o prazo de volatilidade nao seja fornecido assumo que e para usar o prazo normal 
  if (is.na(Tvol))
  {
    Tvol = T
  }
  
  # calculo dos indices d1 e d2
  d1 = (log(S / X) + (b + (sigma ^ 2 / 2)) * Tvol) / (sigma * Tvol ^ 0.5)
  d2 = d1 - (sigma * (Tvol ^ 0.5))
  
  # inicializa a variavel premio
  premio = NA
  
  # calcula o premio da call e da put
  if (tolower(type[1]) == "call") {
    premio = S * exp((b - r) * T) * pnorm(d1) - X * exp(-r * T) * pnorm(d2)
  }
  else if (tolower(type[1]) == "put")
  {
    premio = X * exp(-r * T) * pnorm(-d2) - S * exp((b - r) * T) * pnorm(-d1)
  }
  else
  {
    warning("Tipo de opcao nao definido")
  }
  
  return(premio)
  
}


#' Calcula o delta pela formula fechada de BSM
#'
#' @param type call or put
#' @param S Preco spot ou futuro do ativo
#' @param X Strike da opcao
#' @param T Tempo 
#' @param Tvol Tempo de colatilidade em porcentagem
#' @param r Taxa livre de risco em capitalizacao continua
#' @param b Custo de carregar a posicao - Capitalizacao continua
#' @param sigma Volatilidade implicida
#'
#' @return
#' @export
#'
#' @examples
GBSMOptionDelta = function(type=c("call","put"), S, X, T, Tvol, r, b=0, sigma){
  
  # Caclulo do delta pela formula de BS
  d1 = (log(S / X) + (b + (sigma ^ 2 / 2)) * Tvol) / (sigma * Tvol ^ 0.5)
  
  
  # Inicializo a variavel delta
  d = NA
  
  
  # escolho o metodo de calculo devido a ser put ou call
  if (tolower(type[1]) == "call")
  {
    d = exp((b - r) * T) * pnorm(d1)
  }
  else if (tolower(type[1]) == "put")
  {
    d = exp((b - r) * T) * pnorm(-d1)
  }
  else
  {
    warning("Tipo de opcao nao definido")
  }
  
  return(d)
}


#' Calcula o delta numerico pela formula de derivada numerica
#'
#' @param type call or put
#' @param S Preco spot ou futuro do ativo
#' @param X Strike da opcao
#' @param T Tempo 
#' @param Tvol Tempo de colatilidade em porcentagem
#' @param r Taxa livre de risco em capitalizacao continua
#' @param b Custo de carregar a posicao - Capitalizacao continua
#' @param sigma Volatilidade implicida
#'
#' @return
#' @export
#'
#' @examples
GBSMOptionNumDelta = function(type=c("call","put"), S, X, T, Tvol=NA, r, b=0, sigma){
 
  # Defino o nivel de precisao da minha derivada
  h = S * 1e-6
  
  
  # realizo o calculo da minha derivara
  d = (GBSMOptionPrice(type, S+h, X, T, Tvol, r, b, sigma) - GBSMOptionPrice(type, S-h, X, T, Tvol, r, b, sigma))/(2*h);
  
  
  return(d)
}

#' Metodo Newton-Hapson para calculo da volatilidade
#'
#' @param type call or put
#' @param S Preco spot ou futuro do ativo
#' @param X Strike da opcao
#' @param T Tempo 
#' @param Tvol Tempo de colatilidade em porcentagem
#' @param r Taxa livre de risco em capitalizacao continua
#' @param b Custo de carregar a posicao - Capitalizacao continua
#' @param price Preco da opcao
#' @param nmax numero maximo de interacoes
#'
#' @return
#' @export
#'
#' @examples
GBSMOptionVolatility = function(type=c("call","put"), S, X, T, Tvol=NA, r, b=0, price, nmax=100){
  
  # Valor inicial de sigma
  sigma = 0.20
  
  # defino o epsilon
  h = sigma * 1e-6
  
  # defino uma funcao 'f' cujo valor e o premio calculado menos o preco
  f = GBSMOptionPrice(type, S, X, T, Tvol, r, b, sigma) - price

  # inicializo o contador
  i = 1
  
  while ((i <= nmax) & (abs(f) > h))
  {
    # Calcula a taxa de variacao do preco em relacao a sigma
    df = (GBSMOptionPrice(type, S, X, T, Tvol, r, b, sigma+h) - GBSMOptionPrice(type, S, X, T, Tvol, r, b, sigma-h)) / (2 * h)
    
    # calcula o novo sigma 
    sigma = (sigma - f / df)
    
    # Calcula novo valor da funcao 'f' para ser revalidado pelo looping
    f = GBSMOptionPrice(type, S, X, T, Tvol, r, b, sigma) - price
    
    # incrementa o contador
    i = i + 1
  }

  return(sigma)
}



