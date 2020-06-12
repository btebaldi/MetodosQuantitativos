# clear all
rm(list=ls())

# fonte
source("./lib/radix.r");


# Unit Tests
ret_a <- raiz(27, 3)
ret_b <- raiz(100)
ret_c <- raiz(81, 3)
ret_d <- raiz(81, 2)
RET <- c(ret_a, ret_b, ret_c, ret_d)
TRG = c(3, 10, 81^(1/3),9)

# Results
TesteResult <- RET == TRG



# Print of Results
TesteType = c("A","B","C","D")
ResultText = c("Fail", "Passed")
TesteCheck = c(" ", "X")
cat(sprintf("\n------------------------\nRESULTS\n------------------------"))
cat(sprintf("\nTest %s: [%s] %7s - ret: %6.2f   Target: %6.2f",
            TesteType,
            TesteCheck[TesteResult+1],
            ResultText[TesteResult+1],
            RET,
            TRG))
