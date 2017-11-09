library(RODBC);

DataLoaderSQL = function(db, query){
  
  ## Estabelece a conexão com o banco de dados
  conn = odbcConnectAccess(db$filename);
  
  ## Executa a query; rs = ResultSet
  rs = sqlQuery(conn,query);
  
  ## Fecha a conexão
  odbcClose(conn);
  
  ## Retorna o dado par a programa principal
  return(rs);
  
  
} 