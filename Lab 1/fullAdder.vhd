entity fullAdder is 
	generic(prop_delay: Time := 10 ns);
	port(carry_in, a_in, b_in: in bit;
             result,carry_out: out bit);
end entity fullAdder; 


architecture behaviour1 of fullAdder is
begin
	fullAddProcess : process(carry_in,a_in,b_in) is 
	-- carry_in and a_in and b_in = result, carry_out
	begin
                if carry_in = '0' then 
                  if a_in = '0' then
		     if b_in = '0' then
                     -- 0 and 0 and 0 = 0,0
                     result <= '0' after prop_delay; 
		     carry_out <= '0' after prop_delay;
                     else  
		     -- 0 and 0 and 1 = 1, 0   
                     result <= '1' after prop_delay; 
		     carry_out <= '0' after prop_delay;
                     end if;
                  else
		    if b_in = '0' then
                     --  0 and 1 and 0 = 1, 0
                     result <= '1' after prop_delay; 
		     carry_out <= '0' after prop_delay;
		    else 
                      -- 0 and 1 and 1 = 0,1
		     result <= '0' after prop_delay; 
		     carry_out <= '1' after prop_delay;
                    end if;
                 end if;
            
                 
                 
                else
                   if a_in = '0' then
                      if b_in = '0' then
		    -- 1 and 0 and 0 = 1,0
                      result <= '1' after prop_delay; 
                      carry_out <= '0' after prop_delay;
                      else 
                    -- 1 and 0 and 1 = 0,1
                      result <= '0' after prop_delay;
                      carry_out <= '1' after prop_delay;
                      end if;
                   else 
		    -- 1 and 1 and 0 = 0,1   
                    if b_in = '0' then
                    result <= '0' after prop_delay;
                    carry_out <= '1' after prop_delay;
                    else  
                    -- 1 and 1 and 1 = 1,1
                    result <= '1' after prop_delay;
                    carry_out <= '1' after prop_delay;
                    end if;
                  end if;                  
                end if;
              
                
	end process fullAddProcess; 
end architecture behaviour1; 



