### FGV/EESP - Mestrado Profissional em Economia e Financas
### Disciplina: Metodos Quantitativos Aplicados         Turma: 2017-04
### Nome do aluno:  Bruno Tebaldi de Queiroz Barbosa    Codigo: 174887
###
### Exercecio: HistCovariance
### Subject email: [MPE/MetQuant 2017-04] Exercicio: HistCovariance Aluno: Bruno Tebaldi

DataPrepFXWeekly = function(data,
                            begin,
                            end,
                            currencies,
                            indexes,
                            yields,
                            vols)
  {
  
  # ordeno o data frame para garantir que trabalhamos na ordem crescente
  data = data[order(data[["Date"]]),];
  
  
  # Dividir as variaveis (yields, vols) por 100
  data[, c(yields, vols)] = data[, c(yields, vols)] / 100;
  
  
  ## Calcular uma nova variável yield.
  # O Diferencial da taxa de 1 ano entre o Brasil e os EUA: DSWAP1YBRUS = BCSWFPD - USSA1
  if (("USSA1" %in% colnames(data)) &
      ("BCSWFPD" %in% colnames(data)))
  {
    # Crio a coluna requisitada
    data[["DSWAP1YBRUS"]] = data[["BCSWFPD"]] - data[["USSA1"]];
    
    # incremento a variavel yields, informando a existencia da nova coluna
    yields = c(yields, "DSWAP1YBRUS");
    
  }
  
  ## Calcular as medias semanais (para semana fechada) das variaveis
  
  # Vetor que contem as datas dos periodos
  dateWeek = seq(begin, end, by="week");
  
  # Crio o Dataframe de retorno de variaveis
  dataRetorno = data.frame("Date" = dateWeek, stringsAsFactors = F);
  
  # defino um vetor que contem as colunas que nao serem utilizadas para calculo da media
  colRemoveIndex = c(1);
  
  
  # Defino as colunas para calculo da media. Desconsiddero a coluna data (1) e a ultima("YearWeek")
  colunasMedia = colnames(data)[-colRemoveIndex];
  
  
  # inicializo as colunas no dataframe de retorno com valor NA
  dataRetorno[, colunasMedia] = NA;
  
  
  # Calculo as medias da semana
  for (nContador in 1:length(dateWeek))
  {
    # determino quais datas vao fazer parte da media
    dateIndexes = which(data[["Date"]] >= dateWeek[nContador] & data[[1]]< dateWeek[nContador] + 7);

    #detemino as medias das colunas
    dataRetorno[nContador, colunasMedia] = colMeans(data[dateIndexes, colunasMedia], na.rm = T);
  }
  
  
  # Para os valores das medias semanais das variáreis de currencies e indexes calcular o
  # retorno aritmetico
  
  # Crio o nome das colunas de retorno
  colRetornoName = gsub("^", "ra", c(currencies, indexes), perl = T);
  
  # inicializo as colunas de retorno no data frame
  dataRetorno[, colRetornoName] = NA;
  
  dataRetorno[-1, colRetornoName]=(dataRetorno[-1, c(currencies, indexes)]- dataRetorno[-nrow(dataRetorno), c(currencies, indexes)]) / dataRetorno[-nrow(dataRetorno), c(currencies, indexes)];
  
  
  # Para os valores das medias semanais das variareis de yields de vols
  # calcular a primeira diferenca: d1=Y_t - Y_t-1.
  
  # Crio o nome das colunas de retorno
  colDiferencaName = gsub("^", "d1", c(yields, vols), perl = T);
  
  # inicializo as colunas de retorno no data frame
  dataRetorno[, colDiferencaName] = NA;
  
  dataRetorno[-1, colDiferencaName] =dataRetorno[-1, c(yields, vols)] - dataRetorno[-nrow(dataRetorno), c(yields, vols)];
  
  return (dataRetorno)
  
}
