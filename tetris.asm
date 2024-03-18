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
addi $t6, $zero, 32
lw $t1, GREY
lw $t0, ADDR_DSPL

draw_walls_sides:
beq $t5, $t6, reset_value	# Branch to Exit if $t5 == 16

sw $t1, 0($t0) 		# paint the first (top-left) unit
addi $t0, $t0, 80 	# move to the next pixel over in the bitmap
sw $t1, 0($t0) 		# paint the first unit on the second row.
addi $t0, $t0, 48   	
sw $t1, 0($t0) 	
addi $t5, $t5, 1	# increment $t5 by 1
j draw_walls_sides

reset_value: # reset the register to start drawing bottom wall
add $t5, $zero, $zero	# set $t5 to zero
addi $t6, $zero, 18
lw $t0, ADDR_DSPL
addi $t0, $t0, 3972
j draw_wall_bottom

draw_wall_bottom:
beq $t5, $t6, Exit
sw $t1, 0($t0)
addi, $t0, $t0, 4
sw $t1, 0($t0)
addi $t5, $t5, 1	# increment $t5 by 1
j draw_wall_bottom



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