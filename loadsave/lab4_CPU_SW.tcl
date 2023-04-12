#restart simulation
restart

add_force /CPU/Clock -radix hex 0
add_force /CPU/Reset -radix hex 1
run 1 ns
add_force /CPU/Reset -radix hex 0
run 4 ns

#Case 1: ADDI
add_force /CPU/MemoryDataIn -radix bin 00100000001000110000000000001111 


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

#Expected Address: 0x4
#Expected result : F in 00011

#Case 2: ADDI
add_force /CPU/MemoryDataIn -radix bin 00100000001001110000000000000110 

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

#Expected Address: 0x8
#Expected result : 0x6 in 00111


#Case 3: SW

add_force /CPU/MemoryDataIn -radix bin 10101100011001110000000000001100 

#content of 00011 (0xF) + offset(0xC) = 0x1B --> address to save rt
#rt = content of 00111 = 0x6
#Therefore, 0x6 saved in 0x1B

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


#Expected MemoryAddress: 0xC
#Expected result : memorydataout = 0x6 
