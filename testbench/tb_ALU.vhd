library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end tb_ALU;

architecture testbench of tb_ALU is
    signal A, B: std_logic_vector(15 downto 0);
    signal opcode: std_logic_vector(2 downto 0);
    signal C: std_logic_vector(15 downto 0);
    signal z_flag: std_logic;

    -- Component declaration for the ALU
    component ALU is
        port(
            A, B: in std_logic_vector(15 downto 0);
            opcode: in std_logic_vector(2 downto 0);
            C: out std_logic_vector(15 downto 0);
            z_flag: out std_logic
        );
    end component;

begin
    -- Instantiate the ALU
    uut: ALU
        port map(
            A => A,
            B => B,
            opcode => opcode,
            C => C,
            z_flag => z_flag
        );

    -- Clock generation process (not needed for ALU as there's no clock)
    -- but we can simulate the test inputs by providing stimulus manually.
    stimulus: process
    begin
        -- Test case 1: ADD operation (opcode = "000")
        A <= "0000000000000010";  -- A = 2
        B <= "0000000000000100";  -- B = 4
        opcode <= "000";          -- ADD
        wait for 20 ns;           -- Wait for ALU to process
        
        -- Test case 2: SUB operation (opcode = "010")
        A <= "0000000000000110";  -- A = 6
        B <= "0000000000000010";  -- B = 2
        opcode <= "010";          -- SUB
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 3: MUL operation (opcode = "011")
        A <= "0000000000000011";  -- A = 3
        B <= "0000000000000010";  -- B = 2
        opcode <= "011";          -- MUL
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 4: AND operation (opcode = "100")
        A <= "0000000000001111";  -- A = 15 (binary 1111)
        B <= "0000000000001010";  -- B = 10 (binary 1010)
        opcode <= "100";          -- AND
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 5: ORA operation (opcode = "101")
        A <= "0000000000001100";  -- A = 12 (binary 1100)
        B <= "0000000000001010";  -- B = 10 (binary 1010)
        opcode <= "101";          -- ORA
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 6: IMP operation (opcode = "110")
        A <= "0000000000000110";  -- A = 6
        B <= "0000000000000011";  -- B = 3
        opcode <= "110";          -- IMP
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 7: Zero result check (opcode = "000" - ADD)
        A <= "0000000000000000";  -- A = 0
        B <= "0000000000000000";  -- B = 0
        opcode <= "000";          -- ADD (A + B = 0)
        wait for 20 ns;           -- Wait for ALU to process

        -- Test case 8: Zero result check (opcode = "010" - SUB)
        A <= "0000000000000001";  -- A = 1
        B <= "0000000000000001";  -- B = 1
        opcode <= "010";          -- SUB (A - B = 0)
        wait for 20 ns;           -- Wait for ALU to process

        -- End of test cases
        wait;
    end process;
end testbench;
