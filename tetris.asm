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
RED: .word 0x44050f
ORANGE: .word 0x4d2c07
YELLOW: .word 0xFFFF00
GREEN: .word 0x2a420f
BLUE: .word 0x26404a
PURPLE: .word 0x21192e

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
lw $t1, dark_grey
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
beq $t5, $t6, init_draw_grid #start drawing grid after finish all the walls
sw $t1, 0($t0)
addi, $t0, $t0, 4
sw $t1, 0($t0)
addi $t5, $t5, 1	# increment $t5 by 1
j draw_wall_bottom

init_draw_grid:
add $t5, $zero, $zero	# set $t5 to zero
addi $t6, $zero, 5
lw $t1, GREY
lw $t0, ADDR_DSPL
addi $t2, $zero, 19 # change this line to change grid height 
addi $t3, $zero, 0
add $t4, $zero, 1
j draw_grid1

to_next_line:
add $t5, $zero, $zero	# set $t5 to zero
beq $t2, $t3, game_loop
addi $t0, $t0, 88
li $t7, 2      # Load 2 into $t7
div $t4, $t7   # Divide $t4 by 2
mfhi $t8       # Load the remainder into $t8
addi $t4, $t4, 1
addi $t3, $t3, 1
beq $t8, $zero, draw_grid1 # check which line of grid to draw
b draw_grid2

draw_grid1: # a line of the grid
beq $t5, $t6, to_next_line
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0) 
addi $t5, $t5, 1
j draw_grid1

draw_grid2: # another line of the grid
beq $t5, $t6, to_next_line
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0) 
addi $t5, $t5, 1
j draw_grid2


game_loop:

    li $v0, 42 #Load random integer from 0 to 6
    li $a0, 0
    li $a1, 6
    syscall
    
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    beq $a0, $t7, tetris0
    addi $t7, $t7, 1 
    beq $a0, $t7, tetris1
    addi $t7, $t7, 1
    beq $a0, $t7, tetris2
    addi $t7, $t7, 1
    beq $a0, $t7, tetris3
    addi $t7, $t7, 1
    beq $a0, $t7, tetris4
    addi $t7, $t7, 1
    beq $a0, $t7, tetris5
    addi $t7, $t7, 1
    beq $a0, $t7, tetris6
    
    tetris0: # O tetris
        j draw_O
    tetris1: # S tetris
        j draw_S
    tetris2: # I tetris
        j draw_I
    tetris3: # Z tetris
        j draw_Z
    tetris4: # L tetris
        j draw_L
    tetris5: # J tetris
        j draw_J
    tetris6: # T tetris
        j draw_T
        
	# 1a. Check if key has been pressed
	keyboard:
	   lw $t9, ADDR_KBRD  # Load the address of the keyboard
	   lw $t8, 0($t9) # Load the keyboard input
	   beq $t8, 1, keyboard_input # If first word 1, key is pressed
	
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    j keyboard
    
#A key is pressed
keyboard_input:
    lw $t7, 4($t9)
    beq $t7, 119, wkey
    beq $t7, 100, dkey
    beq $t7, 115, skey
    beq $t7, 97, akey
    beq $t7, 113, qkey

wkey:

    j keyboard
akey:
    lw $t0, GREY
    sw $t0, 0($t2)
    sw $t0, 0($t3)
    sw $t0, 0($t4)
    sw $t0, 0($t5)
    addi $t2, $t2, -4
    addi $t3, $t3, -4
    addi $t4, $t4, -4
    addi $t5, $t5, -4
    sw $t1, 0($t2)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    j keyboard
skey:
    lw $t0, GREY
    sw $t0, 0($t2)
    sw $t0, 0($t3)
    sw $t0, 0($t4)
    sw $t0, 0($t5)
    addi $t2, $t2, 128
    addi $t3, $t3, 128
    addi $t4, $t4, 128
    addi $t5, $t5, 128
    sw $t1, 0($t2)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
    j keyboard
dkey:
    lw $t0, GREY
    sw $t0, 0($t2)
    sw $t0, 0($t3)
    sw $t0, 0($t4)
    sw $t0, 0($t5)
    addi $t2, $t2, 4
    addi $t3, $t3, 4
    addi $t4, $t4, 4
    addi $t5, $t5, 4
    sw $t1, 0($t2)
    sw $t1, 0($t3)
    sw $t1, 0($t4)
    sw $t1, 0($t5)
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
    lw $t1, GREY
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
    j game_loop
    
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
    j game_loop
    
Exit:
li $v0, 10 # terminate the program gracefully
syscall