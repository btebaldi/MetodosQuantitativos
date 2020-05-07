# Biblioteca de titulos publicos
# Inicio de desenvolvimento: Aula 3




#' Truncagem de numeros
#'
#' @param x vetor de numeros para truncagem
#' @param n Casas decimais de truncagem
#'
#' @return vetor truncado
#' @export
#'
#' @examples truncar(1.12345678)
truncar = function(x, n) {
  return(trunc(x * 10 ^ n) / 10 ^ n)
}


#' Verifica qual o titulo calcular
#'
#' @param dataVencto Data de Vencimento
#' @param dataLiquidacao Data de liquidação do titulo
#' @param titulo c("NTNF")
#' @param TIR TIR para calculo do PU.
TPFBrPU = function(titulo, dataVencto, dataLiquidacao, TIR) {
  require(bizdays)
  
  # Truncagem da TIR
  TIR = truncar(TIR, 6)
  
  if (titulo == "NTNF") {
    # Valor de face da NTN-F
    valorFace = 1000
    
    # Cupom da NTN-F eh 10% (pagos semestralmente)
    cupom.tx = 0.10
    cupom.value = (1 + cupom.tx) ^ 0.5 - 1
    
    # Determina o fluxo de pagamentos
    fluxo = NTN_F.Fluxo(dataVencto, dataLiquidacao)
    
    # Determina o Fluxo de caixa
    vffluxoCxJuros = rep(cupom.value, length(fluxo$dataPagmentos.efetivo))
    vffluxoCxFinal = rep(0, length(fluxo$dataPagmentos.efetivo))
    vffluxoCxFinal[1] = 1
    vffluxoCxFinal = rev(vffluxoCxFinal)
    
    vffluxoCx = vffluxoCxJuros + vffluxoCxFinal
    vffluxoCx = round(vffluxoCx * valorFace, 5)
    
    # Agrupa o fluxo de caixa
    fluxo$fluxoDeCaixa = vffluxoCx
    
    
    # calcula o VPL do fluxo de caixa
    fluxo$VPL = round(fluxo$fluxoDeCaixa / ((1 + TIR) ^ truncar(fluxo$diasUteis /
                                                                  252, 14)), 9)
    
    # Calcula o PU final
    PU =  truncar(sum(fluxo$VPL), 6)
    
    
  } else if (titulo == "LTN") {
    # sss
  } else {
    return("Titulo nao suportado")
  }
  
  # Retorno do valor do PU
  return(PU)
}



#' Fluxo de pagamentos de uma NTNF
#'
#' @param dataVencto Data de vencimento da NTN-F
#' @param dataLiquidacao Data de liquidação da NTN-F
#' @param cal Calendario para calculo do fluxo de pagamentos
#'
#' @return data.frame com fluxo de pagamentos
#' @export
#'
#' @examples NTN_F.Fluxo(as.Date("2014-01-01"), as.Date("2008-05-21"))
NTN_F.Fluxo = function(dataVencto, dataLiquidacao, cal = NULL) {
  require(bizdays)
  
  # determina as datas de pagamentos
  dataPagmentos = rev(seq(from = dataVencto, to = dataLiquidacao, by = "-6 months"))
  
  # Determina o calendario a ser utilizado
  if (is.null(cal))
  {
    calendar = create.calendar("ANBIMA",
                               holidays = holidaysANBIMA,
                               weekdays = c("saturday", "sunday"))
  } else{
    calendar = cal
  }
  
  # Determina data de pagamento efetiva
  dataPagmentos.efetivo = bizdays::adjust.next(dataPagmentos, calendar)
  
  # Determina os dias uteis da data de liquidacao ate as datas de pagamento
  diasUteis = bizdays::bizdays(from = dataLiquidacao, to = dataPagmentos.efetivo, cal = calendar)
  
  # Ajusta todos os dados em um data.frame
  retorno = data.frame(dataPagmentos, dataPagmentos.efetivo, diasUteis)
  
  # retorno do fluxo
  return(retorno)
}
