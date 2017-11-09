# limpa variaveis antigas
rm(list = ls())

# Carrega biblioteca utilizadas
library(gmodels);
library(class)

## Carrega a base de dados
data =  read.csv("./database/german.data.csv")
colnames(data)

## Convert the dependent var to factor.
colLabelsId = which(colnames(data)=="Creditability");
data.classes = ifelse(data[[colLabelsId]]==2,"bad","good");
data.classes = factor(data.classes)

# Normalize the numeric variables  
num.vars = sapply(data, is.numeric)
data[num.vars] = lapply(data[num.vars], scale)

myvars = c("DurationOfCreditMonth", "CreditAmount", "InstalmentPerCent")
data.subset = data[myvars]

summary(data.subset)

set.seed(123) 

test = 1:100
train.data = data.subset[-test,]
test.data = data.subset[test,]

train.data.classes = data.classes[-test]
test.data.classes = data.classes[test]

knn.1 =  knn(train.data, test.data, train.data.classes, k=1)
knn.5 =  knn(train.data, test.data, train.data.classes, k=5)
knn.20 = knn(train.data, test.data, train.data.classes, k=20)

## Let's calculate the proportion of correct classification for k = 1, 5 & 20 

100 * sum(test.data.classes == knn.1)/100  # For knn = 1
## [1] 68
100 * sum(test.data.classes == knn.5)/100  # For knn = 5
## [1] 74
100 * sum(test.data.classes == knn.20)/100 # For knn = 20
## [1] 81
## If we look at the above proportions, it's quite evident that K = 1 correctly classifies 68% of the outcomes, K = 5 correctly classifies 74% and K = 20 does it for 81% of the outcomes. 

## We should also look at the success rate against the value of increasing K.

table(knn.1, test.data.classes)
##      test.def
## knn.1  0  1
##     0 54 11
##     1 21 14
## For K = 1, among 65 customers, 54 or 83%, is success rate. Let's look at k = 5 now

table(knn.5, test.data.classes)
table(knn.20, test.data.classes)

# plot(train.data[,c("CreditAmount","DurationOfCreditMonth")],
#      col=c(4,3,6,2),
#      pch=c(1,2)[as.numeric(test.data.classes)],
#      main="Predicted Default, by 1 Nearest Neighbors",cex.main=.95)
# 
# points(test.gc[,c("amount","duration")],
#        bg=c(4,3,6,2)[gc.bkup[-test,"installment"]],
#        pch=c(21,24)[as.numeric(knn.1)],cex=1.2,col=grey(.7))
# 
# legend("bottomright",pch=c(1,16,2,17),bg=c(1,1,1,1),
#        legend=c("data 0","pred 0","data 1","pred 1"),
#        title="default",bty="n",cex=.8)
# 
# legend("topleft",fill=c(4,3,6,2),legend=c(1,2,3,4),
#        title="installment %", horiz=TRUE,bty="n",col=grey(.7),cex=.8)