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


#Case 2: 
#base + offset --> content of 00011 + 3 = F + 3 = 0x12 : address that memory is reading from
#saved the content of 0x12 to 00111
add_force /CPU/MemoryDataIn -radix bin 10000100011001110000000000000011

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
#put in memorydatain for now (goes into memorydata register)
#half of 0x0FFFFFFF goes in, so FFFF expected
add_force /CPU/MemoryDataIn -radix bin 00001111111111111111111111111111
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#5 cycle
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Since memory is not attached yet --> manually put in MemoryDataIn to test if value goes into 00111
#Expected Address: 0x8
#Expected result : content of 0x12 (0xFFFF in this case) in 00111