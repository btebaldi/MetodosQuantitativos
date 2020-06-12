
#' retorna os coeficientes das curvas de cubic spline de um conjuntos de pares (x,y)
#'
#' @param x vetor de parametros do eixo x
#' @param y vetor de parametros do eixo y
#'
#' @return data.frame with intervals and coeficients
#' @export
#'
#' @examples CCSpline.Coef(x=1:20, y=rnorm(20))
CCSpline.Coef = function (x, y){
  if(length(x) != length(y))  {
    stop("vector x and y must have the same length!")
  }
  
  if(!(is.vector(x) & is.vector(y)))  {
    stop("x and y must be vectors!")
  }
  
  # lenght of the points
  n=length(x)
  
  # data.fame with interval results
  dt = data.frame(i = 1:(n-1),
                  xi_1 = x[1:(n-1)],
                  xi = x[2:n],
                  yi_1 = y[1:(n-1)],
                  yi = y[2:n],
                  Slope = 0,
                  dfi_xi_1 = 0,
                  dfi_xi = 0,
                  ddfi_xi_1 = 0,
                  ddfi_xi = 0,
                  a=0,b=0,c=0,d=0
  )
  
  # Calcula a inclinacao de cada intervalo
  dt$Slope = (dt$yi-dt$yi_1)/(dt$xi-dt$xi_1);
  
  for(i in 2:nrow(dt)){
    
    # Verifica se houve mudanca de sinal da inclinacao e se ? diferente de zero
    if (dt$Slope[i] * dt$Slope[i-1] > 0) {
      dfi_xi_1 = 2/((dt$xi[i] - dt$xi_1[i])/(dt$yi[i] - dt$yi_1[i]) +
                      (dt$xi[i-1] - dt$xi_1[i-1])/(dt$yi[i-1] - dt$yi_1[i-1]));
    } else {
      # Se muda o sinal a derivada ? zero
      dfi_xi_1 = 0;
    }
    
    # Atualiza o valor da tabela
    dt$dfi_xi_1[i] = dfi_xi_1;
    
    # Se for a primeira funcao i = 2 calcula f'2(x1)
    if (i == 2){
      df1_x0 = (3*(dt$yi[i-1] - dt$yi_1[i-1])/(2*(dt$xi[i-1] - dt$xi_1[i-1]))) - dfi_xi_1/2;
      dt$dfi_xi_1[i-1] = df1_x0
    }
    
    # Condicao de f_{i}(x_i) = f_{i-1}(x_i)
    dt$dfi_xi[i-1] = dt$dfi_xi_1[i]
    
    ## Se for a ultima funcao i = n calcula f'i(xi)=f'n(xn)
    if (i == nrow(dt)){
      dfn_xn = (3*(dt$yi[i] - dt$yi_1[i])/(2*(dt$xi[i] - dt$xi_1[i])))-dfi_xi_1/2;
      dt$dfi_xi[i] = dfn_xn
    }
  }
  
  # Calculo da segunda derivada.
  dt$ddfi_xi_1 = - 2*(dt$dfi_xi+2*dt$dfi_xi_1)/(dt$xi - dt$xi_1) +
    6*(dt$yi - dt$yi_1)/((dt$xi - dt$xi_1)^2)
  
  dt$ddfi_xi = 2*(2* dt$dfi_xi + dt$dfi_xi_1)/(dt$xi -dt$xi_1) +
    -6*(dt$yi -dt$yi_1)/((dt$xi - dt$xi_1)^2)
  
  # Calculo dos coeficientes a, b, c, d
  
  dt$d = (dt$ddfi_xi - dt$ddfi_xi_1)/(6*(dt$xi - dt$xi_1));
  
  dt$c = (dt$xi * dt$ddfi_xi_1 - dt$xi_1 * dt$ddfi_xi)/(2*(dt$xi - dt$xi_1));
  
  dt$b = ((dt$yi - dt$yi_1) - dt$c *(dt$xi^2 - dt$xi_1^2) +
            - dt$d *(dt$xi^3 - dt$xi_1^3))/(dt$xi - dt$xi_1);
  
  dt$a = dt$yi_1 - dt$b *dt$xi_1 - dt$c * dt$xi_1^2 - dt$d * dt$xi_1^3;
  
  return(dt)
}



#' Calcula o valor de interpolacao baseado em um cubic spline
#'
#' @param x Valores de X
#' @param y Valores de Y
#' @param x_star Valor de X para ser interpolado
#'
#' @return retorna o valor de Y correspondente a Y Star
#' @export
#'
#' @examples
CCSpline = function (x, y, x_star){
  spline.coef = CCSpline.Coef(x, y)
  
  if(any(x_star > max(x) | x_star < min(x))){
    stop("x_star must be in the range of the x vector")
  }
  
  dt = data.frame(x_star=x_star, i=0, y_star=0)
  
  for (i in 1:nrow(dt)) {
    dt[i, "i"] = min(spline.coef[(spline.coef$xi_1 <= dt$x_star[i]) & (spline.coef$xi >= dt$x_star[i]), "i"])
  }
  
  dt$y_star =   spline.coef$a[dt$i] +
    spline.coef$b[dt$i] * dt$x_star +
    spline.coef$c[dt$i] * dt$x_star^2 +
    spline.coef$d[dt$i] * dt$x_star^3
  
  return(dt[c("x_star", "y_star")])
}
