#restart simulation
restart
add_force /CPU/Clock -radix hex 0
add_force /CPU/Reset -radix hex 1
run 1 ns
add_force /CPU/Reset -radix hex 0
run 4 ns

add_force /CPU/MemoryDataIn -radix bin 00001000000000000000000000000100

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

#3 cycle (fetch)
add_force /CPU/Clock -radix hex 1
run 5ns
add_force /CPU/Clock -radix hex 0
run 5ns

#Case 1: Jump
#100 --> 10000 = 0x10 in hex
#Expected address : 0x10