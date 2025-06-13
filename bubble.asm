.orig x3000
ORIGINATION
; === beginning of program
; right now this just initializes values in memory from x3150-3157 with some numbers in order to test
; feel free to change the values if you want

ld r6, stack_top  ; initialize stack pointer

and r0, r0, x0      ;init counter for input      
sti r0, main_count  

;INPUT_LOOP      
;  ldi r0, main_count   
;  and r3, r3, x0
;  add r3, r3, #-8
;
;  add r3, r0, r3
;  brzp INPUT_LOOP_BREAK
;
;  jsr INPUT
;  INPUT_LOOP_INCREMENT
;  ldi r0, main_count
;  add r0, r0, x1
;  sti r0, main_count 
;  br INPUT_LOOP

;INPUT_LOOP_BREAK

ld r0, num

and r1, r1, x0
add r1, r1, #11
str r1, r0, x0

and r1, r1, x0
add r1, r1, #8
str r1, r0, x1

and r1, r1, x0
add r1, r1, #2
str r1, r0, x2

and r1, r1, x0
add r1, r1, xf
add r1, r1, x2
str r1, r0, x3

and r1, r1, x0
add r1, r1, x6
str r1, r0, x4

and r1, r1, x0
add r1, r1, x4
str r1, r0, x5

and r1, r1, x0
add r1, r1, x3
str r1, r0, x6

and r1, r1, x0
add r1, r1, xf
add r1, r1, x6
str r1, r0, x7

jsr SORT  ; takes no parameters and should leave a sorted array in memory


; end of program
END
  halt

; ==========================================
; ===============================================================
SORT 

num 	.fill x3450
	.fill x3451
	.fill x3452
	.fill x3453
	.fill x3454
	.fill x3455
	.fill x3456
	.fill x3457
; sort function, struggling to make it work
; variable names are place holders so feel free to change them

  add r6, r6, #-1 ;push onto stack
  str r7, r6, x0  ;return address

  jsr SAVE_REG

  ; ======== init area ( runs only once) ============
  ld r4, num		; r4 reserved for base address

  and r5, r5, x0    ; i counter used for looping through every element atleast once.
  sti r5, sort_count_i 	; initialize count_i = 0 ;
                    ; once counter is complete, the data should be sorted.
                    ;
  and r5, r5, x0		; swapped keeps track of whether a swap occured during a single pass
  sti r5, sort_swapped   ; if no swap occurs, that means the list is already sorted and we 
                    ; can escape from the loop

; ========== loop 1 (i < n - 1) ==============
SORT_LOOP1        
  ldi r1, sort_count_i   ; loads the value of the incremented i

  ld r0, sort_count_i_MAX 
  add r0, r0, r1        ; check if count - max = 0
  brzp SORT_FINISHED    ; if i < i_max then keep looping  ; will always be sorted once this
                        ;conditional is met

  and r0, r0, x0        
  sti r0, sort_swapped  ;loop begins by marking swapped as false 

  and r2, r2, x0    ; clears r2 to set up for -(n - i - 1)
  add r2, r1, x0    ; r2 = i
  not r2, r2		
  add r2, r2, x1		; r2 = -i
  add r2, r2, #-1		; r2 = -i - 1
  ld r0, sort_n    ; r0 = n
  add r2, r2, r0		; r6 = n - i - 1 
  not r2, r2
  add r2, r2, x1		; -(n - i - 1)  ; we set this up so we 
                    ; loop for j
  sti r2, sort_count_j_max ; 

  and r3, r3, x0    ;
  sti r3, sort_count_j;   ; initialize j to 0

SORT_LOOP2 ; inner loop 
            ; since each pass, the largest value will bubble up to the last, 
            ; we don't need to access the n-i-1th value since it's in its 
            ; correct position
            ;
  ldi r3, sort_count_j 

  ldi r4, sort_count_j_max
  add r4, r4, r3      ; j - j_max
  brzp END_SORT_LOOP2 ;break out of loop if conditional doesn't apply

  ld r4, num ; we want our base address + count to find arr[j]

  add r4, r4, r3    ; r4 = base + count = j ; we will use this address to access elements
                    ; in our array by using ldr, r4, xOffset
                    ;
  add r1, r4, x0   ; r1 = base + count(j)
  ldr r0, r1, x0    ; load arr[j] to r0
  ldr r1, r1, x1    ; load arr[j+1] to r1

  and r2, r2, x0    
  add r2, r1, x0    ; copy arr[j+1] to r2
  not r2, r2
  add r2, r2, x1    ; r2 = - arr[j+1] ; for comparison's sake

  add r2, r2, r0    ; 
  brnz SORT_LOOP2_INCREMENT  ; arr[j] - arr[j+1] isn't positive, we don't want to swap, so pass
  and r0, r0, x0 
  add r0, r0, x1 
  sti r0, sort_swapped      ; turn on swapped flag

  ldi r0, sort_count_j       ; pass j as location to swap
  jsr SWAP                  ; SWAP(r0 = count) 
SORT_LOOP2_INCREMENT
  ldi r0, sort_count_j      ;increment j counter
  add r0, r0, x1
  sti r0, sort_count_j 
  br SORT_LOOP2             ;jump back to beginning of loop

END_SORT_LOOP2

  ldi r0, sort_swapped      ;check if swapped = 0
  add r0, r0, x0            ; if so, list is sorted
  brz END_SORT_LOOP1

SORT_LOOP1_INCREMENT
  ldi r0, sort_count_i      ;increment i
  add r0, r0, x1
  sti r0, sort_count_i

  br SORT_LOOP1           ; else just go back to the beginning of sort1

END_SORT_LOOP1
SORT_FINISHED
; restore registers

  jsr LOAD_REG

  ldr r7, r6, x0      ;pop stack
  add r6, r6, x1
ret

; =======================================================
; end of sort function




; ==========================================================================
; swap function that works properly
; just supply location of what to swap in r0, and the JSR SWAP
SWAP    ; count = r0
  add r6, r6, #-1
  str r7, r6, #0

  jsr SAVE_REG

  ld r1, num
  add r1, r1, r0    ; r1 = num1 + count

  ldr r2, r1, x1    ; r2 = *(num1+count+1)
  ldr r1, r1, x0    ; r1 = *(num1+count)


  and r3, r3, x0    ; r3 = tmp = r1
  add r3, r1, x0

  and r1, r1, x0    ; r1 = r2
  add r1, r2, x0

  and r2, r2, x0    ; r2 = tmp
  add r2, r3, x0

  ld r3, num     ; load num1*
  add r3, r3, r0  ; num1* = num1* + count
  str r1, r3, x0  ; store r1 -> num1 location
  str r2, r3, x1  ; sotre r2 -> num1+1 location

  jsr LOAD_REG
  ldr r7, r6, x0
  add r6, r6, x1
  ret


  ; ===============INPUT (count = r0)===========
  ; gathers up to 3 digit input
  ; stores each number into digits 1, 2, and 3 
  ; after each digit entered, all digits are multiplied by 10 
  ;   number in ones place, goes to tens place etc.
  ; when enter is pressed, all current digits are summed up
  ; and stored into its place in memory base + count
  ; 
;INPUT
;  add r6, r6, #-1
;  str r7, r6, #0
;
;  jsr SAVE_REG
;
;  sti r0, input_count
;
;INPUT_FIRST_NUM
;  lea r0, enter_num
;  puts              ;display prompt
;  getc              ;get char
;  out               ;echo
;
;;; INPUT VALIDATION PORTION
;  add r2, r0, x0    ; copy input to r2
;  ld r0, char_enter ; check if num is enter
;  add r0, r2, r0    
;  brz INPUT_DONE    ; skip to end
;  ld r0, char_zero  ;
;  add r0, r2, r0    ; if ascii of num is less than ascii 0 
;  brn INPUT_ERROR_1 ; 
;  ld r0, char_nine
;  add r0, r2, r0    ; if ascii of num is greather than ascii 9
;  brp INPUT_ERROR_1 ;
;
;  ld r3, ASCIItoI   ; convert from ascii to Integer
;  add r2, r2, r3    ; r2 = num 1
;
;  sti r2, digit1    ; store digit1 in ones place
;
;INPUT_SECOND_NUM
;  getc
;  out
;
;  ;; INPUT VALIDATION PORTION
;  add r2, r0, x0    ; copy input to r2
;  ld r0, char_enter ; check if num is enter
;  add r0, r2, r0    
;  brz INPUT_DONE    ; skip to end
;  ld r0, char_zero  ;
;  add r0, r2, r0    ; if ascii of num is less than ascii 0 
;  brn INPUT_ERROR_1 ; 
;  ld r0, char_nine
;  add r0, r2, r0    ; if ascii of num is greather than ascii 9
;  brp INPUT_ERROR_1 ;
;
;  ld r3, ASCIItoI   ; convert from ascii to Integer
;  add r2, r2, r3    ; r2 = num 1
;
;  sti r2, digit2    ; store digit2 in ones place
;
;  ldi r1, digit1    ; shift digit1 to tens place
;  jsr MULTby10      ; MULTby10(r1 = num) -> r0
;  sti r0, digit1
;
;
;INPUT_THIRD_NUM
;  getc
;  out
;
;;; INPUT VALIDATION PORTION
;  add r2, r0, x0    ; copy input to r2
;  ld r0, char_enter ; check if num is enter
;  add r0, r2, r0    
;  brz INPUT_DONE    ; skip to end
;  ld r0, char_zero  ;
;  add r0, r2, r0    ; if ascii of num is less than ascii 0 
;  brn INPUT_ERROR_1 ; 
;  ld r0, char_nine
;  add r0, r2, r0    ; if ascii of num is greather than ascii 9
;  brp INPUT_ERROR_1 ;
;
;  ld r3, ASCIItoI   ; convert from ascii to Integer
;  add r2, r2, r3    ; r2 = num 1
;
;  sti r2, digit3    ; store digit3 in ones place
;
;  ldi r1, digit1    ; shift digit1 to hundreds place
;  jsr MULTby10      ; MULTby10(r1 = num) -> r0
;  sti r0, digit1
;
;  ldi r1, digit2    ; shift digit2 to tens place
;  jsr MULTby10      ; MULTby10(r1 = num) -> r0
;  sti r0, digit2
;
;
;INPUT_DONE
;
;  jsr SUM
;  ld r1, num
;  ldi r2, input_count
;  add r1, r1, r2
;  str r0, r1, x0  ; load sum into base + count
;
;  ldr r7, r6, x0      ;pop stack
;  add r6, r6, x1
;  ret
;
;INPUT_ERROR_1 
;  lea r0, enter_err ;; error message
;  puts
;  ldr r7, r6, x0      ;pop stack
;  add r6, r6, x1
;  ret ; end program
;
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
add r0, r4, x0


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

and r0, r0, x0  ; clear r0

and r3, r3, x0  
add r3, r3, xa  ; r3 = 10

and r2, r2, x0  ; r2 = num to mult
add r2, r2, r1

MULT_LOOP
add r3, r3, x0  ;check if 10 times has past
brnz MULT_DONE
add r0, r0, r2  ; add r2 to r0
add r3, r3, #-1 ; decrement
br MULT_LOOP

MULT_DONE

ldr r7, r6, x0      ;pop stack
add r6, r6, x1
ret
;===============SAVE REGISTERS
SAVE_REG
add r6, r6, #-1
str r7, r6, #0

sti r0, saveReg0
sti r1, saveReg1
sti r2, saveReg2
sti r3, saveReg3
sti r4, saveReg4
sti r5, saveReg5
ldr r7, r6, x0
add r6, r6, x1
ret

LOAD_REG
add r6, r6, #-1
str r7, r6, #0
ldi r0, saveReg0
ldi r1, saveReg1
ldi r2, saveReg2
ldi r3, saveReg3
ldi r4, saveReg4
ldi r5, saveReg5
ldr r7, r6, x0
add r6, r6, x1
ret
;=======================================
main_count .fill x4100

stack_top .fill x4000

sort_swapped .fill x4159
sort_count_i_MAX .fill #-7
sort_count_i .fill x4158
sort_count_j_max .fill x415b
sort_count_j .fill x415a
sort_n .fill x8

saveReg0 .fill x4200
saveReg1 .fill x4201
saveReg2 .fill x4202
saveReg3 .fill x4203
saveReg4 .fill x4204
saveReg5 .fill x4205

; ================= INPUT VARIABLES ==============
enter_num .stringz "Enter a num 1-999: "
enter_err .stringz "invalid input retry"

ASCIItoI .fill #-48

char_enter .fill #-10
char_zero .fill #-48
char_nine .fill #-57

digit1 .fill x4350
digit2 .fill x4351
digit3 .fill x4352
num_sum .fill x4353
input_count .fill x4354

num_of_val .fill #-8

.end
