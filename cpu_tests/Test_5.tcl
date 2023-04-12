# restart the simulation
restart

add_wave {{/cpu_tb/U_1}} 

#addi $7, $0, 17
#addi $11, $0, -3
#slti $11, $7, 63
#sw $11, 15($7)

add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070011}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {200BFFFD}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {28EB003F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {ACEB000F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}


add_force clk 1 {0 5ns} -repeat_every 10ns

add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 200 ns

#Expected: 0x11(17) in $7, 0x1 in $11

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x00000001} {
	puts "Correct! Test 5 passed."
} else {
	puts "InCorrect! Test 5 didn't pass."
}