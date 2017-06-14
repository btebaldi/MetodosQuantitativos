My.Util.Is.PackageInstalled = function(myPackages)
{
  return (is.element(myPackages, installed.packages()[, 1]))
}

My.Util.Is.PackageLoaded = function(myPackages)
{
  return(myPackages %in% .packages())
}


My.Util.LoadPackages = function(myPackages)
{
  needInstall = !My.Util.Is.PackageInstalled(myPackages)
  # print(needInstall)
  
  if (any(needInstall))
  {
    print(sprintf(
      "Installing packages: %s",
      paste(myPackages[needInstall], collapse = ", ")
    ))
    install.packages(myPackages[needInstall])
  }
  
  for (lib in myPackages)
  {
    if (lib %in% loadedNamespaces())
    {
      print(sprintf("Package %s already loaded.", lib))
    }
    else
    {
      print(sprintf("Loading package: %s", lib))
      library(lib, character.only = T)
    }
  }
}


My.Util.PathCombine=function(pathVector)
{
   # subistitui bara invertida por barra (normal)
    pathVector =gsub("\\\\",x=pathVector,replacement = "/", perl = T )
    
    # Retira a primeira e ultima barra
    pathVector =gsub("(^/)|(/$)",x=pathVector,replacement = "", perl = T )
  
    return(paste(pathVector, collapse = "/"))
}


My.Util.ValidadeWorkStructure=function(stopOnWarning=F )
{
  currentWorkDirectory = getwd()
  
  hasWarning = F
  
  if(!grepl(pattern = "R/scripts$", x = currentWorkDirectory))
  {
    stop("Script sendo executado em diretorio invalido. o Mesmo deve ser exeutado na pasta 'R/scripts'")
  }
  
  if(!dir.exists("../database"))
  {
    warning("Diretorio batabase nao existe.")
    hasWarning = T
  }
  
  if(!dir.exists("../lib"))
  {
    warning("Diretorio lib nao existe.")
    hasWarning = T
  }
  
  if(!dir.exists("../dev"))
  {
    warning("Diretorio dev nao existe.")
    hasWarning = T
  }
  
  if(stopOnWarning & hasWarning)
  {
    stop("Stoping on warnings.")
  }
  
}
  

