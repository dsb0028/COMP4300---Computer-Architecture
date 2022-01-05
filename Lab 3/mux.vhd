use work.dlx_types.all;

entity mux is 
        generic(prop_delay : Time := 5 ns);
	port (input_1, input_0: in dlx_word; which: in bit; output: out dlx_word);
end entity mux; 

architecture behaviour of mux is 
begin
	mux_behav : process (input_1, input_0, which) is
	begin
		if which = '0' then
                 output <= input_0;
                else
                 output <= input_1;
                end if;
	end process mux_behav; 
end architecture behaviour; 