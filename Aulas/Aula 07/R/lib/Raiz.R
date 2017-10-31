

#' Calcula a derivada numerica de uma funcao no ponto
#'
#' @param f uma funcao
#' @param x ponto da derivada
#' @param h nivel de precisao
#' @param dx variavel que deve ser derivada
#' @param providedFunctionParams  outros parametros da funcao
#'
#' @return derivada numerica em um ponto
#' @export
#'
#' @examples
#'
#' f1=function(x){return(x^3)}
#'
#' df(f1, 8, providedFunctionParams = list())
#' [1] 192
#'
df = function (f,
               x,
               h = 1e-6,
               dx = "x",
               providedFunctionParams) {
  ## Iteracao da funcao f(x+h,...)
  
  # Estabeleço o ponto x_uppper
  providedFunctionParams[[dx]] = x + abs(h)
  
  # executo a chamada da funcao
  fplus = do.call(f, providedFunctionParams)
  
  ## Iteracao da funcao f(x-h,...)
  
  # Estabeleço o ponto x_lower
  providedFunctionParams[[dx]] = x - abs(h)
  
  # executo a chamada da funcao
  fminus =  do.call(f, providedFunctionParams)
  
  # Caculo a derivada pelo TVM
  return((fplus - fminus) / (2 * h))
}


#' Retorna a raiz de uma funcao atraves do metodo de Newton-Raphson
#'
#' @param f Funcao
#' @param x0 ponto inicial da regressao
#' @param eps nivel de precisao
#' @param nmax numero maximo de interacoes
#' @param dx paraetro da funcao que deve ser avaliado
#' @param providedFunctionParams outros parametros da funcao
#'
#' @return ponto da funcao
#' @export
#'
#' @examples
#' 
#' f1=function(x){return(x^2-2)}
#'
#' root_f(f1, 4, providedFunctionParams = list())
#' [1] 1.414214
#'
root_f = function(f,
                  x0,
                  eps = 1e-6,
                  nmax = 1000,
                  dx = "x",
                  providedFunctionParams)
{
  providedFunctionParams[[dx]] = x0
  
  # Determino y=f(x, y, ...) / executo a chamada da funcao
  y =  do.call(f, providedFunctionParams)
  
  # inicializo o contador
  nContador = 0
  while ((nContador <= nmax) & (abs(y) >  eps))
  {
    # calculo a derivada no ponto
    Ndf = df(
      f = f,
      x =  x0,
      h = eps,
      dx = dx,
      providedFunctionParams
    )
    
    if (abs(Ndf) < eps)
    {
      # Aviso o usuario que foi encontrado um possivel ponto critico
      warning("Possible critical point found. Incrementing by 2 epsilon")
      
      # Incremento o x por 2 epsilon
      x_i = x0 + 2 * eps
    }
    else
    {
      # Calculo o novo x
      x_i = x0 - (y / Ndf)
    }
    
    # atualizo o x da interacao
    x0 = x_i
    providedFunctionParams[[dx]] = x_i
    
    # executo a chamada da funcao determinando y=f(x_i, y, ...)
    y =  do.call(f, providedFunctionParams)
    
    # incremento a interacao do contador
    nContador = nContador + 1
  }
  
  # avisa o usiario que o numero maximo de interacoes foi atingido
  if (nContador > nmax)
  {
    warning("The process reached the maximum number of interactions")
  }
  
  return(x0)
}