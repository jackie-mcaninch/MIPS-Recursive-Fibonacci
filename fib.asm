.data 0x0
    prompt: .asciiz "Enter a value for n: \n"
.text 0x3000
.globl main

main:
    #initialize pointers
	ori     $sp, $0, 0x3000 	#set stack pointer
    	addi    $fp, $sp, -4    	#set frame pointer
    	
    #obtain n from user
	#prompt 
	li	$v0, 4
	la 	$a0, prompt
	syscall				#4: print $a0 and accepts user input
	
	#read
	li	$v0, 5
	syscall				#5: $v0 is set to user input
	
	#set
	add	$a0, $0, $v0		#register $a0 now contains n
	add	$v0, $0, $0		#empty $v0 to hold the sum
	
    #enter recursive function
    	jal fibonacci   		#jumps to the recursive function
    	
    #print result 
	add	$a0, $0, $v0		#move result back to $a0
	li	$v0, 1		
    	syscall				#1: print whatever is in $a0
	
exit:
    #exit program	
	li	$v0, 10     	
    	syscall                 	#10: exit program


fibonacci:
    #create checkpoint for return
	addi    $sp, $sp, -12        	#reserve space for $ra, $fp, and $a0 (represents n)
  	sw      $ra, 8($sp)		
    	sw      $fp, 4($sp)		#$fp and $ra now saved respectively at consecutive addresses on the stack
    	addi    $fp, $sp, 8         	#set $fp to the start of fibonacci's stack frame

    #test for base case
	ble	$a0, 1, fib_return	#base case reached: get out of the function	
	sw      $a0, 0($sp)		#save n for use later
    	
    #recursive calculation	
	addi	$a0, $a0, -1		#for fib(n-1)
	jal	fibonacci		#recursive call
	
	lw	$a0, -8($fp)		#restore original n
	addi	$a0, $a0, -2		#for fib(n-2)
	jal	fibonacci		#second recusive call
	
    #revert stack
    	addi    $sp, $fp, 4     	#restore old stack pointer
    	lw      $ra, 0($fp)     	#restore return address
    	lw      $fp, -4($fp)    	#restore old frame pointer
    	jr	$ra			#jump back to return address
	
                                
fib_return:
    #base case reached
    	add	$v0, $v0, $a0		#add n to final result
    	
    #revert stack
    	addi    $sp, $fp, 4     	#restore old stack pointer
    	lw      $ra, 0($fp)     	#restore return address
    	lw      $fp, -4($fp)    	#restore old frame pointer
    	jr	$ra			#jump back to return address