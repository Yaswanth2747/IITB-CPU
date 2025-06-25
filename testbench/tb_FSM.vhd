library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FSM is
end tb_FSM;

architecture testbench of tb_FSM is
    signal zselect: std_logic;
    signal opcode: std_logic_vector(3 downto 0);
    signal clk, reset: std_logic;
    signal fsm_out_state: std_logic_vector(3 downto 0);

    component FSM is
        port(
            zselect: in std_logic;
            opcode: in std_logic_vector(3 downto 0);
            clk, reset: in std_logic;
            fsm_out_state: out std_logic_vector(3 downto 0)
        );
    end component;
    
begin
    -- Instantiate the FSM
    uut: FSM
        port map(
            zselect => zselect,
            opcode => opcode,
            clk => clk,
            reset => reset,
            fsm_out_state => fsm_out_state
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Test stimulus
    stimulus: process
    begin
        -- Initial reset
        reset <= '1';
        zselect <= '0';
        opcode <= "0000"; -- op_ADD
        wait for 20 ns;
        reset <= '0';
        
        -- Test case 1: op_LHI (Should transition to s6)
        opcode <= "1000"; -- op_LHI
        wait for 20 ns;

        -- Test case 2: op_LLI (Should transition to s6)
        opcode <= "1001"; -- op_LLI
        wait for 20 ns;
        
        -- Test case 3: op_JAL (Should transition to s13)
        opcode <= "1101"; -- op_JAL
        wait for 20 ns;
        
        -- Test case 4: op_JLR (Should transition to s13)
        opcode <= "1111"; -- op_JLR
        wait for 20 ns;
        
        -- Test case 5: op_J (Should transition to s14)
        opcode <= "1110"; -- op_J
        wait for 20 ns;

        -- Test case 6: op_ADD (Should transition to s2)
        opcode <= "0000"; -- op_ADD
        wait for 20 ns;
        
        -- Test case 7: op_SUB (Should transition to s2)
        opcode <= "0010"; -- op_SUB
        wait for 20 ns;
        
        -- Test case 8: op_MUL (Should transition to s2)
        opcode <= "0011"; -- op_MUL
        wait for 20 ns;

        -- Test case 9: op_ADI (Should transition to s4)
        opcode <= "0001"; -- op_ADI
        wait for 20 ns;

        -- Test case 10: op_BEQ (Should transition to s11)
        opcode <= "1100"; -- op_BEQ
        wait for 20 ns;

        -- Test case 11: op_LW (Should transition to s7)
        opcode <= "1010"; -- op_LW
        wait for 20 ns;
        
        -- Test case 12: op_SW (Should transition to s7)
        opcode <= "1011"; -- op_SW
        wait for 20 ns;
        
        -- Test case 13: op_BEQ with zselect = '1' (Should transition to s12)
        zselect <= '1';
        opcode <= "1100"; -- op_BEQ
        wait for 20 ns;

        -- Test case 14: Reset FSM to s0
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test end
        wait;
    end process;
end testbench;
