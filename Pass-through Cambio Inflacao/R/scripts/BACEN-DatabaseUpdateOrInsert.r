## Script importa dados das séries históricas do Banco Central

## --- Bibliotecas R
library(RODBC);

## --- Bibliotecas locais
source("../lib//BACEN-DatabaseImport.r");

## --- Programa Principal

databasefile = "../database/MQA-PassThrough-Database.accdb"

filepaths = list.files(path="../download",full.names=TRUE);

for (i in 1:length(filepaths)) {
  
  cat(sprintf("Importando: %s...\n",filepaths[i]));

  
  ## Carrega os dados do arquivo
  data = DataLoaderFileCSV(filepaths[i]);
  
  
  ## Abre a conexão com o banco de dados
  conn = odbcConnectAccess2007(databasefile);
  
  ## Insere os dados
  # print(DataInsert(conn, data));
  
  ## Insere ou atuliza os dados
  print(DataUpdateOrInsert(conn, data));
  
  ## Fecha a conexão com o banco de dados
  odbcClose(conn);
  
}


