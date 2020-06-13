.data
	tb1: .asciiz "Nhap year: "
	tb2: .asciiz "KQ: "
	str: .space 100
	kq1: .word 0
	kq2: .word 0
.text
	#xuat tb1
	li $v0,4
	la $a0,tb1
	syscall

	#Nhap chuoi
	li $v0,8
	la $a0,str
	li $a1,100
	syscall
	
	#Luu $v0 vao str
	sw $v0,kq1
	sw $v1,kq2
	#goi ham
	jal NearestLeapYear
	
	#Lay ket qua tra ve
	sw $v0,kq1
	sw $v1,kq2

	#xuat tb2
	li $v0,4
	la $a0,tb2
	syscall

	#xuat kq
	li $v0,1
	lw $a0,kq1
	syscall

	#xuat tb2
	li $v0,4
	la $a0,tb2
	syscall

	#xuat kq
	li $v0,1
	lw $a0,kq2
	syscall
	
	#ket thuc
	li $v0,10
	syscall
#----------------------------------------
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

	
	#------------------------------------------------------------

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
	sw $a0, 0($sp)
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
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
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
	bne $t0, $zero, isNotLeapYear # t0 != 0 -> khong phai nam nhuan
	addi $t0, $zero, 100 # t0 = 100
	div $a0, $t0 
	mfhi $t0 # t0 = year % 100
	beq $t0, $zero, isNotLeapYear # t0 == 0 -> khong phai nam nhuan vi chia het cho 4 & chia het cho 100
isLeapYear:
	addi $v0, $zero, 1
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
isNotLeapYear:
	addi $v0, $zero, 0
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra


# ====== Ham Tim 2 Nam Nhuan Gan Nhat ===========
# pair<int, int> NearestLeapYear(char* TIME)
# Tra ve: 2 nam nhuan gan nhat ($v0, $v1)
# Tham so: $a0: dia chi chuoi TIME

NearestLeapYear:
# Dau thu tuc 
	addi $sp, $sp, -20 # khai bao kich thuoc stack
	sw $ra, 16($sp) 
	sw $a0, 12($sp) 
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
# Than thu tuc
	# Get year from TIME
	lw $a0, 12($sp)
	jal Year
	#lw $s0, 0($sp)
	add $s0, $v0, $0 # luu lai gia tri YEAR
	
	subi $s1, $s0, 1 # luu gia tri buoc nhay NAM back
	addi $s2, $s0, 1 # luu gia tri buoc nhay NAM next
	sw $a0, 12($sp) 
NearestLeapYear_back:
	add $a0, $s1, $0
	jal CheckLeapYear
	bne $v0, $zero, NearestLeapYear_next # neu la nam nhuan
	subi $s1, $s1, 1 # giám t0 len 1
	j NearestLeapYear_back

NearestLeapYear_next:
	add $a0, $s2, $0
	jal CheckLeapYear
	bne $v0, $zero, returnLeapYear # neu la nam nhuan
	addi $s2, $s2, 1
	j NearestLeapYear_next

returnLeapYear:
	add $v0, $s1, $0
	add $v1, $s2, $0

# Cuoi thu tuc
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $a0, 12($sp) 
	lw $ra, 16($sp) 
	addi $sp, $sp, 20
	jr $ra