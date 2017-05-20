## --- Funções


## Função que define o polinomio
user_f = function(x){
  
  return ((x-1)*(x+2)*(x-3));
  
}


user_f2 = function(x){
  
  return (2 +x^2);
  
}


## Função que calcula a derivada
df = function (f, x, h=1e-6){
  
  return((f(x+h)-f(x-h))/(2*h));

}


## Função de calcula a raiz de uma função polinomial

root_f = function(f, x0, eps=1e-6, nmax=1e3){

  ## Iniciar xn
  xn = x0;
  
  ## Contador de iterações
  n = 0;
    
  ## Inicia o looping principal
  while (abs(f(xn))>eps && n<nmax){
    
    ## Calcula o próximo da iteracão
    xn1 = xn - f(xn)/df(f,xn);
    
    ## xn da próxima iteração
    xn = xn1;
    
    ## Incrementa o contador
    n = n + 1
    
    print(n);
  }
  
  ## verifica se encontrou uma raiz
  if (f(xn)>eps) xn = NaN;
  
  ## Retorna o valor
  return(xn);
}


## --- Programa Principal


## Teste da função

x = c(-4,0,-1,2,-2,1,3);
print(user_f(x));

## Plotar a função
x = seq(from=-3,to=4,by=0.2);
plot(x,user_f(x),type="l", col="red");
abline(h = 0, v= 0)


## Calcula a derivada
x = c(-4,0,-1,2,-2,1,3);
dfxs = df(user_f,x);
print(dfxs);

## Verificação
dfxs = 3*x^2-4*x-5
print(dfxs);


x0 = -3;
xn = root_f(user_f, x0);
cat(sprintf("x0=%.2f  x_root=%.2f\n",x0,xn));
  

x0 = 0;
xn = root_f(user_f, x0);
cat(sprintf("x0=%.2f  x_root=%.2f\n",x0,xn));


x0 = 100;
xn = root_f(user_f, x0);
cat(sprintf("x0=%.2f  x_root=%.2f\n",x0,xn));



x0 = 4;
xn = root_f(user_f2, x0, nmax=100);
cat(sprintf("x0=%.2f  x_root=%.2f\n",x0,xn));




