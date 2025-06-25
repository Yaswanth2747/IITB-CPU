library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port( clk,reset: in std_logic;
			state: in std_logic_vector(3 downto 0);
			opcode_out: out std_logic_vector(3 downto 0);
			zselect: out std_logic;
			R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0));
end entity;

architecture path of datapath is

	component SE6 is
		port (input: in std_logic_vector(5 downto 0); 
			output: out std_logic_vector(15 downto 0));
	end component SE6;
	
	
	component SE9 is
		port (input: in std_logic_vector(8 downto 0);
			output: out std_logic_vector(15 downto 0));
	end component SE9;
	
	component Register1 is
		  port (
        input         : in std_logic_vector(15 downto 0);
        write_en, clk : in std_logic;
        -- init_value    : in std_logic_vector(15 downto 0);
        output        : out std_logic_vector(15 downto 0)
    );
	end component Register1 ;
	
	component Register_File is
	    port (
        RF_A1, RF_A2, RF_A3 : in std_logic_vector(2 downto 0); -- Address inputs
        RF_D3               : in std_logic_vector(15 downto 0); -- Data input
        RF_D1, RF_D2        : out std_logic_vector(15 downto 0); -- Read outputs
        clk, RF_write       : in std_logic; -- Clock and Write enable for the register file
		R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0)
	 );
	end component Register_File;

	component left_1s is
		port (input : in std_logic_vector (15 downto 0);
				output : out std_logic_vector (15 downto 0));
	end component left_1s;
   
	component concatenator is
    port (
        concat_sel: in std_logic; -- IR_12, Selection line: 0 for LHI, 1 for LLI
        concat_in: in std_logic_vector(7 downto 0); -- IR_7to0
        concat_out: out std_logic_vector(15 downto 0) -- Output 16-bit vector
    );
   end component;


	component ALU is 
		port (A, B: in std_logic_vector(15 downto 0);
				opcode: in std_logic_vector(2 downto 0);
				C: out std_logic_vector(15 downto 0);
				z_flag: out std_logic);
	end component ALU;
	
	component Memory is 
	   port(
        clk : in std_logic; -- clock
        MWR : in std_logic; -- write enable
        MDR : in std_logic; -- read enable
        M_add : in std_logic_vector(15 downto 0); -- 16-bit address
        M_data_in : in std_logic_vector(15 downto 0); -- data input to the memory
        M_data_out : out std_logic_vector(15 downto 0) -- data output from the memory
		 
    );
	end component; 
	
	constant s0  : std_logic_vector(3 downto 0):= "0000";
	constant s1  : std_logic_vector(3 downto 0):= "0001";  
	constant s2  : std_logic_vector(3 downto 0):= "0010";
	constant s3  : std_logic_vector(3 downto 0):= "0011";
	constant s4  : std_logic_vector(3 downto 0):= "0100";
	constant s5  : std_logic_vector(3 downto 0):= "0101";
	constant s6  : std_logic_vector(3 downto 0):= "0110";
	constant s7  : std_logic_vector(3 downto 0):= "0111";
	constant s8  : std_logic_vector(3 downto 0):= "1000";
	constant s9  : std_logic_vector(3 downto 0):= "1001";  
	constant s10 : std_logic_vector(3 downto 0):= "1010";
	constant s11 : std_logic_vector(3 downto 0):= "1011";
	constant s12 : std_logic_vector(3 downto 0):= "1100";
	constant s13 : std_logic_vector(3 downto 0):= "1101";
	constant s14 : std_logic_vector(3 downto 0):= "1110";
	constant s15 : std_logic_vector(3 downto 0):= "1111";

	-- ALU
	signal ALU_A, ALU_B, ALU_C: std_logic_vector(15 downto 0) := (others => '0');
	signal ALU_OPCODE: std_logic_vector(2 downto 0);
	signal ALU_Z: std_logic;

	-- Memory
	signal M_add, M_data_in, M_data_out: std_logic_vector(15 downto 0) := (others => '0'); 
	signal M_WR, M_DR: std_logic := '0';

	-- Register File
	signal A1, A2, A3: std_logic_vector(2 downto 0) := (others => '0');
	signal D1, D2, D3: std_logic_vector(15 downto 0) := (others => '0'); 
	signal RF_WR: std_logic;
	
	-- Temporary Registers
	signal   T1_E, T2_E, T3_E ,IR_E,PC_E: std_logic := '0'; -- control signals
	signal T1_in, T1_out, T2_in, T2_out, T3_in, T3_out,IR_in,IR_out ,PC_in,PC_out: std_logic_vector(15 downto 0):= (others => '0'); -- Temporary Register i/p and o/p
	-- signal R1r, R2r, R3r, R4r, R5r: std_logic_vector(15 downto 0) := (others => '0');
	-- Sign Extenders	
	signal I_SE6: std_logic_vector(5 downto 0);
	signal I_SE9: std_logic_vector(8 downto 0);
	signal O_SE6,O_SE9 : std_logic_vector(15 downto 0);

	-- Left Shifter
	signal I_LS1,O_LS1 : std_logic_vector(15 downto 0);
	--concat
	signal C_sel : std_logic := '0';
   signal C_in: std_logic_vector(7 downto 0);
   signal C_out: std_logic_vector(15 downto 0); 
--	signal R0_t, R1_t, R2_t, R3_t, R4_t, R5_t, R6_t, R7_t: std_logic_vector(15 downto 0);
	
--	
--	signal R0_t: std_logic_vector(15 downto 0) := "0000000000000001";
--	signal R1_t: std_logic_vector(15 downto 0) := "0000000000000010";
--	signal R2_t: std_logic_vector(15 downto 0) := "0000000000000011";
--	signal R3_t: std_logic_vector(15 downto 0) := "0000000000000100";
--	signal R4_t: std_logic_vector(15 downto 0) := "0000000000000101";
--	signal R5_t: std_logic_vector(15 downto 0) := "0000000000000110";
--	signal R6_t: std_logic_vector(15 downto 0) := "0000000000000111";
--	signal R7_t: std_logic_vector(15 downto 0) := "0000000000000000";

	begin
	
	-- R1r <= "0000000000000000";
   -- R2r <= "0000000000000000";
	-- R3r <= "0000000000000000";
	-- R4r <= "0000000000000000";
	-- R5r <= "0000000000000000";
	
		
		se61: component SE6
			port map(I_SE6,O_SE6);
		
		se91: component SE9
			port map(I_SE9,O_SE9);
		
		reg16_IR: component Register1
			port map(IR_in, IR_E, clk, IR_out);
			
		reg16_T1: component Register1
			port map(T1_in, T1_E, clk, T1_out);
			
		reg16_T2: component Register1
			port map(T2_in, T2_E, clk,T2_out);
			
		reg16_T3: component Register1
			port map(T3_in, T3_E, clk, T3_out);
			
		reg16_PC: component Register1
			port map(PC_in, PC_E, clk,PC_out);
		
		leftshift1: component left_1s
			port map(I_LS1,O_LS1);
			
		rf: component Register_File
			port map(A1,A2,A3, D3, D1,D2,clk,RF_WR,R0, R1, R2, R3, R4, R5, R6, R7);
			
		alucomp: component ALU
			port map(ALU_A,ALU_B,ALU_OPCODE,ALU_C,ALU_Z);
					
		conc : component concatenator
		   port map(C_sel,C_in,C_out);
			
		mem: component Memory
			port map(clk,M_WR,M_DR, M_add, M_data_in, M_data_out);
			
		opcode_out <= IR_out(15 downto 12);
--		ALU_OPCODE <= IR_out(15 downto 13);
		Zselect <= ALU_z;
		
		datapath_process: process(state,D1,D2,PC_in,M_data_out,ALU_C,ALU_Z,IR_out,T1_out,T2_out,T3_out,PC_out,O_SE6,O_SE9,O_LS1,C_out)
		begin
			I_SE6 <= (others => '0');
			I_SE9 <= (others => '0');
			
			A3 <= (others => '0');
			A2 <= (others => '0');
			A1 <= (others => '0');
			D3 <= (others => '0');
			I_LS1 <= (others => '0');
			
			ALU_A <= (others => '0');
			ALU_B <= (others => '0');
         C_in  <= (others => '0');
			IR_in <= (others => '0');
			T1_in <= (others => '0');
			T2_in <= (others => '0');
			T3_IN <= (others => '0');
			PC_in <= (others => '0');
			
			ALU_OPCODE <= (others => '0');
			C_sel <= '0';
			RF_WR <= '0';
			IR_E <= '0';
			T1_E <= '0';
			T2_E <= '0';
			T3_E <= '0';
			PC_E <= '0';
			
			M_WR <= '0';
			M_DR <= '0';
			
			case state is
			--(DISCRPTION)
				when s0 =>
					M_add <= PC_out;
				   IR_in <= M_data_out;
					D3  <= PC_out;
				
					A3	 <= "111";
					IR_E <= '1';
					M_DR <= '1';
					RF_WR <= '1';
			      T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			         M_WR <= '0';			
				when s1 =>
				   ALU_A <= PC_out;
					ALU_B <= "0000000000000010";
					PC_in <= ALU_C ;
					A1 <= IR_out(11 downto 9);
				   A2 <= IR_out(8 downto 6);
					T1_in <= D1;
					T2_in <= D2;
				
				  
			      T1_E <= '1';
			      T2_E <= '1';
			      PC_E <= '1';
					RF_WR <= '0';
			      IR_E <= '0';
			        
			        T3_E <= '0';
			        
			
			        M_WR <= '0';
			        M_DR <= '0';
			      ALU_OPCODE <= "000";
				
				when s2 =>
					ALU_A <= T1_out;
					ALU_B <= T2_out;
					T3_in <= ALU_C;
					
			      T3_E <= '1';
					  T1_E <= '0';
			        T2_E <= '0';
			       RF_WR <= '0';
			        PC_E <= '0';
			         IR_E <= '0'; 
			        M_WR <= '0';
			        M_DR <= '0';
				   ALU_OPCODE <= IR_out(14 downto 12);
				
				when s3 =>
					A3 <= IR_out(5 downto 3);
					D3 <= T3_out;
			
					  RF_WR <= '1';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					
				when s4 =>
					ALU_A <= T1_out;
					I_SE6 <= IR_out(5 downto 0);
					ALU_B <= O_SE6;
					T3_in <= ALU_C;
			
					T3_E <= '1';
					
					  T1_E <= '0';
			        T2_E <= '0';
			       RF_WR <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					ALU_OPCODE <= "000";
				
				when s5 =>
				
					A3 <= IR_out(8 downto 6);
					D3 <= T3_out;
					
					RF_WR <= '1';
				
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
				
				when s6 =>
			      C_sel <= IR_out(12);	
					A3 <= IR_out(11 downto 9);
					C_in <= IR_out(7 downto 0);
					D3 <= C_out;
					
					ALU_A <= PC_out;
					ALU_B <= "0000000000000010";
					PC_in <= ALU_C ;
					
					RF_WR <= '1';
					PC_E <= '1';
					 
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					ALU_OPCODE <= "000";
					
				when s7 =>
				   ALU_A <= T2_out;
					I_SE6 <= IR_out(5 downto 0);
					ALU_B <= O_SE6;
					T3_in <= ALU_C ;
			
					T3_E <= '1';
					 RF_WR <= '0';
					  T1_E <= '0';
			        T2_E <= '0';
			       
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					ALU_OPCODE <= "000";
					
				when s8 =>
					 M_add <= T3_out;
					T3_in <=  M_data_out;
					
					M_DR <= '1';
					T3_E <= '1';
					 RF_WR <= '1';
					  T1_E <= '0';
			        T2_E <= '0';
			       
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			       
				
				when s9 =>
					A3 <= IR_out(11 downto 9);
					D3 <= T3_out;
					
					RF_WR <= '1';
					
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
				when s10 =>
					M_add <= T3_out;
					M_data_in <= T1_out;
					
					M_WR <= '1';
					 RF_WR <= '1';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			      
			        M_DR <= '0';
					
				when s11 =>
					ALU_A <= T1_out;
					ALU_B <= T2_out;
					
					
					ALU_OPCODE <= "010";
					 RF_WR <= '0';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					
					
				when s12 =>
					ALU_A <= D1;
					I_SE6 <= IR_out(5 downto 0);
					I_LS1 <= O_SE6;
					ALU_B <= O_LS1;
					PC_in <= ALU_C;
					
					  PC_E <= '1';
					  RF_WR <= '0';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					  ALU_OPCODE <= "000";
					
				when s13 =>	
				
	              A3 <= IR_out(11 downto 9);
					  D3 <= PC_in;
				     RF_WR <= '1';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			        PC_E <= '0';
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					
				when s14 =>
				
					ALU_A <= D1;
					I_SE9 <= IR_out(8 downto 0);
					I_LS1 <= O_SE9;
					ALU_B <= O_LS1;
					PC_in <= ALU_C;
					
					PC_E <= '1';
					RF_WR <= '0';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			       
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					A1	 <= "111";
				when s15 =>
					A2 <= IR_out(8 downto 6);
					PC_in <= D2 ;
				
				   PC_E <= '1';
					RF_WR <= '0';
					  T1_E <= '0';
			        T2_E <= '0';
			        T3_E <= '0';
			      
			        IR_E <= '0';
			        M_WR <= '0';
			        M_DR <= '0';
					
				when others =>
					ALU_OPCODE <= "000";
			end case;
		end process;
end architecture path;
		
		
		
		
		