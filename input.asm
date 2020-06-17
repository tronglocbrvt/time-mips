.data
	inputDay: .asciiz "\nNhap ngay DAY: "
	inputMonth: .asciiz "\nNhap thang MONTH: "
	inputYear: .asciiz "\nNhap nam YEAR: "
	msgNotValid: .asciiz "\nKhong hop le!\n"
	msgValid: .asciiz "\nHop le!\n"
	Time: .space 100
	Temp: .space 100
.text 
main:
inputMain:
	la $a0, Time
	la $a1, Temp
	jal inputTime
	add $s0, $v0, $zero
	add $s1, $v1, $zero
	beq $s0, $zero, inputMainAgain
	# cho nay goi Menu, nhung chua co Menu nen goi tam msgValid
	la $a0, msgValid
	addi $v0, $zero, 4	
	syscall
	
# Ham main nhap lai time khi khong hop le
inputMainAgain:
	la $a0, msgNotValid
	addi $v0, $zero, 4	
	syscall
	j inputMain
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
# ====== Ham Xuat Chuoi Theo Dinh Dang Mac Dinh DD/MM/YYYY ===========
# char* Date(int day, int month, int year, char* TIME)
# Tra ve: dia chi chuoi TIME ($v0)
# Tham so: $a0: day, $a1: month, $a2: year, $a3: dia chi chuoi TIME

Date:
	# Dau thu tuc 
	addi $sp, $sp, -4 # khai bao kich thuoc stack
	sw $ra, 0($sp) 
	
	# Than thu tuc
	# chuyen int Day -> chuoi Day
	addi $t0, $zero, 10 # t0 = 10 (vi day chi co 2 chu so)
	div $a0, $t0
	mflo $t1 # lay phan nguyen luu vao t1
	mfhi $t2  # lay phan du luu vao t2
	
	# chuyen sang ky tu -> cong them 48 ( '0' )
	addi $t1, $t1, 48
	addi $t2, $t2, 48
	# add them ky tu '/'
	addi $t3, $zero, 47
	
	# luu du lieu tu thanh ghi vao bo nho
	sb $t1, 0($a3)		
	sb $t2, 1($a3)	
	sb $t3, 2($a3)	
	
	# chuyen int Month -> chuoi Month
	addi $t0, $zero, 10 # t0 = 10 (vi month chi co 2 chu so)
	div $a1, $t0
	mflo $t1 # lay phan nguyen luu vao t1
	mfhi $t2  # lay phan du luu vao t2
	
	# chuyen sang ky tu -> cong them 48 ( '0' )
	addi $t1, $t1, 48
	addi $t2, $t2, 48
	# add them ky tu '/'
	addi $t3, $zero, 47
	
	# luu du lieu tu thanh ghi vao bo nho
	sb $t1, 3($a3)		
	sb $t2, 4($a3)	
	sb $t3, 5($a3)
	
	# chuyen int Year -> chuoi Year
	addi $t0, $zero, 1000 # t0 = 1000 (vi year co 4 chu so)
	div $a2, $t0
	mflo $t1 # lay phan nguyen luu vao t1
	mfhi $t2  # lay phan du luu vao t2
	
	# chuyen sang ky tu -> cong them 48 ( '0' )
	addi $t1, $t1, 48 # chuyen phan nguyen, con phan du chia tiep
	
	# luu du lieu tu thanh ghi vao bo nho
	sb $t1, 6($a3)		
	
	addi $t0, $zero, 100 # t0 = 100
	div $t2, $t0
	mflo $t1 # lay phan nguyen luu vao t1
	mfhi $t2  # lay phan du luu vao t2
	
	# chuyen sang ky tu -> cong them 48 ( '0' )
	addi $t1, $t1, 48 # chuyen phan nguyen, con phan du chia tiep
	
	# luu du lieu tu thanh ghi vao bo nho
	sb $t1, 7($a3)
	
	addi $t0, $zero, 10 # t0 = 10
	div $t2, $t0
	mflo $t1 # lay phan nguyen luu vao t1
	mfhi $t2  # lay phan du luu vao t2
	
	# chuyen sang ky tu -> cong them 48 ( '0' )
	addi $t1, $t1, 48 # chuyen phan nguyen
	addi $t2, $t2, 48 # chuyen phan du
	
	# luu du lieu tu thanh ghi vao bo nho
	sb $t1, 8($a3)
	sb $t2, 9($a3)
	
	# Cuoi thu tuc 
	lw $ra, 0($sp)
	addi $sp, $sp, 4 
	jr $ra
# ====== Ham Kiem Tra La So =========== 
# bool isDigit (char* temp)
# Tham so: chuoi ky tu ($a0)
# Tra ve $v0: 1 neu $a0 toan la so, 0 neu $a0 khong toan la so
isDigit:
	# Dau thu tuc
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $t0, 8($sp)
	sw $t1, 4($sp)
	sw $t2, 0($sp)
	# Than thu tuc
	add $t0, $a0, $zero # t0 = a0
	addi $v0, $zero, 1 # mac dinh la hop le
	
	isDigit.Loop:
	lb $t1, 0($t0)
	# Dieu kien thoat lap
	addi $t2, $zero, 10 # ky tu xuong dong
	beq $t1, $t2, isDigit.Exit
	
	beq $t1, $zero, isDigit.Exit # ky tu ket thuc chuoi
	
	# kiem tra tung ky tu
	slti $t2, $t1, 48 # $t1 < '0'
	bne $t2, $zero, isNotDigit  # Neu < '0' -> false
	
	slti $t2, $t1, 58 # $t0 < '9'
	beq $t2, $zero, isNotDigit # Neu > '9' -> false
	
	addi $t0, $t0, 1 # Tang t0 len 1
	j isDigit.Loop
	j isDigit.Exit
isNotDigit:
	add $v0, $zero, $zero
isDigit.Exit:
	lw $t2, 0($sp)
	lw $t1, 4($sp)
	lw $t0, 8($sp)
	lw $a0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

# ====== Ham Input TIME ===========
# bool inputTime(char* TIME, char* temp)
# Tra ve: 0 (khong hop le) hoac 1 (hop le) ($v0), $v1: dia chi cua TIME
# Tham so: chuoi TIME ($a0), temp ($a1)

inputTime:
	# Dau thu tuc
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	add $s0, $a0, $0
	add $s1, $a1, $0
	# add $t0, $zero, $zero # bien tam de kiem tra tinh trang so lan nhap DAY, MONTH, YEAR toan la so
	# Than thu tuc
	# Nhap chuoi ngay
	addi $v0, $zero, 4	
	la $a0, inputDay
	syscall # in ra man hinh thong bao nhap DAY
	
	addi $v0, $zero, 8	
	add $a0, $s1, $zero # a0 = s1
	addi $a1, $zero, 100
	syscall # Nhap ngay
	
	jal isDigit
	add $t0, $v0, $zero
	beq $v0, $zero, NhapMonth
	jal atoi
	add $t1, $v0, $zero # t1 = gia tri Day o dang int
NhapMonth:	
	# Nhap chuoi thang
	addi $v0, $zero, 4	
	la $a0, inputMonth
	syscall # in ra man hinh thong bao nhap MONTH
	
	addi $v0, $zero, 8	
	add $a0, $s1, $zero # a0 = s1
	addi $a1, $zero, 100
	syscall # Nhap thang
	
	jal isDigit
	add $t0, $t0, $v0
	beq $v0, $zero, NhapYear
	jal atoi
	add $t2, $v0, $zero # t2 = gia tri Month o dang int
NhapYear:	
	# Nhap chuoi nam
	addi $v0, $zero, 4	
	la $a0, inputYear
	syscall # in ra man hinh thong bao nhap YEAR
	
	addi $v0, $zero, 8	
	add $a0, $s1, $zero # a0 = s1
	addi $a1, $zero, 100
	syscall # Nhap nam
	
	jal isDigit
	add $t0, $t0, $v0
	beq $v0, $zero, inputTime.check
	jal atoi
	add $t3, $v0, $zero # t3 = gia tri Year o dang int
inputTime.check:
	addi $t4, $zero, 3 # t4 = 3
	bne $t0, $t4, notValidDate # t0 != 3
	
	# Kiem tra ngay thang nam theo logic tung ngay thang nam
	add $a0, $t1, $zero
	add $a1, $t2, $zero
	add $a2, $t3, $zero
	add $a3, $s1, $zero
	jal checkValid
	
	beq $v0, $zero, notValidDate
	addi $v0, $zero, 1
	jal Date
	j inputTime.exit

notValidDate:
	add $v0, $zero, $zero
inputTime.exit:
	add $v1, $s0, $zero
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $a1, 8($sp)
	lw $a0, 12($sp)
	lw $ra, 16($sp)
	
	addi $sp, $sp, 20
	jr $ra
	
# ====== Ham Chuyen Ky Tu Sang So Nguyen ===========
# int atoi (char* temp);
# Tra ve: so nguyen $v0
# Tham so: chuoi temp ($a0)

		
atoi:
	# Dau thu tuc
	addi $sp, $sp, -16

	sw $ra, 12($sp)
	sw $t0, 8($sp)
	sw $t1, 4($sp)
	sw $t2, 0($sp)
	# Than thu tuc:
	add $v0, $zero, $zero
	add $t0, $a0, $zero
atoi.loop:
	# Kiem tra truong hop chuoi rong
	lb $t1, 0($t0)				
	beq $t1, $zero, atoi.exit	
	
	addi $t2, $zero, 10
	beq $t1, $t2, atoi.exit		
	mult $v0, $t2
	mflo $v0		
	addi $t1, $t1, -48	
	add $v0, $v0, $t1	
	addi $t0, $t0, 1		
	j atoi.loop

atoi.exit:
	lw $t2, 0($sp)
	lw $t1, 4($sp)
	lw $t0, 8($sp)
	lw $ra, 12($sp)

	addi $sp, $sp, 16
	jr $ra
# ====== Ham Kiem Tra Ngay Thang Nam ===========
# bool checkValid(int Day, int Month, int Year)
# Tra ve: 0 (khong hop le) hoac 1 (hop le) ($v0)
# Tham so: $a0: Day, $a1: Month, $a2: Year

checkValid:
	# Dau thu tuc
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	
	# Than thu tuc
	slti $t0, $a1, 13 
	beq $t0, $zero, notValid # if month >= 13
	
	slti $t0, $a1, 1
	bne $t0, $zero, notValid # if month < 1
	
	# Kiem tra Ngay
	addi $t0, $zero, 1 # month = 1
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 2 # month = 2
	beq $a1, $t0, CheckThang2
	
	addi $t0, $zero, 3 # month = 3
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 4 # month = 4
	beq $a1, $t0, Check30Days
	
	addi $t0, $zero, 5 # month = 5
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 6 # month = 6
	beq $a1, $t0, Check30Days
	
	addi $t0, $zero, 7 # month = 7
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 8 # month = 8
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 9 # month = 9
	beq $a1, $t0, Check30Days
	
	addi $t0, $zero, 10 # month = 10
	beq $a1, $t0, Check31Days
	
	addi $t0, $zero, 11 # month = 11
	beq $a1, $t0, Check30Days
	
	addi $t0, $zero, 12 # month = 12
	beq $a1, $t0, Check31Days

Check30Days:
	slti $t0, $a0, 1
	bne $t0, $zero, notValid # if day < 1
	
	slti $t0, $a0, 31
	beq $t0, $zero, notValid # if day >= 31
	
	j valid
Check31Days:
	slti $t0, $a0, 1
	bne $t0, $zero, notValid # if day < 1
	
	slti $t0, $a0, 32
	beq $t0, $zero, notValid # if day >= 32
	
	j valid
CheckThang2:
	slti $t0, $a0, 1
	bne $t0, $zero, notValid # if day < 1
	
	slti $t0, $a0, 30
	beq $t0, $zero, notValid # if day >= 30
	
	add $a0, $a2, $zero # a0 = nam
	jal CheckLeapYear
	
	beq $v0, $zero, NotLeapYear # nam khong nhuan
	j valid
NotLeapYear: 
	addi $t0, $zero, 29 # day = 29
	beq $a0, $t0, notValid # khong hop le
	j valid
notValid:
	addi $v0, $zero, 0
	j checkValid.exit
valid:
	addi $v0, $zero, 1
	j checkValid.exit
checkValid.exit:
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $a0, 8($sp)
	lw $ra, 12($sp)
	
	addi $sp, $sp, 16
	jr $ra
	
