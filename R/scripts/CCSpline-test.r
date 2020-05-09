## Script com exemplo para da interpola??o Contrained Cubic Spline
## Para verificar os valores das derivadas e coeficientes ver a planilha: CCSpline-exemplo.xlsx

# Clear all
rm(list = ls())

# libraries
library(ggplot2)

## -- Carrega a biblioteca de funcoes
source("./lib/MetQuantLib_v2.r");

## Valores de 'x'
x = c(0,10,30,50,70,90,100);

## Valores de 'y'
y = c(30,130,150,150,170,220,320);

## Teste de intepola??o

xstar = 5;
ystar = CCSpline(x,y,xstar);
print(ystar);

xstar = 25;
ystar = CCSpline(x,y,xstar);
print(ystar);

xstar = 40;
ystar = CCSpline(x,y,xstar);
print(ystar);

xstar = 60;
ystar = CCSpline(x,y,xstar);
print(ystar);

xstar = 80;
ystar = CCSpline(x,y,xstar);
print(ystar);

xstar = 95;
ystar = CCSpline(x,y,xstar);
print(ystar);


x_star = c(5, 25, 40, 60, 80, 95, 01, 100)
res = CCSpline(x, y, x_star);

x_star2 = 0:100
res2 = CCSpline(x, y, x_star2);


ggplot(data.frame(x,y)) +
  geom_point(aes(x, y)) +
  geom_point(data = res, aes(x=x_star, y=y_star), colour= "blue") +
  geom_line(data = res2, aes(x=x_star, y=y_star), colour= "red")

