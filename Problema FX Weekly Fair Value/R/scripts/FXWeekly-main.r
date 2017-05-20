### FGV/EESP - Mestrado Profissional em Economia e Financas
### Disciplina: Metodos Quantitativos Aplicados         Turma: 2017-04
### Nome do aluno:  Bruno Tebaldi de Queiroz Barbosa    Codigo: 174887
###
### Exercecio: HistCovariance
### Subject email: [MPE/MetQuant 2017-04] Exercicio: HistCovariance Aluno: Bruno Tebaldi

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


## (sugestão) Faz as previsões
output = LinearMovingPredict(wdata,"raBRL",lbp=lbp);

## Plot previsões
m = output[(lbp+1):nrow(output),c("raBRL","fit","lwr","upr")];
matplot(m,type="l",col=c("blue","green","red","red"));
