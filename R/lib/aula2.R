x=rnorm(1000)
hist(x)
# r data type
# numeric
# string = cadeias de caracteres pode usar aspas duplas ou simples.
# boolean
# date as.Date(<string>)
s = "2014-02-03"
today = as.Date(s)
today + 1
# NA = Not Available
is.na(today)
is.na(s)

x=c(1,2,3,4,5, NA)
mean(x)
mean(x, na.rm = T)

is.na(x)
# NULL

7 & 2
bitwAnd(8,2)


x= Sys.Date() + 1:30
x[44]

x[c(3,4,8,9)]

sort(x)

length(x)

y= -5:20

y[c(3,5,10)] = NA

y[is.na(y)==F]

# seq(from=2, to=40, by=2)
seq(2,40,2)

seq(from=Sys.Date(), to=Sys.Date()+365, by="weekday")
help("seq.Date")

x=array(1:3,6)
x

x=array(1:20,c(5,4))
x

x[,4]
x[1,4]

x=array(NA,c(5,4))
x

x=array(1:20,c(5,4))
x

colnames(x)=c("a","b","c","d")
x
row.names(x)=c("row1","row2","row3","row4", "row5")
x

x[1,4]
x["row2","b"]

y=c(1:2)
y
x=array(1:4,c(2,2))
x
dim(x)
dim(x)[2]


preco = data.frame(dates=(Sys.Date()+1:5), PETR4=14+rnorm(5), VALE5=26+rnorm(5))
preco

preco[["PETR4"]]
preco$dates[5:10]


raiz(x, radix=2);


somaum(9)
