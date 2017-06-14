is.installed = function(myPackages)
{
  is.element(myPackages, installed.packages()[, 1])
}

LoadPackages = function(myPackages)
{
  needInstall = !is.installed(myPackages)
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
