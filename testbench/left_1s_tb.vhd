library ieee;
use ieee.std_logic_1164.all;

entity left_1s_tb is
end entity left_1s_tb;

architecture sim of left_1s_tb is
    signal input : std_logic_vector(15 downto 0);
    signal output : std_logic_vector(15 downto 0);
begin
    uut: entity work.left_1s
        port map (
            input => input,
            output => output
        );

    stim_proc: process
    begin
        input <= "0000000000000001"; wait for 10 ns;
        input <= "0000000000000010"; wait for 10 ns;
        input <= "0000000000000100"; wait for 10 ns;
        input <= "0000000000001000"; wait for 10 ns;
        input <= "0000000000010000"; wait for 10 ns;
        input <= "0000000000100000"; wait for 10 ns;
        input <= "0000000001000000"; wait for 10 ns;
        input <= "0000000010000000"; wait for 10 ns;
        input <= "0000000100000000"; wait for 10 ns;
        input <= "0000001000000000"; wait for 10 ns;
        wait;
    end process;
end architecture sim;
