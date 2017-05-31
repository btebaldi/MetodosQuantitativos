## Biblioteca
source("../lib/Baskara.r");


## Vetor de coeficientes

coeffs = array(0,c(4,3));


coeffs[1,] = c(1,-5,6);
coeffs[2,] = c(1,0,-2);
coeffs[3,] = c(1,0,5);
coeffs[4,] = c(1,-2,-35);


roots = Baskara(coeffs);

print(roots);

