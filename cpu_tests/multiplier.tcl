restart
add_wave {{/cpu_tb/U_1}}

#addi $7, $0, 20
#lui $11, 0xFFFF
#multu $7, $11
#mflo $4
#mfhi $5
#sw $4, 15($7) 
#sw $5, 19($7)

# you can use any of the following commands as an example on how to initilaize a memory location with a value
add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {20070014}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3C0BFFFF}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {00EB0019}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {00002012}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00002810}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {ACE4000F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {ACE50013}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}

add_force clk 1 {0 5ns} -repeat_every 10ns

#give a reset signal
add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 700 ns

#expected result: 0x00000013FFEC0000
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0xFFEC0000} {
	puts "Correct! mflo passed."
} else {
	puts "InCorrect! mflo didn't pass."
}
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[9]}] == 0x00000013} {
	puts "Correct! mfhi passed."
} else {
	puts "InCorrect! mfhi didn't pass."
}
