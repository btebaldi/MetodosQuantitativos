## remove all objects fromt the current workspace 
rm(list = ls());

## Load User scripts
source(file = "lib/RaizesQuadratica.R");


## Initialize variables
  a=c(1, 1, 3, 4,-3,  9,   1,2,3,5,7,11)
  b=c(3, 0,-4,16, 0,-18,   1,2,3)
  c=c(2,-4, 5, 0,27,  9,   3,3,5,6,7)  

  RaizesQuadratica(a,b,c);

  