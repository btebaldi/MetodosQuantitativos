# linearMovingPredict = function (data,
#                                 yname,
#                                 lbp,
#                                 interval = "confidence",
#                                 level = 95)
# {
imput = wdata[-nrow(wdata), ]
imput[[yname]] = data[2:nrow(wdata), yname]


yname = "raBRL"


#montar a formula
f = as.formula(sprintf("%s ~ ."), yname)


result = data.frame()


result[1:nrow(imput), yname] = imput[[yname]]

# daa.fram (na, nome col?)

# criar bounds
result[c("fit", "lwr", "upr")]

for (name in  colnames(imput)) {
  if (name != yname)
    result[[name]] = 0
  
}


modelo = lm(f, data = imput[(53 - 52):(53 - 1), ])
fit = step(modelo, trace = 0)

fit.pred = predict(fit,
                   newdata = imput[53, ],
                   interval = interval,
                   level = level)



}