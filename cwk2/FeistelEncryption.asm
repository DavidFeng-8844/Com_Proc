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
D;JGE
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
D;JGE
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
D;JGE
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

// Perform the Feistel encryption algorithm
// Store number of rounds in RAM[12]
@3
D = A 
@12
M = D

//Store Key 0 - 3 in RAM[25] - RAM[28]
@1
D = M
@25
M = D
@15
D = M
@26
M = D
@16
D = M
@27
M = D
@17
D = M
@28
M = D

// Store L0 in RAM[30]
@3
D = M
@30
M = D

// Calculate L1, R1 (RAM 5,6)
// L1 = R0
// Store R0 in RAM[13] for later loop, L_i = R_i-1
@4
D = M
@13
M = D
(loop2)
    // Break condition
    @12
    D = M
    @loop2end
    D;JLT

    @13
    D = M
    @5 // Assign Ri-1 to Li
    M = D

    // R1 = L0 XOR (R0 XOR !K0)
    // Calculate R0 XOR !K0
    //Calculate R0 & K0
    // Use Pointer to access to keys
    @12
    D = M 
    @28
    D = A - D // Ki = RAM[D]
    @29 // Use RAM[29] to store the key
    M = D
    A = M
    D = M // D = Ki
    @31
    M = D
    @13
    D = M
    @31
    D = D & M // Since no invert, no need to mask
    // Store the result in RAM[20]
    @20 // R0 & K0
    M = D
    // Calculate !R0 & !K0
    @13
    D = !M
    // Mask !R0 to 8 bit
    @255
    D = D & A
    // Store !R0 in RAM[21]
    @21
    M = D
    @31
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
    @30
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
    @30
    D = D & M
    @24
    M = D
    // Calculate RAM[23] | RAM[24]
    @23
    D = M
    @24
    D = D | M
    @6
    M = D // Value of Ri

    @13
    M = D
    @5
    D = M
    @30
    M = D // Value of Li

    @12
    M = M - 1
    @loop2
    0;JMP
(loop2end)


// LOB 8 bits of L1
@5
D = M
// Store the result of L0 in RAM7
@7
M = D
@8
D = A
@11
M = D
(loop3)
    // Break condition
    @11
    D = M - 1
    @loop3end
    D;JLT

    @18
    M = 0
    @7
    D = M
    @overFlowCheck2 // Assign RAM[18] to 1 if overflow (MSB is 1)
    D;JLT
    (finishOverflowCheck2)
    @7
    M = D + M
    D = M
    @18
    D = M
    @7
    M = D + M

    @11
    M = M - 1
    @loop3
    0;JMP
(loop3end)

//OR RAM[6] and RAM[7] to get the result and store in in RAM[0]
@6
D = M
@7
D = D | M
@0
M = D

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

(overFlowCheck2)
    @18
    M = 1
    @finishOverflowCheck2
    0;JMP