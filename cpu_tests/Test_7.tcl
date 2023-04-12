# restart the simulation
restart

add_wave {{/cpu_tb/U_1}} 

#lui $1, 0x00001001 
#ori $13, $1,0x00000020 
#lui $1, 0x00000123 
#ori $9, $1,0x00004567 
#sw $9, 0($13) 
#lh $11, 2($13) 
#sw $11, 16($13) 

add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {342D0020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {3C010123}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {34294567}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {ADA90000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {85AB0002}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {ADAB0010}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {00000000}


add_force clk 1 {0 5ns} -repeat_every 10ns

add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

#Expected: 19070976 in $1, 19088743 in $9, 291 in $11, 268501024 in $13, 268468224 in $28, 2147479548 in $29

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x01234567} {
	puts "Correct! Test 7 first SW passed"
} else {
	puts "InCorrect! Test 7 first SW didn't pass."
}

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[12]}] == 0x00000123} {
	puts "Correct! Test 7 second SW passed"
} else {
	puts "InCorrect! Test 7 second SW didn't pass."
}