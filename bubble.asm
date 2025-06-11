.orig x3000
and r0, r0, x0
add r0, r0, x2
sti r0, num0

and r0, r0, x0
add r0, r0, x4
sti r0, num1

and r0, r0, x0
add r0, r0, x6
sti r0, num2

and r0, r0, x0
add r0, r0, x8
sti r0, num3

and r0, r0, x0
add r0, r0, xb
sti r0, num4

and r0, r0, x0
add r0, r0, xc
sti r0, num5

and r0, r0, x0
add r0, r0, xd
sti r0, num6

and r0, r0, x0
add r0, r0, xd
sti r0, num7

and r0, r0, x0
add r0, r0, x4 ; index 4

jsr SWAP 
halt

SWAP    ; count = r0
ld r1, num0
add r1, r1, r0    ; r1 = num1 + count

ldr r2, r1, x1    ; r2 = *(num1+count+1)
ldr r1, r1, x0    ; r1 = *(num1+count)


and r3, r3, x0    ; r3 = tmp = r1
add r3, r1, x0

and r1, r1, x0    ; r1 = r2
add r1, r2, x0

and r2, r2, x0    ; r2 = tmp
add r2, r3, x0
num1 .fill x3150
num2 .fill x3151
num3 .fill x3152
num4 .fill x3153

ld r3, num0     ; load num1*
add r3, r3, r0  ; num1* = num1* + count
str r1, r3, x0  ; store r1 -> num1 location
str r2, r3, x1  ; sotre r2 -> num1+1 location

ret



num0 .fill x3150
num1 .fill x3151
num2 .fill x3152
num3 .fill x3153
num4 .fill x3154
num5 .fill x3155
num6 .fill x3156
num7 .fill x3157
.end
