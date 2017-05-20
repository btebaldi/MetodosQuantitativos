cat("\014")
rm(list = ls())

Dados = read.table(file = "../database/ExemploRegressaoPolinomio.txt", header = T,
                             sep = "\t", dec = ",", stringsAsFactors = F);

poly = lm(y ~ 1 + x + I(x^2) + I(x^3), data = Dados)
summary(poly)

plot(Dados$x, Dados$y)
lines(Dados$x, poly$fitted.values, col="red")
poly$df.residual



