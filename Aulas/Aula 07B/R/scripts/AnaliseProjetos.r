## Clear variables
rm(list = ls())

## Carrego bibliotecas do usuario
# source(file = "./lib/Utils.r")
source(file = "./lib/Raiz.R")
source(file = "./lib/VPL.R")

# f = function(y,x,pot=2){return(x^pot-2)}
# 
# a= root_f(f=f, x0 = 1, pot=3)
# 
# a
# 
# z=2^(1/3)



CF = c(-75e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3)
r=.1

VPL(CF, r = r)
TIR(CF, r=r )

CF = c(-120e3,34e3,34e3,34e3,34e3,34e3)

VPL(CF,r)
TIR(CF, r)

