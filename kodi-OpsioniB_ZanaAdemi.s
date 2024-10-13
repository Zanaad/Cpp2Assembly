.data
	vektori1: .word 5, 4, 9, 17, 31, 8
	vektori2: .word -5, 2, 3, 4, 6, -3
	message: .asciiz "Rezultati i operacionit: "
.text
.globl main
main:

	
	la $a1,vektori1 	#base address of vektori1 in $a1
	la $a2,vektori2 	#base address of vektori2 in $a2
	addi $a3,$zero,6 	#n=6 in $a3
	
	jal OperacioniMeVektore #call OperacioniMeVektore procedure
	
	#Print the message
	li $v0,4 			#system call code for print_string
	la $a0,message 		#load the base address of the string we want to print in $a0
	syscall 			#print it
	
	#Print the result
	li $v0,1 			#system call code for print_int
	addi $a0,$v1,0 		#the integer we want to print
	syscall				#print it
	
Exit:

	li $v0,10			#system call code for exit
	syscall				#exit
	
OperacioniMeVektore:

	addi $t0,$zero,0 	#i=0 in $t0
	#$s0-$s7 are Callee Save. If the callee uses these registers, we should save and restore them in case the caller uses them
	addi $sp,$sp,-4		#move the stack pointer down to create space for the register $s0
	sw $s0,0($sp)		#save $s0 on stack/save $s0 at $sp+0
	addi $s0,$zero,0 	#sum=0 in $s0
	
Loop:

	slt $t8,$t0,$a3 	#if($t0<$a3) $t8=1 else $t8=0
	beq $t8,$zero,End 	#if $t8=0, go to End
	sll $t1,$t0,2 		#4*i in $t1 (in order to go to the next element in array)
	add $t1,$t1,$a1 	#4*i+base address of vektori1 (in order to increment 4*i bytes away from the base address of the array)
	lw $t2,0($t1) 		#vektori1[i] in $t2 
	
	addi $t3,$a3,-1 	#n-1 in $t3
	add $t3,$t3,$t0 	#(n-1-i) in $t3
	sll $t4,$t3,2  		#4(n-1-i) in $t4 
	add $t4,$t4,$a2		#4(n-1-i)+base address of vektori2 (in order to increment 4*(n-1-i) bytes away from the base address of the array)
	lw $t5,0($t4) 		#vektori2[n-1-i] in $t5
	
	move $t6,$t2		#temp1=vektori1[i] in $t6
	move $t7,$t5		#temp2=vektori2[n-1-i] in $t7
	
	add $t2,$t6,$t7		#vektori1[i]=temp1+temp2
	sub $t5,$t6,$t7		#vektori2[n-1-i]=temp1-temp2
	
	add $s0,$s0,$t2		#sum=sum+vektori1[i]
	add $s0,$s0,$t5		#sum=sum+vektori2[n-1-i]
	
	addi $t0,$t0,1 		#i++
	j Loop				#jump to Loop

End:
	
	add $v1,$zero,$s0	#move the result of sum to $v1
	lw $s0,0($sp)		#restore $s0 from $sp+0
	addi $sp,$sp,4		#move the stack pointer back
	
	jr $ra				#return to caller
	
