.data
	months:  .word 0,3,3,6,1,4,6,2,5,0,3,5
	leapMonths: .word 6,2,3,6,1,4,6,2,5,0,3,5
	
	Sun: .asciiz "Sun"
	Mon: .asciiz "Mon"
	Tues: .asciiz "Tues"
	Wed: .asciiz "Wed"
	Thurs: .asciiz "Thurs"
	Fri: .asciiz "Fri"
	Sat: .asciiz "Sat"
	
	days: .word Sun, Mon, Tues, Wed, Thurs, Fri, Sat
.text

	main: 
		jal Weekday

	li $v0, 10
	syscall

	Weekday:		
		addi $t0, $0, 11
		addi $t1, $0, 2
		addi $t2, $0, 2018
		# $t0, $t1, $t2 = d, m, y
		
		# Tinh m
		addi $t1, $t1, -1 # offset m cho dung voi array
		
		#tinh leap year
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		jal LeapYear
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		
		beq $v0, $0, NotLeap
		# m = LeapMonths[m]
		la $t3, leapMonths
		sll $t1, $t1, 2
		add $t4, $t3, $t1
		lw $t1, 0($t4)	
		j Out1
		
		NotLeap:
		# m = months[m]
		la $t3, months
		sll $t1, $t1, 2
		add $t4, $t3, $t1
		lw $t1, 0($t4)		

		Out1:
		
		div $t2, $t2, 100
		mfhi $t3 # c luu vao $t4
		
		
		
		addi $t5, $t5, 0
		add $t5, $t0, $t1
		add $t5, $t5, $t2
		div $t2, $t2, 4 # y = y/4
		add $t5, $t5, $t2
		add $t5, $t5, $t3
		
		div $t5, $t5, 7
		mfhi $t6
		
		# Tim ngay tu $t6
		la $t7, days
		sll $t6, $t6, 2
		add $t6, $t6, $t7
		lw $t1, 0($t6)
	
		
		addi $v0, $t1, 0		
		jr $ra
		