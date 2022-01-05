use work.dlx_types.all;

entity dlx_register is 
     generic(prop_delay : Time := 10 ns);
     port(in_val: in dlx_word; clock: in bit; out_val: out 
dlx_word);  
end entity dlx_register;

architecture behaviour1 of dlx_register is 
begin
	dlx_regProcess: process(in_val, clock) is 
        begin       
	if clock = '1' then
	   out_val <= in_val after prop_delay;
        end if;
	end process dlx_regProcess; 
end architecture behaviour1;


