### FGV/EESP - Mestrado Profissional em Economia e FinanÁas
### Disciplina: MÈtodos Quantitativos Aplicados         Turma: <N˙meroAno>-<N˙meroMÍs>
### Nome do aluno:  <NomeAluno>  		        CÛdigo: <NomeAluno>
###
### ExercÌcio: HistCovariance
### Subject email: [MPE/MetQuant <N˙meroAno>-<N˙meroMÍs>] ExercÌcio: HistCovariance Aluno: <NomeAluno>


## Source nas bibliotecas necess√°rias
source("../lib/DataLoader.r");
source("../lib/DataPreparation.r");
source("../lib/MovingPredict.r");

## -- Configura√ß√£o

## Arquivo de dados
filepath="../database/BBG-FX-Daily.txt";

## Data inicial
begin = as.Date("2008-01-09");

## Data Final
end = as.Date("2015-01-23");

## Vari√°veis seleciondas da base
## Moedas
currencies = c("BRL","AUD");

## Ind√≠ces
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

## (sugest√£o) Vari√°veis para o modelo: ra.+ e d1.+
## variables = colnames(wdata)[grep("^ra.+|^d1.+",colnames(wdata))];

## (sugest√£o) Dados que ser√£o utilizados no modelo
## input = wdata[,variables];

## (sugest√£o) Faz as previs√µes
## output = LinearMovingPredict(input,"raBRL",lbp=lbp);

## Plot previs√µes
# m = output[(lbp+1):nrow(output),c("raBRL","fit","lwr","upr")];
# matplot(m,type="l",col=c("blue","green","red","red"));
