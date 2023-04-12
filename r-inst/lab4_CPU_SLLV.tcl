#restart simulation
restart
add_force /CPU/Reset -radix hex 1
run 1 ns
add_force /CPU/Reset -radix hex 0
run 4 ns

#Case 1: ADDI F in register 00011
add_force /CPU/Clock -radix hex 0
add_force /CPU/MemoryDataIn -radix bin 00100000000000110000000000001111 


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

#4 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns


#Expected address: 0x4
#Expected result: 0xF in 00011


#Case 2: ADDI 4 in 00111
add_force /CPU/MemoryDataIn -radix bin 00100000000001110000000000000100 

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

#4 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected address: 0x8
#Expected result: 0x4 in 00111


#Case 3: SLLV
#Test SLLV
#00011 << 00111 --> 01111

add_force /CPU/MemoryDataIn -radix bin 00000000111000110111100000000100

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

#4 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Expected address: 0xC
#Expected result: F0 in 01111
