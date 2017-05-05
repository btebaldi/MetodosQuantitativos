## Definição de função
raiz = function(x, radix=2) {
  
  y = x^(1/radix);
  
  return(y)
  
}

## Execução

x = raiz(64);
print(x);

x = raiz(64,radix=6);
print(x);