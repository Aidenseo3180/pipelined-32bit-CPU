# restart the simulation
restart

add_wave {{/cpu_tb/U_1}} 

#addi $7, $0, 17
#addi $11, $0, -3
#sub $11, $7, $11
#sw $11, 15($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00EB5822}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {ACEB000F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

add_force clock 1 {0 5ns} -repeat_every 10ns

#give a reset signal
add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 200 ns

#check if the result is correct (result F010 E8EE A3E2 0B28)
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000014} {
	puts "Correct! Test 1 passed."
} else {
	puts "InCorrect! Test 1 didn't pass."
}


#Expected : 0x11 (17) in $7,  0x14 (20) in $11