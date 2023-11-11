	.data
Matrix:	.asciiz	"......................0.....0......0......0...........0....0..0...........0..0.......0....0......0..0....0...0............0.........0...00..........0.....0...............000......0....0....0..............000........000....0....000....0....0........00.....0"

	.text
Main:		
		addi $t0, $zero, 0 # row counter = 0
		addi $t1, $zero, 0 # column counter = 0
		li $s2, 48 # loading '0' character
		li $s3, 46 # loading '.' character
		li $s4, 97 # loading 'a' character to remind which bomb will explode first
		la $t3, Matrix # To move in the matrix
		jal PrintMap
		li $a0, 10
		syscall
		
OuterLoop:	
		beq $t0, 16, PhaseThree # When t0 equals 16 breaks the loop
		addi $t0, $t0, 1 #row++
		addi $t1, $zero, 0 # reseting column count
InnerLoop:	
		beq $t1, 16, OuterLoop # When t1 equals, go back to outer loop
		addi $t1, $t1, 1 #column++
		lb $s1, 0($t3) # next element
		addi $t3, $t3, 1
		bne $s1, $s3, PutA
		j PutZero
		
PutA:		
		sb $s4, -1($t3)
		j InnerLoop
		
PutZero:	
		sb $s2, -1($t3)
		j InnerLoop
		
PhaseThree:	
		la $t3, Matrix
		jal PrintMap
		li $a0, 10
		syscall
		addi $t0, $zero, 0 # row counter = 0
		addi $t1, $zero, 0 # column counter = 0
OuterLoopTwo:	
		beq $t0, 16, Exit
		addi $t0, $t0, 1
		addi $t1, $zero, 0 # reseting column count
InnerLoopTwo:
		beq $t1, 16, OuterLoopTwo
		addi $t1, $t1, 1
		lb $s1, 0($t3)
		addi $t3, $t3, 1
		beq $s1, $s4, ExplodeBomb
		j InnerLoopTwo
	
ExplodeBomb:
		sb $s3, -1($t3)
		bne $t0, 1, ExplodeUp
UpLink:
		bne $t0, 16, ExplodeDown
DownLink:
		bne $t1, 1, ExplodeLeft
LeftLink:
		bne $t1, 16, ExplodeRight
RightLink:
		j InnerLoopTwo
		
ExplodeUp:
		sb $s3, -17($t3)
		j UpLink
ExplodeDown:
		sb $s3, 15($t3)
		j DownLink
ExplodeLeft:
		sb $s3, -2($t3)
		j LeftLink
		
ExplodeRight:
		sb $s3, 0($t3)
		j RightLink

Exit:		la $t3, Matrix
		jal PrintMap
		li $a0, 10
		syscall
		li $v0, 10
    		syscall


PrintMap:	
		li $v0, 11 # To print matrix with syscall
		addi $t4, $zero, 0 # counter = 0
		addi $t5, $zero, 0 # counter to put \n = 0
PrintLoop:	
		beq $t4, 256, ExitFunc
		lb $a0, 0($t3)# Adress of matrix[i]
		beq $a0, 97, CaseA
LinkToHere:	
		syscall
		addi $t3, $t3, 1
		addi $t4, $t4, 1
		beq $t5, 15, PrintN
		addi $t5, $t5, 1
		j PrintLoop		
PrintN:		
		li $a0, 10
		syscall
		li $t5, 0
		j PrintLoop
CaseA:		
		li $a0, 48
		j LinkToHere
ExitFunc:	
		la $t3, Matrix
		jr $ra
			 