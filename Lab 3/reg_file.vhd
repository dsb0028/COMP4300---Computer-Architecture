use work.dlx_types.all;
use work.bv_arithmetic.all;


entity reg_file is 

generic(prop_delay : Time := 15 ns);

port(data_in : in dlx_word; readnotwrite, clock: in bit; data_out: out
dlx_word; reg_number : in register_index);
end entity reg_file; 

architecture behaviour1 of reg_file is
type reg_type is array (0 to 31) of dlx_word;
begin
	reg_fileProcess: process(data_in, readnotwrite, clock, reg_number) is
        variable registers :reg_type;
        begin 
        if clock = '1' then
		if readnotwrite = '1' then
   		data_out <= registers(bv_to_natural(reg_number)) after prop_delay;
       		else
        	registers(bv_to_natural(reg_number)) := data_in;
        	end if;
        end if;
	end process reg_fileProcess;
end architecture behaviour1;