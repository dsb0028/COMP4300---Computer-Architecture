#Objects for entity dlx_register
add wave -position end  sim:/dlx_register/prop_delay
add wave -position end  sim:/dlx_register/in_val
add wave -position end  sim:/dlx_register/clock
add wave -position end  sim:/dlx_register/out_val

#Objects for entity mux
add wave -position end  sim:/mux/prop_delay
add wave -position end  sim:/mux/input_1
add wave -position end  sim:/mux/input_0
add wave -position end  sim:/mux/which
add wave -position end  sim:/mux/output

#Objects for entity pcplusone
add wave -position end  sim:/pcplusone/prop_delay
add wave -position end  sim:/pcplusone/input
add wave -position end  sim:/pcplusone/clock
add wave -position end  sim:/pcplusone/output

#Objects for entity reg_file
add wave -position end  sim:/reg_file/prop_delay
add wave -position end  sim:/reg_file/data_in
add wave -position end  sim:/reg_file/readnotwrite
add wave -position end  sim:/reg_file/clock
add wave -position end  sim:/reg_file/data_out
add wave -position end  sim:/reg_file/reg_number


#Tests for entity dlx_register
force -freeze sim:/dlx_register/in_val 00000000000000000000000000000100 0
force -freeze sim:/dlx_register/clock 0 0
#nothing should be saved to out_val
run  
force -freeze sim:/dlx_register/clock 1 0
#value 00000000000000000000000000000100 in in_val should be saved to out_val
run
 
#Tests for entity mux
force -freeze sim:/mux/input_1 00000000000000000000000100000000 0
force -freeze sim:/mux/input_0 00000000000000000000000000000001 0
force -freeze sim:/mux/which 0 0
#the value of input_0 should be passed to output
run
force -freeze sim:/mux/which 1 0
#the value of input_1 should be passed to output
run

#Tests for entity reg_file
#data_in
force -freeze sim:/reg_file/data_in 00000000000000000001000000000001 0
#Write
force -freeze sim:/reg_file/readnotwrite 0 0
#Clock is clear
force -freeze sim:/reg_file/clock 0 0
#register R0
force -freeze sim:/reg_file/reg_number 00000 0
#Since clock is clear, nothing should happen
run

force -freeze sim:/reg_file/readnotwrite 1 0
#Since clock is still clear, value of readnotwrite is irrelevent; therefore, nothing will happen
run

#Clock is now set 
force -freeze sim:/reg_file/clock 1 0
#Write
force -freeze sim:/reg_file/readnotwrite 0 0
#Since clock is now set and readnotwrite has a value of 0, the value stored in data_in is copied into register number reg_num, 00000 (R0)
#The value of data_out will not change 
run

#Read
force -freeze sim:/reg_file/readnotwrite 1 0
#Since clock is now set and readnotwrite has a value of 1,the data_in input is ignored, and the value in register R0 is copied to the data_out port
run

#Still doing a read
#Clock is still set
#reg_number is 11111 which refers to R31
force -freeze sim:/reg_file/reg_number 11111 0
force -freeze sim:/reg_file/data_in 00010000000100000001000000011001 0
#Since nothing has been written to R31 yet, data_out will equal 00000000000000000000000000000000
run

#Write
force -freeze sim:/reg_file/readnotwrite 0 0
#value of data_in will be copied into R31, the value of data_out is not affected
run

#Read
force -freeze sim:/reg_file/readnotwrite 1 0
#Since clock is now set, readnotwrite has a value of 1, and reg_number = 11111, the value that R32 holds at its absolute address will be stored to data_out
#data_out will equal 00010000000100000001000000011001
run 

#Tests for enitity pcplusone 
force -freeze sim:/pcplusone/input 00000000000000000000000000000000 0
force -freeze sim:/pcplusone/clock 0 0
#Since clock is clear, nothing will happen
run 
force -freeze sim:/pcplusone/clock 1 0
#Since clock is now set, pc will be incremented by one and new_pc will equal 00000000000000000000000000000001
run
force -freeze sim:/pcplusone/input 00000000000000000000000000000001 0
#Since input is now 00000000000000000000000000000001 and clock is still set, the input will be incremented by 1 and the new_pc will equal  00000000000000000000000000000010
run