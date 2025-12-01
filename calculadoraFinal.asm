.data
strAutor: .asciiz "Brenda Luana Correia Bezerra (Blcb)\n"
strData: .asciiz "Data de Criacao: 30/11/2025\n"
strRevisao1: .asciiz "commit 1 (30/11/2025 - 20:33): Implementacao de Base 2, 8 e 16.\n"
strRevisao2: .asciiz "commit 2:(01/12/2025 - 15:26): Implementacao de BCD e Complemento de 2 (16 bits)\n"
strRevisao3: .asciiz "commit 3:(01/12/2025 - 19:42): Implementacao de Real para Float e Double (IEEE 754)\n"

.data
menu: .asciiz "\nCALCULADORA PROGRAMADOR DIDATICA\n"
menu1: .asciiz "1 - Converter Decimal (Base 10) para 2, 8, 16 e BCD\n"
menu2: .asciiz "2 - Converter Decimal (Base 10) para Complemento de 2 (16 bits)\n"
menu3: .asciiz "3 - Converter Real (Decimal) para Float e Double (IEEE 754)\n"
menu4: .asciiz "4 - Sair\n"
menu5: .asciiz "Escolha uma opcao: "
promptNum: .asciiz "Digite o numero inteiro Decimal (Base 10): "
promptFloat: .asciiz "Digite o numero Real Decimal: "
msgBin: .asciiz "\n--- CONVERSAO PARA BINARIO (BASE 2) ---\n"
msgOct: .asciiz "\n--- CONVERSAO PARA OCTAL (BASE 8) ---\n"
msgHex: .asciiz "\n--- CONVERSAO PARA HEXADECIMAL (BASE 16) ---\n"
msgBCD: .asciiz "\n--- CONVERSAO PARA BCD (Binary-Coded Decimal) ---\n"
msgC2: .asciiz "\n--- CONVERSAO PARA COMPLEMENTO DE 2 (16 BITS) ---\n"
msgFloat: .asciiz "\n--- CONVERSAO PARA FLOAT (32 BITS - IEEE 754) ---\n"
msgDouble: .asciiz "\n--- CONVERSAO PARA DOUBLE (64 BITS - IEEE 754) ---\n"
msgFloatBin: .asciiz "Bits (32 bits): "
msgDoubleBin: .asciiz "Bits (64 bits): "
msgSinal: .asciiz "SINAL (Bit 31/63): "
msgExpoente: .asciiz "EXPOENTE (Decimal): "
msgExpoenteVies: .asciiz "EXPOENTE COM VIES (Binario/Decimal): "
msgFracao: .asciiz "FRACAO (Mantissa): "
msgDiv: .asciiz " / "
msgResto: .asciiz " = "
msgIgualResto: .asciiz ", Resto: "
msgFinal: .asciiz "Resultado final: "
msgErro: .asciiz "Opcao invalida.\n"
msgC2Positivo: .asciiz "1. Numero positivo. Resultado e o Binario de 16 bits.\n"
msgC2Negativo: .asciiz "1. Numero negativo. Usar Complemento de 2:\n"
msgC2Mag: .asciiz "2. Magnitude (Valor Absoluto) em Decimal: "
msgC2Bin: .asciiz "3. Binario 16-bits da Magnitude: "
msgC2Inv: .asciiz "4. Inversao de bits (Complemento de 1): "
msgC2Add1: .asciiz "5. Adicionar 1 para Comp. de 2: "
msgC2Res: .asciiz "6. Resultado Final (C2): "

buffer_bin: .space 33
buffer_hex: .space 9
buffer_oct: .space 12
buffer_bcd: .space 40
buffer_c2: .space 17
buffer_32bit: .space 33
buffer_64bit: .space 65
zero_char: .asciiz "0"
newline: .asciiz "\n"

.text
.globl main

main:
li $v0, 4
la $a0, strAutor
syscall
la $a0, strData
syscall
la $a0, strRevisao1
syscall
la $a0, strRevisao2
syscall
la $a0, strRevisao3
syscall

loop_menu:
li $v0, 4
la $a0, menu
syscall
la $a0, menu1
syscall
la $a0, menu2
syscall
la $a0, menu3
syscall
la $a0, menu4
syscall
la $a0, menu5
syscall

li $v0, 5
syscall
move $t0, $v0

li $t1, 1
beq $t0, $t1, conversao1
li $t1, 2
beq $t0, $t1, conversao2
li $t1, 3
beq $t0, $t1, conversao3
li $t1, 4
beq $t0, $t1, sair

li $v0, 4
la $a0, msgErro
syscall
j loop_menu

sair:
li $v0, 10
syscall

conversao1:
li $v0, 4
la $a0, promptNum
syscall
li $v0, 5
syscall
move $s0, $v0

move $a0, $s0
jal to_bin

move $a0, $s0
jal to_oct

move $a0, $s0
jal to_hex
    
move $a0, $s0
jal to_bcd

j loop_menu

conversao2:
li $v0, 4
la $a0, promptNum
syscall
li $v0, 5
syscall
move $s0, $v0
    
move $a0, $s0
jal to_comp2
    
j loop_menu

conversao3:
li $v0, 4
la $a0, promptFloat
syscall
    
li $v0, 6
syscall
    
jal to_float_32bit
    
li $v0, 7
syscall
    
jal to_double_64bit
    
j loop_menu

to_float_32bit:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
li $v0, 4
la $a0, msgFloat
syscall
    
mfc1 $t0, $f0
    
li $v0, 4
la $a0, msgFloatBin
syscall
move $a0, $t0
li $t1, 32
la $t2, buffer_32bit
jal print_bits_from_int_32
    
li $v0, 4
la $a0, msgSinal
syscall
srl $t1, $t0, 31
li $v0, 1
move $a0, $t1
syscall
li $v0, 4
la $a0, newline
syscall
    
li $v0, 4
la $a0, msgExpoenteVies
syscall
srl $t1, $t0, 23
andi $t1, $t1, 0xFF
li $v0, 1
move $a0, $t1
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, msgExpoente
syscall
li $t2, 127
sub $t1, $t1, $t2
li $v0, 1
move $a0, $t1
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, msgFracao
syscall
andi $t1, $t0, 0x7FFFFF
move $a0, $t1
li $t1, 23
la $t2, buffer_32bit
jal print_bits_from_int_23
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

to_double_64bit:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
li $v0, 4
la $a0, msgDouble
syscall
    
mfc1 $t0, $f0
mfc1 $t1, $f1
    
li $v0, 4
la $a0, msgDoubleBin
syscall
move $a0, $t0
move $a1, $t1
la $t2, buffer_64bit
jal print_bits_from_int_64
    
li $v0, 4
la $a0, msgSinal
syscall
srl $t2, $t0, 31
li $v0, 1
move $a0, $t2
syscall
li $v0, 4
la $a0, newline
syscall
    
li $v0, 4
la $a0, msgExpoenteVies
syscall
srl $t2, $t0, 20
andi $t2, $t2, 0x7FF
li $v0, 1
move $a0, $t2
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, msgExpoente
syscall
li $t3, 1023
sub $t2, $t2, $t3
li $v0, 1
move $a0, $t2
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, msgFracao
syscall
    
andi $t2, $t0, 0xFFFFF
move $a0, $t2
li $t3, 20
la $t4, buffer_32bit
jal print_bits_from_int_20
    
move $a0, $t1
li $t3, 32
la $t4, buffer_32bit
jal print_bits_from_int_32_no_space
    
li $v0, 4
la $a0, newline
syscall

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_bits_from_int_32:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t1
move $s1, $t2
addi $s1, $s1, 31
sb $zero, ($s1)
addi $s1, $s1, -1
    
li $s2, 0
    
loop_print_32bit:
beq $s0, $zero, end_print_32bit
    
andi $t3, $t0, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t0, $t0, 1
addi $s1, $s1, -1
addi $s0, $s0, -1
    
addi $s2, $s2, 1
li $t5, 8
rem $t6, $s2, $t5
beq $t6, $zero, add_space
    
j loop_print_32bit

add_space:
li $v0, 11
li $a0, 32
syscall
j loop_print_32bit

end_print_32bit:
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_bits_from_int_23:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t1
move $s1, $t2
addi $s1, $s1, 23
sb $zero, ($s1)
addi $s1, $s1, -1
    
loop_print_23bit:
beq $s0, $zero, end_print_23bit
    
andi $t3, $t0, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t0, $t0, 1
addi $s1, $s1, -1
addi $s0, $s0, -1
j loop_print_23bit

end_print_23bit:
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_bits_from_int_64:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $t1, $a1
move $s1, $t2
addi $s1, $s1, 63
sb $zero, ($s1)
addi $s1, $s1, -1
    
li $s2, 0
li $s3, 32
    
loop_low_word:
beq $s3, $zero, start_high_word
    
andi $t3, $t1, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t1, $t1, 1
addi $s1, $s1, -1
addi $s3, $s3, -1
    
addi $s2, $s2, 1
j loop_low_word

start_high_word:
li $s3, 32
    
loop_high_word:
beq $s3, $zero, end_print_64bit
    
andi $t3, $t0, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t0, $t0, 1
addi $s1, $s1, -1
addi $s3, $s3, -1
    
addi $s2, $s2, 1
li $t5, 8
rem $t6, $s2, $t5
beq $t6, $zero, add_space_64
    
j loop_high_word

add_space_64:
li $v0, 11
li $a0, 32
syscall
j loop_high_word

end_print_64bit:
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_bits_from_int_20:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t1
move $s1, $t2
addi $s1, $s1, 20
sb $zero, ($s1)
addi $s1, $s1, -1
    
loop_print_20bit:
beq $s0, $zero, end_print_20bit
    
andi $t3, $t0, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t0, $t0, 1
addi $s1, $s1, -1
addi $s0, $s0, -1
j loop_print_20bit

end_print_20bit:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_bits_from_int_32_no_space:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t1
move $s1, $t2
addi $s1, $s1, 32
sb $zero, ($s1)
addi $s1, $s1, -1
    
loop_print_32_no_space:
beq $s0, $zero, end_print_32_no_space
    
andi $t3, $t0, 1
    
addi $t4, $t3, 48
sb $t4, ($s1)
    
srl $t0, $t0, 1
addi $s1, $s1, -1
addi $s0, $s0, -1
j loop_print_32_no_space

end_print_32_no_space:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra