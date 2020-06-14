# Biblioteca 
library(readxl); ## Instalar pacote se necessario [Tools] [Install packages...]


# ---- Dataloader ----
data <- read_excel("./database/BBG-YieldMarketData.v0.1.xlsx", 
                   range = "A4:D42")

dt.refDate <- read_excel("./database/BBG-YieldMarketData.v0.1.xlsx", 
                   range = "B1:B1", col_names = FALSE)

# determina a data de referencia
refDate = as.Date(dt.refDate[[1]])

## Carrega dos dados da curva. celula B4 (canto esquerdo superior)
yiedlCurve = data[,-1]

# remove arquivos auxiliares
rm(list = c("dt.refDate", "data"))

# mostra as primeiras linhas
print(head(yiedlCurve))
