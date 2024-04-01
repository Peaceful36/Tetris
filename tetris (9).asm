################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Hoa Nguyen, 1007996830
# Student 2: Shizhuo Liao 1008768442
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8 
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   168
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################
GREY: .word 0xaaaaaa
light_grey: .word 0xd3d3d3
dark_grey: .word 0x3b3b3b
RED: .word 0xFF2E2E
ORANGE: .word 0xFFA74F
YELLOW: .word 0xFFFF00
GREEN: .word 0x00FF00
BLUE: .word 0x75E6DA
PURPLE: .word 0xca9bf7
WHITE: .word 0xFFFFFF

rotation: .space 4
id: .space 4
next_piece: .space 4
first_piece: .space 4
current_piece: .space 4
line: .space 4
count: .space 4
##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    # Initialize the game
    # initialize the loop variables $t5, $t6
add $t5, $zero, $zero	# set $t5 to zero
addi $t6, $zero, 20
lw $t1, GREY
lw $t0, ADDR_DSPL

draw_walls_sides:
beq $t5, $t6, reset_value	# Branch to Exit if $t5 == 16

sw $t1, 0($t0) 		# paint the first (top-left) unit
addi $t0, $t0, 44 	# move to the next pixel over in the bitmap
sw $t1, 0($t0) 		# paint the first unit on the second row.
addi $t0, $t0, 84   	
sw $t1, 0($t0) 	
addi $t5, $t5, 1	# increment $t5 by 1
j draw_walls_sides

reset_value: # reset the register to start drawing bottom wall
add $t5, $zero, $zero	# set $t5 to zero
addi $t6, $zero, 11
lw $t0, ADDR_DSPL
addi $t0, $t0, 2560
j draw_wall_bottom

draw_wall_bottom:
beq $t5, $t6, draw_preview 
sw $t1, 0($t0)
addi, $t0, $t0, 4
sw $t1, 0($t0)
addi $t5, $t5, 1	# increment $t5 by 1
j draw_wall_bottom

draw_preview:
    lw $t0, ADDR_DSPL
    lw $t6, GREY
    sw $t6, 1072($t0)
    sw $t6, 1076($t0)
    sw $t6, 1080($t0)
    sw $t6, 1084($t0)
    sw $t6, 1088($t0)
    sw $t6, 1092($t0)
    sw $t6, 1860($t0)
    sw $t6, 1732($t0)
    sw $t6, 1604($t0)
    sw $t6, 1476($t0)
    sw $t6, 1348($t0)
    sw $t6, 1220($t0)
    sw $t6, 1856($t0)
    sw $t6, 1852($t0)
    sw $t6, 1848($t0)
    sw $t6, 1844($t0)
    sw $t6, 1840($t0)

game_loop:

    lw $t9, first_piece
    bne $t9, 0, draw_next
    
    li $v0, 42 #Load random integer from 0 to 6
    li $a0, 0
    li $a1, 7
    syscall 
    sw $a0, id
    
    draw_next:
    
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1332
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 128
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, 128
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 124
    sw $zero, 0($t0)
    
    bne $t9, 0, set_piece
    addi $t9, $zero, 1
    sw $t9, first_piece
    lw $t6, id
    set_piece:
    lw $t9, current_piece
    sw $t9, id
    
    
    
    li $v0, 42 #Load random integer from 0 to 6
    li $a0, 0
    li $a1, 7
    syscall
    sw $a0, next_piece
    
    lw $t6, next_piece
    sw $zero, rotation
    beq $t6, 0, next0
    beq $t6, 1, next1
    beq $t6, 2, next2
    beq $t6, 3, next3
    beq $t6, 4, next4
    beq $t6, 5, next5
    beq $t6, 6, next6
    
    next0: # O tetris
        lw $t0, ADDR_DSPL
        j draw_O2
    next1: # S tetris
        lw $t0, ADDR_DSPL
        j draw_S2
    next2: # I tetris
        lw $t0, ADDR_DSPL
        j draw_I2
    next3: # Z tetris
        lw $t0, ADDR_DSPL
        j draw_Z2
    next4: # L tetris
        lw $t0, ADDR_DSPL
        j draw_L2
    next5: # J tetris
        lw $t0, ADDR_DSPL   
        j draw_J2
    next6: # T tetris
        lw $t0, ADDR_DSPL
        j draw_T2
        
    draw_piece:
    
    
    lw $t6, id
    sw $zero, rotation
    beq $t6, 0, tetris0
    beq $t6, 1, tetris1
    beq $t6, 2, tetris2
    beq $t6, 3, tetris3
    beq $t6, 4, tetris4
    beq $t6, 5, tetris5
    beq $t6, 6, tetris6
    
    tetris0: # O tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 24($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        lw $t7, 152($t0)
        bne $t7, $zero, game_over
        j draw_O
    tetris1: # S tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 24($t0)
        bne $t7, $zero, game_over
        lw $t7, 144($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        j draw_S
    tetris2: # I tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        lw $t7, 276($t0)
        bne $t7, $zero, game_over
        lw $t7, 404($t0)
        bne $t7, $zero, game_over
        j draw_I
    tetris3: # Z tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 24($t0)
        bne $t7, $zero, game_over
        lw $t7, 152($t0)
        bne $t7, $zero, game_over
        lw $t7, 156($t0)
        bne $t7, $zero, game_over
        j draw_Z
    tetris4: # L tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        lw $t7, 276($t0)
        bne $t7, $zero, game_over
        lw $t7, 280($t0)
        bne $t7, $zero, game_over
        j draw_L
    tetris5: # J tetris
        lw $t0, ADDR_DSPL
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        lw $t7, 272($t0)
        bne $t7, $zero, game_over
        lw $t7, 276($t0)
        bne $t7, $zero, game_over
        j draw_J
    tetris6: # T tetris
        lw $t0, ADDR_DSPL
        lw $t7, 16($t0)
        bne $t7, $zero, game_over
        lw $t7, 20($t0)
        bne $t7, $zero, game_over
        lw $t7, 24($t0)
        bne $t7, $zero, game_over
        lw $t7, 148($t0)
        bne $t7, $zero, game_over
        j draw_T
    
    add $t7,$zero, $zero
	keyboard:
    	   lw $t9, ADDR_KBRD  # Load the address of the keyboard
    	   lw $t8, 0($t9) # Load the keyboard input
    	   beq $t8, 1, keyboard_input # If first word 1, key is pressed
	
	loop:
	   delay:
    	   beq $t7, 10, skey
    	   addi $t7, $t7, 1
    	   li $v0, 32
    	   li $a0, 50
	       syscall
	       lw $t9, ADDR_KBRD  # Load the address of the keyboard
    	   lw $t8, 0($t9) # Load the keyboard input
    	   beq $t8, 1, keyboard_input # If first word 1, key is pressed
	   j keyboard

    
#A key is pressed
keyboard_input:
    lw $t7, 4($t9)
    beq $t7, 119, wkey
    beq $t7, 100, dkey
    beq $t7, 115, skey
    beq $t7, 97, akey
    beq $t7, 113, qkey
    beq $t7, 112, pkey # Pause
pkey:
    
akey:
    lw $t6, id
    beq $t6, 0, a0
    beq $t6, 1, a1
    beq $t6, 2, a2
    beq $t6, 3, a3
    beq $t6, 4, a4
    beq $t6, 5, a5
    beq $t6, 6, a6
    
    update_a:
        sw $zero, 0($t2)
        sw $zero, 0($t3)
        sw $zero, 0($t4)
        sw $zero, 0($t5)
        addi $t2, $t2, -4
        addi $t3, $t3, -4
        addi $t4, $t4, -4
        addi $t5, $t5, -4
            
        exita:
        sw $t1, 0($t2)
        sw $t1, 0($t3)
        sw $t1, 0($t4)
        sw $t1, 0($t5)
        j keyboard
        
collision_a1:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $t7, -4($a1)
    beq $t7, $zero, successa
    j faila
collision_a2:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $t7, -4($a1)
    beq $t7, $zero, ifa2
    j faila
    ifa2:
        lw $t7, -4($a2)
        beq $t7, $zero, successa
        j faila
collision_a3:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    lw $t7, -4($a1)
    beq $t7, $zero, ifa3
    j faila
    ifa3:
        lw $t7, -4($a2)
        beq $t7, $zero, L1
       j faila
    L1:
        lw $t7, -4($a3)
        beq $t7, $zero, successa
        j faila
    
a0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a2
    
a1:
    lw $t8, rotation
    beq $t8, 0, collision_0
    beq $t8, 1, collision_90
    beq $t8, 2, collision_0
    beq $t8, 3, collision_90
   collision_0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a2
    collision_90:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a3
a2:
    lw $t8, rotation
    beq $t8, 0, collision_a2_0
    beq $t8, 1, collision_a2_90
    beq $t8, 2, collision_a2_0
    beq $t8, 3, collision_a2_90
    
    collision_a2_0:
    lw $t7, -4($t2)
    beq $t7, $zero, ifa4
    j faila
    ifa4:
        lw $t7, -4($t3)
        beq $t7, $zero, L2
        j faila
    L2:
        lw $t7, -4($t4)
        beq $t7, $zero, L3
        j faila
    L3:
        lw $t7, -4($t5)
        beq $t7, $zero, successa
        j faila
        
    collision_a2_90:
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a1
a3:
    lw $t8, rotation
    beq $t8, 0, collision_a3_Z0
    beq $t8, 1, collision_a3_Z90
    beq $t8, 2, collision_a3_Z0
    beq $t8, 3, collision_a3_Z90
    
    collision_a3_Z0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a2
    
    collision_a3_Z90:
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_a2
    
a4:
    lw $t8, rotation
    beq $t8, 0, collision_a4_0
    beq $t8, 1, collision_a4_90
    beq $t8, 2, collision_a4_180
    beq $t8, 3, collision_a4_270
    
    collision_a4_0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a3
    
    collision_a4_90:
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_a2
    
    collision_a4_180:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_a3
    
    collision_a4_270:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_a2
    
a5:
    lw $t8, rotation
    beq $t8, 0, collision_a5_0
    beq $t8, 1, collision_a5_90
    beq $t8, 2, collision_a5_180
    beq $t8, 3, collision_a5_270
    collision_a5_0:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_a3
    collision_a5_90:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a2
    collision_a5_180:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a3
    collision_a5_270:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_a2
a6:
    lw $t8, rotation
    beq $t8, 0, collision_a6_0
    beq $t8, 1, collision_a6_90
    beq $t8, 2, collision_a6_180
    beq $t8, 3, collision_a6_270
    collision_a6_0:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a2
    collision_a6_90:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a3
    collision_a6_180:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_a2
    collision_a6_270:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_a3
    
successa:
    add $t7,$zero, $zero
    j update_a
faila:
    add $t7,$zero, $zero
    j keyboard

skey:
     lw $t6, id
    beq $t6, 0, s0
    beq $t6, 1, s1
    beq $t6, 2, s2
    beq $t6, 3, s3
    beq $t6, 4, s4
    beq $t6, 5, s5
    beq $t6, 6, s6
    
    update_s:
        sw $zero, 0($t2)
        sw $zero, 0($t3)
        sw $zero, 0($t4)
        sw $zero, 0($t5)
        addi $t2, $t2, 128
        addi $t3, $t3, 128
        addi $t4, $t4, 128
        addi $t5, $t5, 128
        exits:       
        sw $t1, 0($t2)
        sw $t1, 0($t3)
        sw $t1, 0($t4)
        sw $t1, 0($t5)
        j keyboard

collision_s1:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 128($a1)
    beq $t7, $zero, successs
    j fails
collision_s2:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 128($a1)
    beq $t7, $zero, ifs2
    j fails
    ifs2:
        lw $t7, 128($a2)
        beq $t7, $zero, successs
        j fails
collision_s3:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 128($a1)
    beq $t7, $zero, ifs3
    j fails
    ifs3:
        lw $t7, 128($a2)
        beq $t7, $zero, L7
        j fails
    L7:
        lw $t7, 128($a3)
        beq $t7, $zero, successs
        j fails
s0:
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s2
s1:
    lw $t8, rotation
    beq $t8, 0, collision_s0
    beq $t8, 1, collision_s90
    beq $t8, 2, collision_s0
    beq $t8, 3, collision_s90
   collision_s0:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s3
    collision_s90:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s2
s2:
    lw $t8, rotation
    beq $t8, 0, collision_s2_0
    beq $t8, 1, collision_s2_90
    beq $t8, 2, collision_s2_0
    beq $t8, 3, collision_s2_90
    
    collision_s2_0:
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s1
    
    collision_s2_90:
    lw $t0, dark_grey
    lw $t7, 128($t2)
    beq $t7, $zero, ifs4
    bne $t7, $t0, fails
    ifs4:
        lw $t7, 128($t3)
        beq $t7, $zero, Ls2
        bne $t7, $t0, fails
    Ls2:
        lw $t7, 128($t4)
        beq $t7, $zero, Ls3
        bne $t7, $t0, fails
    Ls3:
        lw $t7, 128($t5)
        beq $t7, $zero, successs
        beq $t7, $t0, successs
        j fails
    
s3:
    lw $t8, rotation
    beq $t8, 0, collision_s3_0
    beq $t8, 1, collision_s3_90
    beq $t8, 2, collision_s3_0
    beq $t8, 3, collision_s3_90
    collision_s3_0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s3
    
    collision_s3_90:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    j collision_s2
    
s4:
    lw $t8, rotation
    beq $t8, 0, collision_s4_0
    beq $t8, 1, collision_s4_90
    beq $t8, 2, collision_s4_180
    beq $t8, 3, collision_s4_270
    
    collision_s4_0:
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s2
    
    collision_s4_90:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s3
    
    collision_s4_180:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_s2
    collision_s4_270:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_s3
    
s5:
    lw $t8, rotation
    beq $t8, 0, collision_s5_0
    beq $t8, 1, collision_s5_90
    beq $t8, 2, collision_s5_180
    beq $t8, 3, collision_s5_270
    collision_s5_0:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_s2
    collision_s5_90:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_s3
    collision_s5_180:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_s2
    collision_s5_270:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_s3
s6:
    lw $t8, rotation
    beq $t8, 0, collision_s6_0
    beq $t8, 1, collision_s6_90
    beq $t8, 2, collision_s6_180
    beq $t8, 3, collision_s6_270
    collision_s6_0:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_s3
    collision_s6_90:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_s2
    collision_s6_180:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_s3
    collision_s6_270:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_s2
    
    
successs:
    add $t7,$zero, $zero
    j update_s
fails:
    add $t7,$zero, $zero
    
    lw $t0, ADDR_DSPL
    add $t6, $zero, $zero
    addi $t0, $t0, 2432
    sw $t0, line
    
    check_line:
        lw $t0, line
        add $t6, $zero, $zero
        line_check:
            addi $t6, $t6, 4
            addi $t0, $t0, 4
            beq $t6, 44, remove_line
            lw $t8, 0($t0)
            beq $zero, $t8, check_next
            j line_check
            
    remove_line:
        addi $t6, $t6, -4
        addi $t0, $t0, -4
        sw $zero, 0($t0)
        beq $t6, 4, shift_line
        j remove_line
        
    shift_line:
        lw $t0, count
        addi $t0, $t0, 1
        sw $t0, count
        lw $t0, line
        shift:
            lw $t6, ADDR_DSPL
            add $t8, $zero, $zero
            beq $t0, $t6, fails
            addi $t0, $t0, -128
            add $t6, $t0, $zero
            paint_one:
                addi $t8, $t8, 4
                addi $t6, $t6, 4
                beq $t8, 44, shift
                lw $t9, 0($t6)
                sw $zero, 0($t6)
                sw $t9, 128($t6)
                j paint_one
        
    check_next:
        lw $t0, line
        lw $t6, ADDR_DSPL
        beq $t0, $t6, game_loop
        addi $t0, $t0, -128
        sw $t0, line
        j check_line
        
    j game_loop


dkey:
    lw $t6, id
    beq $t6, 0, d0
    beq $t6, 1, d1
    beq $t6, 2, d2
    beq $t6, 3, d3
    beq $t6, 4, d4
    beq $t6, 5, d5
    beq $t6, 6, d6
    
    update_d:
        sw $zero, 0($t2)
        sw $zero, 0($t3)
        sw $zero, 0($t4)
        sw $zero, 0($t5)
        addi $t2, $t2, 4
        addi $t3, $t3, 4
        addi $t4, $t4, 4
        addi $t5, $t5, 4
            
        exitd:
        sw $t1, 0($t2)
        sw $t1, 0($t3)
        sw $t1, 0($t4)
        sw $t1, 0($t5)
        j keyboard
collision_d1:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 4($a1)
    beq $t7, $zero, successd
    j faild
collision_d2:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 4($a1)
    beq $t7, $zero, ifd2
    j faild
    ifd2:
        lw $t7, 4($a2)
        beq $t7, $zero, successd
        j faild
collision_d3:
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a2, 0($sp)
    addi $sp, $sp, 4
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    lw $t7, 4($a1)
    beq $t7, $zero, ifd3
    j faild
    ifd3:
        lw $t7, 4($a2)
        beq $t7, $zero, L4
        j faild
    L4:
        lw $t7, 4($a3)
        beq $t7, $zero, successd
        j faild
d0:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d2
d1:
    lw $t8, rotation
    beq $t8, 0, collision_d0
    beq $t8, 1, collision_d90
    beq $t8, 2, collision_d0
    beq $t8, 3, collision_d90
   collision_d0:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d2
    collision_d90:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_d3
d2:
    lw $t8, rotation
    beq $t8, 0, collision_d2_0
    beq $t8, 1, collision_d2_90
    beq $t8, 2, collision_d2_0
    beq $t8, 3, collision_d2_90
    
    collision_d2_0:
    addi $t0, $zero, 0
    lw $t7, 4($t2)
    beq $t7, $zero, ifd4
    bne $t7, $t0, faild
    ifd4:
        lw $t7, 4($t3)
        beq $t7, $zero, L5
        bne $t7, $t0, faild
    L5:
        lw $t7, 4($t4)
        beq $t7, $zero, L6
        bne $t7, $t0, faild
    L6:
        lw $t7, 4($t5)
        beq $t7, $zero, successd
        beq $t7, $t0, successd
        j faild
        
    collision_d2_90:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    j collision_d1
    
d3:
    lw $t8, rotation
    beq $t8, 0, collision_dZ0
    beq $t8, 1, collision_dZ90
    beq $t8, 2, collision_dZ0
    beq $t8, 3, collision_dZ90
    
    collision_dZ0:
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d2
    
    collision_dZ90:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    jal collision_d2
    
    
d4:
    lw $t8, rotation
    beq $t8, 0, collision_d4_0
    beq $t8, 1, collision_d4_90
    beq $t8, 2, collision_d4_180
    beq $t8, 3, collision_d4_270
    
    collision_d4_0:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d3
    
    collision_d4_90:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d2
    
    collision_d4_180:
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    jal collision_d3
    
    collision_d4_270:
    addi $sp, $sp, -4
    sw $t4, 0($sp)
    addi $sp, $sp, -4
    sw $t5, 0($sp)
    jal collision_d2
    
    
d5:
    lw $t8, rotation
    beq $t8, 0, collision_d5_0
    beq $t8, 1, collision_d5_90
    beq $t8, 2, collision_d5_180
    beq $t8, 3, collision_d5_270
    collision_d5_0:
       addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_d3
    collision_d5_90:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_d2
    collision_d5_180:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_d3
    collision_d5_270:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_d2
d6:
    lw $t8, rotation
    beq $t8, 0, collision_d6_0
    beq $t8, 1, collision_d6_90
    beq $t8, 2, collision_d6_180
    beq $t8, 3, collision_d6_270
    collision_d6_0:
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_d2
    collision_d6_90:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t3, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        jal collision_d3
    collision_d6_180:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_d2
    collision_d6_270:
        addi $sp, $sp, -4
        sw $t2, 0($sp)
        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $sp, $sp, -4
        sw $t5, 0($sp)
        jal collision_d3
    
successd:
    add $t7,$zero, $zero
    j update_d
faild:
    add $t7,$zero, $zero
    j keyboard
    
wkey:
    lw $t9, rotation
    lw $t6, id
    beq $t6, 0, exit_w
    beq $t6, 1, rotate_S
    beq $t6, 2, rotate_I
    beq $t6, 3, rotate_Z
    beq $t6, 4, rotate_L
    beq $t6, 5, rotate_J
    beq $t6, 6, rotate_T
    
    
    rotate_S:
        lw $t9, rotation
        beq $t9, 0, rotate_S_90
        beq $t9, 1, rotate_S_180
        beq $t9, 2, rotate_S_270
        beq $t9, 3, rotate_S_360
        
        rotate_S_90:
            lw $t8, -128($t2)
            bne $t8, $zero, failw
            lw $t8, -124($t2)
            bne $t8, $zero, failw
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 4
            addi $t3, $t3, 128
            addi $t4, $t4, -252
            addi $t5, $t5, -128
            j exit_w
            
        rotate_S_180:
            lw $t8, 4($t4)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -4
            addi $t3, $t3, -128
            addi $t4, $t4, 252
            addi $t5, $t5, 128
            j exit_w
        
        rotate_S_270:
            j rotate_S_90
        rotate_S_360:
            lw $t8, 4($t4)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
            bne $t8, $zero, failw
            
            addi $t9, $zero, 0
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -4
            addi $t3, $t3, -128
            addi $t4, $t4, 252
            addi $t5, $t5, 128
            j exit_w
            
    rotate_I:
        beq $t9, 0, rotate_I_90
        beq $t9, 1, rotate_I_180
        beq $t9, 2, rotate_I_270
        beq $t9, 3, rotate_I_360
        
        rotate_I_90:
            lw $t8, 4($t4)
            bne $t8, $zero, failw
            lw $t8, 132($t4)
            bne $t8, $zero, failw
            lw $t8, -4($t2)
            bne $t8, $zero, failw
            lw $t8, -8($t2)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
            bne $t8, $zero, failw
            lw $t8, -4($t4)
            bne $t8, $zero, failw
            lw $t8, -8($t4)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 260
            addi $t3, $t3, 128
            addi $t4, $t4, -4
            addi $t5, $t5, -136
            j exit_w
            
        rotate_I_180:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -256($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t4)
            bne $t8, $zero, failw
            lw $t8, -256($t4)
            bne $t8, $zero, failw
            lw $t8, -128($t5)
            bne $t8, $zero, failw
            lw $t8, -256($t5)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -260
            addi $t3, $t3, -128
            addi $t4, $t4, 4
            addi $t5, $t5, 136
            j exit_w
        
        rotate_I_270:
            j rotate_I_90
        rotate_I_360:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -256($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t4)
            bne $t8, $zero, failw
            lw $t8, -256($t4)
            bne $t8, $zero, failw
            lw $t8, -128($t5)
            bne $t8, $zero, failw
            lw $t8, -256($t5)
            bne $t8, $zero, failw
            
            sw $zero, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -260
            addi $t3, $t3, -128
            addi $t4, $t4, 4
            addi $t5, $t5, 136
            j exit_w
            
     rotate_T:
        beq $t9, 0, rotate_T_90
        beq $t9, 1, rotate_T_180
        beq $t9, 2, rotate_T_270
        beq $t9, 3, rotate_T_360
        
        rotate_T_90:
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -124
            addi $t4, $t4, 124
            addi $t5, $t5, -132
            j exit_w
        rotate_T_180:
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 132
            addi $t4, $t4, -132
            addi $t5, $t5, -124
            j exit_w
        rotate_T_270:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 124
            addi $t4, $t4, -124
            addi $t5, $t5, 132
            j exit_w
        rotate_T_360:
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $zero, 0
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -132
            addi $t4, $t4, 132
            addi $t5, $t5, 124
            j exit_w
            
    rotate_Z:
        beq $t9, 0, rotate_Z_90
        beq $t9, 1, rotate_Z_180
        beq $t9, 2, rotate_Z_270
        beq $t9, 3, rotate_Z_360
        
        rotate_Z_90:
            lw $t8, -128($t2)
            bne $t8, $zero, failw
            lw $t8, -124($t2)
            bne $t8, $zero, failw
            lw $t8, -120($t2)
            bne $t8, $zero, failw
            lw $t8, 8($t2)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -120
            addi $t3, $t3, 4
            addi $t4, $t4, -128
            addi $t5, $t5, -4
            j exit_w
        
        rotate_Z_180:
            lw $t8, -4($t2)
            bne $t8, $zero, failw
            lw $t8, -8($t2)
            bne $t8, $zero, failw
            lw $t8, -4($t4)
            bne $t8, $zero, failw
            lw $t8, 4($t5)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 120
            addi $t3, $t3, -4
            addi $t4, $t4, 128
            addi $t5, $t5, 4
            j exit_w
        rotate_Z_270:
            j rotate_Z_90
        rotate_Z_360:
            lw $t8, -4($t2)
            bne $t8, $zero, failw
            lw $t8, -8($t2)
            bne $t8, $zero, failw
            lw $t8, -4($t4)
            bne $t8, $zero, failw
            lw $t8, 4($t5)
            bne $t8, $zero, failw
            
            addi $t9, $zero, 0
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 120
            addi $t3, $t3, -4
            addi $t4, $t4, 128
            addi $t5, $t5, 4
            j exit_w
        
    rotate_L:
        beq $t9, 0, rotate_L_90
        beq $t9, 1, rotate_L_180
        beq $t9, 2, rotate_L_270
        beq $t9, 3, rotate_L_360
        
        rotate_L_90:
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 132
            addi $t4, $t4, -132
            addi $t5, $t5, -8
            j exit_w
        rotate_L_180:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 124
            addi $t4, $t4, -124
            addi $t5, $t5, -256
            j exit_w
        rotate_L_270:
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -132
            addi $t4, $t4, 132
            addi $t5, $t5, 8
            j exit_w
        rotate_L_360:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            
            add $t9, $zero, $zero
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -124
            addi $t4, $t4, 124
            addi $t5, $t5, 256
            j exit_w
            
    rotate_J:
        beq $t9, 0, rotate_J_90
        beq $t9, 1, rotate_J_180
        beq $t9, 2, rotate_J_270
        beq $t9, 3, rotate_J_360
        
        rotate_J_90:
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 132
            addi $t5, $t5, -132
            addi $t4, $t4, -256
            j exit_w
        rotate_J_180:
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, 124
            addi $t5, $t5, -124
            addi $t4, $t4, 8
            j exit_w
        rotate_J_270:
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, 132($t3)
            bne $t8, $zero, failw
            
            addi $t9, $t9, 1
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -132
            addi $t5, $t5, 132
            addi $t4, $t4, 256
            j exit_w
        rotate_J_360:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -128($t3)
            bne $t8, $zero, failw
            lw $t8, -132($t3)
            bne $t8, $zero, failw
            lw $t8, 124($t3)
            bne $t8, $zero, failw
            
            addi $t9, $zero, 0
            sw $t9, rotation
            sw $zero, 0($t2)
            sw $zero, 0($t3)
            sw $zero, 0($t4)
            sw $zero, 0($t5)
            addi $t2, $t2, -124
            addi $t5, $t5, 124
            addi $t4, $t4, -8
            j exit_w
            
    exit_w:
        sw $t1, 0($t2)
        sw $t1, 0($t3)
        sw $t1, 0($t4)
        sw $t1, 0($t5)
        add $t7,$zero, $zero
        j keyboard    
failw:
    add $t7,$zero, $zero
    j keyboard
    
qkey:
    j Exit

draw_O:
    lw $t1, YELLOW
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
draw_S:
    lw $t1, RED
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 120
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
draw_I:
    lw $t1, BLUE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
draw_Z:
    lw $t1, GREEN
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
draw_L:
    lw $t1, ORANGE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
draw_J:
    lw $t1, WHITE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 20
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
    
draw_T:
    lw $t1, PURPLE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 16
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j keyboard
    
draw_O2:
    sw $t6, current_piece
    lw $t1, YELLOW
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1336
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
draw_S2:
    sw $t6, current_piece
    lw $t1, RED
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1336
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 120
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
draw_I2:
    sw $t6, current_piece
    lw $t1, BLUE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1336
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
draw_Z2:
    sw $t6, current_piece
    lw $t1, GREEN
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1332
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
draw_L2:
    sw $t6, current_piece
    lw $t1, ORANGE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1332
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
draw_J2:
    sw $t6, current_piece
    lw $t1, WHITE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1336
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 128
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
    
draw_T2:
    sw $t6, current_piece
    lw $t1, PURPLE
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1332
    add $t2, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t3, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    add $t4, $zero, $t0
    sw $t1, 0($t0)
    addi $t0, $t0, 124
    add $t5, $zero, $t0
    sw $t1, 0($t0)
    j draw_piece
     
game_over:
    lw $t0, ADDR_DSPL
    addi $t0, $t0, 1332
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 128
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, -4
    sw $zero, 0($t0)
    addi $t0, $t0, 128
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 4
    sw $zero, 0($t0)
    addi $t0, $t0, 124
    sw $zero, 0($t0)
    
    lw $t0, ADDR_DSPL
    addi $t6, $zero, 0
    sw $t6, 1072($t0)
    sw $t6, 1076($t0)
    sw $t6, 1080($t0)
    sw $t6, 1084($t0)
    sw $t6, 1088($t0)
    sw $t6, 1092($t0)
    sw $t6, 1860($t0)
    sw $t6, 1732($t0)
    sw $t6, 1604($t0)
    sw $t6, 1476($t0)
    sw $t6, 1348($t0)
    sw $t6, 1220($t0)
    sw $t6, 1856($t0)
    sw $t6, 1852($t0)
    sw $t6, 1848($t0)
    sw $t6, 1844($t0)
    sw $t6, 1840($t0)

    lw $t0, ADDR_DSPL
    lw $t6, RED
    sw $t6, 308($t0)
    sw $t6, 312($t0)
    sw $t6, 316($t0)
    sw $t6, 320($t0)
    sw $t6, 436($t0)
    sw $t6, 564($t0)
    sw $t6, 692($t0)
    sw $t6, 820($t0)
    sw $t6, 824($t0)
    sw $t6, 828($t0)
    sw $t6, 832($t0)
    sw $t6, 704($t0)
    sw $t6, 576($t0)
    sw $t6, 572($t0)
    lw $t6, ORANGE
    sw $t6, 328($t0)
    sw $t6, 456($t0)
    sw $t6, 584($t0)
    sw $t6, 712($t0)
    sw $t6, 840($t0)
    sw $t6, 332($t0)
    sw $t6, 336($t0)
    sw $t6, 464($t0)
    sw $t6, 592($t0)
    sw $t6, 720($t0)
    sw $t6, 848($t0)
    sw $t6, 588($t0)
    lw $t6, YELLOW
    sw $t6, 344($t0)
    sw $t6, 348($t0)
    sw $t6, 352($t0)
    sw $t6, 356($t0)
    sw $t6, 360($t0)
    sw $t6, 472($t0)
    sw $t6, 600($t0)
    sw $t6, 728($t0)
    sw $t6, 856($t0)
    sw $t6, 480($t0)
    sw $t6, 608($t0)
    sw $t6, 736($t0)
    sw $t6, 864($t0)
    sw $t6, 488($t0)
    sw $t6, 616($t0)
    sw $t6, 744($t0)
    sw $t6, 872($t0)
    lw $t6, PURPLE
    sw $t6, 368($t0)
    sw $t6, 372($t0)
    sw $t6, 376($t0)
    sw $t6, 496($t0)
    sw $t6, 624($t0)
    sw $t6, 628($t0)
    sw $t6, 632($t0)
    sw $t6, 752($t0)
    sw $t6, 880($t0)
    sw $t6, 884($t0)
    sw $t6, 888($t0)
    lw $t6, GREY
    sw $t6, 1076($t0)
    sw $t6, 1080($t0)
    sw $t6, 1084($t0)
    sw $t6, 1088($t0)
    sw $t6, 1204($t0)
    sw $t6, 1332($t0)
    sw $t6, 1460($t0)
    sw $t6, 1588($t0)
    sw $t6, 1592($t0)
    sw $t6, 1596($t0)
    sw $t6, 1600($t0)
    sw $t6, 1472($t0)
    sw $t6, 1344($t0)
    sw $t6, 1216($t0)
    lw $t6, BLUE
    sw $t6, 1352($t0)
    sw $t6, 1484($t0)
    sw $t6, 1616($t0)
    sw $t6, 1492($t0)
    sw $t6, 1368($t0)
    lw $t6, WHITE
    sw $t6, 1120($t0)
    sw $t6, 1124($t0)
    sw $t6, 1128($t0)
    sw $t6, 1248($t0)
    sw $t6, 1376($t0)
    sw $t6, 1380($t0)
    sw $t6, 1384($t0)
    sw $t6, 1504($t0)
    sw $t6, 1632($t0)
    sw $t6, 1636($t0)
    sw $t6, 1640($t0)
    lw $t6, GREEN
    sw $t6, 1264($t0)
    sw $t6, 1268($t0)
    sw $t6, 1272($t0)
    sw $t6, 1392($t0)
    sw $t6, 1520($t0)
    sw $t6, 1648($t0)
    
    keyboard_lose:
	   lw $t9, ADDR_KBRD  # Load the address of the keyboard
	   lw $t8, 0($t9) # Load the keyboard input
	   beq $t8, 1, keyboard_choose # I
	   j keyboard_lose
	   
keyboard_choose:
    lw $t7, 4($t9)
    beq $t7, 114, rkey  # Restart the game
    beq $t7, 113, qkey
    j keyboard_lose
    
rkey:
    lw $t0, ADDR_DSPL
    add $t6, $zero, $zero
    clear:
        beq $t6, 2560, main
        sw $zero, 0($t0)
        addi $t6, $t6, 4
        addi $t0, $t0, 4
        j clear
    
Exit:
li $v0, 10 # terminate the program gracefully
syscall