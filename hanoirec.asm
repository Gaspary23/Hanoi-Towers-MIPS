# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
texto0: .asciiz "\nTorres de Hanoi"
texto1: .asciiz "\nDigite o numero de discos: "
texto2: .asciiz "Numero de movimentos para resolver a torre: "
texto3: .asciiz "\n\nDeseja testar de novo? (0-nao, outro numero-sim): "
cont:	.word	0

.text
.globl MAIN

	# Texto0
	li	$v0, 4
	la	$a0, texto0	# Imprime o texto
	syscall
	
MAIN:
	move 	$v1, $zero	# Zera o contador de movimentos para nao influenciar multiplas execucoes

	# Texto1
	li	$v0, 4
	la	$a0, texto1		# Pergunta o num de aros desejados
	syscall
	
	# Input - numero de aros
	li	$v0, 5			# Le o numero de aros
	syscall
	move 	$a0, $v0		# Salva o num de aros em $a0
	
	# Chama o algoritmo recursivo
	li 	$a1, 1			# $a1 eh a fonte
    	li 	$a2, 2			# $a2 eh o extra
    	li 	$a3, 3			# $a3 eh o destino
	jal 	HANOI
	
	# Texto2
	li 	$v0, 4
	la	$a0, texto2		# Imprime o texto
	syscall	
	li 	$v0, 1
	move	$a0, $v1		# Imprime o numero de movimentos 
	syscall
	
	# Texto3
	li	$v0, 4
	la	$a0, texto3		# Pergunta se quer testar de novo
	syscall
	li	$v0, 5			# Le a resposta
	syscall
	move 	$t0, $v0		# Bota o input em $t0
	bne	$t0, 0, MAIN		# Se o usuario digitou 0, termina o programa
	
	# Saida do programa
	li	$v0, 10 	        # Fim do programa
   	syscall
   	
#############################################################################################
# Algoritmo de hanoi 

HANOI:
    	addi 	$v1, $v1, 1		# Incrementa o numero de movimentos
    	bne 	$a0, 1, ELSE		# Se tiver mais de um disco, pula para o else
    	jr 	$ra			# Se soh tiver um disco, retorna
    
ELSE:
    	# Aloca espaco e bota os pinos na pilha
    	addi 	$sp, $sp, -20
    	sw 	$ra, 16($sp)		# Guarda o endereco de retorno de $ra
    	sw 	$a2, 12($sp)		# Guarda o pino extra
    	sw 	$a3, 8($sp)		# Guarda o pino destino
    	sw 	$a1, 4($sp)		# Guarda o pino fonte
	sw 	$a0, 0($sp)		# Guarda o numero de discos
	    
   	# han_move_tower(disk - 1, source, spare, dest): 
    	# Movimenta os discos e chama HANOI de novo
    	addi 	$t3, $a2, 0		#
    	addi 	$a2, $a3, 0		# Troca o disco do extra com o do destino
    	addi 	$a3, $t3, 0	 	# 
    	addi 	$a0, $a0, -1		# Decrementa o numero de discos 		
    	jal 	HANOI   		# Chamada recursiva
    	
      	# Pega o que esta na pilha
    	lw 	$ra, 16($sp)		# Carrega o endereco de retorno
    	lw 	$a2, 12($sp)		# Carrega o pino extra 
    	lw 	$a3, 8($sp)		# Carrega o pino destino
    	lw 	$a1, 4($sp)		# Carrega o pino fonte
    	lw 	$a0, 0($sp)		# Carrega o numero de discos
   
    	addi $t1, $zero, 1		#  Move um disco da fonte para o destino
    
    	# han_move_tower(disk - 1, spare, dest, source):
    	# Movimenta os discos e chama HANOI de novo
    	addi 	$t3, $a2, 0		# 
    	addi 	$a2, $a1, 0		# Troca o disco do extra com o do destino
    	addi 	$a1, $t3, 0		# 
    	addi 	$a0, $a0, -1		# Decrementa o numero de discos  
    	jal 	HANOI			# Chamada recursiva
    	
    	lw 	$ra, 16($sp)		# Bota o endereco de retorno no $ra
    	addi 	$sp, $sp, 20		# Limpa a pilha

    	# Retorna 
    	move $v0, $zero
    	jr $ra    