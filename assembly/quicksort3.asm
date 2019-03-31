.data

array:		.word 4,7,8,6,10,5,9,3,2,1
size:		.word 40 #array size
spc:		.asciiz " "
nl:		.asciiz "\n"


.text

main:	
	la $t0, array	
	
	addi $a0, $zero, 0 #l = 0
	lw $a1, size       #r = 40
	
	jal quicksort
	
	jal print_array
		
end:	li $v0, 10
	syscall
		
				
		
quicksort:
	bge $a0,$a1 retq
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	 
	sw $a0, 4($sp) #l
	sw $a1, 8($sp) #r
	
	jal partition
	
	lw $a0, 4($sp)    #l = 0 
	addi $a1, $v1, -4 #r = p-1
	sw $v1, 12($sp)   #p
	
	jal quicksort # < p
	
	lw $a0, 12($sp)  #l
	addi $a0, $a0, 4 #l = p+1
	lw $a1, 8($sp)   #r = size
	
	jal quicksort # > p
	
	lw $ra, 0($sp)
	addi $sp $sp 16
	
retq:	jr $ra
	
					
		
partition:
	move $s0, $a0 #p = l
	move $s1, $a1 #r
	move $s2,$s0
ploop:	addi $s2,$s2,4 #i
	lw $s4, array($s0) #p value
	bgt $s2,$s1 retp #l >= r
	lw $s5, array($s2) #carrega o próximo da lista
	blt $s5,$s4, less #próximo < p_val
	j ploop
less:	addi $s6,$s0,4 #index depois de p
	lw $s7, array($s6)
	sw $s4, array($s6)
	sw $s7, array($s0)
	beq $s6, $s2, next #p igual i -> [7] 5< |  5 [7]<
	sw $s7, array($s2)
	sw $s5, array($s0) #  [7] 8 5< | 8 [7] 5< | 5 [7] 8<
next:	move $s0, $s6 #atualiza p 
	j ploop
retp:   move $v1,$s0 #return
	addi $s2, $zero, 0	
	jr $ra	
	
	
	
print_array:

	lw $t1,size
	addi $t2,$zero,0 #i
	
prloop:	bge $t2,$t1 retpa
	
	li $v0, 1
	lw $a0, array($t2)
	syscall
	
	li $v0, 4
	la $a0, spc
	syscall
	
	addi $t2, $t2, 4
	j prloop
	
retpa:	jr $ra
