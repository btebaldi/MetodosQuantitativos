### FGV/EESP - Mestrado Profissional em Economia e Financas
### Disciplina: Metodos Quantitativos Aplicados         Turma: 2017-04
### Nome do aluno:  Bruno Tebaldi de Queiroz Barbosa    Codigo: 174887
###
### Exercecio: HistCovariance
### Subject email: [MPE/MetQuant 2017-04] Exercicio: HistCovariance Aluno: Bruno Tebaldi

LinearMovingPredict = function(data, yname, lbp, interval="confidence", level=.95){
  
  # As variaveis que deverao ser utilizadas sao apenas os retornos aritmeticos e as primeiras
  # diferencas que retornaram da funcao anterior de preparação dos dados;

  # seletor de colunas
  ## (sugestão) Variáveis para o modelo: ra.+ e d1.+
  variables = colnames(wdata)[grep("^ra.+|^d1.+",colnames(wdata))];
  
  # Verifica se variavel explicada esta nos dados
  indxVarExplicada = grep(yname,variables);
  if(indxVarExplicada==0)
  { stop("Variavel explicada (yname) não esta presente nos dados"); }
  
  # Construcao da formula de regressao 
  f = as.formula(sprintf("%s ~ %s", variables[indxVarExplicada], paste(variables[-indxVarExplicada], sep = "", collapse = "+")));
  

  # inicializacao do dataframe de resultados com a variavel explicada
  retorno = data.frame("id" = 1:(nrow(wdata)-1), "fit" = NA, "lwr" = NA, "upr" = NA, "col1" = wdata[-1,variables[indxVarExplicada]]);
  colnames(retorno)[5] = variables[indxVarExplicada]
  
  
  # inicializa o dataframe de resultados com as variaveis explicativas
  retorno[,variables[-indxVarExplicada]] = wdata[-nrow(wdata),variables[-indxVarExplicada]];
  
  
  # Adiciono a ultima linha da matriz fornecida
  retorno[nrow(retorno)+1,] = NA;
  retorno[nrow(retorno),variables[-indxVarExplicada]] = wdata[nrow(wdata),variables[-indxVarExplicada]];
  
  
  # Determino o modelo de regressao e realizo previsao 
  for( nContador in 1:(nrow(retorno)-lbp) )
    {

        # Estimo o modelo atravez de minimos quadrados
        lmFit = lm(f, data=retorno[nContador:(lbp+nContador-1),]);

        # Seleciono variaveis significativas via step
        stepFit = step(lmFit, trace=0)

        # realiza previsao do modelo
        stepFit.pred = predict(stepFit, newdata=retorno[lbp+nContador,],  interval=interval, level=level)  

        # Alimento o data fram de resposta com os resultados do modelo 
        retorno[lbp+nContador, c("fit", "lwr", "upr")] = stepFit.pred[,1:3];
  }
  
  return(retorno)
}