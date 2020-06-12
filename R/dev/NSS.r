<<<<<<< HEAD
# Limpa variaveis
rm(list = ls())

# Carrega bibliotecas
library(ggplot2)

# DataLoader ----
source("./scripts/BBG-MarketData_DataLoader.r")

# calcula o log retorno do titulo ----
yiedlCurve$r_year = log(1+yiedlCurve$Yield)
yiedlCurve$Maturity_years = yiedlCurve$WorkDays / 252
head(yiedlCurve)

# plota os dados
ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) + geom_point()


# Define a funcao Nelson-Siegel-Svensson
# x: vetor(beta_1, beta_2, beta_3, beta_4, lambda_1, lambda_2)
# beta_1: is interpreted as the long run levels of interest rates
#         (the loading is 1, it is a constant that does not decay);
# beta_2: is the short-term component (it starts at 1, and decays 
#         monotonically and quickly to 0);
# beta_3: is the medium-term component (it starts at 0, increases,
#         then decays to zero);
# beta_4: analogous to beta_3
# Lambda_1: is the decay factor: small values produce slow decay and can
#           better fit the curve at long maturities, while large values 
#           produce fast decay and can better fit the curve at short maturities;
#           it also governs where beta_3 achieves its maximum.
# Lambda_2: analogous to lambda_1
NSS = function(x, Data)
{
  t=Data$Maturity_years
  beta1 = x[1]
  beta2 = x[2]
  beta3 = x[3]
  beta4 = x[4]
  lambda1 = x[5]
  lambda2 = x[6]
  
  y <- beta1 +
    beta2*(1-exp(-t/lambda1))/(t/lambda1) +
    beta3*((1-exp(-t/lambda1))/(t/lambda1) -exp(-t/lambda1)) +
    beta4*((1-exp(-t/lambda2))/(t/lambda2) -exp(-t/lambda2))
  
  return(y)
}

# funcao que calcula os erros da curva NSS contra o previsto real.
NSS.SSE = function(x, Data)
{
  y <- NSS(x, Data)
  
  error <- y - Data$r_year 
  
  SSE <- t(error) %*% error
  
  return(SSE)
}

# Roda um OLS simples para se ter uma ideia dos valores
mdl = lm(r_year ~ I((1-exp(-Maturity_years))/(Maturity_years)) +
           I((1-exp(-Maturity_years))/(Maturity_years) - exp(-Maturity_years)),
         data = yiedlCurve)
names(mdl$coefficients) = c(paste("beta", 1:3, sep = "_"))
summary(mdl)



# define x como o "ponto inicial)
x=c(mdl$coefficients[1], mdl$coefficients[2], mdl$coefficients[3], 0, 1, 1)
names(x) = c(paste("beta", 1:4, sep = "_"), "lambda_1", "lambda_2")
yiedlCurve$prev_OLS = NSS(x, yiedlCurve)

# Plota o valor previsto
ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) +
  geom_point() +
  geom_point(aes(x= Maturity_years, y=prev_OLS), colour="red")

# Faz a otimizacao irrestrita dos parametros
mdl.unrestrict <- optim(x, NSS.SSE, Data=yiedlCurve,
                        method="L-BFGS-B",
                        lower = c(0,-Inf,-Inf,-Inf,0,0),
                        upper = c(Inf, Inf, Inf, Inf, Inf, Inf) )

# Guarda os valores para comparacao
yiedlCurve$prev_Irrestrita = NSS(mdl.unrestrict$par, yiedlCurve)

# Faz a otimizacao irrestrita dos parametros
# beta_1 > 0
# beta_1 + beta_2 > 0
# lambda_1, lambda_2 > 0
mdl.restrict <- constrOptim(x,
                            NSS.SSE,
                            grad=NULL,
                            ui = rbind(c(1,0,0,0,0,0), c(1,1,0,0,0,0), c(0,0,0,0,1,0), c(0,0,0,0,0,1)),
                            ci=c(0, 0, 0, 0),
                            Data=yiedlCurve)

# Guarda os valores para comparacao
yiedlCurve$prev_Restrita = NSS(mdl.restrict$par, yiedlCurve)



# Plota as curvas para comparacao
ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) +
  geom_point(aes(colour="Original"), shape=1) +
  geom_line(aes(y=prev_OLS, colour="OLS"), linetype = "dashed") +
  # geom_line(aes(y=prev_Irrestrita, colour="Unrestricted")) +
  geom_line(aes(y=prev_Restrita, colour="Restricted"), linetype = "solid") +
  scale_colour_manual(
                      breaks = c("Original", "OLS", "Unrestricted", "Restricted"),
                      values = c("black", "black", "blue", "red")
                      ) +
  theme(legend.position = c(0.8, 0.3),
        legend.direction = "vertical") +
  labs(title = "Nelson-Siegel-Svensson",
       subtitle = "Parameter estimation",
       caption="FGV-EESP - Métodos Quantitativos",
       y="log-return [year]",
       x="Maturity [year]",
       colour="Legenda")


mdl.unrestrict$par
mdl.restrict$par
mdl$coefficients

=======
# Limpa variaveis
rm(list = ls())

# Carrega bibliotecas
library(ggplot2)


# DataLoader ----
source("./scripts/BBG-MarketData_DataLoader.r")

# plota os dados
plot(yiedlCurve$WorkDays, yiedlCurve$Yield )


# calcula o log retorno do titulo
yiedlCurve$r_year = log(1+yiedlCurve$Yield)
yiedlCurve$Maturity_years = yiedlCurve$WorkDays / 252
head(yiedlCurve)

# data$maturity2 = as.numeric(difftime(data$Date, lubridate::ymd("2017-11-30"), units="days"))

ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) + geom_point()

# Define a funcao Nelson-Siegel-Svensson
# x: vetor(beta_1, beta_2, beta_3, beta_4, lambda_1, lambda_2)
# beta_1: is interpreted as the long run levels of interest rates
#         (the loading is 1, it is a constant that does not decay);
# beta_2: is the short-term component (it starts at 1, and decays 
#         monotonically and quickly to 0);
# beta_3: is the medium-term component (it starts at 0, increases,
#         then decays to zero);
# beta_4: analogous to beta_3
# Lambda_1: is the decay factor: small values produce slow decay and can
#           better fit the curve at long maturities, while large values 
#           produce fast decay and can better fit the curve at short maturities;
#           it also governs where beta_3 achieves its maximum.
# Lambda_2: analogous to lambda_1
NSS = function(x, Data)
{
  t=Data$Maturity_years
  beta1 = x[1]
  beta2 = x[2]
  beta3 = x[3]
  beta4 = x[4]
  lambda1 = x[5]
  lambda2 = x[6]
  
  y <- beta1 +
    beta2*(1-exp(-t/lambda1))/(t/lambda1) +
    beta3*((1-exp(-t/lambda1))/(t/lambda1) -exp(-t/lambda1)) +
    beta4*((1-exp(-t/lambda2))/(t/lambda2) -exp(-t/lambda2))
  
  return(y)
}

# funcao que calcula os erros da curva NSS contra o previsto real.
NSS.SSE = function(x, Data)
{
  y <- NSS(x, Data)
  
  error <- y - Data$r_year 
  
  SSE <- t(error) %*% error
  
  return(SSE)
}

# Roda um OLS simples para se ter uma ideia dos valores
mdl = lm(r_year ~ I((1-exp(-Maturity_years))/Maturity_years) + I((1-exp(-Maturity_years))/Maturity_years - exp(-Maturity_years)), data = yiedlCurve)
summary(mdl)

# define x como o "ponto inicial)
x=c(mdl$coefficients[1], mdl$coefficients[2], mdl$coefficients[3], 0, 1, 1)
yiedlCurve$prev_OLS = NSS(x, yiedlCurve)

# Plota o valor previsto
ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) +
  geom_point() +
  geom_point(aes(x= Maturity_years, y=prev_OLS), colour="red")

# Faz a otimizacao irrestrita dos parametros
mdl.unrestrict <- optim(x, NSS.SSE, Data=yiedlCurve,
                        method="L-BFGS-B",
                        lower = c(0,-Inf,-Inf,-Inf,0,0),
                        upper = c(Inf, Inf, Inf, Inf, Inf, Inf) )

# Guarda os valores para comparacao
yiedlCurve$prev_Irrestrita = NSS(mdl.unrestrict$par, yiedlCurve)

# Faz a otimizacao irrestrita dos parametros
# beta_1 > 0
# beta_1 + beta_2 > 0
# lambda_1, lambda_2 > 0
mdl.restrict <- constrOptim(x,
                            NSS.SSE,
                            grad=NULL,
                            ui = rbind(c(1,0,0,0,0,0), c(1,1,0,0,0,0), c(0,0,0,0,1,0), c(0,0,0,0,0,1)),
                            ci=c(0, 0, 0, 0),
                            Data=yiedlCurve)

# Guarda os valores para comparacao
yiedlCurve$prev_Restrita = NSS(mdl.restrict$par, yiedlCurve)



# Plota as curvas para comparacao
ggplot(yiedlCurve, aes(x=Maturity_years, y=r_year)) +
  geom_point(aes(colour="Original")) +
  geom_line(aes(y=prev_OLS, colour="OLS")) +
  geom_line(aes(y=prev_Irrestrita, colour="Unrestricted")) +
  geom_line(aes(y=prev_Restrita, colour="Restricted")) +
  scale_colour_manual(
                      breaks = c("Original", "OLS", "Unrestricted", "Restricted"),
                      values = c("magenta", "black", "red", "blue")
                      ) +
  theme(legend.position = c(0.8, 0.3),
        legend.direction = "vertical") +
  labs(title = "Nelson-Siegel-Svensson",
       subtitle = "Parameter estimation",
       caption="FGV-EESP - Métodos Quantitativos",
       y="log-return [year]",
       x="Maturity [year]")

>>>>>>> c8ed81d0c95c3beaec36abcaaf9a309bdae80a02
