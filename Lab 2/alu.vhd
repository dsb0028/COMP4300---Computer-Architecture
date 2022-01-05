use work.dlx_types.all;
use work.bv_arithmetic.all;
entity ALU is
	generic(prop_delay : Time := 5 ns);
	port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
	result: out dlx_word; error: out error_code);
end entity ALU;


architecture behaviour1 of ALU is
begin
	aluProcess : process(operand1,operand2,operation) is
        variable bv_result: dlx_word;
        variable overflow: boolean;
        variable div_by_zero: boolean;
        begin 
           if operation = "0000" then   -- unsigned add: 0000
           bv_addu(operand1,operand2, bv_result, overflow);
           result <= bv_result;
             if overflow = true then
              error <= "0001";  -- error overflow: 0001
             else 
              error <= "0000";  -- no error
             end if;                 
           end if;  

	   if operation = "0001" then	-- unsigned sub: 0001
              error <= "0000"; -- ensures error code is reset when operation codes are switched during simulation of code  
              bv_subu(operand1,operand2, bv_result, overflow);
              result <=  bv_result;
              if overflow = true then
              error <= "0001";  -- overflow
              else 
              error <= "0000";  -- no error
              end if;  
            end if;    

          if operation = "0010" then    -- 2's comp add: 0010
             error <= "0000";             
             result <= "+"(operand1, operand2); 
          end if;
            
	  if operation = "0011" then    -- 2's comp sub: 0011
              error <= "0000";
	      result <= "-"(operand1, operand2);
          end if;
 
          if operation = "0100" then    -- 2's comp mult: 0100
              error <= "0000";
              bv_multu(operand1,operand2, bv_result, overflow);
    	      result <= bv_result;
              if overflow = true then
              error <=  "0001";  -- overflow
              else 
              error <= "0000";   -- no error
              end if;
	  end if;
          
          if operation = "0101" then    -- 2's comp div:  0101
           error <= "0000";
           result  <= "00000000000000000000000000000000";
           bv_div(operand1, operand2, bv_result,div_by_zero,overflow); 
            if div_by_zero = true then
            error <= "0010"; -- error: div_by_zero 
            else 
             if overflow = true then
              error <= "0001"; -- overflow 
             end if;
	     result <= bv_result;
            end if;
          end if;
        
          if operation = "0111" then    -- bitwise AND:   0111
              error <= "0000";            
              result <=  operand1 and operand2;
          end if;
	   
          if operation = "1001" then    -- bitwise OR:    1001
               error <= "0000";
               result <= operand1 or operand2;
          end if;
          
          if operation = "1011" then    -- bitwise NOT of operand1 (ignore operand2): 1011
               error <= "0000";
               result <= not operand1;
          end if;
	  
          if operation = "1100" then    -- pass operand1 through to the output: 1100
                error <= "0000"; 
          	result <= operand1;
          end if;

          if operation = "1101" then    -- pass operand2 through to the output: 1101
                error <= "0000";
          	result <= operand2;
          end if;

          if operation = "1110" then    --  output all zero's: 1110
                error <= "0000";
          	result <= "00000000000000000000000000000000";
          end if;
          
          if operation = "1111" then    --  output all ones's:  1111
                error <= "0000";
          	result <= "11111111111111111111111111111111";
          end if;       
        
               
           
           
	end process aluProcess;    
end architecture behaviour1;
