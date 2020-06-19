.data
	TIME_1: .space 120
	TIME_2: .space 120
	
	inputDay: .asciiz "Nhap ngay DAY: "
	inputMonth: .asciiz "Nhap thang MONTH: "
	inputYear: .asciiz "Nhap nam YEAR: "
	continue: .asciiz "\nNeu muon tiep tuc thi nhan Y: "
	msgNotValid: .asciiz "Khong hop le!\n"
	Temp: .space 100

	#data cho ham convert
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

	#data cho ham weekday
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

	#data cho ham main
	khoangTrang: .asciiz " "
	tbLuaChon: .asciiz "Lua chon: "
	tbDinhDang: .asciiz "Nhap loai dinh dang (A-B-C): "
	tb1: .asciiz "Ket Qua: "
	
	tb2: .asciiz "----Ban hay chon 1 trong cac thao tac duoi day------\n1. Xuat chuoi TIME theo dinh day DD/MM/YYYY\n"
	tb3: .asciiz "2. Chuyen doi chuoi TIME thanh 1 trong cac dinh dang sau:\n\tA. MM/DD/YYYY\n\tB. Month DD, YYYY\n\tC. DD Month, YYYY\n"
	tb4: .asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan\n4. Kiem tra nam trong chuoi TIME co phai la nam nhuan hay khong\n"
	tb5: .asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n6. Cho biet 2 nam nhuan gan nhat trong chuoi TIME\n--------------------------------------------\n"
.text

#------------------main function---------------
main:
	la $a0, Temp
	la $a1, TIME_1
	jal inputMain
	
	# Xuat menu cac lua chon
	addi $v0,$zero, 4
	la $a0, tb2
	syscall
	
	addi $v0,$zero, 4
	la $a0,tb3
	syscall
	
	addi $v0,$zero, 4
	la $a0,tb4
	syscall
	
	addi $v0,$zero, 4
	la $a0,tb5
	syscall
	
	addi $v0,$zero, 4
	la $a0,tbLuaChon
	syscall
	
	# Nhap lua chon
	addi $v0, $zero,5
	syscall
	add $s0, $v0, 0 # luu gia tri nhap
	
	MainLoop:
	# So sanh lua chon va thuc hien chuc nang
	addi $t0, $zero, 1
	beq $s0, $t0, XuatChuoi_1	
	
	addi $t0, $zero, 2
	beq $s0, $t0, Convert_2
	
	addi $t0, $zero, 3
	beq $s0, $t0, WeekDay_3
	
	addi $t0, $zero, 4
	beq $s0, $t0, LeapYear_4
	
	addi $t0, $zero, 5
	beq $s0, $t0, GetTime_5
	
	addi $t0, $zero, 6
	beq $s0, $t0, NearLeap_6
	
	XuatChuoi_1:
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	addi $v0, $zero ,4
	la $a0, TIME_1
	syscall
	j OutMainLoop
	
	Convert_2:
	addi $v0, $zero, 4
	la $a0,tbDinhDang
	syscall
	
	la $a0, Temp
	addi $a1, $zero, 10
	addi $v0, $zero, 8
	syscall
	
	# Chuyen dinh dang thanh char va luu vao $a1
	lb $a1, 0($a0)	
	la $a0, TIME_1
	
	jal Convert
	
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	addi $v0, $zero ,4
	la $a0, TIME_1
	syscall
	
	j OutMainLoop
	
	WeekDay_3:
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	la $a0, TIME_1
	jal Weekday
	
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall
	
	j OutMainLoop
	
	LeapYear_4:
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	la $a0, TIME_1
	jal LeapYear
	
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	
	j OutMainLoop
	
	GetTime_5:
	#Goi ham nhap va luu vao TIME_2
	la $a0, Temp
	la $a1, TIME_2
	jal inputMain
	
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	la $a0, TIME_1
	la $a1, TIME_2
	
	jal GetTime
	
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	
	j OutMainLoop
	
	
	NearLeap_6:
	addi $v0, $zero, 4
	la $a0,tb1
	syscall
	
	la $a0, TIME_1
	jal NearestLeapYear
	
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	
	addi $v0,$zero, 4
	la $a0, khoangTrang
	syscall
	
	addi $a0, $v1, 0
	addi $v0, $zero, 1
	syscall
	
	j OutMainLoop
	
	OutMainLoop:
	addi $v0, $zero, 4
	la $a0, continue
	syscall	

	la $a0, Temp
	addi $a1, $zero, 10
	addi $v0, $zero, 8
	syscall
	
	# Chuyen dinh dang thanh char va luu vao $t0
	lb $t0, 0($a0)
	
	addi $t1, $zero, 'Y'
	
	beq $t0, $t1, main
	
	addi $v0, $zero, 10
	syscall
	
#------------------inputMain function---------------
inputMain:
	# Dau thu tuc
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# Than thu tuc
	jal inputTime
	add $s0, $v0, $zero
	add $s1, $v1, $zero
	beq $s0, $zero, inputMainAgain
	# Cuoi thu tuc
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	# Tra ve
	jr $ra
	
#------------------inputMainAgain function---------------
# Ham main nhap lai time khi khong hop le
inputMainAgain:
	la $a0, msgNotValid # in ra thong bao khong hop le
	addi $v0, $zero, 4	
	syscall
	j inputMain
#------------------StrToInt function---------------
# Tham so: $a0 str
#Tra ve: $v0 int
StrToInt:
	add $v0, $zero, $zero
	add $t0, $a0, $a1	# t0 = p, p = str + a0 (vi tri bat dau cua str)
	add $t1, $a0, $a2	# t1 = str + a1
	addi $t1, $t1, 1	# t1 = str + a1 + 1 (vi tri ket thuc cua str)
	
	StrToIntLoop:
	slt $t2, $t0, $t1
	beq $t2, $zero, StrToIntExit # neu p = 0 (chuoi rong) thi exit
	# num += n[i] * 10^(n-j)
	addi $t3, $zero, 10
	mult $v0, $t3
	mflo $v0		# v0 = v0 * 10
	lb $t3, 0($t0)		# t3 = *p
	addi $t3, $t3, -48	# *p = *p - 48 ('0'=48)
	add $v0, $v0, $t3	# v0 = v0 + *p
	addi $t0, $t0, 1	# p = p + 1
	j StrToIntLoop
	
	StrToIntExit:
	jr $ra	
#------------------Day-Month-Year-function---------------
# int Day(char* TIME)
# Tham so: $a0: chuoi time
# Tra ve: $v0: day 
Day:
	# Dau thu tuc
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)

	# Day la 2 bit dau cua time(time(0), time(1))
	add $a1, $zero, $zero
	addi $a2, $zero, 1
	jal StrToInt
	
	add $v0, $v0, $zero
	# Cuoi thu tuc
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	# Tra ve
	jr $ra
	
# int Month (char* TIME)
# Tham so: $a0: chuoi time
# Tra ve: $v0: month
Month:
	# Dau thu tuc
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)

	# Month la bit thu 3, 4 cua time(time(3), time(4))
	addi $a1, $zero, 3
	addi $a2, $zero, 4
	jal StrToInt

	add $v0, $v0, $zero
	# Cuoi thu tuc
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	# Tra ve
	jr $ra
	
# int Year (char* TIME)
# Tham so: $a0: chuoi time
# Tra ve: $v0: year
Year:
	# Dau thu tuc
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)

	# Year la bit thu 6 den thu 9 cua time
	addi $a1, $zero, 6
	addi $a2, $zero, 9
	jal StrToInt

	add $v0, $v0, $zero
	# Cuoi thu tuc
	lw $a2, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	# Tra ve
	jr $ra

#----------------Convert function------------------------------
# char* Convert(char* TIME, char type)
# Tham so: $a0: chuoi TIME; $a1: loai dinh dang (A-B-C)
# Tra ve: $v0: dia chi chuoi TIME
Convert:
	addi $t8, $a0, 0
	addi $t7, $zero, '\n'
	addi $t6, $zero, ' ' # $t6 la khoang trang
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
	
	addi $t0, $zero, 'A'
	beq $a1, $t0, A 
	
	# Neu toi buoc nay thi phai tinh ra ten Month
	addi $sp, $sp, -4
	sw $ra, 28($sp)
	jal Month
	lw $ra, 28($sp)
	addi $sp, $sp, 4
	
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

	addi $t0, $zero, 'B'
	beq $a1, $t0, B 
	addi $t0, $zero, 'C'
	beq $a1, $t0, C 
	
	A: # dinh dang MM/DD/YYYY
	# Luu MM vao $t1-2
	lb $t0, 3($a0)
	lb $t1, 4($a0)
	
	# Load MM DD
	sb $s0, 3($a0)
	sb $s1, 4($a0)
	sb $t0, 0($a0)
	sb $t1, 1($a0)
	j Out
	
	B: # Dinh dang Month DD, YYYY
	
	# Luu ten thang
	Loop:	
	lb $t0, 0($t3) 
	beq $t0, $zero, OutLoop
	beq $t0, $7, OutLoop
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j Loop
	OutLoop:
	sb $t6, 0($a0)
	sb $s0, 1($a0)
	sb $s1, 2($a0)
	addi $t0, $zero, ','
	sb $t0, 3($a0)
	sb $t6, 4($a0)
	
	#Load year
	sb $s3, 5($a0)
	sb $s4, 6($a0)
	sb $s5, 7($a0)
	sb $s6, 8($a0)
	sb $zero, 9($a0)
	
	j Out
	
	C: # Dinh dang DD Month, YYYY

	sb $s0, 0($a0)
	sb $s1, 1($a0)
	sb $t6, 2($a0)
	addi $a0, $a0, 3
	LoopC:	
	lb $t0, 0($t3)
	beq $t0, $zero, OutLoopC
	beq $t0, $7, OutLoopC
	sb $t0, 0($a0)
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j LoopC
	OutLoopC:
	
	addi $t0, $zero, ','
	sb $t0, 0($a0)
	sb $t6, 1($a0)
	
	#Load year
	sb $s3, 2($a0)
	sb $s4, 3($a0)
	sb $s5, 4($a0)
	sb $s6, 5($a0)
	sb $zero, 6($a0)
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
		

#------------------Date Function----------------------------
# char* Date(int day, int month, int year, char* TIME) - xuat dinh dang DD/MM/YYYY
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
	add $v0, $a3, $zero
	# Cuoi thu tuc 
	lw $ra, 0($sp)
	addi $sp, $sp, 4 
	jr $ra
	
#-------------------LeapYear Function---------------------------
# int LeapYear(char* TIME) - Kiem tra nam nhuan
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

#-------------------CheckLeapYear Function---------------------------
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

#-----------------GetTime Function-----------------------------
# int GetTime(char* TIME_1, char* TIME_2)
# Tham so: $a0: chuoi TIME_1, $a1: chuoi TIME_2
# Tra ve: $v0: khoang cach nam giua 2 TIME (>=0)
GetTime:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	# $s0, $s1, $s2 = d1, m1, y1
	# $s3, $s4, $s5 = d2, m2, y
	
	addi $sp, $sp, -12
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	jal Day
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s0, $v0, 0 # Lay d1
	
	addi $sp, $sp, -8
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	jal Month
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s1, $v0, 0 # Lay m1
	
	addi $sp, $sp, -8
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	jal Year
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s2, $v0, 0 # Lay y1
	
	
	
	addi $sp, $sp, -8
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	addi $a0, $a1, 0
	jal Day
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s3, $v0, 0 # Lay d2
	
	addi $sp, $sp, -8
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	addi $a0, $a1, 0
	jal Month
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s4, $v0, 0 # Lay m2
	
	addi $sp, $sp, -8
	sw $ra, 28($sp)
	sw $a0, 32($sp)
	addi $a0, $a1, 0
	jal Year
	lw $ra, 28($sp)
	lw $a0, 32($sp)
	addi $sp, $sp, 8
	addi $s5, $v0, 0 # Lay y2
	
	slt $t7, $s5, $s2
	beq $t7, $zero, NotSwitch # Neu y2 < y1 ma sai thi khong switch 2 ngay
	
	# Doi 2 ngày cho nhau neu y2 < y1
	add $t7, $s3, $zero 
	add $s3, $s0, $zero
	add $s0, $t7, $zero
	
	add $t7, $s4, $zero 
	add $s4, $s1, $zero
	add $s1, $t7, $zero
	
	add $t7, $s5, $zero 
	add $s5, $s2, $zero
	add $s2, $t7, $zero
	
	NotSwitch:
	
	sub $v0, $s5, $s2 # Ket qua luu
	
	beq $v0, $zero, Done
	
	slt $t7, $s4, $s1 # m2 < m1
	bne $t7, $zero, Minus
	
	bne $s4, $s1, Done # m2 > m1 thi done
	
	slt $t7, $s3, $s0
	beq $t7, $zero, Done # d2 >= d1 thi done
	
	# So sanh xem co phai la ngay 29/2 va 28/2 hay khong
	addi $t7, $zero, 2 # tao hang so de so sánh
	bne $s4, $t7, Minus
	
	addi $t7, $zero, 29
	bne $s0, $t7, Minus
	
	addi $t7, $zero, 28
	bne $s3, $t7, Minus
	j Done
	
	Minus:
	
	sub $v0, $v0, 1
	
	Done:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra
			
#----------------Weekday Function------------------------------
# char* Weekday(char* TIME) -- xac dinh thu trong tuan
# Tham so: $a0: chuoi TIME
# Tra ve: $v0: Thu trong tuan

Weekday:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	
	addi $sp, $sp, -4
	sw $ra, 12($sp)
	jal Day
	addi $s0, $v0, 0
	lw $ra, 12($sp)
	
	sw $ra, 12($sp)
	jal Month
	addi $s1, $v0, 0
	lw $ra, 12($sp)
	
	sw $ra, 12($sp)
	jal Year
	addi $s2, $v0, 0
	lw $ra, 12($sp)
	addi $sp, $sp, 4
	
	#tinh leap year
	addi $sp, $sp, -4
	sw $ra, 12($sp)
	jal LeapYear
	lw $ra, 12($sp)
	addi $sp, $sp, 4
	
	# $t0, $t1, $t2 = d, m, y
	addi $t0, $s0, 0
	addi $t1, $s1, 0
	addi $t2, $s2, 0
	
	# Tinh m
	addi $t1, $t1, -1 # offset m cho dung voi array
	

	
	beq $v0, $zero, NotLeap
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
	
	div $t2, $t2, 100 # c luu vao $t2
	mfhi $t3 # y luu vao $t3
	
	
	addi $t5, $t5, 0
	add $t5, $t0, $t1
	add $t5, $t5, $t3
	div $t3, $t3, 4 # y = y/4
	add $t5, $t5, $t3
	add $t5, $t5, $t2
	
	div $t5, $t5, 7
	mfhi $t6
	
	# Tim ngay tu $t6
	la $t7, days
	sll $t6, $t6, 2
	add $t6, $t6, $t7
	lw $t1, 0($t6)
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	addi $v0, $t1, 0		
	jr $ra

#-----------------NearestLeapYear-----------------------------
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
	add $s0, $v0, $zero # luu lai gia tri YEAR
	
	subi $s1, $s0, 1 # luu gia tri buoc nhay NAM back
	addi $s2, $s0, 1 # luu gia tri buoc nhay NAM next
	sw $a0, 12($sp) 
	
	NearestLeapYear_back:
	add $a0, $s1, $zero
	jal CheckLeapYear
	bne $v0, $zero, NearestLeapYear_next # neu la nam nhuan
	subi $s1, $s1, 1 # giám t0 xuong 1
	j NearestLeapYear_back

	NearestLeapYear_next:
	add $a0, $s2, $zero
	jal CheckLeapYear
	bne $v0, $zero, returnLeapYear # neu la nam nhuan
	addi $s2, $s2, 1
	j NearestLeapYear_next

	returnLeapYear:
	add $v0, $s1, $zero
	add $v1, $s2, $zero

	# Cuoi thu tuc
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $a0, 12($sp) 
	lw $ra, 16($sp) 
	addi $sp, $sp, 20
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
# bool inputTime(char* temp, char* TIME)
# Tra ve: 0 (khong hop le) hoac 1 (hop le) ($v0), $v1: dia chi cua TIME
# Tham so: chuoi tam ($a0), chuoi TIME ($a1)

inputTime:
	# Dau thu tuc
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a1, $zero
	# add $t0, $zero, $zero # bien tam de kiem tra tinh trang so lan nhap DAY, MONTH, YEAR toan la so
	
	# Than thu tuc
	# Nhap chuoi ngay
	addi $v0, $zero, 4	
	la $a0, inputDay
	syscall # in ra man hinh thong bao nhap DAY
	
	addi $v0, $zero, 8	
	add $a0, $s0, $zero # a0 = s0
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
	add $a0, $s0, $zero # a0 = s0
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
	add $a0, $s0, $zero # a0 = s0
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
	add $a3, $s0, $zero
	jal checkValid
	
	beq $v0, $zero, notValidDate
	addi $v0, $zero, 1
	jal Date
	
	j inputTime.exit
	
	notValidDate:
	add $v0, $zero, $zero
	
	inputTime.exit:
	add $v1, $s0, $zero
	lw $s0, 0($sp)
	lw $a1, 4($sp)
	lw $a0, 8($sp)
	lw $ra, 12($sp)
	
	addi $sp, $sp, 16
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
	
	# Cuoi thu tuc
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
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	
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
	
	sw $a0, 0($sp)
	add $a0, $a2, $zero # a0 = nam
	jal CheckLeapYear
	lw $a0, 0($sp)
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
	
	# Cuoi thu tuc
	checkValid.exit:
	lw $a2, 4($sp)
	lw $a1, 8($sp)
	lw $ra, 12($sp)
	
	addi $sp, $sp, 16
	jr $ra
	
