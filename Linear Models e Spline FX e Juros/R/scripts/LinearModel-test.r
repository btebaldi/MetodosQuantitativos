rm(list = ls())

sample = read.table("./database/ExemploRegressaoLinear.txt",
                    header = TRUE, sep="\t", dec=",", 
                    stringsAsFactors = FALSE);

## Quebrei a amostra
sample_in = sample[1:(nrow(sample)/2),];
sample_out = sample[(nrow(sample_in)+1):nrow(sample),];

## Ajustar o modelo
fit1 = lm(y ~ x1 + log(x2), data=sample_in);

## Analise
summary(fit1);

## Verificar o poder de previsao
sample_out.predict = predict(fit1, newdata = sample_out, interval = "confidence", level=0.95);

## Erro quadrado
erro1 = sum((sample_out.predict[,"fit"] - sample_out[["y"]])^2)
print(erro1)

#### Modelo 02

## Ajustar o modelo
fit2 = lm(y ~ x1 + I(x2^2), data=sample_in);

## Analise
summary(fit2);

## Verificar o poder de previsao
sample_out.predict = predict(fit2, newdata = sample_out, interval = "confidence", level=0.95);

## Erro quadrado
erro2 = sum((sample_out.predict[,"fit"] - sample_out[["y"]])^2)
print(erro2)






