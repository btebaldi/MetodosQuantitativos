rm(list = ls())

sample = read.table("./database/ExemploRegressaoPolinomio.txt",header = TRUE,sep="\t",dec=",",stringsAsFactors = FALSE);

## Ajustar o modelo
poly = lm(y ~ x + I(x^2)+ I(x^3)+ I(x^4), data=sample);

summary(poly)

plot(sample[["x"]],sample[["y"]])
lines(sample[["x"]], poly$fitted.values, col="red")



