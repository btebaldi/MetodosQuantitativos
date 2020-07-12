### FGV/EESP - Mestrado Profissional em Economia
### Disciplina: Metodos Quant Computacionais Aplicados a Economia e Financas
### Professor: Ernesto Coutinho Colla

### --- CLEAR ALL ----
rm(list = ls())

### --- Packages R ----
library(readxl); # Pacote de leitura da planilha Excel de Input
library(lpSolve); # Pacote de otimizacao Simplex

# INPUT: Necessario buscar o input proveninente de uma planilha Excel 
# localizada no diretorio abaixo
# Definicao do diretorio de busca da planilha no arquivo "...R/database/ExOtimizacaoCashFlow.xls"

# Uso do package "readxl" para busca dos dados da planilha necessario para o
# calculo de otimizacao.
# Carrega as colunas de Data, DC, DU e TaxaPre da planilha "ExOtim..." 
# em um banco de dados chamado "dados"

# ---- DATA LOAD ----

# Carrega dados da curva de juros prefixada
dados <- read_excel("./database/ExOtimizacaoCashFlow.xlsx", range = "A3:D110", col_names = T) 


# Carrega os periodos de pagamento dos CDB's
periodos <- read_excel("./database/ExOtimizacaoCashFlow.xlsx", range = "F3:G10", col_names = T)


# Carrega as colunas de Aplicacoes em CDB's disponiveis
taxa_cdi <- read_excel("./database/ExOtimizacaoCashFlow.xlsx", range = "F14:G18", col_names = T)


# --- DRIVERS
# Necessario montar data.frame para calculos das rentabilidades dos 4 CDB's e a 
# otimizacao por LpSolve
# Entrada de dados e composicao do DataFrame "tabela" necessario para o calculo da 
# rentabilidade dos CDB's  

# ---- tbl.info ----
# - Montar DataFrame (DF) "tabela" necessario para o calculo da rentabilidade dos CDB's  
tbl.info <- data.frame(Id=c(rep("CDB 01", 6), rep("CDB 02", 3),rep("CDB 03", 2),rep("CDB 04", 1)), 	
                      Dt_Inicial=as.Date(NA),
                      Dt_Final=as.Date(NA),
                      Tx_CDI=as.numeric(NA),
                      Retorno=as.numeric(NA), 
                      FRA=as.numeric(NA),
                      Tx_PtaLonga=as.numeric(NA),
                      Tx_PtaCurta=as.numeric(NA),
                      Tx_PtaLongaEfetiva=as.numeric(NA),
                      Tx_PtaCurtaEfetiva=as.numeric(NA),
                      DU_Longo=as.numeric(NA),
                      DU_Curto=as.numeric(NA),
                      DELTA_DU=as.numeric(NA),
                      Montante=as.numeric(NA))


# - Data Inicial e Final para CDB1
tbl.info$Dt_Inicial[1:6] <- periodos$Data[1:6]
tbl.info$Dt_Final[1:6] <- periodos$Data[2:7]


# - Data Inicial e Final para CDB2
tbl.info$Dt_Inicial [7:9] <- periodos$Data[c(1,3,5)]
tbl.info$Dt_Final[7:9] <- periodos$Data[c(3,5,7)]


# - Data Inicial e Final para CDB3
tbl.info$Dt_Inicial[10:11] <- periodos$Data[c(1,4)]
tbl.info$Dt_Final[10:11] <- periodos$Data[c(4,7)]


# - Data Inicial e Final para CDB4
tbl.info$Dt_Inicial[12] <- periodos$Data[1]
tbl.info$Dt_Final[12] <- periodos$Data[7]


# - Percentual do CDI para respectivos CDB1 (105%), CDB2(107,50%), CDB3(110%) e CDB4(112,50%)
tbl.info$Tx_CDI[1:6] <- taxa_cdi$`Taxa %CDI`[1]
tbl.info$Tx_CDI[7:9] <- taxa_cdi$`Taxa %CDI`[2]
tbl.info$Tx_CDI[10:11] <- taxa_cdi$`Taxa %CDI`[3]
tbl.info$Tx_CDI[12] <- taxa_cdi$`Taxa %CDI`[4]


# - Looping para input dos dados de entrada no DF "tabela" 
for (i in 1:nrow(tbl.info)) {
  # preenche dados da ponta longa
  tbl.info$DU_Longo[i] <- dados$DU[as.Date(dados$Data)==tbl.info$Dt_Final[i]]
  tbl.info$Tx_PtaLonga[i] <- dados$CurvaPre[as.Date(dados$Data)==tbl.info$Dt_Final[i]]  
  
  # preenche dados da ponta curta
  tbl.info$DU_Curto[i] <- dados$DU[as.Date(dados$Data)==tbl.info$Dt_Inicial[i]]
  tbl.info$Tx_PtaCurta[i] <- dados$CurvaPre[as.Date(dados$Data)==tbl.info$Dt_Inicial[i]]  
}

# - Calculo dos total de dos dias uteis para cada resgate dos respectivos CDB's
tbl.info$DELTA_DU <- tbl.info$DU_Longo-tbl.info$DU_Curto

# - Calculo da Taxa Prefixada a partir de um percentual do CDI
# - 2. Formulario => TxPre_PercCDI = {{[(1+TaxaPre_mkt)^1/252-1]*PercCDI+1}^252}-1
tbl.info$Tx_PtaLongaEfetiva <- ((((tbl.info$Tx_PtaLonga+1)^(1/252)-1)*tbl.info$Tx_CDI)+1)^252 -1
tbl.info$Tx_PtaCurtaEfetiva <- ((((tbl.info$Tx_PtaCurta+1)^(1/252)-1)*tbl.info$Tx_CDI)+1)^252 -1


# - Calculo da taxa Prefixa do FRA
# - 2. Formulario => iFRA = {[(1+i_longo)^DU_Longo/252 / (1+i_curto)^DU_Curto/252]^252/DU_FRA}
tbl.info$FRA <- (((tbl.info$Tx_PtaLongaEfetiva+1)^(tbl.info$DU_Longo/252))/((tbl.info$Tx_PtaCurtaEfetiva+1)^(tbl.info$DU_Curto/252)))^(252/tbl.info$DELTA_DU)

# - Equalizacao do 1 fluxo de cada CDB para que considere a taxa pre bullet Longa
# (nao ha FRA no 1° fluxo de cada CDB) quando DU_Curto for igual a 1
tbl.info$FRA[tbl.info$DU_Curto==1] <- tbl.info$Tx_PtaLongaEfetiva[tbl.info$DU_Curto==1]+1


# - Calculo final da Rentabilidade ("RetornoPeriodo" na pag.5 do exercicio) por fluxo de cada CDB
tbl.info$Retorno <- tbl.info$FRA^(tbl.info$DELTA_DU/252)-1

# ---- OTIMIZACAO ----

# X = [M_1_0, M_1_1, M_1_2, M_1_3, M_1_4, M_1_5, M_2_0, M_2_2, M_2_4, M_3_0, M_3_3, M_4_0]
# max{M_1_0 + M_2_0 + M_3_0 + M_4_0}
f.obj = c(1,0,0,0,0,0,1,0,0,1,0,1)


# Construcao da matriz "restricoes" necessaria na funcao lpSolve
# const.mat para t = 1:6 em 12 possibilidades de aplicacoes em CDB´s
restricoes = matrix(data=NA, nrow=6, ncol=12)

# Nome das colunas para auxiliar a visualiazacao das restricoes 
# considerando Montante (M) no instante t (t de 1 a 6)
colnames(restricoes)=c(paste("M1", 0:5, sep="-"),
                       paste("M2", c(0,2,4),sep="-"),
                       paste("M3", c(0,3),sep="-"),
                       paste("M4", 0,sep="-"))

# Construcao para cada instante t da restricoes conforme pag.3 do exercicio, considerando Aportes+Resgates-Aplicacoes = Pagamentos

# Instante t = 1:
restricoes[1,]=c(1+tbl.info$Retorno[1],-1,rep(0,10))
# Instante t = 2:
restricoes[2,]=c(0, 1+tbl.info$Retorno[2],-1,rep(0,3),1+tbl.info$Retorno[7],-1,0,0,0,0 )
# Instante t = 3:
restricoes[3,]=c(0,0, 1+tbl.info$Retorno[3],-1,rep(0,2),0,0,0,1+tbl.info$Retorno[10],-1,0 )
# Instante t = 4:
restricoes[4,]=c(0,0, 0,1+tbl.info$Retorno[4],-1,rep(0,1),0,1+tbl.info$Retorno[8],-1,0,0,0 )
# Instante t = 5:
restricoes[5,]=c(0, 0,0, 0,1+tbl.info$Retorno[5],-1,0,0,0,0,0,0 )
# Instante t = 6:
restricoes[6,]=c(0,0, 0,0, 0,1+tbl.info$Retorno[6],0,0,1+tbl.info$Retorno[9],0,1+tbl.info$Retorno[11],1+tbl.info$Retorno[12] )


# - 4° Parametro da funcao lpSolve => const.dir : Condicao ("direcao") da restricao => somente igualdade.
direcao = rep("=",6)


# - 5° Parametro funcao lpSolve => const.rhs : Desembolsos (Dt) nos 6 instantes (t) de acordo Fluxo do Projeto, pag.2/7.
desembolso = c(0,2500,0,5000,0,7500)

# - Otimizar mdl (modelo) dada a funcao lpSolve e parametros (5 parametros acima definidos)
mdl= lp(direction="min",objective.in = f.obj, const.mat = restricoes, const.dir = direcao, const.rhs = desembolso )

# - arredondamento para 2 casas decimais da solucao de otimizacao
tbl.info$Montante = round(mdl$solution,3)

# ---- OUTPUT ----
tbl.info[,c(1, 2, 5, 14)]


#### ----- FIM DO SCRIPT    
