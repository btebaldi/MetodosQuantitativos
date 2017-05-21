#' Calcula o Valor Presente liquido
#'
#' @param CF Fluxo de caixa
#' @param r taxa de retorno no periodo
#'
#' @return VPL
#' @export
#'
#' @examples
#' 
#' CF = c(-75e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3)
#' r=.1
#' VPL(CF, r = r)
#' #' Calcula o Valor Presente liquido
#'
#' @param CF Fluxo de caixa
#' @param r taxa de retorno no periodo
#'
#' @return VPL
#' @export
#'
#' @examples
#' 
#' CF = c(-75e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3)
#' r=.1
#' VPL(CF, r = r)
#' VPL = function(CF, r)
#' [1] 10292.7
#' 
VPL = function(CF, r)
{
  periodo = 0:(length(CF) - 1)
  
  ## Calcula o valore presente
  VP = CF / ((1 + r) ^ (periodo))
  
  return(sum(VP))
}

#' Calcula a TIR
#'
#' @param CF Fluxo de caixa
#' @param r Taxa minima de atratividade (usado para melhor conversao da TIR)
#'
#' @return Taxa interna de retorno
#' @export
#'
#' @examples
#' CF = c(-75e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3)
#' r=.1
#' TIR(CF, r=r )
#' [1] 0.1523824
#' 
TIR = function(CF, r)
{
  params = list(CF = CF, r = r)
  
  root_f(
    f = VPL,
    x0 = r,
    dx = "r",
    eps = 1e-7,
    nmax = 1000,
    providedFunctionParams = params
  )
}
