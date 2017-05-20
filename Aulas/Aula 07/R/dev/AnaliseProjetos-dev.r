source("../lib/AnaliseProjetos.r");

cfA = c(-75000,22500,22500,22500,22500,22500);
cfB = c(-120000,34000,34000,34000,34000,34000);

r = .10;
VPL_A = VPL(cfA,r)
VPL_B = VPL(cfB,r)

TIR_A = TIR(cfA,r)
TIR_B = TIR(cfB,r)