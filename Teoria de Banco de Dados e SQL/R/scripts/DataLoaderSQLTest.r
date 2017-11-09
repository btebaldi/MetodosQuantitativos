## Teste da função de carga de dados

## Carrega a biblioteca
source("../lib/DataLoader.r");

## Parâmetros de acesso ao banco de dados
db = list(filename="../database/empresas.mdb", user="", passwd="");

## Define a query
query = "select * from EMPRESAS";

## Executa a query
data = DataLoaderSQL(db,query);

## Mostra os dados
print(data);
