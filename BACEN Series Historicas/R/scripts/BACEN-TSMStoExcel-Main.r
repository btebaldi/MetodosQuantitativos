source("../lib//BACEN-TSMStoExcel.r");

## Programa principal para execução do scripts

## -- Configurações
wbFilepath = "../database/BACEN-TSMS-database.xlsx";

## Carrega os dado - retorna o número de séries baixadas/atulizada
BACEN_TSMStoExcel(wbFilepath);