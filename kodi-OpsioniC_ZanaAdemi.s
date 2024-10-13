.data
	vektori1: .word 4, 9, -3, -5, 6, 8, 1
	message1: .asciiz "The sum_pre is: "
	message2: .asciiz "The sum_post is: "
	newLine: .asciiz "\n"
.text
.globl main 				#Declare main as a global function
main:
	la $t0,vektori1 		#load base address of vektori1 in $t0
	addi $t1,$zero,1 		#i=1 in $t1
	addi $t2,$zero,7 		#n=7 in $t2
	lw $s0,0($t0)			#sum_pre in $s0
	addi $s1,$zero,0 		#sum_post in $s1
	lw $s3,24($t0)			#vektori[n-1] in $s3
	
Loop:

	sll $t3,$t1,2 			#4*i in $t3 (in order to go to the next element in array)
	add $t3,$t3,$t0 		#4*i+base address of vektori1 (in order to increment 4*i bytes away from the base address of the array)
	lw $t4,0($t3)  			#vektori1[i] in $t4
	
	slt $t5,$t1,$t2 		#if ($t1<$t2) $t5=1 else $t5=0
	beq $t5,$zero,End 	    #if ($t5=0) go to the end of loop
	add $s0,$s0,$t4			#sum_pre=sum_pre+vektori1[i]
	
	addi $t6,$t1,-1 		#i-1 in $t6
	sll $t7,$t6,2			#4*(i-1) in $t7 (this is the 4*(i-1) offset)
	add $t7,$t7,$t0			#4*(i-1)+base address of vektori1 in $t7
	lw $t8,0($t7)			#vektori1[i-1] in $t8
	add $t8,$t4,$t1			#vektori[i-1]=vektori1[i]+i
	add $s1,$s1,$t8			#sum_post=sum_post+vektori[i-1]
	
	addi $t1,$t1,1			#i++
	j Loop					#jump to the begin of loop
	
End:	

	add $s1,$s1,$s3 		#sum_post=sum_post+vektori[n-1]
	
	#print message1
	li $v0,4				#system call code for print_string
	la $a0,message1 		#load the base address of the string we want to print in $a0
	syscall 				#print the string
	
	#print sum_pre
	li $v0,1 				#system call code for print_int
	move $a0,$s0 			#the integer we want to print
	syscall 				#print the integer
	
	#print a new line
	li $v0,4
	la $a0,newLine
	syscall
	
	#print message1
	li $v0,4				#system call code for print_string
	la $a0,message2 		#load the base address of the string we want to print in $a0
	syscall 				#print the string
	
	#print sum_post
	li $v0,1 				#system call code for print_int
	move $a0,$s1 			#the integer we want to print
	syscall 				#print the integer
	
	
#The end of the program
Exit:
	li $v0,10 				#system call code for exit
	syscall					#exit