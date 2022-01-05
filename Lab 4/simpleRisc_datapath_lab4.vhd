-- simpleRisc_datapath_lab4.vhd



-- entity reg_file (correct for simple Risc) 
use work.dlx_types.all; 
use work.bv_arithmetic.all;  

entity reg_file is
     generic(prop_delay : Time := 15 ns);
     port (data_in: in dlx_word; readnotwrite,clock : in bit; 
	   data_out: out dlx_word; reg_number: in register_index );
end entity reg_file; 

-- end entity regfile

architecture behavior of reg_file is
type reg_type is array (0 to 31) of dlx_word;
begin
	reg_fileProcess: process(data_in, readnotwrite, clock, reg_number) is
        variable registers :reg_type;
        begin 
        if clock = '1'  then
		if readnotwrite = '1' then
   		data_out <= registers(bv_to_natural(reg_number));
       		else
        	registers(bv_to_natural(reg_number)) := data_in;
        	end if;
        end if;
	end process reg_fileProcess;
end architecture behavior;

-- entity simple_alu (correct for simple risc, different from Aubie) 
use work.dlx_types.all; 
use work.bv_arithmetic.all; 

entity simple_alu is 
     generic(prop_delay : Time := 5 ns);
     port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
          result: out dlx_word; error: out error_code); 
end entity simple_alu; 

-- alu_operation_code values (simpleRisc)
-- 0000 unsigned add
-- 0001 unsigned sub
-- 0010 2's compl add
-- 0011 2's compl sub
-- 0100 2's compl mul
-- 0101 2's compl divide
-- 0110 logical and
-- 0111 bitwise and
-- 1001 bitwise or 
-- 1011 bitwise not (op1)
-- 1100 copy op1 to output
-- 1101 copy op2 to output
-- 1110 output all zero's
-- 1111 output all one's

-- error code values
-- 0000 = no error
-- 0001 = overflow (too big or too small) 
-- 0011 = divide by zero 

-- end entity simple_alu

architecture behavior of simple_alu is
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
end architecture behavior;
-- entity dlx_register 
use work.dlx_types.all; 

entity dlx_register is
     generic(prop_delay : Time := 10 ns);
     port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word);
end entity dlx_register;

-- end entity dlx_register

architecture behavior of dlx_register is 
begin
	dlx_regProcess: process(in_val, clock) is 
        begin       
	if clock = '1' then
	   out_val <= in_val after prop_delay;
        end if;
	end process dlx_regProcess; 
end architecture behavior;

-- entity pcplusone (correct for simpleRisc)
use work.dlx_types.all;
use work.bv_arithmetic.all; 

entity pcplusone is
	generic(prop_delay: Time := 5 ns); 
	port (input: in dlx_word; clock: in bit;  output: out dlx_word); 
end entity pcplusone; 

architecture behavior of pcplusone is 
begin
	pcplusoneProcess: process(input, clock) is 
        variable new_pc: dlx_word;
        variable overflow: boolean;
        begin
        if clock'event and clock = '1' then          
        	bv_addu(input,"00000000000000000000000000000001", new_pc, overflow); 
       		output <= new_pc after prop_delay;
        end if;
	end process pcplusoneProcess;
end architecture behavior;

-- entity mux 
use work.dlx_types.all; 

entity mux is
     generic(prop_delay : Time := 5 ns);
     port (input_1,input_0 : in dlx_word; which: in bit; output: out dlx_word);
end entity mux;

-- end entity mux

architecture behavior of mux is 
begin
	mux_behav : process (input_1, input_0, which) is
	begin
		if which = '0' then
                 output <= input_0;
                else
                 output <= input_1;
                end if;
	end process mux_behav; 
end architecture behavior; 
  
-- entity memory 
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity memory is
  
  port (
    address : in dlx_word;
    readnotwrite: in bit; 
    data_out : out dlx_word;
    data_in: in dlx_word; 
    clock: in bit); 
end memory;

architecture behavior of memory is

begin  -- behavior

  mem_behav: process(address,clock) is
    -- note that there is storage only for the first 1k of the memory, to speed
    -- up the simulation
    type memtype is array (0 to 1024) of dlx_word;
    variable data_memory : memtype;
  begin
    -- fill this in by hand to put some values in there
    -- some instructions
   data_memory(0) :=  "00000000000000000000100000000000";   -- LD R1,R0(100)
   data_memory(1) :=  "00000000000000000000000100000000";
   data_memory(2) :=  "00000000000000000001000000000000";   -- LD R2,R0(101)
   data_memory(3) :=  "00000000000000000000000100000001";
   data_memory(4) :=  "00001000001000100001100100000000";   -- ADD R3,R1,R2
   data_memory(5) :=  "00000100011000000000000000000000";   -- STO R3,R0(102)
   data_memory(6) :=  "00000000000000000000000100000010";
   -- if the 3 instructions above run correctly for you, you get full credit for the assignment


   -- data for the first two loads to use 
    data_memory(256) := X"55550000"; 
    data_memory(257) := X"00005555";
    data_memory(258) := X"ffffffff";

    -- testing for extra credit 
    -- code to test JZ , should be taken unless value of R1 changed
    data_memory(7) := "00001100100000000000000000000000";         -- JMP R4(00000010)
    data_memory(8) := X"00000010";

    data_memory(16):=  "00010000100001010000000000000000";        -- JZ R5,R4(00000000)
    data_memory(17) := X"00000000";

   
    if clock = '1' then
      if readnotwrite = '1' then
        -- do a read
        data_out <= data_memory(bv_to_natural(address)) after 5 ns;
      else
        -- do a write
        data_memory(bv_to_natural(address)) := data_in; 
      end if;
    end if;


  end process mem_behav; 

end behavior;
-- end entity memory


