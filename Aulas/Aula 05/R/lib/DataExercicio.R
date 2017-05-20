



source("./lib/DataLoader.R")



dados = DataLoaderTxt("./database/BBG-FX-Daily.txt")

head(dados)

## apenas os dados pos 2008-01-01
rowselector = dados[["Date"]] > as.Date("2008-01-01")

dados = dados[rowselector, ]


colnames(dados)

## Dividir variaveir percentuais
percColnames = c("USDBRL25R1M",
                 "USDBRLV1M",
                 "BCSWCPD",
                 "BCSWFPD",
                 "GT10",
                 "USSA1")



dados[, percColnames] = dados[, percColnames] / 100


dados[, "DSWAP1YR_US"] = dados[, "BCSWCPD"] - dados[, "USSA1"]

## Coluna ano e mes

dados[, "DateMonth"] = as.Date(format(dados[["Date"]], "%Y-%m-01"))

## Dataframe media mensal
datam = data.frame("DateMonth" = unique(dados[, "DateMonth"]), stringsAsFactors = F)



varname = colnames(dados)[-c(1, ncol(dados))]

datam[, varname] = NA


for (rowCounter in 1:nrow(datam))
{
  for (colItem in varname)
  {
    #print(datam[rowCounter, "DateMonth"])
    
    rowselector = dados[["DateMonth"]] == datam[rowCounter, "DateMonth"]
    
    datam[rowCounter, colItem] = mean(dados[rowselector, colItem], na.rm = T)
    # print(dados[rowselector,"DateMonth"])
  }
  
}

# Eliminar colunas com NA
toRemove = c()

for (i in 1:ncol(datam))
{
  if (any(is.nan(datam[, i])))
  {
    toRemove = c(toRemove, i)
    
  }
}

datam = datam[, -toRemove]


# Separar base de treinamento e de verificacao
dataLimit = as.Date("2011-01-01")

datamInSample = datam[datam[,"DateMonth"] <= dataLimit, ]
datamOutSample = datam[datam[,"DateMonth"] > dataLimit, ]

# fit Modelo
fit = step(lm (BRL ~ USDBRL25R1M + USDBRLV1M + DXY + CRY + USSA1 + DSWAP1YR_US, datamInSample))
summary(fit)


BRL.predict = predict(fit, newdata = datamOutSample)


