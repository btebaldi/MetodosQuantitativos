source("../lib/AnaliseProjetos.r");


## Parâmetros do problema
y0 = 5;
alpha = .125;
beta = 1;
r0 = .10;
nSimula = 100;


## Estrutura para armazenar as TIRs
TIRs = array(NA,c(nSimula));

## looping de simulação do fluxo de caixa
i = 0;
while (i<nSimula){
  
    ## Fluxo de Caixa
    cf = array(0,c(16));
    
    ## Investimentos
    cf[1] = -10; # t = 0
    cf[6] = -10; # t = 5
    cf[11] = -10; # t = 10
    
    ## Simulação do fluxo de caixa
    yt = y0;
    
    ## 2 anos de carência
    for (t in 3:16) {
      ## Simula o fluxo
      yt1 = yt + alpha + beta*rnorm(1);
      
      ## Armazena
      cf[t] = cf[t] + yt1; 
      
      ## Atualiza a iteração
      yt = yt1;
    }
    
    ## Calcula a TIR
    TIRs[i] = TIR(cf,r0);
    
    ## TIR válida, incrementa o contador
    if (is.numeric(TIRs[i])) i = i + 1 ;    
  
}

summary(TIRs);

hist(TIRs);
