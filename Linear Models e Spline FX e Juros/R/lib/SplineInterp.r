SplineInterp = function(x,y,xout){
  
  out = spline(x,y,xout=xout);
  
  return(out$y);
  
}


SplineInterpFun = function(x,y,xout){
  
  mySpline = splinefun(x,y);
  
  return(100*mySpline(xout));
  
}