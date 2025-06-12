.orig x3000

; === beginning of program
; right now this just initializes values in memory from x3150-3157 with some numbers in order to test
; feel free to change the values if you want

ld r1, num

and r0, r0, x0
add r0, r0, x2
str r0, r1, x0

and r0, r0, x0
add r0, r0, x4
str r0, r1, x1

and r0, r0, x0
add r0, r0, x6
str r0, r1, x2

and r0, r0, x0
add r0, r0, x8
str r0, r1, x3

and r0, r0, x0
add r0, r0, xb
str r0, r1, x4

and r0, r0, x0
add r0, r0, xc
str r0, r1, x5

and r0, r0, x0
add r0, r0, xd
str r0, r1, x6

and r0, r0, x0
add r0, r0, xd
str r0, r1, x7

; used to test input for swap.
; this swaps the 4th and 5th element
and r0, r0, x0
add r0, r0, x4 ; index 4

jsr SWAP 

; end of program
halt


; ===============================================================
SORT 
; sort function, struggling to make it work
; variable names are place holders so feel free to change them

; const base
; int count
; bool swapped
ld r4, base		;r4 reserved for base

and r5, r5, x0
sti r5, count_i 	;initialize count_i = 0

and r6, r6, x0		;initialize swapped = 0
sti r6, swapped

SORT_LOOP1
ldi r7, count_i

and r6, r6, x0		
add r6, r7, x0		; r6 = i
not r6, r6		
add r6, r6, x1		; r6 = -i
add r6, r6, #-1		; r6 = -i - 1
add r6, r7, x8		; r6 = n - i - 1 
not r6, r6
add r6, r6, x1		; -(n - i - 1)

add r7, r7, #-7		; n-1 = 7
brzp SORT_LOOP1_BREAK	; if count_i < n-1
and r7, r7, x0
sti r7, swapped		; swapped = false

			;for
and r2, r2, x0		
sti r2, count_j		;j = 0

SORT_LOOP2		

ldi r2, count_j		
ldi r3, count_j	
add r3, r3, r6	
brzp SORT_LOOP2_BREAK	; j < n-i-1
ldr r3, r4, r2		; r3 = ldr(base + count_j)

add r2, r2, x1
ldr r2, r4, r2		; r2 = ldr(base + count_j + 1)

add r5, r2, x0
not r5, r5
add r5, r5, x1		
add r5, r5, r3		; num[base+count] - num[base+count+1]
brnz SWAP_PASS		; num[base+count] > num[base+count+1]

; =======================================================
; end of sort function




; ==========================================================================
; swap function that works properly
; just supply location of what to swap in r0, and the JSR SWAP
SWAP    ; count = r0
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

ret

;=======================================


sort_count .fill x3158
sort_n .fill x8

num 	.fill x3150
	.fill x3151
	.fill x3152
	.fill x3153
	.fill x3154
	.fill x3155
	.fill x3156
	.fill x3157
.end
