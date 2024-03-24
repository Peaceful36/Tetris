################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Hoa Nguyen, 1007996830
# Student 2: Name, Student Number (if applicable)
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8 
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
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
beq $t5, $t6, init_draw_grid #start drawing grid after finish all the walls
sw $t1, 0($t0)
addi, $t0, $t0, 4
sw $t1, 0($t0)
addi $t5, $t5, 1	# increment $t5 by 1
j draw_wall_bottom

init_draw_grid:
add $t5, $zero, $zero	# set $t5 to zero
addi $t6, $zero, 5
lw $t1, dark_grey
lw $t0, ADDR_DSPL
addi $t2, $zero, 19 # change this line to change grid height 
addi $t3, $zero, 0
add $t4, $zero, 1
j draw_grid1

to_next_line:
add $t5, $zero, $zero	# set $t5 to zero
beq $t2, $t3, draw_O
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
sw $zero, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0) 
addi $t5, $t5, 1
j draw_grid1

draw_grid2: # another line of the grid
beq $t5, $t6, to_next_line
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $zero, 0($t0) 
addi $t5, $t5, 1
j draw_grid2

draw_O: # temporary code for milestone 1
lw $t1, YELLOW
lw $t0, ADDR_DSPL
addi $t0, $t0, 16
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
addi $t0, $t0, 124
sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t1, 0($t0)
j Exit

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop

Exit:
li $v0, 10 # terminate the program gracefully
syscall