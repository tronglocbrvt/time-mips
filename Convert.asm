.data
	TIME: .space 120
	newline: .byte '\n'
	date: .asciiz "12/04/2017"
	January: .asciiz "January"
	February: .asciiz "February"
	March: .asciiz "March"
	April: .asciiz "April"
	May: .asciiz "May"
	June: .asciiz "June"
	July: .asciiz "July"
	August: .asciiz "August"
	September: .asciiz "September"
	October: .asciiz "October"	
	November: .asciiz "November"
	December: .asciiz "December"
	MonthNames: .word January, February, March, April, May, June, July, August, September, October, November, December 

.text
la $a0, date
la $s0, TIME

loop:
lb $t0, 0($a0)
beq $t0, $0, out
sb $t0, 0($s0)
addi $a0, $a0, 1
addi $s0, $s0, 1
j loop
out:
sb $0, 0($s0)

la $a0, TIME

addi $a1, $0, 'C'

jal Convert

addi $v0, $0, 4
syscall


addi $v0, $0, 10
syscall




Convert:
	addi $t8, $a0, 0
	addi $t7, $0, '\n'
	addi $t6, $0, ' ' # $t6 la khoang trang
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	# Luu DD vao $s1-2
	lb $s0, 0($a0)
	lb $s1, 1($a0)
	
	addi $t0, $0, 'A'
	beq $a1, $t0, A 
	
	# Neu toi buoc nay thi phai tinh ra ten Month
	addi $t0, $ra, 0
	#jal Month
	addi $ra, $t0, 0
	
	#-----------------TEST-------
	addi $v0, $0, 4
	
	addi $v0, $v0, -1 # Tru di 1 de cho dung index voi array

	sll $v0, $v0, 2
	la $t2, MonthNames
	add $t2, $t2, $v0
	lw $t3, 0($t2) # Luu ten thang vao $t3
		
	
	# Luu YYYY vao $s3-6
	lb $s3, 6($a0)
	lb $s4, 7($a0)
	lb $s5, 8($a0)
	lb $s6, 9($a0)

	addi $t0, $0, 'B'
	beq $a1, $t0, B 
	addi $t0, $0, 'C'
	beq $a1, $t0, C 
	
	A:
	# Luu MM vao $t1-2
	lb $t0, 3($a0)
	lb $t1, 4($a0)
	
	# Load MM DD
	sb $s0, 3($a0)
	sb $s1, 4($a0)
	sb $t0, 0($a0)
	sb $t1, 1($a0)
	j Out
	
	B:
	 
	Loop:	
	lb $t0, 0($t3)
	beq $t0, $0, OutLoop
	beq $t0, $7, OutLoop
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j Loop
	OutLoop:
	sb $t6, 0($a0)
	sb $s0, 1($a0)
	sb $s1, 2($a0)
	addi $t0, $0, ','
	sb $t0, 3($a0)
	sb $t6, 4($a0)
	
	#Load year
	sb $s3, 5($a0)
	sb $s4, 6($a0)
	sb $s5, 7($a0)
	sb $s6, 8($a0)
	sb $0, 9($a0)
	
	j Out
	C:
	sb $s0, 0($a0)
	sb $s1, 1($a0)
	sb $t6, 2($a0)
	addi $a0, $a0, 3
	LoopC:	
	lb $t0, 0($t3)
	beq $t0, $0, OutLoopC
	beq $t0, $7, OutLoopC
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j LoopC
	OutLoopC:
	
	addi $t0, $0, ','
	sb $t0, 0($a0)
	sb $t6, 1($a0)
	
	#Load year
	sb $s3, 2($a0)
	sb $s4, 3($a0)
	sb $s5, 4($a0)
	sb $s6, 5($a0)
	sb $0, 6($a0)
	j Out
	
	Out:
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
	addi $a0, $t8, 0
	addi $v0, $t8, 0
	jr $ra
		
