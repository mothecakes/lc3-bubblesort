.orig x3000

IN
add r2, r2, r0      ;copy input into r2
ld r3, ASCII
add r2, r2, r3      ;convert r2 into integer
sti r2, digit1      ;store r2 into digit1

and r2, r2, x0      ;clear r2 for second input
IN
add r2, r2, r0      ;copy input into r2
ld r3, ASCII
add r2, r2, r3      ;convert r2 into integer
sti r2, digit2      ;store r2 into digit2

ldi  r1, digit1      ; digit1 = MULTby10(digit1);
jsr MULTby10
sti r0, digit1

and r2, r2, x0      ;clear r2 for third input
IN
add r2, r2, r0      ;copy input into r2
ld r3, ASCII
add r2, r2, r3      ;convert r2 into integer
sti r2, digit3      ;store r2 into digit2

ldi  r1, digit1      ; digit1 = MULTby10(digit1);
jsr MULTby10
sti r0, digit1

ldi  r1, digit2      ; digit2 = MULTby10(digit2);
jsr MULTby10
sti r0, digit2

SUM 
ldi r0, digit1
ldi r1, digit2
ldi r2, digit3
and r4, r4, x0
add r4, r4, r0
add r4, r4, r1
add r4, r4, r2
str r4, sum

halt

MULTby10      ; result in r0 input in r1
st r2, saveReg2
st r3, saveReg3

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
ld r2, saveReg2
ld r3, saveReg3
ret


ASCII .fill #-48

digit1 .fill x3150
digit2 .fill x3151
digit3 .fill x3152
sum .fill x3153
saveReg2 .fill x0
saveReg3 .fill x0
.end
