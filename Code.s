.data
OutputBufferPosition:.quad 0
inputBufferPosition:    .space    64
inputBuffer:    .space    64
OutputBuffer:   .space    64

.text
    .text
    .global inImage
    .global getInt
    .global getText
    .global getChar
    .global getInPos
    .global setInPos

    .global inBufOut
    .global outImage
    .global putInt
    .global putText
    .global putChar
    .global getOutPos
    .global setOutPos

#-----Functions Defination-----#

#----- Image Functions -----#

inImage:
    movq     $0,inputBufferPosition           #reseting the position of buffer       
    movq     $inputBuffer, %rdi               #buffer argument
    movq     stdin, %rdx  
    call     fgets

outImage:
    leaq    OutputBuffer, %rdi                #load effictive address of OutputBuffer into rdi register
    movl    OutputBufferPosition, %esi        #moving OutputBufferPosition into esi register
    movb    $0, (%rdi, %rsi, 1)
    call    puts
    leaq    OutputBuffer, %rdi                #load effictive address of OutputBuffer into rdi register
    movl    $0, OutputBufferPosition
    movb    $0, (%rdi) 
    ret

#----- Ascii Function -----#

Find_Ascii:
    cmpb    $58, %dil                         #Checking if colon sign exits by comparing the ascii of colon sign with data stored in buffer
    jge     Ascii_Else 

    cmpb    $32, %dil                         #Checking if space exits
    je      Ascii_Space

    cmpb    $43, %dil                         #Checking if plus sign exits
    je      Ascii_Addition

    cmpb    $45, %dil                         #Checking if minus sign exits
    je      Ascii_Subtraction

    cmpb    $48, %dil                         #Checking if zero digit exits
    jl      Ascii_Else  

    movl    $3, %eax
    jmp     Find_Ascii_End

    Ascii_Space:
    movl    $1, %eax
    jmp     Find_Ascii_End

    Ascii_Addition:
    movl    $1, %eax
    jmp     Find_Ascii_End

    Ascii_Subtraction:
    movl    $2, %eax
    jmp     Find_Ascii_End

    Ascii_Else:
    movl    $0, %eax
    jmp     Find_Ascii_End

    Find_Ascii_End:
    ret

#----- Int Functions -----# 

getInt:
    xorq    %rdx, %rdx                          #resetting 
    xorq    %rdi, %rdi
    movl    inputBufferPosition, %edx           #moving stored value of inputBufferPosition into edx register
    leaq    inputBuffer, %rcx                   #load effictive address of inputBuffer into rcx register
    movq    $0, %r9                             #register for negative number and resetting r9
    movq    $0, %r10                            #register for the number and resetting r10     
    movq    $0, %r11                            #register for number counter and resetting r11             

    GI_Loop:
        cmpq    $256, %rdx
        jne     GI_At_Ending
        call    inImage
        jmp     getInt

        GI_At_Ending:
            movb    (%rcx, %rdx, 1), %dil
            call    Find_Ascii

            cmpl    $0, %eax                    #checks if input ends
            je      GI_Return_Number

            cmpl    $1, %eax                    #checks if space exits
            je      GI_Space

            cmpl    $2, %eax                    #checks if negative number exits
            je      GI_Negative_Number

            cmpl    $3, %eax                    #checks if positive number exits
            je      GI_Number

        GI_Number:
            subb    $48, %dil    
            push    %rdi
            addq    $1, %r11                    #incrementing the counter %r11 register
            jmp     GI_Loop_Ending

        GI_Negative_Number:
            cmp     $0, %r11                    #checks if negative number is not the first number in the input data
            jne     GI_Return_Number
            movq    $1, %r9                     #set the register value negative
            jmp     GI_Loop_Ending
        
        GI_Space:
            cmp     $0, %r11                    #checks if space is not the first input in the data
            jne     GI_Return_Number
            movq    $0, %r9                     #sets the register value positive 

        GI_Loop_Ending:
            incq    %rdx
            jmp     GI_Loop

    GI_Return_Number:                           #iterate through numbers on stack
        movq    $1, %rcx                        #number iterator
        
        GI_Pop_Loop:
            cmpq    $0, %r11
            je      GI_Ending
            
            pop     %rax
            decq    %r11                        #decrementing one from stack counter
            imulq   %rcx, %rax                  #multiplying number with 10 to power of x
            addq    %rax, %r10                  #adding multiplication in return number
            imulq   $10, %rcx                   #multiplying iterator with 10
            jmp     GI_Pop_Loop

        GI_Ending:
        cmpq    $1, %r9
        jne     GI_Returning
        negl    %r10d

        GI_Returning:
        movl    %edx, inputBufferPosition       #moving %edx register value in inputBufferPosition
        movl    %r10d, %eax                     #moving lower 32 bits of %r10(register for the number) register to %eax register
    ret

putInt:
    movq    $0, %r9                             #Counter for stack
    xorq    %rax, %rax                          #resetting %rax register
    movl    %edi, %eax                          
    xorq    %rdi, %rdi                          #resetting %rdi register

    cmpl    $0, %eax                            #Checking negativity
    jge     PI_DividngLoop
    negl    %eax                                #Taking 2's Complement of binary bits
    movb    $45, %dil
    call    putChar

    PI_DividngLoop:
        xorq    %rdx, %rdx                      #resetting rdx
        movq    $10, %r10
        idivq   %r10                            #dividing the value in r10 by rax and rdx which are holding 64 bits of number each
        addb    $48, %dl                        #adding 0
        push    %rdx                            #pushing in stack
        incb    %r9b                            #incrementing the lower 8 bits of r9 register
        cmpl    $0, %eax
        jne     PI_DividngLoop

    PI_PrintingLoop:
        pop     %rdi                            #removing from stack
        decb    %r9b                            #decrementing the lower 8 bits of r9 register
        call    putChar                         
        cmpb    $0, %r9b                        #comparing 0 with lower 8 bits of r9 register
        jne     PI_PrintingLoop
    ret

#----- Text Functions -----#

getText:
    movl    inputBufferPosition, %edx           #moving inputBufferPosition into edx
    leaq    inputBuffer, %rcx                   #load effictive address of inputBuffer into rcx register
    movq    $0, %r9

    GT_Loop:          
        cmpl    $256, %edx                      #Checks if inputBufferPosition is at the end
        jne     GT_At_Ending
        cmpq    $256, %rsi
        jge     GT_Ending
        call    inImage
        jmp     getText

    GT_At_Ending:
        movb    (%rcx, %rdx, 1), %r10b
        incl    %edx                            #incrementing inputBufferPosition register
        cmpb    $0, %r10b                       #checks if '\0' is reached in input data then stops looking for chars
        je      GT_Ending
        movb    %r10b, (%rdi, %r9, 1)
        incl    %r9d                            #incrementing in lower 32 bits of r9 register
        cmpq    %r9, %rsi
        jne     GT_Loop

    GT_Ending:                  
        movb    $0, (%rdi, %r9, 1)              #Adding '\0' to the end of input data
        movl    %edx, inputBufferPosition       
        movl    %r9d, %eax                      #moving lower 32 bits of r9 register(Input data) into eax register
        ret

putText:
    movq    $0, %rsi
    xorq    %rdx, %rdx                          #resetting rdx register
    movl    OutputBufferPosition, %edx
    leaq    OutputBuffer, %r10                  #load effictive address of OutputBuffer into r10 register

    PT_Loop:
    cmp     $256 ,%edx                          #Checks if inputBufferPosition is at the end,then call outImage
    jne     PT_Continue
    call    outImage
    jmp     putText

    PT_Continue:
    movb    (%rdi, %rsi, 1), %r9b 
    cmpb    $0, %r9b
    je      PT_Ending
    movb    %r9b, (%r10, %rdx, 1)
    incl    %edx                                #incrementing one in edx regsiter value                
    incq    %rsi
    jmp     PT_Loop

    PT_Ending:
    movl    %edx, OutputBufferPosition
    ret

#----- Char Functions -----#
.global getChar

getChar:
    leaq    inputBuffer, %rdi
    mov     inputBufferPosition, %rsi
    
    cmp     $256, %rsi                          #Checks if inputBufferPosition is at the end,then call inImage.
    jne     GC_Starting
    call    inImage

    GC_Starting:
    mov     inputBufferPosition, %rsi           #moving inputBufferPosition into rsi register
    add     %rsi, %rdi                          #adding inputBuffer and inputBufferPosition
    cmp     $0, (%rdi)
    je      GC_Ending
    add     $1, inputBufferPosition

    GC_Ending:
    mov     (%rdi), %eax
    ret

putChar:
    movl    OutputBufferPosition, %edx
    cmpl    $256, %edx                          #checks if OutputBufferPosition is at the end
    jne     PC_Ending   
    call    outImage
    movl    OutputBufferPosition, %edx

    PC_Ending:
    leaq    OutputBuffer, %rsi
    movb    %dil, (%rsi, %rdx, 1) 
    incl    %edx
    movl    %edx, OutputBufferPosition
    ret

#----- Position Functions -----#

getOutPos:
    movl     OutputBufferPosition, %eax
    ret

setOutPos:
    cmpl    $0, %edi
    jg      SOP_Continue 
    movl    $0, %edi

    SOP_Continue:
    cmpl    $255, %edi
    jl      SOP_Ending 
    movl    $255, %edi

    SOP_Ending:
    movl    %edi, OutputBufferPosition 
    ret

.global getInPos

getInPos:
    movl     inputBufferPosition, %eax
    ret

.global setInPos

setInPos:
    cmpl    $0, %edi
    jg      SIP_Continue 
    movl    $0, %edi

    SIP_Continue:
    cmpl    $255, %edi
    jl     SIP_Ending 
    movl    $255, %edi

    SIP_Ending:
    movl    %edi, inputBufferPosition 
    ret

#----- main -----#

