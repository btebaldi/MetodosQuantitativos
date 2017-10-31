Teo_Util = list(
  Is.PackageInstalled = function(myPackages)
  {
    return (is.element(myPackages, installed.packages()[, 1]))
  }
  ,
  
  Is.PackageLoaded = function(myPackages)
  {
    return(myPackages %in% .packages())
  }
  ,
  
  LoadPackages = function(myPackages)
  {
    needInstall = !(myPackages %in% .packages())
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
  
  ,
  PathCombine=function(pathVector)
  {
    # subistitui bara invertida por barra (normal)
    pathVector =gsub("\\\\",x=pathVector,replacement = "/", perl = T )
    
    # Retira a primeira e ultima barra
    pathVector =gsub("(^/)|(/$)",x=pathVector,replacement = "", perl = T )
    
    return(paste(pathVector, collapse = "/"))
  }
)
