# Teste unitario nas funcoes de analise de projetos

# clear all
rm(list=ls())

# fonte
source("./lib/AnaliseProjetos.R");

# fluxo de caixa para teste
cfA = c(-75000,22500,22500,22500,22500,22500);
cfB = c(-120000,34000,34000,34000,34000,34000);
cfC = c(-110733.11,23740.09,25261.55,24288.76,31863.46,28196.28);
cfD = c(-108949.65,100658.47,65174.01,28424.8,219652.93,732895.69);

VPL_trg = c(10292.70, 8886.75, -22650.92, 0.64)
TIR_trg = c(0.1524, 0.1286, 0.0627, 0.9840)

# taxa de juros para teste
r_a = .10;
r_b = .10;
r_c = .1494;
r_d = .984;

# Calculo do VPL A e B
VPL_A = VPL(cfA,r_a)
VPL_B = VPL(cfB,r_b)
VPL_C = VPL(cfC,r_c)
VPL_D = VPL(cfD,r_d)
VPL_results = c(VPL_A, VPL_B, VPL_C, VPL_D)

# Calculo da TIR A e B
TIR_A = TIR(cfA,r_a)
TIR_B = TIR(cfB,r_b)
TIR_C = TIR(cfC,r_c)
TIR_D = TIR(cfD,r_d)
TIR_results = c(TIR_A, TIR_B, TIR_C, TIR_D)

# calculo dos resultados
VPL_TesteResult = trunc((abs(VPL_trg - VPL_results)/VPL_trg)*10) <= 1
TIR_TesteResult = trunc((abs(TIR_trg - TIR_results)/TIR_trg)*10) <= 1


TesteType = c("A","B","C","D")
TesteResult = c("Fail", "Passed")
TesteCheck = c(" ", "X")
cat(sprintf("\n------------------------\nRESULTS\n------------------------"))
cat(sprintf("\nVPL Test %s: [%s] %7s - VPL: %9.2f   Target: %9.2f", TesteType, TesteCheck[VPL_TesteResult+1], TesteResult[VPL_TesteResult+1], VPL_results, VPL_trg))
cat(sprintf("\nTIR Test %s: [%s] %7s - TIR: %9.4f   Target: %9.4f", TesteType, TesteCheck[TIR_TesteResult+1], TesteResult[TIR_TesteResult+1], TIR_results, TIR_trg))


# TIR STRESS TEST
TIR_E = TIR(cfD, -4)
cat(sprintf("\n\nTIR Stress Test\nInitial guess at -400%% leads to TIR:%9.4f", TIR_E))
cat(sprintf("\n(If result is 0.984 check code for hardset values)"))



