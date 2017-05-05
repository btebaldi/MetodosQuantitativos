## Script: Exemplo de utilização dos comando break e next

for (i in 1:20){
  
  if (i%%5==0) {
    cat(sprintf("next\n"));
    next;
  }
  
  cat(sprintf("i=%.0f\n",i));
    
  if (i==17) {
    cat(sprintf("break\n"));
    break;
  }
    
}

cat("done!\n");