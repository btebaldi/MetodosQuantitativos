## Le um range especifico

XLReadColRange = function(workbook, sheet=1, range){
  
  return(readWorksheetFromFile(workbook, sheet=sheet, region=range, header=FALSE, useCachedValues=TRUE)[[1]]);
  
}
