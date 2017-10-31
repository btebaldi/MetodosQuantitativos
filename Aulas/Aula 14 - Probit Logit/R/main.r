rm(list = ls())

source("./lib/Utils.r")

Teo_Util$LoadPackages(c("aod", "ggplot2"))

myData = read.csv("./database/binary.csv")

summary(myData)

head(myData)

## convert rank to a factor (categorical variable)
myData$Frank = factor(myData$rank)

summary(myData)

# Create a contingency table (optionally a sparse matrix) from cross-classifying factors,
# usually contained in a data frame, using a formula interface.
xtabs( ~ Frank + admit, data = myData)


# Using the Probit Model
# The code below estimates a probit regression model using the glm
# (generalized linear model) function. Since we stored our model output in the object “myprobit”, R
# will not print anything to the console. We can use the summary function to get a
# summary of the model and all the estimates.
myprobit = glm(admit ~ gre + gpa + Frank, family = binomial(link = "probit"), data = myData)

mylogit = glm(admit ~ gre + gpa + Frank, family = binomial(link = "logit"), data = myData)

## model summary
summary(myprobit)
summary(mylogit)

# We can use the confint function to obtain confidence intervals for the coefficient
# estimates. Note that for logistic models, confidence intervals are based on the
# profiled log-likelihood function. We can also get CIs based on just the standard errors
# by using the default method.
confint(myprobit)
confint(mylogit)

confint.default(myprobit)
confint.default(mylogit)




# The chi-squared test statistic of 21.4 with three degrees of freedom is associated with
# a p-value of less than 0.001 indicating that the overall effect of rank is statistically
# significant.
aod::wald.test(b = coef(myprobit), Sigma = vcov(myprobit), Terms = 4:6)


# We can also test additional hypotheses about the differences in the coefficients for
# different levels of rank. Below we test that the coefficient for rank=2 is equal to the
# coefficient for rank=3.
R = cbind(0, 0, 0, 1, -1, 0)
wald.test(b = coef(myprobit), Sigma = vcov(myprobit), L = R)


exp(coef(mylogit))


# You can also use predicted probabilities to help you understand the model. To do
# this, we first create a data frame containing the values we want for the independent
# variables.
newdata = data.frame(gre = rep(seq(from = 200, to = 800, length.out = 100),4 * 4), gpa = rep(c(2.5, 3, 3.5, 4), each = 100 * 4), Frank = factor(rep(rep(1:4, each = 100), 4)))

summary(newdata)

head(newdata)


# Now we can predict the probabilities for our input data as well as their standard
# errors. These are stored as new variable in the data frame with the original data, so
# we can plot the predicted probabilities for different gre scores. We create four plots,
# one for each level of gpa we used (2.5, 3, 3.5, 4) with the colour of the lines
# indicating the rank the predicted probabilities were for.
newdata[, c("p", "se")] = predict(myprobit, newdata, type = "response", se.fit = TRUE)[-3]

newdata[, c("LL")] = newdata[,"p"] -1.96* newdata[,"se"]
newdata[, c("UL")] = newdata[,"p"] +1.96* newdata[,"se"]

ggplot(newdata, aes(x = gre, y = p, colour = Frank)) + geom_line() + facet_wrap(~gpa)

ggplot(newdata, aes(x = gre, y = p)) + geom_ribbon(aes(ymin = LL, ymax = UL, fill = Frank), alpha = 0.2) + geom_line(aes(colour = Frank), size = 1) + facet_wrap(~gpa)

summary(myprobit)

## change in deviance
with(myprobit, null.deviance - deviance)

## change in degrees of freedom
with(myprobit, df.null - df.residual)

## chi square test p-value
with(myprobit, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))

logLik(myprobit)
## 'log Lik.' -229.2 (df=6)
