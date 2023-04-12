#restart simulation
restart

add_force /CPU/Clock -radix hex 0
add_force /CPU/Reset -radix hex 1
run 1 ns
add_force /CPU/Reset -radix hex 0
run 4 ns

#Case 1: LUI
#need 32 bit, so shift 16 bits to left, put in 00011

add_force /CPU/MemoryDataIn -radix bin 00111100000000111111111111111111

#1 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#2 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#3rd cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#4th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected address: 0x4
#Expected result: FFFF0000 stored in 00011 register


#Case 2: ADDI (for rt)
#put in 00001
add_force /CPU/MemoryDataIn -radix bin 00100000000000010000111111111111 

#1 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#2 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#3rd cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#4th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#expected address : 0x8
#expected result: 0x9 in 00001


#Case 3: MULTU
add_force /CPU/MemoryDataIn -radix bin 00000000001000110000000000011001

#1 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#2 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#3rd cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#4th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#5th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#6th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#7th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#8th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#9th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#10th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#11 cycle

add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#12 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#13th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#14th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#15th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#16th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#17th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#18th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#19th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#20th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#21 cycle

add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#22 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#23th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#24th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#25th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#26th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#27th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#28th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#29th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#30th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#31 cycle

add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#32 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#33th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#34th cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#35th cycle (done signal raises)
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#36th cycle (move)
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#37th cycle (fetch)
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected result : FFFF0000 * 00000FFF = FFEF0010000

#Case 4: MFHI
#Test mfhi
#rd = 31th register
add_force /CPU/MemoryDataIn -radix bin 00000000000000001111100000010000

#1 cycle

add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#2 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#3 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected result: 00000FFE in reg 31

#Case 5: MFLO
#Test mflo
#rd = 21th register
add_force /CPU/MemoryDataIn -radix bin 00000000000000001010100000010010

#1 cycle

add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#2 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#3 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected result: F0010000 in reg 21