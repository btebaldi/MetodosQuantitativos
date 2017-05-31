### --- Bibliotecas e arquivos externos

## Pacotes R
library(XLConnect);

## Carrega as bibliotecas
source("../lib/GBSMOptionModel.r");

### --- Funcoes

## Funcao para carregas os dados de validacao
LoadOptionValidation = function(filepath,sheet) {
  
  wb = loadWorkbook(filepath);
  
  data = readWorksheet(wb,sheet=sheet,header=TRUE,startRow=1,startCol=1);
  
  
  return(data);
}

## -- Script/Programa Principal

## Arquivos de valida??o
filepath="../database/GBSMOption-Validacao.xlsx"

## planilha de valida??o das op??es
optionSheet = "USDBRL Onshore Options";

## Carrega a base de validacao
options = LoadOptionValidation(filepath,optionSheet);

## Base
base = 252;

## Estrutura para armazenar o Resultado
result = data.frame(n=1:nrow(options));

## Para cada linha da planilha
for (i in 1:nrow(options)){
  
  ## Calcula o pre?o da op??o
  ## result[i,"Price"] = GBSMOptionPrice(type=c("call","put"), S, X, T, Tvol, r, b, sigma)
  result[i,"Price"] = GBSMOptionPrice(
    type = options[i,"Type"],
    S = options[i,"Forward"],
    X = options[i,"Strike"],
    T = options[i,"WDays"]/base,
    Tvol = options[i,"WDaysVol"]/base,
    r = log(1+options[i,"RiskFree"]),
    b = 0,
    sigma = options[i,"Volatility"]
  );
  
  ## result[i,"FwdDelta"] = GBSMOptionDelta(type=c("call","put"), S, X, T, Tvol, r, b, sigma)
  result[i,"FwdDelta"] = GBSMOptionDelta(
    type = options[i,"Type"],
    S = options[i,"Forward"],
    X = options[i,"Strike"],
    T = options[i,"WDays"]/base,
    Tvol = options[i,"WDaysVol"]/base,
    r = log(1+options[i,"RiskFree"]),
    b = 0,
    sigma = options[i,"Volatility"]
  );
  
  ## result[i,"NumDelta"] = GBSMOptionNumDelta(type=c("call","put"), S, X, T, Tvol, r, b, sigma)
  result[i,"NumDelta"] = GBSMOptionNumDelta(
    type = options[i,"Type"],
    S = options[i,"Forward"],
    X = options[i,"Strike"],
    T = options[i,"WDays"]/base,
    Tvol = options[i,"WDaysVol"]/base,
    r = log(1+options[i,"RiskFree"]),
    b = 0,
    sigma = options[i,"Volatility"]
  );
  
  
  ## result[i,"Volatility"] = GBSMOptionVolatility(type=c("call","put"), S, X, T, Tvol=NA, r, b=0, price, nmax=100)
  result[i,"Volatility"] = GBSMOptionVolatility(
    type = options[i,"Type"],
    S = options[i,"Forward"],
    X = options[i,"Strike"],
    T = options[i,"WDays"]/base,
    Tvol = options[i,"WDaysVol"]/base,
    r = log(1+options[i,"RiskFree"]),
    b = 0,
    price = options[i,"Price"]
  );
  
}

print(result);
