#restart simulation
restart

add_force /CPU/Reset -radix hex 1
run 1 ns
add_force /CPU/Reset -radix hex 0
run 4 ns

#assign(add) FF to 00001
add_force /CPU/MemoryDataIn -radix bin 00100000000000010000000011111111 
add_force /CPU/Clock -radix hex 0
run 5ns

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

#Expected address : 0x4
#Expected result: FF in 00001

#Assign some # to 00011
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

#Expected address : 0x8
#Expected result: F in 00011


#then, compare with immediate through 5 cycles
#then, read rs (00001) --> put result in 00011
#since rs < 1FF, result = 0
add_force /CPU/MemoryDataIn -radix bin 00101000001000110000000111111111 

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

#Case 2: SLTI, rs < immediate (compare FF with 1FF)

#Expected Address: 0xC
#Expected result: 0x0 in 00011


#compare again with immediate
#then, read rs(00001) --> put result in 01111
#since rs > F, result = 1
add_force /CPU/MemoryDataIn -radix bin 00101000001011110000000000001111 

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

#Case 3: SLTI, rs > immediate (compare FF with F)

#Expected Address: 0x10
#Expected result: 0x1 in 01111