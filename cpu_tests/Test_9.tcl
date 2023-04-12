# restart the simulation
restart

add_wave {{/cpu_tb/U_1}} 

#lui $1, 0x00001001
#li $3,0xFF0F
#sw $3, 32($1)
#li $5,0xBBBB
#sll $0,$0,0
#lw $2, 32($1)
#and $4, $2,$5
#sw $4, 36($1)

add_force {/cpu_tb/U_1/mw_U_0ram_table[0]} -radix hex {3C011001}
add_force {/cpu_tb/U_1/mw_U_0ram_table[1]} -radix hex {3403FF0F}
add_force {/cpu_tb/U_1/mw_U_0ram_table[2]} -radix hex {AC230020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[3]} -radix hex {3405BBBB}
add_force {/cpu_tb/U_1/mw_U_0ram_table[4]} -radix hex {00000000}
add_force {/cpu_tb/U_1/mw_U_0ram_table[5]} -radix hex {8C220020}
add_force {/cpu_tb/U_1/mw_U_0ram_table[6]} -radix hex {00452024}
add_force {/cpu_tb/U_1/mw_U_0ram_table[7]} -radix hex {AC240024}


add_force clk 1 {0 5ns} -repeat_every 10ns

add_force reset 0
run 2500ps
add_force reset 1
run 5 ns
add_force reset 0

run 400 ns

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[8]}] == 0x0000ff0f} {
	puts "Correct! Test 9 first SW passed"
} else {
	puts "InCorrect! Test 9 first SW didn't pass."
}

#check if the result is correct
if {[get_value -radix unsigned {/cpu_tb/U_1/mw_U_0ram_table[9]}] == 0x0000bb0b} {
	puts "Correct! Test 9 second SW passed"
} else {
	puts "InCorrect! Test 9 second SW didn't pass."
}
