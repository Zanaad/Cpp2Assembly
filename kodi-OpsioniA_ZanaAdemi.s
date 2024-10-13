.data
	a: .space 20
	message1: .asciiz "Jep numrin e anetareve te vektorit (max.5):"
	message2: .asciiz "\nShtyp elementet nje nga nje: \n"
	message3: .asciiz "\nVlerat e vektorit ne fund: \n"
	space: .asciiz " "
.text
.globl main
main:
	jal populloVektorin				#call populloVektorin procedure
	jal unazaKalimit				#call unazaKalimit procedure
exit:
	li $v0,10						#system call code for exit	
	syscall							#exit
	
populloVektorin:
	#display the 1st message
	li $v0,4 						#system call code for print_string
	la $a0,message1					#load the base address of the string we want to print in $a0
	syscall							#print it
	
	#Get the user's input(the size of the array)
	li $v0,5						#system call code for read_int
	syscall							#read it
	move $a1,$v0					#move the value of size into register $a1

	#display the 2nd message
	li $v0,4 						#system call code for print_string
	la $a0,message2					#load the base address of the string we want to print in $a0
	syscall							#print it	
	
	#Get the user's input(elements of the array)
	addi $t0,$zero,1				#i=1 in $t0
	
Loop:
	bgt $t0,$a1,endLoop				#if(i>n) go to endLoop
	sll $t1,$t0,2					#index=4i for passing to next element in $t1
	li $v0,5						#system call code for read_int
	syscall							#read it	
	
	sw $v0,a($t1)					#Store the value in $v0 in the first position of the array
	
	addi $t0,$t0,1					#i++
	j Loop							#jump to Loop	
endLoop:
	jr $ra							#return to caller (main)
	
unazaKalimit:
	addi $sp,$sp,-20				#adjust stack for 5 items
	sw $ra,16($sp)					#save return address 
	#$s0-$s7 are Callee Save. If the callee uses these registers, we should save and restore them in case the caller uses them
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)	
	addi $t2,$zero,1				#p=1 in $t2
	addi $t4,$a1,-1					#n-1 in $t4	
Loop1:
	sll $t3,$t2,2					#index=4p for passing to next element in $t3
	bgt $t2,$t4,endLoop1			#if (p>n-1) go to endLoop1
	lw $a2,a($t3)					#min=a[p] in $a2
	move $a3,$t2					#loc=p in $a3
	jal unazaVlerave				#call the procedure unazaVlerave
	sll $t9,$a3,2					#index=4loc for passing to next element in $t9
	lw $s0,a($t3)					#load the value of a[p] in $s0
	lw $s1,a($t9)					#load the value of a[loc] in $s1
	sw $s1,a($t3)					#store the value in $s1 (a[loc]) into a[p]	
	sw $s0,a($t9)					#store the value in $s0 (a[p]) into a[loc]				
	addi $t2,$t2,1					#p++
	j Loop1							#jump to Loop1
endLoop1:
	#display the third message
	li $v0,4 						#system call code for print_string
	la $a0,message3					#load the base address of the string we want to print in $a0
	syscall							#print it	
	addi $s2,$zero,1				#i=1 in $s2
Loop3:
	sll $s3,$s2,2					#index=4i for passing to next element in $s3
	bgt $s2,$a1,endLoop3			#if(i>n) go to endLoop3
	li $v0,1						#system call code for print_int
	lw $a0,a($s3)					#load the integer we want to print into $a0
	syscall							#print it
	
	#print some space between the elements of the array
	li $v0,4						#system call code for print_string
	la $a0,space					#load the base address of the string we want to print into $a0
	syscall							#print it
	
	addi $s2,$s2,1					#i++
	j Loop3							#jump to Loop3
endLoop3:
	#restore the $s0-$s3 registers
	lw $s3,0($sp)					
	lw $s2,4($sp)
	lw $s1,8($sp)
    lw $s0,12($sp)	
	lw $ra,16($sp)					#restore return address
	addi $sp,$sp,20					#move the stack pointer back
	jr $ra							#return to caller (main)
	
unazaVlerave:
	addi $t5,$t2,1					#k=p+1 	in $t5
	
Loop2:
	sll $t6,$t5,2					#index=4k for passing to next element in $t6
	bgt $t5,$a1,endLoop2			#if(k>n) go to endLoop2
	lw $t7,a($t6)					#load the value of a[k] into $t6
	slt $t8,$t7,$a2					#if(a[k]<min) t8=1 else t8=0
	beq $t8,$zero,rriteIndeksin		#if(t8=0) go to rriteIndeksin
	lw $a2,a($t6)					#min=a[k] in $a2
	move $a3,$t5					#loc=k in $a3
rriteIndeksin:
	addi $t5,$t5,1					#k++
	j Loop2							#jump to Loop2
endLoop2:	
	jr $ra							#return to caller (procedura unazaKalimit)
	