# Torres de Hanoi - OAP
#
# Authors: Pedro da Cunha Gaspary (21101429), 
#	   Bernardo Barzotto Zomer (21103639), 
#          Lucas Marchesan Cunha (21101060)

.data
texto0: .asciiz "\nTorres de Hanoi"
texto1: .asciiz "\nDigite o numero de discos: "
texto2: .asciiz "Numero de movimentos para resolver a torre: "
texto3: .asciiz "\n\nDeseja testar de novo? (0-nao, outro numero-sim): "

.text
.globl MAIN

	# Texto0
	li	$v0, 4			#
	la	$a0, texto0		# Imprime o texto
	syscall				#
	
MAIN:
	move 	$v1, $zero		# Zera o contador de movimentos para nao influenciar multiplas execucoes

	# Texto1
	li	$v0, 4			#
	la	$a0, texto1		# Pergunta o num de aros desejados
	syscall				#
	
	# Input - numero de aros
	li	$v0, 5			# Le o numero de aros
	syscall				#
	move 	$a0, $v0		# Salva o num de aros em $a0
	
	# Chama o algoritmo recursivo
	li 	$a1, 1			# $a1 eh a fonte
    	li 	$a2, 2			# $a2 eh o extra
    	li 	$a3, 3			# $a3 eh o destino
	jal 	HANOI			# Salta pra o algoritmo de Hanoi
	
	# Texto2
	li 	$v0, 4			#
	la	$a0, texto2		# Imprime o texto
	syscall				#
	li 	$v0, 1			#
	move	$a0, $v1		# Imprime o numero de movimentos 
	syscall				#
	
	# Texto3
	li	$v0, 4			#
	la	$a0, texto3		# Pergunta se quer testar de novo
	syscall				#
	li	$v0, 5			# Le a resposta
	syscall				#
	move 	$t0, $v0		# Bota o input em $t0
	bne	$t0, 0, MAIN		# Se o usuario digitou 0, termina o programa
	
	# Saida do programa
	li	$v0, 10 	        # Fim do programa
   	syscall				#
   	
#############################################################################################
# Algoritmo recursivo de Hanoi
HANOI:
    	addi 	$v1, $v1, 1		# Incrementa o numero de movimentos
    	bne 	$a0, 1, ELSE		# Se tiver mais de um disco, pula para o else
    	jr 	$ra			# Se soh tiver um disco, retorna
ELSE:
    	# Aloca espaco e bota os argumentos na pilha
    	addi 	$sp, $sp, -20		# Aloca 20 bytes para 5 words
    	sw 	$ra, 16($sp)		# Guarda o endereco de retorno em $ra
    	sw 	$a2, 12($sp)		# Guarda o pino extra
    	sw 	$a3, 8($sp)		# Guarda o pino destino
    	sw 	$a1, 4($sp)		# Guarda o pino fonte
	sw 	$a0, 0($sp)		# Guarda o numero de discos
	    
   	# han_move_tower(disk - 1, source, spare, dest): 
    	move 	$t3, $a2		#
    	move 	$a2, $a3		# Troca o disco de extra para destino
    	move 	$a3, $t3	 	# 
    	addi 	$a0, $a0, -1		# Decrementa o numero de discos 		
    	jal 	HANOI   		# Chamada recursiva
    	
      	# Recebe os argumentos da pilha
    	lw 	$ra, 16($sp)		# Carrega o endereco de retorno para $ra
    	lw 	$a2, 12($sp)		# Carrega o pino extra 
    	lw 	$a3, 8($sp)		# Carrega o pino destino
    	lw 	$a1, 4($sp)		# Carrega o pino fonte
    	lw 	$a0, 0($sp)		# Carrega o numero de discos
    
    	# han_move_tower(disk - 1, spare, dest, source):
    	move 	$t3, $a2		# 
    	move 	$a2, $a1		# Troca o disco de extra para fonte
    	move 	$a1, $t3		# 
    	addi 	$a0, $a0, -1		# Decrementa o numero de discos  
    	jal 	HANOI			# Chamada recursiva
    	
    	# Sai do algoritmo
    	lw 	$ra, 16($sp)		# Bota o endereco de retorno em $ra
    	addi 	$sp, $sp, 20		# Limpa a pilha
    	jr 	$ra    			# Salta para o endereco de retorno em $ra
