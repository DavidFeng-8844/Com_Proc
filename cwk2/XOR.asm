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

// Perform first AND operation between !R0 and R1, store the result in R3
@R0
D=!M
@R1
D=D&M
@R3
M=D

// Perform second AND operation between R0 and !R1, store the result in R4
@R1
D=!M
@R0
D=D&M
@R4
M=D

// Perform OR operation between R3 and R4, store the result in RAM5
@R3
D=M
@R4
D=D|M
@5
M=D

// End of program
(END)
@END
0;JMP