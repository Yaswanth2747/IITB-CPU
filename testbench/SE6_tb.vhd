library ieee;
use ieee.std_logic_1164.all;

entity SE6_tb is
end entity SE6_tb;

architecture sim of SE6_tb is
    signal input : std_logic_vector(5 downto 0);
    signal output : std_logic_vector(15 downto 0);
begin
    uut: entity work.SE6
        port map (
            input => input,
            output => output
        );

    stim_proc: process
    begin
        input <= "000000"; wait for 10 ns;
        input <= "100000"; wait for 10 ns;
        input <= "011111"; wait for 10 ns;
        input <= "111111"; wait for 10 ns;
        input <= "000001"; wait for 10 ns;
        wait;
    end process;
end architecture sim;
