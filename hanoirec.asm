# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
texto1: .asciiz "\nDigite um numero: "
texto2: .asciiz "Numero de movimentos: "
texto3: .asciiz "\n\nDeseja testar de novo? (0-nao, outro numero-sim): "
cont:	.word	0

Move:
    .asciiz      "\nMove disk from "
To:
    .ascii      " to "


.text

MAIN:
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
	addi 	$t0, $a0, 0		# temp save $a0
    	addi 	$t1, $zero, 1
    	bne 	$a0, $t1, else
    	
    	li $v0, 4			# print move
    la $a0, Move
    syscall
    li $v0, 1 			# print start_peg
    move $a0, $a1
    syscall
    li $v0, 4			# print to
    la $a0, To
    syscall
    li $v0, 1 			# print end_peg
    move $a0, $a3
    syscall
    	
    	addi 	$a0, $t0, 0		# restore $a0
    	jr 	$ra
    
else:
    	# Aloca espaco na pilha
    	addi 	$sp, $sp, -20
    
    #save to stack
    	sw 	$ra, 16($sp)
    	sw 	$a2, 12($sp)		#store a2(extra_peg)
    	sw 	$a3, 8($sp)		#store a3(end_peg)
    	sw 	$a1, 4($sp)		#store a1(start_peg)
	sw 	$a0, 0($sp)		#store a0(num_of_disks)
	    
    #hanoi_towers(num_of_disks-1, start_peg, extra_peg, end_peg)    
    	#set args for subsequent recursive call
    		addi $t3, $a2, 0		#copy var into temp
    		addi $a2, $a3, 0		#extra_peg = end_peg
    		addi $a3, $t3, 0		#end_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk--   		
    	#recursive call
    		jal HANOI   
    	
    #load off stack
    	lw $ra, 16($sp)
    	lw $a2, 12($sp)		#load a2(extra_peg)
    	lw $a3, 8($sp)		#load a3(end_peg)
    	lw $a1, 4($sp)		#load a1(start_peg)
    	lw $a0, 0($sp)		#load a0(num_of_disks)
   
    #move a disk from start_peg to end_peg
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1
    	li $v0, 4			# print move
    	la $a0, Move
    	syscall
    	li $v0, 1 			# print start_peg
    	move $a0, $a1
    	syscall
    	li $v0, 4			# print to
    	la $a0, To
    	syscall
    	li $v0, 1 			# print end_peg
    	move $a0, $a3
    	syscall
    	addi $a0, $t0, 0		# restore $a0
    
    #hanoi_towers(num_of_disks-1, extra_peg, end_peg, start_peg)  
    	#set args for subsequent recursive call
    		addi $t3, $a2, 0		#copy var into temp
    		addi $a2, $a1, 0		#extra_peg = start_peg
    		addi $a1, $t3, 0		#start_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk--  		
    	#recursive call
    		jal HANOI
    	#load params off stack
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	jr $ra    
   	