is.installed = function(packages)
{
  is.element(packages, installed.packages()[, 1])
}

LoadPackages = function(packages)
{
  needInstall = !is.installed(packages)
  
  if (any(needInstall))
  {
    print(sprintf("Installing packages: %s",
                  paste(packages[needInstall], collapse = ", ")))
    install.packages(packages[needInstall])
  }
  
  library(packages)
}
