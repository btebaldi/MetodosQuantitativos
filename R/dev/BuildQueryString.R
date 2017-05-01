BuildQueryString = function(site, key, value)
{
  site = paste(site, "?", sep = "")
  
  for (nContador in 1:length(key))
  {
    site = paste(site,
                 paste(key[nContador], URLencode(value[nContador], reserved = T), sep = "="),
                 sep = "&")
    
  }
  
  return(site)
}
