MCAssetPaths = function(S, t, Tvol=NA, r, rf, sigma, nsim=10e4, dt=10e-2){
  
  if(is.na(Tvol)) Tvol = t;
  
  ## Ajusta a vol
  sigma = sigma*sqrt(Tvol/t);
  
  ## N�mero de passos
  steps = round(t/dt);
  
  ## Matriz de simula��es
  St = array(NA,c(nsim,(steps+1)))
  
  ## Inicializa com o valor spot
  St[,1] = S;
  
  ## Simula��es
  for (i in 1:nsim) {
    ## Sequencia de n�meros aleat�rios
    random = rnorm(steps);
    for (j in 2:(steps+1)) {
      St[i,j] = St[i,j-1]*exp(((r-rf)-(sigma^2)/2)*dt + sigma*random[j-1]*sqrt(dt));    
    }
  }
  return(St);  
}


MCOptionPrice = function(type=c("call","put"), S, X, t, Tvol=NA, r, rf, sigma, nsim=10e4, dt=10e-2){
  
  if(is.na(Tvol)) Tvol = t;
  
  St = MCAssetPaths(S, t, Tvol, r, rf, sigma, nsim, dt);
  
  ## N�mero de passos
  steps = round(t/dt);
  
  ## Calcula o Payoff
  if (type=="call") {
    payoff = St[,(steps+1)] - X;
  } else {
    payoff = X - St[,(steps+1)];
  }
  
  ## Calcula o resultado
  payoff[payoff<0] = 0;
  payoff = exp(-r*(t))*payoff;
  price = mean(payoff);
  
  return(price);
  
}