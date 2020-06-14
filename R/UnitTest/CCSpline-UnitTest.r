## Script com exemplo para da interpolacao Contrained Cubic Spline
## Para verificar os valores das derivadas e coeficientes ver a planilha: CCSpline-exemplo.xlsx

# Clear all
rm(list = ls())

## -- Carrega a biblioteca de funcoes
source("./lib/CubicSpline.r");

## Valores de 'x'
x = c(0,10,30,50,70,90,100);

## Valores de 'y'
y = c(30,130,150,150,170,220,320);

## Teste de intepolacao
cat(sprintf("\n------------------------\nRESULTS\n------------------------"))

xstar = 5;
ret = CCSpline(x,y,xstar);
ans = 95.340;

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "A",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))

xstar = 25;
ret = CCSpline(x,y,xstar);
ans = 148.5795;

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "B",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))

xstar = 40;
ret = CCSpline(x,y,xstar);
ans = 150;

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "C",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))

xstar = 60;
ret = CCSpline(x,y,xstar);
ans = 156.4286;

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "D",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))

xstar = 80;
ret = CCSpline(x,y,xstar);
ans = 188.5714

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "E",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))

xstar = 95;
ret = CCSpline(x,y,xstar);
ans = 258.7500

if(trunc(ret$y_star*1000) == trunc(ans*1000)){
  TesteCheck <- "x"
  ResultText <- "Passed"
} else {
  TesteCheck <- " "
  ResultText <- "Fail"
}
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            "F",
            TesteCheck,
            ResultText,
            ret$y_star,
            ans))