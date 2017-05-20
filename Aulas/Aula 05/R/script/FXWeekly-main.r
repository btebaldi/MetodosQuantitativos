# O arquivo a ser editado que será o scrit principal será:
#   R/scripts/FXWeekly-main.r


# Chamo a instalacao das funcoes do usuario
source(file = "./lib/Utils.r")

if (!exists("DataLoaderTxt"))
{
  source(file = "./lib/DataLoaderTxt.R")
}

if (!exists("DataPrepFXWeekly"))
{
  source(file = "./script/DataPrepFXWeekly.R")
}

## Carego eventuais bibliotecas aque serao utilizadas


## Limpo a area de trabalho
#ClearAll()

# Defino a variavel com o nome do arquivo de banco de dados
myFilepath = "./database/BBG-FX-Daily.txt"

# Carego os dados do arquivo
Data = DataLoaderTxt(filepath = myFilepath)

iniPeriodo = "2017-01-01"
fimPeriodo = "2017-01-01"

## Variaveis seleciondas da base
## Moedas
myCurrencies = c("BRL","AUD");

## Indices
myIndexes = c("IBOV","CRY","VIX");

## Yield/Swap
myYields = c("BCSWFPD","GT10","USSA1");

## Volatilidade
myVols = c("USDBRL25R1M","USDBRLV1M");

## lbp: Look Back Period
lbp = 52;




# Preparo os arquivos
data = DataPrepFXWeekly(
  data = Data,
  begin = iniPeriodo,
  end = fimPeriodo,
  currencies = myCurrencies,
  indexes = myIndexes,
  yields = myYields,
  vols = myVols
)



### FGV/EESP - Mestrado Profissional em Economia e Finanças
### Disciplina: Métodos Quantitativos Aplicados         Turma: <NúmeroAno>-<NúmeroMês>
### Nome do aluno:  <NomeAluno>  		        Código: <NomeAluno>
###
### Exercício: HistCovariance
### Subject email: [MPE/MetQuant <NúmeroAno>-<NúmeroMês>] Exercício: HistCovariance Aluno: <NomeAluno>


## Source nas bibliotecas necessÃ¡rias
source("../lib/DataLoader.r");
source("../lib/DataPreparation.r");
source("../lib/MovingPredict.r");

## -- ConfiguraÃ§Ã£o

## Arquivo de dados
filepath="../database/BBG-FX-Daily.txt";

## Data inicial
begin = as.Date("2008-01-09");

## Data Final
end = as.Date("2015-01-23");

## VariÃ¡veis seleciondas da base
## Moedas
currencies = c("BRL","AUD");

## Indices
indexes = c("IBOV","CRY","VIX");

## Yield/Swap
yields = c("BCSWFPD","GT10","USSA1");

## Volatilidade
vols = c("USDBRL25R1M","USDBRLV1M");

## lbp: Look Back Period
lbp = 52;

## -- Carga dos dados

## Carrega os dados do arquivo
Data = DataLoaderTxt(filepath);

## Apenas dos dados listados
data = data[,c("Date",currencies,indexes,yields,vols)];

## -- Data Clearing/Preparation

## Seleciona apenas os dados que interssam
wdata = DataPrepFXWeekly(data,begin,end,currencies,indexes,yields,vols);

## (sugestÃ£o) VariÃ¡veis para o modelo: ra.+ e d1.+
## variables = colnames(wdata)[grep("^ra.+|^d1.+",colnames(wdata))];

## (sugestÃ£o) Dados que serÃ£o utilizados no modelo
## input = wdata[,variables];

## (sugestÃ£o) Faz as previsÃµes
## output = LinearMovingPredict(input,"raBRL",lbp=lbp);

## Plot previsÃµes
# m = output[(lbp+1):nrow(output),c("raBRL","fit","lwr","upr")];
# matplot(m,type="l",col=c("blue","green","red","red"));

