.text
    .globl  main

init:

li $t1, 7                 # $t1 = 7
li $t2, 5                 # $t2 = 5 (4'b0101)
sub $t3, $t1, $t2   # $t3 = 2 (7-5=2)
li $t3, 10               # $t3 = 10 (4'b1010)
or $t2, $t2, $t3      # $t2 = 15 (4'b1111)
and $t3, $t2, $t3   # $t3 = 10 (4'b1010)
slt $t2, $t3, $t2      # $t2 = 1
add $t2, $t3, $t2    # $t2 = 11 (4'b1011=-5)
add $t3, $t1, $t2   # $t3 = 2 (7+(-5)=2)
slt $t1, $t2, $t3      # $t1 = 0 (behavioral ALU) or 1 (gate-level ALU)
