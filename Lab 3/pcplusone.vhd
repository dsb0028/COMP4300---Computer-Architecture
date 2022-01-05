use work.dlx_types.all;
use work.bv_arithmetic.all;

entity pcplusone is 
   generic(prop_delay: Time := 5 ns);  
   port (input: in dlx_word; clock: in bit;  output: out dlx_word);  
end entity pcplusone;

architecture behaviour1 of pcplusone is 
begin
	pcplusoneProcess: process(input, clock) is 
        variable new_pc: dlx_word;
        variable overflow: boolean;
        begin
        if clock = '1' then          
        	bv_addu(input,"00000000000000000000000000000001", new_pc, overflow); 
       		output <= new_pc after prop_delay;
        end if;
	end process pcplusoneProcess;
end architecture behaviour1;