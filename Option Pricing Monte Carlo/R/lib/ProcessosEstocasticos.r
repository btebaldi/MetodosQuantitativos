## Wiener Process

WienerProcess = function(z0, t, dt) {
  
  n = trunc(t/dt);

  z = c(z0,array(NA,n));
  
  for (i in 2:length(z)){
    z[i] = z[i-1]+rnorm(1)*sqrt(dt);
  }
  
  return(z)
  
}

GeneralWienerProcess = function(z0, a, b, t, dt) {
  
  n = trunc(t/dt);
  
  z = c(z0,array(NA,n));
  
  for (i in 2:length(z)){
    z[i] = z[i-1]+ a*dt + b*rnorm(1)*sqrt(dt);
  }
  
  return(z)
  
}

StockPriceSimulation = function(S0, r, sigma, t, dt, nsim=10e4){
  
  ## N�mero de passos
  steps = round(t/dt);
  
  ## Matriz de simula��es
  St = array(NA,c(nsim,(steps+1)))
  
  ## Inicializa com o valor spot
  St[,1] = S0;
  
  ## Simula��es
  for (i in 1:nsim) {
    ## Sequencia de n�meros aleat�rios
    random = rnorm(steps);
    for (j in 1:steps) {
      St[i,j+1] = St[i,j] + r*St[i,j]*dt + sigma*random[j]*sqrt(dt);    
    }
  }
  
  return(St);  
}


PlotProcess = function(z){
  
  ## -- Sa�da Padr�o
  def.par <- par(no.readonly = TRUE) ## Grava a configura��o default
  
  layout(matrix(c(1,2,1,3),2,2));
  
  plot(z,type="l");
  
  dz = diff(z);  
  plot(dz,type="l");
  hist(dz);
  
  par(def.par); ## Configura��o default
  
}