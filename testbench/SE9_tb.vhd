library ieee;
use ieee.std_logic_1164.all;

entity SE9_tb is
end entity SE9_tb;

architecture sim of SE9_tb is
    signal input : std_logic_vector(8 downto 0);
    signal output : std_logic_vector(15 downto 0);
begin
    uut: entity work.SE9
        port map (
            input => input,
            output => output
        );

    stim_proc: process
    begin
        input <= "000000000"; wait for 10 ns;
        input <= "100000000"; wait for 10 ns;
        input <= "011111111"; wait for 10 ns;
        input <= "111111111"; wait for 10 ns;
        input <= "000000001"; wait for 10 ns;
        wait;
    end process;
end architecture sim;
