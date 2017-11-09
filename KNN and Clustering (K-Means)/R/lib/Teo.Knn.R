GetNearestPoint = function(data, centers) {
  points = matrix(data=NA, nrow = nrow(centers), ncol = 1);
  
  distMatrix = matrix(data=NA, nrow = nrow(data), ncol = nrow(centers));
  for(r in 1:nrow(centers))
  {
    for (i in 1:nrow(data))
    {
      distMatrix[i,r]=sum((centers[r,] - data[i, ])^2)^0.5
    }
    
    if(all(is.na(points)))
    {
      points[r] = which(distMatrix[,r]==min(distMatrix[,r], na.rm = T), arr.ind = T);
    }
    else
    {
      points[r] = which(distMatrix[,r]==min(distMatrix[-points[!is.na(points)],r], na.rm = T), arr.ind = T);
    }
  }
  
  return(points)
}

GetDistanceMatrix = function(data) {
  # Calcula matrix de distancias
  ## Para cada aluno calcula a distancia
  distMatrix = matrix(data=NA, nrow = nrow(data), ncol = nrow(data));
  colnames(distMatrix) = 1:nrow(data)
  rownames(distMatrix) = colnames(distMatrix)
  
  for (i in 1:(nrow(data)-1))
  {
    # print(sprintf("i=%d", i))
    for (j in (i+1):nrow(data))
    {
      distMatrix[i,j]=sum((data.subset[i,] - data.subset[j, ])^2)^0.5
    }
  }
  return(distMatrix)
}

GetClassification = function(data, k=2, centers=NULL, dynamicCenter=T, refineLimit=10)
{
  # browser()
  # Determina o numero de dimensoes
  v = dim(data)[2]
  
  # variavel que contem a classificacao e a informacao de centros
  resultado = list(
    classif = matrix(data=NA, nrow = nrow(data), ncol = 2),
    centers.primary = array(NA, c(k, v)),
    centers = array(NA, c(k, (v+3)))
  )

  # Nomeia as colunas de resultados
  colnames(resultado$classif) = c("Classifiction", "CenterDistance")
  
  if (is.null(colnames(data)))  {
    colnames(resultado$centers.primary) = paste("dim", 1:v, sep = "_");
    colnames(resultado$centers) = c(paste("dim", 1:v, sep = "_"), "radius", "radius.Avg", "radius.Sd");
  }   else
  {
    colnames(resultado$centers.primary) = colnames(data);
    colnames(resultado$centers) = c(colnames(data), "radius", "radius.Avg", "radius.Sd")
    }
  
  rownames(resultado$centers.primary) = paste(c("Center"), 1:k, sep = " ")
  rownames(resultado$centers) = paste(c("Center"), 1:k, sep = " ")
  
  # Calcula matrix de distancias
  distMatrix = GetDistanceMatrix(data);
  idx = which(distMatrix==max(distMatrix, na.rm = T), arr.ind = T);
  distMatrix=NULL;
  
  if(is.null(centers))
  {
    # Calcula os centros primarios
    resultado$centers.primary[1,] = data[idx[1],];
    d = (data[idx[2],] - resultado$centers.primary[1,])/(k-1);
    for(i in 2:k)
    {
      resultado$centers.primary[i,] = resultado$centers.primary[i-1,] + d
    }
  } else{
    resultado$centers.primary = centers
  }
  
  
  # determina centros
  resultado$centers[,1] = resultado$centers.primary[,1];
  resultado$centers[,2] = resultado$centers.primary[,2];
  
  if (dynamicCenter) {
    centerPointsIdx = GetNearestPoint(data, resultado$centers.primary)
    for (i in 1:k) {
      # atribui o ponto mais proximo como centro
      resultado$centers[i, 1:v] = data[centerPointsIdx[i], ]
      
      # atualiza a classificacao o ponto para o centro designado
      resultado$classif[centerPointsIdx[i], 1] = i
    }
    
  }
  
  refine = 1
  while (refine > 0) {
    classificationChanged = F;
    for (row in 1:nrow(data))
    {
      # vetor de distancias euclidianas
      d = array(0, c(1, k))
      
      # calcula a distancia do ponto atual para os centros atuais
      for (j in 1:k)
      {
        d[j] = (sum((data[row,] - resultado$centers[j, 1:v]) ^ 2)) ^ (1 / 2)
      }
      
      ## Classificacao
      center_0 = which(d == min(d))
      if (is.na(resultado$classif[row, 1]) | (resultado$classif[row, 1] != center_0))
      { 
        resultado$classif[row, 1] = center_0;
        classificationChanged = T;
      }
      
      if (dynamicCenter) {
        ## Atuliza o centro com o novo membro
        # colMeans precisa pelo menos de dois elementos logo verifico se existem 1 ou mais
        if (length(which(resultado$classif[, 1] == center_0)) == 1)
        {
          resultado$centers[center_0, 1:v] = data[which(resultado$classif[, 1] == center_0),]
        } else
        {
          resultado$centers[center_0, 1:v] = colMeans(data[which(resultado$classif[, 1] == center_0),])
        }
      }
      
      # apaga a variavel de center_0
      center_0 = NULL
      
    }

    if (!dynamicCenter) {
      refine = 0;
    }
    else if ((refine == refineLimit) | (!classificationChanged)) {
      refine = -refine;
    } 
    else{
      refine = refine + 1;
    }
  }
  
  # depois de estabelecido a classificacao e a possicao dos centros
  # calcula o raio do centro, raio medio e desvio do raio
  
  for(c in 1:k)  {
    
    # Inicializa o raio maximo inicial
    resultado$centers[c, "radius"] = 0
    resultado$centers[c, "radius.Avg"] = 0
    resultado$centers[c, "radius.Sd"] = 0

    for (i in which(resultado$classif[,1] == c))
    {
      resultado$classif[i,2]  = sum((resultado$centers[c, 1:v] - data[i, ])^2)^0.5;
    }
    
    resultado$centers[c, "radius"] = max(resultado$classif[which(resultado$classif[ , 1] == c), 2]);
    resultado$centers[c, "radius.Avg"] = mean(resultado$classif[which(resultado$classif[ , 1] == c), 2]);
    resultado$centers[c, "radius.Sd"] = sd(resultado$classif[which(resultado$classif[ , 1] == c), 2]);

  }
  
  
  return(resultado)
}





