## Clear variables
rm(list = ls())

## Carrego bibliotecas do usuario
# source(file = "./lib/Utils.r")
source(file = "./lib/Raiz.R")
source(file = "./lib/VPL.R")

CF = c(-75e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3, 22.5e3)
r=.1

VPL(CF, r = r)
TIR(CF, r=r )

CF = c(-120e3,34e3,34e3,34e3,34e3,34e3)

VPL(CF,r)
TIR(CF, r)
