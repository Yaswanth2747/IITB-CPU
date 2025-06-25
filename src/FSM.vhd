library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity FSM is 
	port( zselect: in std_logic;
	      opcode: in std_logic_vector(3 downto 0);
			clk,reset: in std_logic;
			fsm_out_state: out std_logic_vector(3 downto 0)
		 	);
end entity;

architecture control of FSM is
	constant op_ADD : std_logic_vector(3 downto 0):= "0000";
	constant op_SUB : std_logic_vector(3 downto 0):= "0010";  
	constant op_MUL : std_logic_vector(3 downto 0):= "0011";
	constant op_ADI : std_logic_vector(3 downto 0):= "0001";
	constant op_AND : std_logic_vector(3 downto 0):= "0100";
	constant op_ORA : std_logic_vector(3 downto 0):= "0101";
	constant op_IMP : std_logic_vector(3 downto 0):= "0110";
	constant op_LHI : std_logic_vector(3 downto 0):= "1000";
	constant op_LLI : std_logic_vector(3 downto 0):= "1001";
	constant op_LW  : std_logic_vector(3 downto 0):= "1010";  
	constant op_SW  : std_logic_vector(3 downto 0):= "1011";
	constant op_BEQ : std_logic_vector(3 downto 0):= "1100";
	constant op_JAL : std_logic_vector(3 downto 0):= "1101";
	constant op_JLR : std_logic_vector(3 downto 0):= "1111";
	constant op_J : std_logic_vector(3 downto 0):= "1110";
	--constant s0  : std_logic_vector(3 downto 0):= "0000";
	--constant s1  : std_logic_vector(3 downto 0):= "0001";  
	--constant s2  : std_logic_vector(3 downto 0):= "0010";
	--constant s3  : std_logic_vector(3 downto 0):= "0011";
	--constant s4  : std_logic_vector(3 downto 0):= "0100";
	--constant s5  : std_logic_vector(3 downto 0):= "0101";
	--constant s6  : std_logic_vector(3 downto 0):= "0110";
	--constant s7  : std_logic_vector(3 downto 0):= "0111";
	--constant s8  : std_logic_vector(3 downto 0):= "1000";
	--constant s9  : std_logic_vector(3 downto 0):= "1001";  
	--constant s10 : std_logic_vector(3 downto 0):= "1010";
	--constant s11 : std_logic_vector(3 downto 0):= "1011";
	--constant s12 : std_logic_vector(3 downto 0):= "1100";
	--constant s13 : std_logic_vector(3 downto 0):= "1101";
	--constant s14 : std_logic_vector(3 downto 0):= "1110";
	--constant s15 : std_logic_vector(3 downto 0):= "1111";
	type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15);
	signal y_present, y_next: state:= s0;

begin

   fsm_out_proc: process(y_present)
   begin
      case y_present is
         when s0  => fsm_out_state <= "0000";
         when s1  => fsm_out_state <= "0001";
         when s2  => fsm_out_state <= "0010";
         when s3  => fsm_out_state <= "0011";
         when s4  => fsm_out_state <= "0100";
         when s5  => fsm_out_state <= "0101";
         when s6  => fsm_out_state <= "0110";
         when s7  => fsm_out_state <= "0111";
         when s8  => fsm_out_state <= "1000";
         when s9  => fsm_out_state <= "1001";
         when s10 => fsm_out_state <= "1010";
         when s11 => fsm_out_state <= "1011";
         when s12 => fsm_out_state <= "1100";
         when s13 => fsm_out_state <= "1101";
         when s14 => fsm_out_state <= "1110";
         when s15 => fsm_out_state <= "1111";
         when others => fsm_out_state <= "0000";
      end case;
   end process;
	
	clock_proc:process(clk,reset,y_present)
		begin
		if(clk='1' and clk' event) then
			if(reset='1') then
				y_present <= s0; 
			else
				y_present <= y_next;
			end if;
		end if;
	end process;
		
	
 
	next_state: process(y_present,opcode,zselect)
   begin
		case y_present is
			when s0=>
				case opcode is
					when op_LHI =>
						y_next <= s6;    	    
					when op_LLI =>
						y_next<= s6;
					when op_JAL =>
						y_next <= s13;
					when op_JLR =>
						y_next <= s13;
					when op_J =>
						y_next <= s14;	
					when others =>
						y_next <= s1;
				end case;
				
			when s1=>
				case opcode is
					when op_ADD|op_SUB|op_MUL|op_AND|op_ORA|op_IMP =>	
						y_next<=s2;
					when op_ADI =>
						y_next<=s4;
					when op_BEQ =>
						y_next<=s11;
					when op_LW | op_SW =>
						y_next<=s7;
					when others =>
						y_next<=s0;
				end case;			
				
		   when s2=>
				y_next<=s3;
				
		   when s3=>
				y_next<=s0;
				
			when s4=>
				y_next<=s5;
				
			when s5=>
				y_next<=s0;
				
			when s6=>
				y_next<=s0;

				
			when s7=>
				case opcode is
					when op_LW =>
						y_next<=s8;
					when op_SW =>
						y_next <= s10;
					when others =>
						y_next<=s0;
				end case;	
				
			when s8=>
				y_next<=s9;			
			when s9=>
				y_next<=s0;
			when s10=>
				y_next<=s0;
				
			when s11=> 
				case opcode is 
					when op_BEQ =>
						if (zselect = '1') then
							y_next<=s12;
						else
							y_next<=s0;
						end if;
					when others =>
						y_next<=s0;
				end case;
				
			when s12=> 
				y_next<=s0;
				
				
			when s13=>
				case opcode is
					when op_JAL =>
						y_next<=s14;
					when op_JLR =>
						y_next <= s15;
					when others =>
						y_next<=s0;
				end case;
				
		  	when s14=> 
				y_next<=s0;
				
			when s15=> 
				y_next<=s0;
		
				
		end case;
	end process;
end architecture;