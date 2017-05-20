## Carrega os dados de um arquivo texto separa do 'tab'

DataLoaderTxt = function(filepath) {
  
  data = read.table(filepath,
                    header = TRUE, sep = "\t",
                    quote = "\"", dec = ",",
                    a.strings=c("#N/A N/A", ""), stringsAsFactors=FALSE)
  
  return(data);
}