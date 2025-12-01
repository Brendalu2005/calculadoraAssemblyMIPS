.data
strAutor: .asciiz "Brenda Luana Correia Bezerra (Blcb)\n"
strData: .asciiz "Data de Criacao: 30/11/2025\n"
strRevisao1: .asciiz "commit 1 (30/11/2025 - 20:33): Implementacao de Base 2, 8 e 16.\n"
strRevisao2: .asciiz "commit 2:(01/12/2025 - 15:26): Implementacao de BCD e Complemento de 2 (16 bits)\n"
strRevisao3: .asciiz "commit 3:..\n"

menu: .asciiz "\nCALCULADORA PROGRAMADOR DIDATICA\n"
menu1: .asciiz "1 - Converter Decimal (Base 10) para 2, 8, 16 e BCD\n"
menu2: .asciiz "2 - Converter Decimal (Base 10) para Complemento de 2 (16 bits)\n"
menu3: .asciiz "3 - Converter Real (Decimal) para Float e Double (IEEE 754)\n"
menu4: .asciiz "4 - Sair\n"
menu5: .asciiz "Escolha uma opcao: "
promptNum: .asciiz "Digite o numero inteiro Decimal (Base 10): "
msgBin: .asciiz "\n--- CONVERSAO PARA BINARIO (BASE 2) ---\n"
msgOct: .asciiz "\n--- CONVERSAO PARA OCTAL (BASE 8) ---\n"
msgHex: .asciiz "\n--- CONVERSAO PARA HEXADECIMAL (BASE 16) ---\n"
msgBCD: .asciiz "\n--- CONVERSAO PARA BCD (Binary-Coded Decimal) ---\n"
msgC2: .asciiz "\n--- CONVERSAO PARA COMPLEMENTO DE 2 (16 BITS) ---\n"
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
j loop_menu

to_bin:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
li $v0, 4
la $a0, msgBin
syscall

move $t0, $a0
la $t1, buffer_bin
    
addi $t1, $t1, 31
sb $zero, ($t1)
addi $t1, $t1, -1

loop_bin_div:
beq $t0, $zero, end_bin_div

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgDiv
syscall
li $a0, 2
syscall
la $a0, msgResto
syscall

addi $t3, $t0, 0
li $t4, 2
div $t3, $t4
mflo $t0
mfhi $t5

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgIgualResto
syscall
    
addi $t6, $t5, 48
sb $t6, ($t1)
    
li $v0, 1
move $a0, $t5
syscall
li $v0, 11
li $a0, 10
syscall

addi $t1, $t1, -1
j loop_bin_div

end_bin_div:
li $v0, 4
la $a0, msgFinal
syscall
    
addi $t1, $t1, 1
li $v0, 4
move $a0, $t1
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

to_oct:
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v0, 4
la $a0, msgOct
syscall

move $t0, $a0
la $t1, buffer_oct
addi $t1, $t1, 11
sb $zero, ($t1)
addi $t1, $t1, -1

loop_oct_div:
beq $t0, $zero, end_oct_div

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgDiv
syscall
li $a0, 8
syscall
la $a0, msgResto
syscall

addi $t3, $t0, 0
li $t4, 8
div $t3, $t4
mflo $t0
mfhi $t5

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgIgualResto
syscall
    
addi $t6, $t5, 48
sb $t6, ($t1)
    
li $v0, 1
move $a0, $t5
syscall
li $v0, 11
li $a0, 10
syscall

addi $t1, $t1, -1
j loop_oct_div

end_oct_div:
li $v0, 4
la $a0, msgFinal
syscall
    
addi $t1, $t1, 1
li $v0, 4
move $a0, $t1
syscall
    
li $v0, 11
li $a0, 10
syscall

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

to_hex:
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v0, 4
la $a0, msgHex
syscall

move $t0, $a0
la $t1, buffer_hex
addi $t1, $t1, 8
sb $zero, ($t1)
addi $t1, $t1, -1

loop_hex_div:
beq $t0, $zero, end_hex_div

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgDiv
syscall
li $a0, 16
syscall
la $a0, msgResto
syscall

addi $t3, $t0, 0
li $t4, 16
div $t3, $t4
mflo $t0
mfhi $t5

li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, msgIgualResto
syscall
    
li $t6, 10
blt $t5, $t6, resto_num
    
addi $t6, $t5, 55
j resto_store

resto_num:
addi $t6, $t5, 48

resto_store:
sb $t6, ($t1)
    
li $v0, 1
move $a0, $t5
syscall
li $v0, 11
li $a0, 10
syscall

addi $t1, $t1, -1
j loop_hex_div

end_hex_div:
li $v0, 4
la $a0, msgFinal
syscall
    
addi $t1, $t1, 1
li $v0, 4
move $a0, $t1
syscall
    
li $v0, 11
li $a0, 10
syscall

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

to_bcd:
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v0, 4
la $a0, msgBCD
syscall
    
move $t0, $a0
la $t1, buffer_bcd
li $t2, 10
    
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
    
move $s0, $t0
li $s1, 0
    
loop_bcd_prepare:
div $s0, $t2
mflo $s0
mfhi $s2
    
addi $s2, $s2, 48
addi $sp, $sp, -4
sb $s2, 0($sp)
addi $s1, $s1, 1
    
bgt $s0, $zero, loop_bcd_prepare

loop_bcd_print:
beq $s1, $zero, end_bcd

addi $sp, $sp, 4
lb $t3, 0($sp)
addi $t3, $t3, -48

li $v0, 1
move $a0, $t3
syscall
li $v0, 4
la $a0, msgIgualResto
syscall
    
li $t4, 8
li $t5, 4
    
loop_bcd_bits:
sll $t6, $t3, 0
and $t6, $t6, $t4
bne $t6, $zero, bit_one
li $v0, 11
li $a0, 48
syscall
j next_bit

bit_one:
li $v0, 11
li $a0, 49
syscall

next_bit:
srl $t4, $t4, 1
addi $t5, $t5, -1
bne $t5, $zero, loop_bcd_bits
    
li $v0, 11
li $a0, 32
syscall

addi $s1, $s1, -1
j loop_bcd_print
    
end_bcd:
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $s0, 0($sp)
addi $sp, $sp, 12
    
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

to_comp2:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
li $v0, 4
la $a0, msgC2
syscall

bltz $a0, neg_c2

li $v0, 4
la $a0, msgC2Positivo
syscall
    
move $t0, $a0
li $t1, 16
jal print_16bit_binary
j end_c2

neg_c2:
li $v0, 4
la $a0, msgC2Negativo
syscall
    
li $v0, 4
la $a0, msgC2Mag
syscall
sub $t0, $zero, $a0
li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, newline
syscall
    
li $v0, 4
la $a0, msgC2Bin
syscall
li $t1, 16
move $a0, $t0
jal print_16bit_binary_no_print
move $t0, $s0
    
li $v0, 4
la $a0, msgC2Inv
syscall
li $t1, 0xFFFF0000
nor $t0, $t0, $zero
andi $t0, $t0, 0xFFFF
move $a0, $t0
li $t1, 16
jal print_16bit_binary
    
li $v0, 4
la $a0, msgC2Add1
syscall
addi $t0, $t0, 1
move $a0, $t0
li $v0, 1
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, msgC2Res
syscall
move $a0, $t0
li $t1, 16
jal print_16bit_binary
    
end_c2:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_16bit_binary:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t1
la $t1, buffer_c2
addi $t1, $t1, 15
sb $zero, ($t1)
addi $t1, $t1, -1
    
loop_print_bin:
beq $s0, $zero, end_print_bin
    
andi $t2, $t0, 1
    
addi $t3, $t2, 48
sb $t3, ($t1)
    
srl $t0, $t0, 1
addi $t1, $t1, -1
addi $s0, $s0, -1
j loop_print_bin

end_print_bin:
addi $t1, $t1, 1
li $v0, 4
move $a0, $t1
syscall
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

print_16bit_binary_no_print:
addi $sp, $sp, -4
sw $ra, 0($sp)
    
move $t0, $a0
move $s0, $t0
move $t1, $a0
li $s1, 16
la $t2, buffer_c2
addi $t2, $t2, 15
sb $zero, ($t2)
addi $t2, $t2, -1
    
loop_store_bin:
beq $s1, $zero, end_store_bin
    
andi $t3, $t1, 1
    
addi $t4, $t3, 48
sb $t4, ($t2)
    
srl $t1, $t1, 1
addi $t2, $t2, -1
addi $s1, $s1, -1
j loop_store_bin

end_store_bin:
addi $t2, $t2, 1
li $v0, 4
move $a0, $t2
syscall
li $v0, 4
la $a0, newline
syscall
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra