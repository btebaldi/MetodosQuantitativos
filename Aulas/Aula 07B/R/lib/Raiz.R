df = function (f,
               x,
               h = 1e-6,
               dx = "x",
               providedFunctionParams) {
  # busco os parametros da funcao
  functionParams = as.list(formals(f))
  
  ## Iteracao da funcao f(x+h,...)
  
  # Construo a lista de parametros a serem passadas para a funcao
  for (item in names(functionParams))
  {
    if (item == dx)
    {
      #  se o parametro eh o ponto de derivacao defino o valor para ele
      functionParams[[item]] = x + abs(h)
    }
    else
    {
      #  se o parametro nao eh o ponto de derivacao passo o valor da lista
      functionParams[[item]] = providedFunctionParams[[item]]
    }
  }
  
  # executo a chamada da funcao
  fplus = do.call(f, functionParams)
  
  
  ## Iteracao da funcao f(x-h,...)
  
  # busco os parametros da funcao
  functionParams = formals(f)
  
  # Construo a lista de parametros a serem passadas para a funcao
  for (item in names(functionParams))
  {
    if (item == dx)
    {
      #  se o parametro eh o ponto de derivacao defino o valor para ele
      functionParams[[item]] = x - abs(h)
    }
    else
    {
      #  se o parametro nao eh o ponto de derivacao passo o valor da lista
      functionParams[[item]] = providedFunctionParams[[item]]
    }
  }
  
  # executo a chamada da funcao
  fminus =  do.call(f, as.list(functionParams))
  
  # Caculo a derivada pelo TVM
  return((fplus - fminus) / (2 * h))
}


root_f = function(f,
                  x0,
                  eps = 1e-6,
                  nmax = 1000,
                  dx = "x",
                  providedFunctionParams)
{
  # busco os parametros da funcao
  functionParams = formals(f)
  
  # Construo a lista de parametros a serem passadas para a funcao
  for (item in names(functionParams))
  {
    if (item == dx)
    {
      #  se o parametro eh o ponto de derivacao defino o valor para ele
      functionParams[[item]] = x0
    }
    else
    {
      #  se o parametro nao eh o ponto de derivacao passo o valor da lista
      functionParams[[item]] = providedFunctionParams[[item]]
    }
  }
  
  # executo a chamada da funcao
  y =  do.call(f, as.list(functionParams))
  
  # inicializo o contador
  nContador = 0
  while ((nContador <= nmax) & (abs(y) >  eps))
  {
    # calculo a derivada no ponto
    Ndf = df(
      f = f,
      x =  x0,
      h = eps,
      dx = dx,
      functionParams
    )

    if (abs(Ndf) < eps)
    {
      # Aviso o usuario que foi encontrado um possivel ponto critico
      warning("Possible critical point found. Incrementing by 2 epsilon")
      
      # Incremento o x por 2 epsilon
      x_i = x0 + 2 * eps
    }
    else
    {
      # Calculo o novo x
      x_i = x0 - (y / Ndf)
    }

    # atualizo o x da interacao
    x0 = x_i
    functionParams[[dx]] = x_i
    
    # executo a chamada da funcao
    y =  do.call(f, as.list(functionParams))
    
    # incremento a interacao do contador
    nContador = nContador + 1
  }
  
  return(x0)
}