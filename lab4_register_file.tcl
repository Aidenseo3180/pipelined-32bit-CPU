#restart simulation
restart

add_force /register_file/RST -radix hex 1
add_force /register_file/CLK -radix hex 0
add_force /register_file/readRegister1 -radix hex 0
add_force /register_file/readRegister2 -radix hex 1

run 5ns

add_force /register_file/RST -radix hex 1
add_force /register_file/CLK -radix hex 1

run 5ns

#Case 1: When all registers are 0
if {[get_value -radix unsigned readData1] == [expr {0x0}]} {
	puts "Correct - case 1_1"
} else {
	puts "Wrong - case 1_1"
}
if {[get_value -radix unsigned readData2] == [expr {0x0}]} {
	puts "Correct - case 1_2"
} else {
	puts "Wrong - case 1_2"
}

################

add_force /register_file/RST -radix hex 0
add_force /register_file/CLK -radix hex 0
add_force /register_file/readRegister1 -radix hex 0
add_force /register_file/readRegister2 -radix hex 1
add_force /register_file/writeRegister -radix hex 0
add_force /register_file/writeData -radix hex 1000
add_force /register_file/regWrite -radix hex 1

run 5ns

add_force /register_file/CLK -radix hex 1

run 5ns

#Case 2: read register
if {[get_value -radix unsigned readData1] == [expr {0x1000}]} {
	puts "Correct - case 2_1"
} else {
	puts "Wrong - case 2_1"
}
if {[get_value -radix unsigned readData2] == [expr {0x0}]} {
	puts "Correct - case 2_2"
} else {
	puts "Wrong - case 2_2"
}


################

add_force /register_file/CLK -radix hex 0
add_force /register_file/readRegister1 -radix hex 0
add_force /register_file/readRegister2 -radix hex 1
add_force /register_file/writeRegister -radix hex 1
add_force /register_file/writeData -radix hex 2000

run 5ns

add_force /register_file/CLK -radix hex 1

run 5ns

#Case 3: read register
if {[get_value -radix unsigned readData1] == [expr {0x1000}]} {
	puts "Correct - case 3_1"
} else {
	puts "Wrong - case 3_1"
}
if {[get_value -radix unsigned readData2] == [expr {0x2000}]} {
	puts "Correct - case 3_2"
} else {
	puts "Wrong - case 3_2"
}
################

add_force /register_file/CLK -radix hex 0
add_force /register_file/readRegister1 -radix hex 0
add_force /register_file/readRegister2 -radix hex 1
add_force /register_file/writeRegister -radix hex 0
add_force /register_file/writeData -radix hex 5000
add_force /register_file/regWrite -radix hex 0

run 5ns

add_force /register_file/CLK -radix hex 1

run 5ns

#Case 3: read register
if {[get_value -radix unsigned readData1] == [expr {0x1000}]} {
	puts "Correct - case 3_1"
} else {
	puts "Wrong - case 3_1"
}
if {[get_value -radix unsigned readData2] == [expr {0x2000}]} {
	puts "Correct - case 3_2"
} else {
	puts "Wrong - case 3_2"
}