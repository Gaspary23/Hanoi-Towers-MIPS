# Torres de Hanoi
#
# Authors: Pedro Gaspary, Bernardo Zomer, Lucas Cunhas


.data
texto1: .asciiz "Digite um numero: "
texto2: .asciiz "Deseja testar de novo? (0-nao, 1-sim): "

.text

	addu 	$t0, $zero, 1
MAIN:
	li	$v0, 4
	la	$a0, texto1			# Imprime o texto
	syscall

	li	$v0, 5				# Le o numero
	syscall

	move 	$a0, $v0			# Salva o input em $a0
	move	$s0, $zero			# Zera o $s0
	lw	$s1, 0($sp)			# Carrega o valor do stack pointer em $s1

	# Aqui tem que chamar o programa

	li	$v0, 4
	la	$a0, texto2			# Imprime o texto
	syscall

	li	$v0, 5				# Le o numero
	syscall
	move 	$t0, $v0			# Bota o input em $t0
	bne	$t0, 0, MAIN		# Se o usuario digitou 0, termina o programa	

END:	# Saida do programa
	li	$v0, 10 	        # Fim do programa
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
	sw	$ra, 0($sp)			# bota o endereco de retorno do SO na pilha
	jal	HANOI

HANOI:	
    add     $t5,$s1,$sp  # declara a posição inicial do pino 1
    add     $t6,$t5,4    # declara a posição inicial do pino 2
    add     $t7,$t6,$s1  # declara a posição inicial do pino 3
	and 	$t2,$t2,$zero # zera o ultimo aro movimentado 
	and 	$s2,$s2,$zero # zera o contador
	j       MOVAROS
	jr	    $ra

MOVAROS:
	la  	$s3,($t5) # salva o valor do aro no topo do primeiro pino em $s3 (TODO)     
	la  	$s4,($t6) # salva o valor do aro no topo do segundo pino em $s4 (TODO)
	la  	$s5,($t7) # salva o valor do aro no topo do terceiro pino em $s5 (TODO)
	j 	    Check1
	addiu 	$s2,$s2,1 # aumenta contador de movimentos
	#bne    $s2,(total de aros), MOV AROS # conta o numero total de movimentos
	# escrever algo que verifica se todos os aros estão no pino 3 (se o maior topo dessa pliha é um)
	j 	END


Check1:
	ble 	$s3,$s4, Check2 # caso 2 seja maior que 1, passa prioridade pra ele
	ble 	$s3,$s5, Check3 # caso 3 seja maior que 1, passa prioridade pra ele
	add	    $s6,$s6,$s3 # nesse caso, o aro 1 é o maior e é salvo em $s6
	add  	$t4,$t4,$t1 # salva o endereço do topo do primeiro pino em $t4
	lw	    $s7,$s7,j 
	sw      $s7,0(j) # salva o endereço de j em $s7
	j    	verifica # pula para verifica

Check2:
	ble 	$s4,$s5, Check3 # caso 3 seja maior que 2, passa prioridade pra ele
	ble 	$s4,$s3, Check1 # caso 3 seja maior que 1, passa prioridade pra ele
	add 	$s6,$s6,$s4 # nesse caso, o aro 2 é o maior e é salvo em $s6
	add	    $t4,$t4,$t2 # salva o endereço do topo do segundo pino em $t4
	lw	    $s7,$s7,j 
	sw      $s7,0(j) # salva o endereço de j em $s7
	j 	    verifica # pula para verifica

Check3:
	ble 	$s5,$s3, Check1 # caso 3 seja maior que 1, passa prioridade pra ele
	ble 	$s5,$s4, Check2 # caso 3 seja maior que 2, passa prioridade pra ele
	add 	$s6,$s6,$s5 # nesse caso, o aro 3 é o maior e é salvo em $s6
	add	    $t4,$t4,$t3 # salva o endereço do topo do terceiro pino em $t4
	lw	    $s7,$s7,j 
	sw      $s7,0(j) # salva o endereço de j em $s7
	j 	    verifica # pula para verifica

Verifica:
	beq 	$s6,$t2, Aro Invalido # caso o ultimo aro movido seja escolhido novamente, ele é dito como inválido
	bge 	$s6, $s3, Verifica1   # se o aro no topo do primeiro pino for o maior, vai para Verifica1
	bge 	$s6, $s4, Verifica2	  # se o aro no topo do segundo pino for o maior, vai para Verifica2
	bge 	$s6, $s5, Verifica3   # se o aro no topo do terceiro pino for o maior, vai para Verifica3
	
Verifica1:
    addiu   $t5, $t5,-4  # retira o valor no topo da pilha do pino 1
	ble 	$s6,$s5, Coloca3 # se puder, coloca o aro no topo do pino 3
	ble 	$s6,$s4, Coloca2 # se puder, coloca o aro no topo do pino 2

Verifica2:
    addiu   $t6, $t6,-4   # retira o valor no topo da pilha do pino 2
	ble	    $s6,$s5, Coloca3 # se puder, coloca o aro no topo do pino 3
	ble 	$s6,$s3, Coloca1 # se puder, coloca o aro no topo do pino 1


Verifica3:
    addiu   $t7, $t7,-4   # retira o valor no topo da pilha do pino 3
	ble 	$s6,$s4, Coloca2 # se puder, coloca o aro no topo do pino 2
	bge 	$s6,$s3, Coloca1 # se puder, coloca o aro no topo do pino 1


Coloca1:
    addiu   $t5, $t5,4 
	add 	$t1,$s6,$zero  # salva no topo o aro recem colocado 
	add	    $t4,$s6,$zero  # salva no ultimo aro o aro recem movido
	add     $s6,$zero,$zero # zera a auxiliar de maior valor
	j 	    $s7 # retorna para $s7

Coloca2:
    addiu   $t6, $t6,4
	add	    $t2,$s6,$zero  # salva no topo o aro recem colocado
	add		$t4,$s6,$zero  # salva no ultimo aro o aro recem movido
	add		$s6,$zero,$zero  # zera a auxiliar de maior valor
	j 		$s7 # retorna para $s7

Coloca3:
    addiu   $t7, $t7,4
	add 	$t3,$s6,$zero  # salva no topo o aro recem colocado
	add 	$t4,$s6,$zero  # salva no ultimo aro o aro recem movido
	add		$s6,$zero,$zero # zera a auxiliar de maior valor
	j 		$s7 # retorna para $s7

Aro_Invalido:
	and 	(valor do aro $t4), (valor do aro $t4), $zero
	j 	Check1

