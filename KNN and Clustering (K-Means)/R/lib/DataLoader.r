DataLoadTXT = function(filepath){
  data.df = read.table(filepath, sep="\t", header=TRUE, dec=",", stringsAsFactors = FALSE);  
  data = as.matrix(data.df[,-1]);
  rownames(data) = data.df[,1];
  return(data);
}