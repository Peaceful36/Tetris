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
beq $t5, $t6, game_loop 
sw $t1, 0($t0)
addi, $t0, $t0, 4
sw $t1, 0($t0)
addi $t5, $t5, 1	# increment $t5 by 1
j draw_wall_bottom


game_loop:
    
    li $v0, 42 #Load random integer from 0 to 6
    li $a0, 0
    li $a1, 7
    syscall
    
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    sw $t7, rotation
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

akey:
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    beq $a0, $t7, a0
    addi $t7, $t7, 1 
    beq $a0, $t7, a1
    addi $t7, $t7, 1
    beq $a0, $t7, a2
    addi $t7, $t7, 1
    beq $a0, $t7, a3
    addi $t7, $t7, 1
    beq $a0, $t7, a4
    addi $t7, $t7, 1
    beq $a0, $t7, a5
    addi $t7, $t7, 1
    beq $a0, $t7, a6
    
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
    j update_a
faila:
    j keyboard

skey:
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    beq $a0, $t7, s0
    addi $t7, $t7, 1 
    beq $a0, $t7, s1
    addi $t7, $t7, 1
    beq $a0, $t7, s2
    addi $t7, $t7, 1
    beq $a0, $t7, s3
    addi $t7, $t7, 1
    beq $a0, $t7, s4
    addi $t7, $t7, 1
    beq $a0, $t7, s5
    addi $t7, $t7, 1
    beq $a0, $t7, s6
    addi $t7, $t7, 1
    
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
    j update_s
fails:
    j game_loop


dkey:
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    beq $a0, $t7, d0
    addi $t7, $t7, 1 
    beq $a0, $t7, d1
    addi $t7, $t7, 1
    beq $a0, $t7, d2
    addi $t7, $t7, 1
    beq $a0, $t7, d3
    addi $t7, $t7, 1
    beq $a0, $t7, d4
    addi $t7, $t7, 1
    beq $a0, $t7, d5
    addi $t7, $t7, 1
    beq $a0, $t7, d6
    
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
    j update_d
faild:
    j keyboard
    
wkey:
    lw $t9, rotation
    add $t7, $zero, $zero # set t7 to 0 and randomly load piece
    beq $a0, $t7, exit_w
    addi $t7, $t7, 1 
    beq $a0, $t7, rotate_S
    addi $t7, $t7, 1
    beq $a0, $t7, rotate_I
    addi $t7, $t7, 1
    beq $a0, $t7, rotate_Z
    addi $t7, $t7, 1
    beq $a0, $t7, rotate_L
    addi $t7, $t7, 1
    beq $a0, $t7, rotate_J
    addi $t7, $t7, 1
    beq $a0, $t7, rotate_T
    
    
    rotate_S:
        lw $t9, rotation
        beq $t9, 0, rotate_S_90
        beq $t9, 1, rotate_S_180
        beq $t9, 2, rotate_S_270
        beq $t9, 3, rotate_S_360
        
        rotate_S_90:
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
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
            lw $t8, -4($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
            bne $t8, $zero, failw
            lw $t8, 4($t3)
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
            lw $t8, -128($t4)
            bne $t8, $zero, failw
            lw $t8, -256($t4)
            bne $t8, $zero, failw
            lw $t8, 128($t4)
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
            lw $t8, -128($t4)
            bne $t8, $zero, failw
            lw $t8, -256($t4)
            bne $t8, $zero, failw
            lw $t8, 128($t4)
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
            lw $t8, 4($t3)
            bne $t8, $zero, failw
            lw $t8, -124($t3)
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
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
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
            lw $t8, 128($t3)
            bne $t8, $zero, failw
            lw $t8, -8($t3)
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
        j keyboard    
failw:
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
    
Exit:
li $v0, 10 # terminate the program gracefully
syscall