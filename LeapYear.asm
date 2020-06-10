# ====== Ham Kiem Tra Nam Nhuan ===========
# int LeapYear(char* TIME)
# Tra ve: 0 (khong phai nam nhuan) hoac 1 (la nam nhuan) ($v0)
# Tham so: chuoi TIME ($a0)

LeapYear: 
	# Dau thu tuc 
	addi $sp, $sp, -8 # khai bao kich thuoc stack
	sw $ra, 4($sp) 
	sw $a0, 0($sp)
	
	# Than thu tuc
	# lay nam
	lw $a0, 0($sp)
	jal Year # nhay den nhan Year de lay nam
	
	# kiem tra nam nhuan 
	add $a0, $v0, $zero # $a0 = year
	jal CheckLeapYear # nhay den nhan CheckLeapYear (Kiem tra nam nhuan voi tham so la nam)
	
	# Return 
	add $v0, $v0, $zero 
	
	# Cuoi thu tuc
	# Restore thanh ghi
	lw $a0, 0($sp) 
	lw $ra, 4($sp)
	# Xoa Stack
	addi $sp, $sp, 8
	# quay ve
	jr $ra

# Kiem tra nam nhuan chi voi nam 
# nam nhuan <=> chia het cho 400 hoac chia het cho 4 nhung khong chia het cho 100
CheckLeapYear:
	addi $t0, $zero, 400 # t0 = 400
	div $a0, $t0 
	mfhi $t0 # t0 = year % 400
	
	# if (year % 400 == 0) v0 = 1;
	beq $t0, $zero, isLeapYear
	# else if (year % 4 == 0)
	# 	if (year % 100 != 0) 
	# 		v0 = 1;
	addi $t0, $zero, 4 # t0 = 4
	div $a0, $t0 
	mfhi $t0 # t0 = year % 4
	
isLeapYear:
	addi $v0, $v0, 1
	jr $ra

