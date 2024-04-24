// Rotate.asm

// Load the original number from RAM[3] into R0
@3
D=M
@R0
M=D

// Load the number of times to rotate from RAM[4] into R1
@4
D=M
@R1
M=D

// Loop to rotate the bits R1 times
(LOOP)
  // Shift the bits of R0 to the left by 1
  @R0
  D=M
  D=D<<1
  @R0
  M=D

  // Check if the MSb of R0 is 1
  @R0
  D=M
  @32768
  D=D&A

  // If MSb is 1, set the LSb of R0 to 1
  @R0
  M=M|1

  // If MSb is 0, set the LSb of R0 to 0
  @R0
  D=M
  @32767
  D=D&A
  @R0
  M=D

  // Decrement R1 by 1
  @R1
  M=M-1

  // Check if R1 is greater than 0, if true, repeat the loop
  @R1
  D=M
  @LOOP
  D;JGT

// Store the final rotated number in R0 into RAM[5]
@R0
D=M
@5
M=D