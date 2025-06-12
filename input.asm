.orig x3000

; in progress function for input gathering
; TODO: implement enter functionality (end input when enter is pressed)
; - input checking

;; push onto stack

; save reg


; ===============INPUT (count = r0)===========
; gathers up to 3 digit input
; stores each number into digits 1, 2, and 3 
; after each digit entered, all digits are multiplied by 10 
;   number in ones place, goes to tens place etc.
; when enter is pressed, all current digits are summed up
; and stored into its place in memory base + count
; 
INPUT
jsr SAVE_REG

sti r0, input_count

INPUT_FIRST_NUM
lea r0, enter_num
puts              ;display prompt
getc              ;get char
out               ;echo

;; INPUT VALIDATION PORTION
add r2, r0, x0    ; copy input to r2
ld r0, char_enter ; check if num is enter
add r0, r2, r0    
brz INPUT_DONE    ; skip to end
ld r0, char_zero  ;
add r0, r2, r0    ; if ascii of num is less than ascii 0 
brn INPUT_ERROR_1 ; 
ld r0, char_nine
add r0, r2, r0    ; if ascii of num is greather than ascii 9
brp INPUT_ERROR_1 ;

ld r3, ASCIItoI   ; convert from ascii to Integer
add r2, r2, r3    ; r2 = num 1

sti r2, digit1    ; store digit1 in ones place

INPUT_SECOND_NUM
getc
out

;; INPUT VALIDATION PORTION
add r2, r0, x0    ; copy input to r2
ld r0, char_enter ; check if num is enter
add r0, r2, r0    
brz INPUT_DONE    ; skip to end
ld r0, char_zero  ;
add r0, r2, r0    ; if ascii of num is less than ascii 0 
brn INPUT_ERROR_1 ; 
ld r0, char_nine
add r0, r2, r0    ; if ascii of num is greather than ascii 9
brp INPUT_ERROR_1 ;

ld r3, ASCIItoI   ; convert from ascii to Integer
add r2, r2, r3    ; r2 = num 1

ldi r1, digit1    ; shift digit1 to tens place
jsr MULTby10      ; MULTby10(r1 = num) -> r0
sti r0, digit1

sti r2, digit2    ; store digit2 in ones place

INPUT_THIRD_NUM
getc
out

;; INPUT VALIDATION PORTION
add r2, r0, x0    ; copy input to r2
ld r0, char_enter ; check if num is enter
add r0, r2, r0    
brz INPUT_DONE    ; skip to end
ld r0, char_zero  ;
add r0, r2, r0    ; if ascii of num is less than ascii 0 
brn INPUT_ERROR_1 ; 
ld r0, char_nine
add r0, r2, r0    ; if ascii of num is greather than ascii 9
brp INPUT_ERROR_1 ;

ld r3, ASCIItoI   ; convert from ascii to Integer
add r2, r2, r3    ; r2 = num 1

ldi r1, digit1    ; shift digit1 to hundreds place
jsr MULTby10      ; MULTby10(r1 = num) -> r0
sti r0, digit1

ldi r1, digit2    ; shift digit2 to tens place
jsr MULTby10      ; MULTby10(r1 = num) -> r0
sti r0, digit2

sti r2, digit3    ; store digit3 in ones place

INPUT_DONE

jsr SUM
ld r1, num
ld r2, input_count
ldr r0, r1, r2  ; load sum into base + count

ldr r7, r6, x0      ;pop stack
add r6, r6, x1
ret



; =======================================
; SUM utility routine for input
; just adds all the digits once they've been properly converted to r0
SUM 

add r6, r6, #-1 ;push onto stack
str r7, r6, x0  ;return address


ldi r0, digit1
ldi r1, digit2
ldi r2, digit3
and r4, r4, x0
add r4, r4, r0
add r4, r4, r1
add r4, r4, r2
str r4, num_sum


ldr r7, r6, x0      ;pop stack
add r6, r6, x1
ret

;=========================================

;==========================================
; utility function for input
; works fine, no need to change
MULTby10      ; result in r0 input in r1

add r6, r6, #-1 ;push onto stack
str r7, r6, x0  ;return address

and r0, r0, x0

and r3, r3, x0
add r3, r3, xa

and r2, r2, x0
add r2, r2, r1

MULT_LOOP
add r3, r3, x0
brnz MULT_DONE
add r0, r0, r2
add r3, r3, #-1
br MULT_LOOP

MULT_DONE

ldr r7, r6, x0      ;pop stack
add r6, r6, x1
ret
;==============================================

enter_num .stringz "Enter a num 1-999: "

ASCIItoI .fill #-48
ItoASCII .fill #48

char_enter .fill #-13
char_zero .fill #-48
char_nine .fill #-57

digit1 .fill x3150
digit2 .fill x3151
digit3 .fill x3152
num_sum .fill x3153
input_count .fill x3154
.end
