## ATENÇAO: Inicilizar as variáveis 'a` e 'b' na janela de comando
 
## Verifica se as variáveis são iguais
if (a == b) {
    cat(sprintf('a=%f IGUAL que b=%f\n',a,b));
} else {
    if (a < b){
        ## Verifica se 'a' é menor que 'b'
        cat(sprintf('a=%f MENOR que b=%f\n',a,b));
    } else {
        ## Verifica se 'a' é maior que 'b'
        cat(sprintf('a=%f MAIOR que b=%f\n',a,b));
    }
}
