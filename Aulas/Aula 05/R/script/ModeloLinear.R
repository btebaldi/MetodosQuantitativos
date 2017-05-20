data = read.table(file = "../database/ExemploRegressaoLinear.txt", header = T,
               sep = "\t", dec = ",", stringsAsFactors = F);

data
class(data)

data[1:10,]

head(data)
tail(data)
plot(data)
x=summary(data)
class(x)
class(x[1])
diag(var(data))

sd(data[,1])

# funcao apply
apply(X = data,FUN = sd,MARGIN = 2)

fit = lm(y ~ x1 + x2 + x3 -1, data = data)
fit = lm(y ~ x1 + x2 + x3, data = data)
summary(fit)

fit2 = lm(y ~ x1 + log(x2) + x3 1, data = data)
summary(fit2)

# nome dos atributos
names(fit)

# Busco coeficiente por residuo fit$residuals
fit$residuals

plot(data$y, fit$residuals)

erro2 = (data[["y"]] - fit$fitted.values) %*% fit$residuals

cat("\014")


hist(fit$residuals)
plot(data$y, type="b")
points(fit$fitted.values, col="red")

#
fit = lm(y ~ x1 + x2 + x3, data = data)


dataOutOfSample = read.table(file = "../database/ExemploRegressaoLinear-NewData.txt", header = T,
               sep = "\t", dec = ",", stringsAsFactors = F);

y_predict = predict(fit, newdata =  dataOutOfSample)

plot(dataOutOfSample$y, type = "b")
points(y_predict, col='red', pch="+")


data[["logx2"]] = log(data[["x2"]])
data[["dlogx2"]] = diff(log(data[["x2"]]))

fit3= lm(y~. , data = data)

fit = step(lm(y~. , data = data))

data = data[-1,];

