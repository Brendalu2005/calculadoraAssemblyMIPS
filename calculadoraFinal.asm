.data

strAutor: .asciiz "Brenda Luana Correia Bezerra (Blcb)\n"
strData: .asciiz "Data de Criacao: 30/11/2025\n"
strRevisao1: .asciiz "commit 1 (30/11/2025 - 20:33): Implementacao de Base 2, 8 e 16.\n"
strRevisao2: .asciiz "commit 2:..\n"
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
msgDiv: .asciiz " / "
msgResto: .asciiz " = "
msgIgualResto: .asciiz ", Resto: "
msgFinal: .asciiz "Resultado final: "
msgErro: .asciiz "Opcao invalida.\n"


buffer_bin: .space 33 # 32 bits + null
buffer_hex: .space 9  # 8 hex chars + null
buffer_oct: .space 12 # 11 octal chars + null
zero_char: .asciiz "0"

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

    j loop_menu


to_bin:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, msgBin
    syscall

    move $t0, $a0    
    la $t1, buffer_bin 
    addi $t2, $zero, 31

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

    addi $t1, $t1, 1 
    addi $t2, $t2, -1 
    j loop_bin_div

end_bin_div:
    
    li $t6, 0
    sb $t6, ($t1) 
    
   
    la $t0, buffer_bin
    move $t1, $t0 
    
  
    
    li $v0, 4
    la $a0, msgFinal
    syscall

    
    li $v0, 4
    la $a0, buffer_bin 
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
    addi $t2, $zero, 11 

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

    addi $t1, $t1, 1
    addi $t2, $t2, -1
    j loop_oct_div

end_oct_div:
    li $t6, 0
    sb $t6, ($t1) 
    
    li $v0, 4
    la $a0, msgFinal
    syscall
    li $v0, 4
    la $a0, buffer_oct
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
    addi $t2, $zero, 8

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

    addi $t1, $t1, 1
    addi $t2, $t2, -1
    j loop_hex_div

end_hex_div:
    li $t6, 0
    sb $t6, ($t1) 
    
    li $v0, 4
    la $a0, msgFinal
    syscall
    li $v0, 4
    la $a0, buffer_hex
    syscall
    
    li $v0, 11
    li $a0, 10
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra