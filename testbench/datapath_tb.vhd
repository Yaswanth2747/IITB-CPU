library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity datapath_tb is
end entity datapath_tb;

architecture behavior of datapath_tb is

    -- Signals for testing
    signal clk, reset : std_logic := '0';
    signal state : std_logic_vector(3 downto 0) := "0000";
    signal opcode_out : std_logic_vector(3 downto 0);
    signal zselect : std_logic;
    signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0);
    
    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the datapath entity
    uut: entity work.datapath
        port map (
            clk => clk,
            reset => reset,
            state => state,
            opcode_out => opcode_out,
            zselect => zselect,
            R0 => R0,
            R1 => R1,
            R2 => R2,
            R3 => R3,
            R4 => R4,
            R5 => R5,
            R6 => R6,
            R7 => R7
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_process;

    -- Stimulus process to apply test vectors
    stimulus: process
    begin
        -- Test Case 1: Reset the datapath
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        -- Test Case 2: Apply state s1
        state <= "0001";
        wait for clk_period;
        
        -- Test Case 3: Apply state s2
        state <= "0010";
        wait for clk_period;
        
        -- Test Case 4: Apply state s3
        state <= "0011";
        wait for clk_period;
        
        -- Test Case 5: Apply state s4
        state <= "0100";
        wait for clk_period;
        
        -- Test Case 6: Apply state s5
        state <= "0101";
        wait for clk_period;
        
        -- Test Case 7: Apply state s6
        state <= "0110";
        wait for clk_period;

        -- Test Case 8: Apply state s7
        state <= "0111";
        wait for clk_period;

        -- Test Case 9: End of test, hold the final state
        state <= "1111";
        wait for clk_period;
        
        -- End simulation
        wait;
    end process stimulus;

end architecture behavior;
