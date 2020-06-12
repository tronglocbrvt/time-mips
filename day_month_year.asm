#$a0 str
#$v0 int
StrToInt:
	add $v0, $0, $0
	add $t0, $a0, $a1	# t0 = p, p = str + a0 (vi tri bat dau cua str)
	add $t1, $a0, $a2	# t1 = str + a1
	addi $t1, $t1, 1	# t1 = str + a1 + 1 (vi tri ket thuc cua str)
StrToIntLoop:
	slt $t2, $t0, $t1
	beq $t2, $0, StrToIntExit # neu p = 0 (chuoi rong) thi exit
	# num += n[i] * 10^(n-j)
	addi $t3, $0, 10
	mult $v0, $t3
	mflo $v0		# v0 = v0 * 10
	lb $t3, 0($t0)		# t3 = *p
	addi $t3, $t3, -48	# *p = *p - 48 ('0'=48)
	add $v0, $v0, $t3	# v0 = v0 + *p
	addi $t0, $t0, 1	# p = p + 1
	j StrToIntLoop
StrToIntExit:
	jr $ra

# Day
# $a0 kieu chuoi time
# $v0 tra ve day 
Day:
	# dung stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Day la 2 bit dau cua time(time(0), time(1))
	add $a1, $0, $0
	addi $a2, $0, 1
	jal StrToInt

	# lay ket qua v0 tu stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# Month
# $a0 kieu chuoi time
# $v0 tra ve month
Month:
	# dung stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Month la bit thu 3, 4 cua time(time(3), time(4))
	addi $a1, $0, 3
	addi $a2, $0, 4
	jal StrToInt

	# lay ket qua v0 tu stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# Year
# $a0 kieu chuoi time
# $v0 tra ve year
Year:
	# dung stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Year la bit thu 6 den thu 9 cua time
	addi $a1, $0, 6
	addi $a2, $0, 9
	jal StrToInt

	# lay ket qua v0 tu stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
