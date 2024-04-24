// FeistelEncryption.asm

// K0 in RAM[1] plaintext in RAM[2] result in RAM[0]
// 3 - 10 for intermediate text values
// ey 14 check bit, 15 - 17 for keys
// 18 Rotate clarity bit
// 0000 0000 1111 1111 -- 255

// Derive the other 3 keys from the original key
@1
D = M
// Subtract 128 from the key to check if the 8th bit is 1
@128
D = D - A
@8bit1-1
D;JGT
(finishCheck1)
@1
D = M
D = D + M
@255
D = D & A
@15
M = D
@14
D = M
@15 // K1
M = D + M

// Then Calculate K2 base on K1
@15
D = M
@128
D = D - A
@14
M = 0
@8bit1-2
D;JGT
(finishCheck2)
@15
D = M
D = D + M
@255
D = D & A
@16
M = D
@14
D = M
@16 // K2
M = D + M

// Then Calculate K3 base on K2
@16
D = M
@128
D = D - A
@14
M = 0
@8bit1-3
D;JGT
(finishCheck3)
@16
D = M
D = D + M
@255
D = D & A
@17
M = D
@14
D = M
@17 // K3
M = D + M

// Split the plaintext into two equal halves, L0 and R0
//R0
@2
D=M
@255
D=D&A
@4
M=D


//L0 by LOB 8 bits using loop
@8
D = A
@11
M = D
@2
D=M
@3
M=D

(loop1)
    // Break condition
    @11
    D = M - 1
    @loop1end
    D;JLT

    @18
    M = 0
    @3
    D = M
    @overFlowCheck1 // Assign RAM[18] to 1 if overflow (MSB is 1)
    D;JLT
    (finishOverflowCheck1)
    @3
    M = D + M
    D = M
    @18
    D = M
    @3
    M = D + M

    @11
    M = M - 1
    @loop1
    0;JMP
(loop1end)

// & the result with 255 to get the last 8 bits
@3
D = M
@255
D = D & A
@3
M = D


// Calculate L1, R1 (RAM 5,6)
// L1 = R0
@4
D = M
@5
M = D

// R1 = L0 XOR (R0 XOR !K0)
// Calculate R0 XOR !K0
//Calculate R0 & K0
@4
D = M
@1
D = D & M // Since no invert, no need to mask
// Store the result in RAM[20]
@20 // R0 & K0
M = D
// Calculate !R0 & !K0
@4
D = !M
// Mask !R0 to 8 bit
@255
D = D & A
// Store !R0 in RAM[21]
@21
M = D
@1
D = !M
@255
D = D & A // Mask !K0 to 8bit
@21
D = D & M
// Store the result in RAM[22]
@22 // !R0 & !K0
M = D
// Calculate R0 XOR !K0
@20
D = M
@22 // R0 XOR !K0
D = D | M
M = D
// Calculate L0 XOR RAM[22]
// RAM[23] = !L0 & RAM[22] RAM[24] = L0 & !RAM[22]
@3
D = !M
@255
D = D & A // D = !L0
@22
D = D & M
@23
M = D
@22
D = !M
@255
D = D & A
@3
D = D & M
@24
M = D
// Calculate RAM[23] | RAM[24]
@23
D = M
@24
D = D | M
@6
M = D // Value of R1


// Calculate the value of L2 and R2
// L2 = R1
@6
D = M
@7
M = D

// R2 = L1 XOR (R1 XOR !K1)
// Calculate R1 XOR !K1
//Calculate R1 & K1
@5
D = M
@15
D = D & M // Since no invert, no need to mask
// Store the result in RAM[25]
@25 // R1 & K1



(END)
@END
0;JMP


(8bit1-1)
    @14
    M = 1
    @finishCheck1
    0;JMP

(8bit1-2)
    @14
    M = 1
    @finishCheck2
    0;JMP

(8bit1-3)
    @14
    M = 1
    @finishCheck3
    0;JMP

(overFlowCheck1)
    @18
    M = 1
    @finishOverflowCheck1
    0;JMP

// @11
// M = D
// M = M + D
// @128    // Load the mask (0b10000000) into A
// D=D&A  // Extract the most significant bit of the key
// @11
// M = M + D



//
// // Perform the Feistel encryption algorithm
// // Repeat the encryption round for a desired number of rounds
//
// // Round 1
// // Encryption round using R1a, R1b, and 1 as inputs
// // Encryption function: R1a XOR 1
// @R1a
// D=!M
// // @1
// // D=D^M
// @1
// D=D&M
//
// @R2
// M = D
//
// @1
// D=!M
//
// @R1a
// D=D&M
//
// @R3
// M=D
//
// @R3
// M = D | M