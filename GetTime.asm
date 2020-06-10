
GetTime:
	# $t0, $t1, $t2 = d1, m1, y1
	# $t3, $t4, $t5 = d2, m2, y2
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal Day
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t0, $v0, 0 # Lay d1
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal Month
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t1, $v0, 0 # Lay m1
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal Year
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t2, $v0, 0 # Lay y1
	
	
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	addi $a0, $a1, 0
	jal Day
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t3, $v0, 0 # Lay d2
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	addi $a0, $a1, 0
	jal Month
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t4, $v0, 0 # Lay m2
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	addi $a0, $a1, 0
	jal Year
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $t5, $v0, 0 # Lay y2
	
	
	
	slt $t6, $t5, $t2
	beq $t6, $0, NotSwitch # Neu y2 < y1 ma sai thi khong switch 2 ngay
	
	# Doi 2 ngày cho nhau neu y2 < y1
	add $t6, $t3, $0 
	add $t3, $t0, $0
	add $t0, $t6, $0
	
	add $t6, $t4, $0 
	add $t4, $t1, $0
	add $t1, $t6, $0
	
	add $t6, $t5, $0 
	add $t5, $t2, $0
	add $t2, $t6, $0
	
	NotSwitch:
	
	sub $v0, $t5, $t2 # Ket qua luu
	
	beq $v0, $0, Done
	
	slt $t6, $t4, $t1 # m2 < m1
	bne $t6, $0, Minus
	
	bne $t4, $t1, Done
	
	slt $t6, $t3, $t0
	beq $t0, $0, Done
	
	addi $t7, $0, 2 # tao so ðe so sánh
	bne $t4, $t7, Minus
	
	addi $t7, $0, 29
	bne $t0, $t7, Minus
	
	addi $t7, $0, 28
	bne $t3, $t7, Minus
	
	Minus:
	
	sub $v0, $v0, 1
	
	Done:
	
	jr $ra
			
		
		
