# check if user provided string is palindrome

.data

userInput: .space 64
stringAsArray: .space 256

welcomeMsg: .asciiz "Enter a string: "
calcLengthMsg: .asciiz "Calculated length: "
newline: .asciiz "\n"
yes: .asciiz "The input is a palindrome!"
no: .asciiz "The input is not a palindrome!"
notEqualMsg: .asciiz "Outputs for loop and recursive versions are not equal"

.text

main:

	li $v0, 4
	la $a0, welcomeMsg
	syscall
	la $a0, userInput
	li $a1, 64
	li $v0, 8
	syscall

	li $v0, 4
	la $a0, userInput
	syscall
	
	# convert the string to array format
	la $a1, stringAsArray
	jal string_to_array
	
	addi $a0, $a1, 0
	
	# calculate string length
	jal get_length
	addi $a1, $v0, 0
	
	li $v0, 4
	la $a0, calcLengthMsg
	syscall
	
	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	la $a0, stringAsArray
	
	# Swap a0 and a1
	addi $t0, $a0, 0
	addi $a0, $a1, 0
	addi $a1, $t0, 0
	addi $t0, $zero, 0
	
	# Function call arguments are caller saved
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	# check if palindrome with loop
	jal is_pali_loop
	
	# Restore function call arguments
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
	addi $s0, $v0, 0
	
	# check if palindrome with recursive calls
	jal is_pali_recursive
	bne $v0, $s0, not_equal
	
	beq $v0, 0, not_palindrome

	li $v0, 4
	la $a0, yes
	syscall
	j end_program

	not_palindrome:
		li $v0, 4
		la $a0, no
		syscall
		j end_program
	
	not_equal:
		li $v0, 4
		la $a0, notEqualMsg
		syscall
		
	end_program:
	li $v0, 10
	syscall
	
string_to_array:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	addi $t2, $a0, 64

	
	to_arr_loop:
		lb $t4, ($t0)
		sw $t4, ($t1)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4
	
		bne $t0, $t2, to_arr_loop
		
	jr $ra


#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################
	
get_length:
	lb $t0, newline
	add $s0, $zero, $zero # initalize counter

add_to_counter:
	lb $t1, 0($a0)
	beq $t1, $t0, return
	addi $s0, $s0, 1
	addi $a0, $a0, 1
	bne $a0, $t0, add_to_counter

return:
	add $v0, $s0, $zero
	jr $ra
	


is_pali_loop:

	slti $t5, $a0, 8
	beq $t5, 1, return_true
	
	add $t0, $a1, $zero
	add $t1, $t0, $a0
	addi $t1, $t1, -4
	
	lw $t2, 0($t0)
	lw $t3, 0($t1)
	
	bne $t2, $t3, return_false

equal:
	# change length
	addi $a0, $a0, -8
	slti $t5, $a0, 8
	beq $t5, 1, return_true

	# shift first and last pointer
	addi $t0, $t0, 4
	addi $t1, $t1, -4
	
	lw $t2, 0($t0)
	lw $t3, 0($t1)
	
	beq $t2, $t3, equal

return_false:
	add $v0, $zero, $zero
	jr $ra

return_true:
	addi $v0, $zero, 1	
	jr $ra
	
	


is_pali_recursive:

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# base case
	slti $t0, $a0, 8
	beq $t0, 1, returnTrue

	# check if first == last
	add $t0, $a1, $zero
	add $t1, $t0, $a0
	addi $t1, $t1, -4
	
	lw $t2, 0($t0)
	lw $t3, 0($t1)
	bne $t2, $t3, returnFalse

	j pali_rec
	
returnFalse:
	add $v0, $zero, $zero
	jr $ra

returnTrue:
	addi $v0, $zero, 1	
	jr $ra

pali_rec:
	# recurs with new pointer and length
	addi $a0, $a0, -8
	addi $a1, $a1, 4	
	jal is_pali_recursive
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
