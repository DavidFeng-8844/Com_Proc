// Rotate.asm

//RAM[3] for the original number, RAM[4] for the number of ratations and RAM[5] for the result
// Set RAM[0] as the counter
// Modify RAM 5, RAM 3 remains the same
@4
D = M
@i
M = D //Assign the rotate number to i
@R0
M = 0 //Set the adder for overflow check
@3
D = M
@5
M = D
@overFlowCheck
D;JLT

(loop)

    // break condition
	@i
	D = M - 1
	@loopEnd
    D;JLT

    //body
    @R0
    M = 0
    @5
    D = M

    // overFlowCheck
    @overFlowCheck
    D;JLT

    (finishCheck)
    @5
    M = M + D
    D = M

    @R0
    D = M
    @5
    M = M + D

    @i
    M = M - 1

    @loop
    0;JMP
(loopEnd)

(END)
@END
0;JMP

(overFlowCheck)
    @R0
    M = 1
    @finishCheck
    0;JMP