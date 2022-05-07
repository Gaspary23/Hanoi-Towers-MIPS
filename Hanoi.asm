# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
discos:	.word 	3	# Valor arbitrario

.text
.globl MAIN

MAIN: 	la $a0, discos
	lw $a0, 0($a0)
	
	
	sw	$ra, 0($sp)	# bota o endereco de retorno do SO na pilha
	jal	HANOI
	
	# Sub-rotina recursiva pra resolver as torres
HANOI: 	

	jr $ra
	
	# Fim do programa
END:	li	$v0,10		# Sai do programa
	syscall			


