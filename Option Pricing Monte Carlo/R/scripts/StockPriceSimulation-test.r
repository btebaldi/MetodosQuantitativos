source("./lib/ProcessosEstocasticos.r");

S0 = 10;
r = 0.1325;
sigma = 0.20;
t = 63/252;
dt = 0.001
nsim=1000;

## Estima os caminhos
St = StockPriceSimulation(S0, r, sigma, t, dt, nsim);

## Plota o gráfico
matplot(t(St),type="l");
