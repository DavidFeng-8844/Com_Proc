// Rotate.asm

//RAM[3] for the original number, RAM[4] for the number of ratations and RAM[5] for the result
// Set RAM[0] as the counter
// Directly modify RAM 3
@4
D = M
@i
M = D //Assign the rotate number to i
@R0
M = 0 //Set the adder for overflow check
(loop)

    // break condition
	@i
	D = M - 1
	@loopEnd
    D;JLT

    //body
    @R0
    M = 0  // Init the adder
    @3
    D = M

    // overFlowCheck
    @overFlowCheck
    D;JLT

    (finishCheck)
    @3 // Rotate the number
    M = M + D

    @R0 // Check if overflow
    D = M

    @3 // Add the overflow to the original number
    M = M + D
    D = M

    @i  // Decrement the counter
    M = M - 1

    @loop
    0;JMP
(loopEnd)

@5 // Store the result
M = D

(END)
@END
0;JMP

(overFlowCheck)
    @R0
    M = 1
    @finishCheck
    0;JMP