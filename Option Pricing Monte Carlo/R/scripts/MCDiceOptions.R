rm(list = ls())

## -- Valor médio espero
n = 5;
s = sample(1:6, size=n, replace=TRUE);
x = mean(s)
cat(sprintf("size=%d mean=%.2f\n",n,x));

n = 100;
s = sample(1:6, size=n, replace=TRUE);
x = mean(s)
cat(sprintf("size=%d mean=%.2f\n",n,x));

n = 1000;
s = sample(1:6, size=n, replace=TRUE);
x = mean(s)
cat(sprintf("size=%d mean=%.2f\n",n,x));

nmax = 1000;
x = array(NA,nmax);
for (n in 1:nmax) {
  s = sample(1:6, size=n, replace=TRUE);
  x[n] = mean(s)
}
plot(x,type="l");
abline(h=3.5, col="red");


## -- Probabilidade do valor ser maior que valor

y = 2;

n = 5;
s = sample(1:6, size=n, replace=TRUE);
x = length(s[s>=y])/length(s)
cat(sprintf("size=%d p(x>=%d)=%.2f%%\n", n, y, x*100));

n = 100;
s = sample(1:6, size=n, replace=TRUE);
x = length(s[s>=y])/length(s)
cat(sprintf("size=%d p(x>=%d)=%.2f%%\n", n, y, x*100));

n = 1000;
s = sample(1:6, size=n, replace=TRUE);
x = length(s[s>=y])/length(s)
cat(sprintf("size=%d p(x>=%d)=%.2f%%\n", n, y, x*100));

nmax = 1000;
x = array(NA,nmax);
for (n in 1:nmax){
  s = sample(1:6, size=n, replace=TRUE);
  x[n] = length(s[s>=y])/length(s)
}
plot(x,type="l");
h = length(which(((1:6)>=y)))/6;
abline(h=h, col="red");

## -- Precificação da opção


strike = 2;
n = 10;
s = sample(1:6, size=n, replace=TRUE);
payoff = s - strike;
payoff[which(payoff<0)] = 0
price = 100*sum(payoff)/length(payoff);
print(price);

nmax = 1000;
price = array(NA,nmax);
for (n in 1:nmax){
  s = sample(1:6, size=n, replace=TRUE);
  payoff = s - strike;
  payoff[which(payoff<0)] = 0
  price[n] = 100*sum(payoff)/length(payoff);
}
plot(price,type="l");

payoff = 1:6 - strike;
payoff[which(payoff<0)] = 0
h = 100*(1/6)*sum(payoff);
abline(h=h, col="red");





