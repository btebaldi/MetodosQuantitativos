## -- Testa a leitura do arquivo texto

## Carrega o arquivo com as função
source("../lib/DataLoader.r");

## Testa a leitura do arquivo texto
data = DataLoaderFileCSV("../database/BASE01-STP-20150420222930288.csv");

head(data);

data = DataLoader(c("../database/BASE01-STP-20150420222930288.csv","../database//BASE02-STP-20150420223024970.csv"),"../database//BC-CODIGO_DAS_SERIES.csv");
