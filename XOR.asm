// XOR.asm

// Load the first value from RAM[3] into R0
@3
D=M
@R0
M=D

// Load the second value from RAM[4] into R1
@4
D=M
@R1
M=D

// Perform XOR operation between R0 and R1, store the result in R2
@R0t
D=M
@R1
D=D^M
@R2
M=D

// Store the result in R2 into RAM[5]
@R2
D=M
@5
M=D