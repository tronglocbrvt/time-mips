
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
	 
	
	
	
	