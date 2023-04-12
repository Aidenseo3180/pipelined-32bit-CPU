# restart the simulation
restart

add_wave {{/cpu_tb/U_1}} 

#lui $1, 0x00001001
#ori $13, $1,0x00000020
#addi $9, $0,-45
#clo, $10,$9
#sw $10, 0($13)

add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {342D0020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {2009FFD3}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {71205021}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {ADAA0000}
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

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x0000001A} {
	puts "Correct! Test 8 passed."
} else {
	puts "InCorrect! Test 8 didn't pass."
}