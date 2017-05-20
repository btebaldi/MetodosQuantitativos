# data: dataframe com os dados a serem tratados. Necessariamente a primeira coluna será a coluna de datas [“Dates”].
# begin: data inicial
# end: data final
# currencies: lista de moedas
# indexes: lista de índice ou preços de ativos
# yields: lista de taxas de juros
# vols: lista de variáveis indicativas de volatilidade
# DataPrepFXWeekly = function (data,
#                              begin,
#                              end,
#                              currencies,
#                              indexes,
#                              yields,
#                              vols)
# {
## Checa a coluna 1 é Dates e do tipo date
## ToDo

data = Data



##Dividir as variáveis (yields, vols) por 100
data[, c(yields, vols)] = data[, c(yields, vols)] / 100

# Crio uma variavel de numero de  semana
data[, "YearWeek"] = as.integer(format(data[["Date"]], "%Y%V"))

# "2008-01-09"
# "2008-01-09"
# seq()

# Crio o Dataframe de retorno de variaveis
dataRetorno = data.frame("YearWeek" = unique(data[, "YearWeek"]), stringsAsFactors = F)

# defino um vetor que contem as colunas a serem removidas
colRemoveIndex = c(1, ncol(data))

## Calcular uma nova variável yield.
# O Diferencial da taxa de 1 ano entre o Brasil e os EUA:
# DSWAP1YBRUS = BCSWFPD - USSA1
data[["DSWAP1YBRUS"]] = data[["BCSWFPD"]] - data[["USSA1"]]

# Defino as colunas para calculo da media. Desconsiddero a coluna data (1) e a ultima("YearWeek")
colunasMedia = colnames(data)[-colRemoveIndex]

# inicializo as colunas de retorno
dataRetorno[, colunasMedia] = NA

# Calculo as medias da semana
for (nCountador in 1:length(dataRetorno[["YearWeek"]]))
{
  # nCountador=1
  dataRetorno[nCountador, colunasMedia] = colMeans(data[data[["YearWeek"]] == dataRetorno[nCountador, "YearWeek"], colunasMedia], na.rm = T)
}

head(dataRetorno)

# for (i in 2:length(weeks))
# {
#   for (col in c(currencies, indexes))
#   {
#     name = sprintf("ra%s", col);
#     wdata[i,name] = (wdata[i,col]-wdata[i-1,col])/wdata[i-1,col];
#   }
#
#   for (col in c(yields, vols))
#   {
#     name =sprintf("dl%s", col);
#     wdata[i,name ] = wdata[i,col]-wdata[i-1,col]
#   }
#   }
#
# return (wdata)
# }