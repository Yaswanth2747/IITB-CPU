library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Register_File is
end tb_Register_File;

architecture testbench of tb_Register_File is
    signal RF_A1, RF_A2, RF_A3: std_logic_vector(2 downto 0);
    signal RF_D3: std_logic_vector(15 downto 0);
    signal RF_D1, RF_D2: std_logic_vector(15 downto 0);
    signal clk, RF_write: std_logic;
    signal R0, R1, R2, R3, R4, R5, R6, R7: std_logic_vector(15 downto 0);

    component Register_File is
        port (
            RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
            RF_D3: in std_logic_vector(15 downto 0);
            RF_D1, RF_D2: out std_logic_vector(15 downto 0);
            clk, RF_write: in std_logic;
            R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0)
        );
    end component;
begin
    uut: Register_File
        port map (
            RF_A1 => RF_A1,
            RF_A2 => RF_A2,
            RF_A3 => RF_A3,
            RF_D3 => RF_D3,
            RF_D1 => RF_D1,
            RF_D2 => RF_D2,
            clk => clk,
            RF_write => RF_write,
            R0 => R0,
            R1 => R1,
            R2 => R2,
            R3 => R3,
            R4 => R4,
            R5 => R5,
            R6 => R6,
            R7 => R7
        );

    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stimulus: process
    begin
        RF_write <= '0';
        RF_A3 <= "000";
        RF_D3 <= "0000000000000010";  -- 16-bit value 2
        wait for 20 ns;
        RF_write <= '1';
        wait for 20 ns;
        RF_write <= '0';
        RF_A1 <= "000";
        wait for 20 ns;
        RF_A2 <= "000";
        wait for 20 ns;
        RF_A3 <= "001";
        RF_D3 <= "0000000000001111";  -- 16-bit value 255
        RF_write <= '1';
        wait for 20 ns;
        RF_write <= '0';
        RF_A1 <= "001";
        wait for 20 ns;
        RF_A2 <= "000";
        RF_A3 <= "010";
        RF_D3 <= "1111111111111111";  -- 16-bit value 65535
        RF_write <= '1';
        wait for 20 ns;
        RF_write <= '0';
        RF_A1 <= "010";
        wait for 40 ns;
        wait;
    end process;
end testbench;
