#
# Carlos Rivera - Towers of Hanoi
# Computer Architecture - ITESO
#
	li	$a0,	10		# Hex A
	li	$a1,	11		# Hex B
	li	$a2,	12		# Hex C
	
	li	$a3,	3		# n
		
	jal	hanoi			# jump to firts recursion
	
	li  	$v0,	10		# send the kill signal
    	syscall
    		
hanoi:	addi	$sp,	$sp,	-24	# load the stack
	beq	$a3,	$0,	kill	# n != 0 ?? kill()
	
	sw	$ra,	0($sp)		# store stack
	sw	$s0,	4($sp)		
	sw	$s1,	8($sp)		
	sw	$s2,	12($sp)
	sw	$s3,	16($sp)
	
	add	$s0,	$a0,	$zero	# move src to $s0
	add	$s1,	$a1,	$zero	# move tmp to $s1
	add	$s2,	$a2,	$zero	# move dst to $s2

	addi	$s3,	$a3,	-1	# n--
	
	add	$a1,	$s2,	$zero	# move args for the recursive call
	add	$a2,	$s1,	$zero	
	add	$a3,	$s3,	$zero	
	
	jal	hanoi			# hanoi(n-1, src, dst, tmp) 
					
	add	$a0,	$s1, 	$zero 	# break here: src = $s0, dst = $s2
	add	$a1,	$s0,	$zero	# move args for the recursive call
	add	$a2,	$s2,	$zero
	add	$a3,	$s3,	$zero
	
	jal 	hanoi			# hanoi(n-1, tmp, src, dst) 
	
	lw	$ra,	0($sp)		# read stack
	lw	$s0,	4($sp)
	lw	$s1,	8($sp)
	lw	$s2,	12($sp)
	lw	$s3,	16($sp)
	
	
    	
kill:	addi	$sp,	$sp,	24	
	jr	$ra			 
	
	