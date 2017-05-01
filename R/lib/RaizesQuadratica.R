RaizesQuadratica = function (a, b, c)
{
  #  Verifica o tamanho dos vetores
  if (length(a) < max(length(b), length(c)))
  {
    warning("constantes b e c maiores do que a!")
    
    
    return(FALSE)
    
    
  } else
  {
    while (length(b) < length(a))
    {
      b = c(b, 0)
      
    }
    
    while (length(c) < length(a))
    {
      c = c(c, 0)
      
    }
    
  }
  
  #Calcula o delta de cada equacao
  deltaVector = b * b - 4 * a * c
  
  #inicializa o vetor de resposta
  X = array(NaN, c(length(a), 2))
  
  # Calcula a(s) raiz(es) de cada equacao
  for (nContador in 1:length(a))
  {
    if (deltaVector[nContador] == 0)
    {
      X[nContador, 1] = (-b[nContador]) / (2 * a[nContador])
    }
    else if (deltaVector[nContador] > 0)
    {
      # Raiz 1
      X[nContador, 1] =
        (-b[nContador] - sqrt(deltaVector[nContador])) / (2 * a[nContador]);
      
      # Raiz 2
      X[nContador, 2] =
        (-b[nContador] + sqrt(deltaVector[nContador])) / (2 * a[nContador]);
    }
  }
  
  return(X);
  
}
