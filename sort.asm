.orig x3000
MAIN
    INIT                ; user must supply 8 values to sort
    ld r1, num1         ; r1 = base address
    INIT_LOOP
    ld r5, count        ; r5 = count
    add r2, r2, #-8     ; will go up to 8 times
    add r2, r2, r5      ; 
    brzp SORT           ; jump to sort once INPUT has filled all 8 variables
    jsr INPUT           ;
    add r5, r5, x1      ; count++
    st r5, count        ;
    br INIT_LOOP
    SORT
    halt

; === fills location (base address + count) with user value ===
; registers used: (count = r5)
INPUT
    st r4, saveReg4     ;save reg 4
    and r0, r0, x0      ;print outputs and gather input 
    and r1, r1, x0      ;r1-3 = digit1-3
    and r2, r2, x0 
    and r3, r3, x0      
    and r4, r4, x0      ;sum = 0

    READ_FIRST
    and r1, r1, x0
    lea r0, first_prompt 
    puts
    getc

    add r1, r0, #-13    ;check input for enter
    brz VALID_FIRST          
    and r1, r1, x0

    add r0, r0, xf      ;conversion to int r0 - 48
    add r0, r0, xf
    add r0, r0, xf
    add r0, r0, x3
    not r0, r0
    add r0, r0, x1

    
    st r0, tmp
    add r0, r0, x0      ;check if below 0
    brn INPUT_ERROR1
    add r0, r0, #-9     ;check if above 9
    brp INPUT_ERROR1
    ld r0, tmp



    add r4, r4, r0      ;sum = sum + r0
    VALID_FIRST

    lea r0, num1
    puts

    st r4, digit1
    br INPUT_DONE
    INPUT_ERROR1    
    and r0, r0, x0 
    lea r0, error_prompt1
    br READ_FIRST
    
    INPUT_DONE
    and r4, r4, x0

    ld r1, digit1 
    add r4, r4, r1

    ld r0, num1
    add r0, r0, r5  ; r0 = baseaddress + count
    st r0, addr
    sti r4, addr      ; 
    
    ret



    


; ===== UTIL routines =====
MULTbyTEN    ;(num1 = r1) (return = r2)
    add r3, r3, xa ; count = 10   
    and r2, r2, x0
    add r2, r2, r1 ; r2 = r1
    MULT_LOOP
    add r3, r3, x0 
    brz MULT_DONE
    add r1, r1, r2 ; r1 + r2
    add r3, r3, #-1
    br MULT_LOOP
    MULT_DONE
    and r2, r2, x0
    add r2, r1, x0
    ret


; ===== MAIN vars =====
count .FILL x0      ; 

; ===== INPUT vars =====
digit1 .fill x3208
digit2 .fill x3209
digit3 .fill x320A
tmp    .fill x320B
sum    .fill x320C
addr   .fill x0

; ===== INPUT prompts =====
first_prompt .stringz "Enter first number: "

error_prompt1 .stringz "input is not a num\n"
out0 .STRINGZ "0"
out1 .STRINGZ "1"
out2 .STRINGZ "2"
out3 .STRINGZ "3"
out4 .STRINGZ "4"
out5 .STRINGZ "5"
out6 .STRINGZ "6"
out7 .STRINGZ "7"
out8 .STRINGZ "8"
out9 .STRINGZ "9"

; ===== SORTING PTRS =====
num1 .FILL x3200        ;   base address
num2 .FILL x3201
num3 .FILL x3202
num4 .FILL x3203
num5 .FILL x3204
num6 .FILL x3205
num7 .FILL x3206
num8 .FILL x3207

; === SAVE REGISTERS ====
saveReg4 .fill x0
saveReg5 .fill x0

.end
