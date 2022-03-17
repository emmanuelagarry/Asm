.data
    message:   .asciiz " \n \n Hello, please input your string. Use '?' to end the program \n "
    newLine:    .asciiz "\n"
    doneMessage:   .asciiz "\n The solution is:  "
    currentValueMessage: .asciiz "\n The current solution is:   "
    stopMessage:   .asciiz "\n The program was stopped. The solution is:  "
    userInput: .space 20
    zeroString: .byte '0'

.text
    main: 


        # Display Hello Text
        li $v0, 4
        la $a0 message
        syscall
        
        # Get user input as text 
        li $v0, 8
        la $a0, userInput
        li $a1, 20
        syscall


        add $t5, $zero, $zero
        lb   $t5, userInput($zero)
     



        # Save bytes in registers
       
        lb  $t0, zeroString # get first byte from zero string $t0 register

        add $t6, $zero, $zero   # $t6 is the counter. set it to 0
        add $t4, $zero, $zero   # $t4 is the accumelator and its set to 0
        beq $t5, 63 stopProgram

        # intialize $t7  to 1 and $t8 to zero and t9$ to zero
        add  $t7, $zero, $zero
        addi $t7, $t7, 10
        add  $t8, $zero, $zero
        add  $t9, $zero, $zero # this saves instriction to run
        
    

    
    while:
        beq  $t5, 33, donForeSure
        lb   $t1, userInput($t6) # get  byte from text saved in $t1 register
        beqz $t1, end            # stop loop if $t1 == 0
        beq  $t1, 10,  end     # stop loop if $t1 ==  NEW LINE
        beq  $t1, 61,  printCurrentValue     # check for equals sign sign


        # Check for arithmetic insruction and maybe execute 
        blt  $t1, 48,    checkIfInstructionExist
        bgt  $t1, 57,    ignorePattern     # Ignore characters


        sub  $t3, $t1,   $t0 # Do t0 - $t1 to get convert string format number to integer and store in $t3
        addi $t6, $t6,   1 # and increment the counter
        
        beq $t6, 1, moveFirstIntoT4     # This commants puts the first decimal value in $t6


    # Here i adjust the unit of the number
        mult $t4, $t7
        mflo $t4 
        add  $t4, $t4, $t3

        j while 


   

    ignorePattern: 
        addi $t6, $t6,   1 # and increment the counter
        b while 

    checkIfInstructionExist:
        beqz $t9 saveFirstInstruction
        beq  $t9, 43, addCurrentWithNext




    saveFirstInstruction:
        move $t2, $t4   # move current accumulator to $t4 
        lb   $t8, userInput($t6)
        beq  $t8, 43,    saveAddInstruction # check for addition sign
        beq  $t8, 45,    saveSubInstruction # check for addition sign
        beq  $t8, 42,    saveMulInstruction # check for multiplication sign
        beq  $t8, 47,    divCurrentByNext # check for division sign
        add  $t4, $zero, $zero   # $t4 Reset 
        addi $t6, $t6,   1 # and increment the counter
        b while

    

     saveAddInstruction:
        addi  $t9, $zero, 43
        addi $t6, $t6,   1 # and increment the counter
        b while


    saveSubInstruction:
        addi  $t9, $zero, 45
        addi $t6, $t6,   1 # and increment the counter
        b while

    saveMulInstruction:
        addi  $t9, $zero, 42
        addi $t6, $t6,   1 # and increment the counter
        b while


    saveDivInstruction:
        addi  $t9, $zero, 47
        addi $t6, $t6,   1 # and increment the counter
        b while












    

    addCurrentWithNext:


        add  $t2, $t2, $t4
        add  $t9, $zero, -1
        addi $t6, $t6, 1 # and increment the counter
        # Go back to while loop
        b while 




    subCurrentFromNext:
        addi $t6, $t6, 1 # Increment the counter to get next 
        lb   $t1, userInput($t6) # get first byte from text saved in $t1 register
        beqz $t1, end
        beq  $t1, 10 , end 
        sub  $t3, $t1,   $t0 # Do t0 - $t1 to get convert string format number to integer and store in $t3
        sub  $t4, $t4, $t3
        addi $t6, $t6, 1 # and increment the counter


        # Go back to while loop
        b while


    mulCurrentByNext:
        addi $t6, $t6, 1 # Increment the counter to get next 
        lb   $t1, userInput($t6) # get first byte from text saved in $t1 register
        beqz $t1, end
        beq  $t1, 10 , end 
        sub  $t3, $t1,   $t0 # Do t0 - $t1 to get convert string format number to integer and store in $t3
        mult  $t4, $t3
        mflo $t4
        addi $t6, $t6, 1 # and increment the counter


        # Go back to while loop
        b while 


    
    divCurrentByNext:
        addi $t6, $t6, 1 # Increment the counter to get next 
        lb   $t1, userInput($t6) # get first byte from text saved in $t1 register
        beqz $t1, end
        beq  $t1, 10 , end 
        sub  $t3, $t1,   $t0 # Do t0 - $t1 to get convert string format number to integer and store in $t3
        div  $t4, $t3
        mflo $t4
        addi $t6, $t6, 1 # and increment the counter


        # Go back to while loop
        b while 

    
    moveFirstIntoT4:
        move $t4, $t3   # move current accumulator to $t4 
        b while 
        
    
    end:

       addi $t5, $zero, 33

       beq  $t9, 43, addCurrentWithNext
        
        


    donForeSure:
         # Display done Text
        li $v0, 4
        la $a0, doneMessage
        syscall



        # Display Input integer
        li   $v0, 1 # Set up display for inter, I put this early because i cant use the bytes loaded yet. It need machine clcles
        add  $a0, $zero, $t2
        syscall


        b main 



    printCurrentValue:

       # Display stop Text
        li $v0, 4
        la $a0, currentValueMessage
        syscall



        # Display Input integer
        li   $v0, 1 # Set up display for inter, I put this early because i cant use the bytes loaded yet. It need machine clcles
        add  $a0, $zero, $t4
        syscall

        addi $t6, $t6, 1 # and increment the counter

        b while 


    stopProgram:

       # Display stop Text
        li $v0, 4
        la $a0, stopMessage
        syscall



        # Display Input integer
        li   $v0, 1 # Set up display for inter, I put this early because i cant use the bytes loaded yet. It need machine clcles
        add  $a0, $zero, $t4
        syscall


     

    
    # End the main program
li $v0, 10
syscall







# if  its a number, 
#
#
#
#
#
#
#