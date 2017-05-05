### FGV/EESP - Mestrado Profissional em Economia e Finan�as
### Disciplina: M�todos Quantitativos Aplicados         Turma: <N�meroAno>-<N�meroM�s>
### Nome do aluno:  <NomeAluno>  		        C�digo: <NomeAluno>
###
### Exerc�cio: HistCovariance
### Subject email: [MPE/MetQuant <N�meroAno>-<N�meroM�s>] Exerc�cio: HistCovariance Aluno: <NomeAluno>


## Source nas bibliotecas necessárias
source("../lib/DataLoader.r");
source("../lib/DataPreparation.r");
source("../lib/MovingPredict.r");

## -- Configuração

## Arquivo de dados
filepath="../database/BBG-FX-Daily.txt";

## Data inicial
begin = as.Date("2008-01-09");

## Data Final
end = as.Date("2015-01-23");

## Variáveis seleciondas da base
## Moedas
currencies = c("BRL","AUD");

## Indíces
indexes = c("IBOV","CRY","VIX");

## Yield/Swap
yields = c("BCSWFPD","GT10","USSA1");

## Volatilidade
vols = c("USDBRL25R1M","USDBRLV1M");

## lbp: Look Back Period
lbp = 52;

## -- Carga dos dados

## Carrega os dados do arquivo
data = DataLoaderTxt(filepath);

## Apenas dos dados listados
data = data[,c("Date",currencies,indexes,yields,vols)];

## -- Data Clearing/Preparation

## Seleciona apenas os dados que interssam
wdata = DataPrepFXWeekly(data,begin,end,currencies,indexes,yields,vols);

## (sugestão) Variáveis para o modelo: ra.+ e d1.+
## variables = colnames(wdata)[grep("^ra.+|^d1.+",colnames(wdata))];

## (sugestão) Dados que serão utilizados no modelo
## input = wdata[,variables];

## (sugestão) Faz as previsões
## output = LinearMovingPredict(input,"raBRL",lbp=lbp);

## Plot previsões
# m = output[(lbp+1):nrow(output),c("raBRL","fit","lwr","upr")];
# matplot(m,type="l",col=c("blue","green","red","red"));
