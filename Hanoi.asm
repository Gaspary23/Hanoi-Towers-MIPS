# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
texto1: .asciiz "Digite um numero: "
texto2: .asciiz "Deseja testar de novo? (0-nao, 1-sim): "

.text

	addu 	$t0, $zero, 1
MAIN:
	li		$v0, 4
	la		$a0, texto1			# Imprime o texto
	syscall

	li		$v0, 5				# Le o numero
	syscall

	move 	$a0, $v0			# Salva o input em $a0
	move	$s0, $zero			# Zera o $s0
	lw		$s1, 0($sp)			# Carrega o valor do stack pointer em $s1

	# Aqui tem que chamar o programa

	li		$v0, 4
	la		$a0, texto2			# Imprime o texto
	syscall

	li		$v0, 5				# Le o numero
	syscall
	move 	$t0, $v0			# Bota o input em $t0
	bne		$t0, 0, MAIN		# Se o usuario digitou 0, termina o programa

END:	# Saida do programa
	li		$v0, 10 	        # Fim do programa
   	syscall

SIZE:
	addiu	$s0, $s0, 1			# $s0 serve como um contador para saber o size
	addiu 	$s1, $s1, 4			# $s1 aumenta seu valor em ´4´ para cada disco
	beq 	$s0, $a0, SIZEEND	# Se o contador e a0 forem iguais,
								#	sai dessa área do size,
								#	ao final desse processo,
								#	s1 será do tamanho de uma pilha
	bne 	$s0, $a0, SIZE		# Caso contrario, repete o processo

SIZEEND:
	sw		$ra, 0($sp)			# bota o endereco de retorno do SO na pilha
	jal		HANOI

HANOI:	# Sub-rotina recursiva pra resolver as torres
	jr		$ra

