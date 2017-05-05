SplineInterp = function(days,curveDays,curveValues) {
		curveFunction = splinefun(curveDays,curveValues);
		return(curveFunction(days));
}
