# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
discos:	.word 	3	# Valor arbitrario

.text
.globl MAIN

MAIN: 	
    la $a0, discos # carrega o valor de discos em a0
	lw $a0, 0($a0)
	la $s0,$zero # zera o s0
	lw $s0, 0($s0) 
	la $s1, $sp # carrega o valor do stack pointer em s1 
	lw $s1, 0($s1)
SIZE:
    addiu $s0,$s0,1 # s0 serve como um contador para saber o size
	addiu $s1,$s1,4 # s1 aumenta seu valor em ´4´ para cada disco 
	beq $s0,$a0,SIZEEND # se o contador e a0 forem iguais, sai dessa área do size, ao final desse processo, s1 será do tamanho de uma pilha
    bne $s0,$a0,SIZE # caso contrario, repete o processo

SIZEEND:
	sw	$ra, 0($sp)	# bota o endereco de retorno do SO na pilha
	jal	HANOI
	
	# Sub-rotina recursiva pra resolver as torres
HANOI: 	

	jr $ra
	
	# Fim do programa
END:	li	$v0,10		# Sai do programa
	syscall			


