
BiSplineVolGrid = function(S, X, period, deltas, periods, vols, base, type=c("call","put"),nmax=100) {
  
  ## --- Interpolação no tempo

  ## Estrutura para armazenar o smile
  smileVols = array(NA,nrow(vols));
  for (row in 1:nrow(vols)) {
    smileVols[row] = spline(periods,vols[row,],xout=period)$y;
  }

  ## --- Interpolação do smile
      
  ## Inicializa o contador de iterações
  n = 0;
  
  ## Precisão
  epson = 10^(-6);
  
  ## Periodo como fração da base
  t = period/base;
  
  ## Inicializa vol_last
  vol_last = 1;
  
  ## Looping:
  ## 1. vol_last = vol_next
  ## 2. Calcula o delta = BSDelta(vol_last)
  ## 3. Calcula a vol_next = Grid(delta)
  ## Comparar: vol_next e vol_last

  ## Ajusta o smile para iniciar a interpolação:
  ## -1 < DeltaPut < 0 e 0 < DeltaCall < 1
  
  ## Chute inicial: delta = S/X
  if (type=="put") {
    delta = -S/X;
    smileSpline = splinefun(-abs(deltas),smileVols);
  } else {
    delta = S/X;
    smileSpline = splinefun(deltas,smileVols);
  }  
    
  ## Calcula a volatilida no grid: Calcula a vol_next = grid(delta)
  vol_next = smileSpline(delta);
  
  while (abs(vol_last-vol_next)>epson && n<nmax){
    
    ## Inicia o novo ciclo
    vol_last = vol_next;
    
    ## Calcula o delta = BSDelta(vol_last)
    d1 = (log(S/X) + (vol_last ^ 2 / 2) * t) / (vol_last * sqrt(t))    
    if (type=="put") {
      delta = -pnorm(-d1);
    } else {
      delta = pnorm(d1);
    }
    
    ## Calcula a vol_next = Grid(delta)
    vol_next = smileSpline(delta);
    
    ## Incrementa o contador
    n = n + 1;
  }  
 
  ## Verifica a convergência
  if (abs(vol_last-vol_next)>epson) vol_next = NaN;
  
  return(vol_next);
  
}