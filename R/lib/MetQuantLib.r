### Descricao:
### Arquivo com funcoes da disciplina de Metodos Quantitativos

### --- Bibliotecas do R

### --- Constantes

### --- Funções

## Funcao: CCSpline
## Descricao: Interpolação utilizandco Constrained Cubic Scpline
## Argumentos:
##  x: Vetor numérico com os valores de x
##  y: Vetor numérico com os valores de y
##  xstar: Valor de x para fazer a interpolação: "y*" 
## Retorno
##  ystar: Valor de y interpolado:  "y*"


CCSpline = function(x,y,xstar){
  
  ## Numero de pontos
  n = length(x);

  ## Atencao: 
  ## No paper: i = 0,1,2,...n-1
  ## No R: contadorex de x i = 1,2,3,...n, ou seja, o primeiro i=1
  ## No R: contadores de f i = 2, 3, 4,...n. Ponto x2: f2 a esquerda de x2 e f3 a direita de x2

  ## Contador das funções
  i = 2;
  
  ## Variáveis auxiliares
  dfxi = 0;     ## f'(xi)
  dfxi_1 = 0;   ## f'(xi_1)
  dfixi_1 = 0;  ## f'i(xi_1)
  dfixi = 0;    ## f'i(xi)
  ddfixi_1 = 0;  ## f''i(xi_1)
  ddfixi = 0;    ## f''i(xi)
  
  ## Coeficientes da equação
  ai = 0;
  bi = 0;
  ci = 0;
  di = 0;

  ## Calcular apenas para os segmentos necessarios, ou seja, xi_1 < xstar
  while (x[i-1] <= xstar && i <= n){
    
    ## -- Calcula f'(xi) = dfxi
    
    ## Verifica se é o ultimo ponto
    if (i < n) {
      ## Slope a esquerda de xi
      dfxiLeft = (y[i]-y[i-1])/(x[i]-x[i-1]);
      
      ## Slope a direita de xi
      dfxiRight = (y[i+1]-y[i])/(x[i+1]-x[i]);
      
      ## Verifica se houve mudanca de sinal do slope e se é diferente de zero
      ## Verificação alternativa ((y[i]-y[i-1]) * (y[i+1]-y[i])) > 0
      if (sign(dfxiLeft)==sign(dfxiRight) && dfxiLeft!=0){
        dfxi = 2/((x[i+1]-x[i])/(y[i+1]-y[i])+(x[i]-x[i-1])/(y[i]-y[i-1]))
      } else {
        ## Se muda o sinal ou dfxiLeft==dfxiRight==0
        dfxi = 0;
      }
      
      ## Para i < n temos f'i(xi)=f'(xi)
      dfixi = dfxi;
      
    } else {
      # Para i == n temos f'i(xi_1)=[f'(xi) da iteracao anterior]
      dfxi_1 = dfxi;
    }
        
    ## Se for a primeira funcao i = 2 calcula f'2(x1)
    if (i == 2){
      dfixi_1 = (3*(y[i]-y[i-1])/(2*(x[i]-x[i-1])))-dfxi/2;
    }
    
    ## Se for a ultima funcao i = n calcula f'i(xi)=f'n(xn)
    if (i == n){
      dfixi = (3*(y[i]-y[i-1])/(2*(x[i]-x[i-1])))-dfxi_1/2;
    }
    
    ## Se o próximo x[i]>=xstar então calcula o polinomio
    if (x[i]>=xstar){

      ## Calcula das derivadas de segunda ordem
      ddfixi_1 = - 2*(dfixi+2*dfixi_1)/(x[i]-x[i-1])+6*(y[i]-y[i-1])/((x[i]-x[i-1])^2)
      
      ddfixi = 2*(2*dfixi+dfixi_1)/(x[i]-x[i-1])-6*(y[i]-y[i-1])/((x[i]-x[i-1])^2)
      
      ## Calcula os coeficientes
      
      di = (ddfixi - ddfixi_1)/(6*(x[i] - x[i-1]));
      
      ci = (x[i]*ddfixi_1 - x[i-1]*ddfixi)/(2*(x[i] - x[i-1]));
      
      bi = ((y[i] - y[i-1]) - ci*(x[i]^2-x[i-1]^2) - di*(x[i]^3-x[i-1]^3))/(x[i] - x[i-1]);
      
      ai = y[i-1] - bi*x[i-1] - ci*x[i-1]^2 - di*x[i-1]^3;
      
    }
      
    ## Atualiza para a proxima interacao
    dfixi_1 = dfixi;
    
    ## Incrementa o contador
    i = i + 1;      
    
  }
  
  ## Calcula o ultimo polinomio
  ystar = ai + bi*xstar + ci*xstar^2 + di*xstar^3;
  
  ## Retorna o polinomio calculado
  return(ystar);
  
}
