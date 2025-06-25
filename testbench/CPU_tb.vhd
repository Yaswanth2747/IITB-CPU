library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CPU_tb is
end entity;

architecture behavior of CPU_tb is

    -- Component declaration for the CPU
    component CPU is
        port(
            clk: in std_logic;
            reset: in std_logic;
            R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0);
				opcode_out : out std_logic_vector(3 downto 0)	
        );
    end component;

    -- Signals for the clock, reset, and register outputs
	 signal opcode : std_logic_vector(3 downto 0);	
    signal clk: std_logic := '0';
    signal reset: std_logic := '0'; -- Keep reset always low
    signal R0_t, R1_t, R2_t, R3_t, R4_t, R5_t, R6_t, R7_t: std_logic_vector(15 downto 0);
    -- Clock generation
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the CPU
    uut: CPU
        port map(
            clk => clk,
            reset => reset,
            R0 => R0_t,
            R1 => R1_t,
            R2 => R2_t,
            R3 => R3_t,
            R4 => R4_t,
            R5 => R5_t,
            R6 => R6_t,
            R7 => R7_t,
				opcode_out => opcode
        );

		  
	clk_process: process(clk)
	begin
	clk <= not clk after 10 ms;
	end process;

 

end architecture;
