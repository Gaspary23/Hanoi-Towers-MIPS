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

HANOI:	
and $t2,$t2,$zero # zera o ultimo aro movimentado 
and $s2,$s2,$zero # zera o contador
j MOVAROS
jr		$ra

MOVAROS:
and $s3,$s3,$zero # salva o valor do aro no topo do primeiro pino em $s3 (TODO)
and $s4,$s4,$zero # salva o valor do aro no topo do segundo pino em $s4 (TODO)
and $s5,$s5,$zero # salva o valor do aro no topo do terceiro pino em $s5 (TODO)
j Check1
addiu $s2,$s2,1 # aumenta contador de movimentos
#bne $s2,(total de aros), MOV AROS # conta o numero total de movimentos
# escrever algo que verifica se todos os aros estão no pino 3 (se o maior topo dessa pliha é um)
j END


Check1:
ble $s3,$s4, Check2 # caso 2 seja maior que 1, passa prioridade pra ele
ble $s3,$s5, Check3 # caso 3 seja maior que 1, passa prioridade pra ele
addiu $s6,$s6,$s3 # nesse caso, o aro 1 é o maior e é salvo em $s6
addiu $t4,$t4,$t1 # salva o endereço do topo do primeiro pino em $t4
addiu $s7,$s7,j # salva o endereço de j em $s7
j verifica # pula para verifica

Check2:
ble $s4,$s5, Check3 # caso 3 seja maior que 2, passa prioridade pra ele
ble $s4,$s3, Check1 # caso 3 seja maior que 1, passa prioridade pra ele
addiu $s6,$s6,$s4 # nesse caso, o aro 2 é o maior e é salvo em $s6
addiu $t4,$t4,$t2 # salva o endereço do topo do segundo pino em $t4
addiu $s7,$s7,j # salva o endereço de j em $s7
j verifica # pula para verifica

Check3:
ble $s5,$s3, Check1 # caso 3 seja maior que 1, passa prioridade pra ele
ble $s5,$s4, Check2 # caso 3 seja maior que 2, passa prioridade pra ele
addiu $s6,$s6,$s5 # nesse caso, o aro 3 é o maior e é salvo em $s6
addiu $t4,$t4,$t3 # salva o endereço do topo do terceiro pino em $t4
addiu $s7,$s7,j # salva o endereço de j em $s7
j verifica # pula para verifica

Verifica:
beq $s6,$s8, Aro Invalido 
bge $s6, $s3, Verifica1 
bge $s6, $s4, Verifica2
bge $s6, $s5, Verifica3

Verifica1:
bge $s6,$s5, Coloca3
bge $s6,$s4, Coloca2 

Verifica2:
bge $s6,$s5, Coloca3
bge $s6,$s3, Coloca1


Verifica3:
bge $s6,$s4, Coloca2
bge $s6,$s3, Coloca1


Coloca1:
addiu $t1,$s6,$zero
addiu $s8,$s6,$zero
addiu $s6,$zero,$zero
addiu $t4,$zero,$zero
j $s7 # retorna para $s7

Coloca2:
addiu $t2,$s6,$zero
addiu $s8,$s6,$zero
addiu $s6,$zero,$zero
addiu $t4,$zero,$zero
j $s7 # retorna para $s7

Coloca3:
addiu $t3,$s6,$zero
addiu $s8,$s6,$zero
addiu $s6,$zero,$zero
addiu $t4,$zero,$zero
j $s7 # retorna para $s7

Aro Invalido:
and (valor do aro $t4), (valor do aro $t4), $zero
j 1 Check

