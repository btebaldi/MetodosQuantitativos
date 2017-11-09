rm(list = ls())

## Define a semente
#set.seed(0);

### --- Bibliotecas e arquivos externos


## Pacotes R
library(XLConnect);

## Carrega as bibliotecas
source("./lib/MCOptionModel.r");

### --- Funções


## Função para carregas os dados de de validação
LoadOptionValidation = function(filepath,sheet) {
  
  wb = loadWorkbook(filepath);
  
  data = readWorksheet(wb,sheet=sheet,header=TRUE,startRow=1,startCol=1);
  
  return(data);
}

## -- Script/Programa Principal

## Arquivos de validação
filepath="./database/MCOption-Validacao.xlsx"

## planilha de validação das opções
optionSheet = "USDBRL Onshore Options";

## Carrega a base de valição
options = LoadOptionValidation(filepath,optionSheet);

## Base
base = 252;

#Simula Caminhos
i = 48;
St = MCAssetPaths(
  S = options[i,"Spot"],
  t = options[i,"WDays"]/base,
  Tvol = options[i,"WDaysVol"]/base,
  r = log(1+options[i,"RiskFree"]),
  rf = log(1+options[i,"Cupom"]),
  sigma = options[i,"Volatility"],
  nsim = 100,
  dt = 10e-2
);

matplot(t(St),type="l")

# for (i in 1:nrow(options)){
  
for (i in 1:10){
  ## MCOptionPrice = function(type=c("call","put"), S, X, T, Tvol, r, rf, sigma, nsim, dt)
  price = MCOptionPrice(
    type = options[i,"Type"],
    S = options[i,"Spot"],
    X = options[i,"Strike"],
    t = options[i,"WDays"]/base,
    Tvol = options[i,"WDaysVol"]/base,
    r = log(1+options[i,"RiskFree"]),
    rf = log(1+options[i,"Cupom"]),
    sigma = options[i,"Volatility"],
    nsim = 20000,
    dt = 0.01
  );
    
  cat(sprintf("Price: %.2f/%.2f\n",options[i,"Price"],price*1000));
  
}
