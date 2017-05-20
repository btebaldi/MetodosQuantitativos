library("XLConnect");

## Carrega o arquivo
wb = loadWorkbook("../R/database/IBOV_Closing.xls");

## Leitura das datas de vencimento
maturity = readWorksheet(wb,1,header = FALSE, startRow = 29, endRow = 29, startCol = 4, endCol = 11);

## Leitura do deltas
deltas = readWorksheet(wb,1,header = FALSE, startRow = 39, endRow = 47, startCol = 3, endCol = 3);

## Leitura das vols
vols = readWorksheet(wb,1,header = FALSE, startRow = 39, endRow = 47, startCol = 4, endCol = 11);

