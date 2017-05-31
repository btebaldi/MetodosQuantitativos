## Clear variables
rm(list = ls())

## Carrego bibliotecas do usuario
# source(file = "./lib/Utils.r")
source(file = "./lib/Raiz.R")
source(file = "./lib/VPL.R")

# Inicia Caixflow de teste 1
CF = c(-75e3, rep(22.5e3, 5))
r = 0.10

VPL(CF, r=r)
TIR(CF, r=0.1125)

# Inicia Caixflow de teste 2
CF = c(-120e3, rep(34e3,5))

VPL(CF, r)
TIR(CF, r)

# inicializo meu vetor de investimento
Inv = rep(0,15)
Inv[c(1,6,11)] = -10

# defino quantos fluoxs de caixa quero gerar (no caso 100)
N=10000

# chamo a funcao simuladora de fluxo de caixa
mcf=SimulaCF(y0=5, a=0.125, b=1,investimento = Inv, n=N)

# Defino um vetor chamado TIRs com valores iniciais NA, N linhas e 1 coluna
TIRs = array(NA, c(N,1))

# para cada fluxo de caixa simulado, calculo uma tir e guardo o resultado no vetor TIRs
for (i in 1:N)
{
  # utilizo a taxa de 10% (0.1) para chute inicial
  TIRs[i] = TIR(CF = mcf[i,], r = 0.1)
}

# pode existir projetos sem TIR, sendo assim retiro eles da amostra
TIRs = TIRs[!is.nan(TIRs)]

# Ploto o histograma da distribuicao
hist(TIRs) 

