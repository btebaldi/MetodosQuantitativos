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
  
  tirValue=root_f(
    f = VPL,
    x0 = r,
    dx = "r",
    eps = 1e-7,
    nmax = 1000,
    providedFunctionParams = params
  )
  
  return(tirValue)
}


SimulaCF = function(y0, a, b, investimento, n = 10000)
{
  # para que isso?
  set.seed(10)
  
  #inicializo variaveis internas
  sizePeriodo = length(investimento)
  nCF = array(0, c(n, sizePeriodo))
  
  for (n_Contador in 1:n)
  {
    # # MEETODO 1
    #     nCF[n,] = investimento
    #     yt_1=y0
    #     for (i in 2:nper)
    #     {
    #       yt = yt_1 + a +  b * rnorm(1,0,1)
    #       nCF[n,i] = nCF[n,i] + yt
    #
    #       yt_1 = yt
    #     }
    
    # MEETODO 2
    
    # inicializo o primeiro periodo
    nCF[n_Contador, 1] = y0
    
    # faz o looping do calculo dos periodos
    for (i in 2:sizePeriodo)
    {
      nCF[n_Contador, i] = nCF[n_Contador, i - 1] + a +  b * rnorm(1, 0, 1)
    }
    
    # somo os investimentos
    nCF[n_Contador,] = nCF[n_Contador,] + investimento
    
  }
  
  # retorno o fluxo de caixa
  return(nCF)
}
