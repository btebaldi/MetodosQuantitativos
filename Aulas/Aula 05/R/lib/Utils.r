## Arquivo de funcoes uteil

is.installed = function(package) {
  return = is.element(package, installed.packages()[, 1])
}

ClearAll = function(ClearConsole=TRUE)
{
  if (ClearConsole){cat("\014")}
    rm(list = ls())  
}