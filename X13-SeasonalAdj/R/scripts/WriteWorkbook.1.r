library(XLConnect);

wb = loadWorkbook("../workbooks/WriteWorkbook-v0.1.xlsx");

## Escreve texto
strs = sprintf("str_%02d",1:10);
integers = 1:10;
doubles = rnorm(10);
dates = Sys.Date() + 1:10;

str.numbers = sprintf("1.%d",1:10);

df = data.frame(strs=strs, integers=integers, doubles=doubles, dates=dates,str.numbers=as.numeric(str.numbers));

## Gravação o data.frame
writeWorksheet(wb,df,1,startRow=4,startCol=13,header=TRUE);

## Grava coluna a coluna
writeWorksheet(wb,doubles,1,startRow=5,startCol=13,header=FALSE);

## Grava coluna a coluna
writeWorksheet(wb,as.numeric(str.numbers),1,startRow=4,startCol=1,header=TRUE);


## Save
saveWorkbook(wb,"../workbooks/WriteWorkbook-v0.1.xlsx");