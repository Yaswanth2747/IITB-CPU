library ieee;
use ieee.std_logic_1164.all;

entity concatenator_tb is
end entity concatenator_tb;

architecture sim of concatenator_tb is
    signal concat_sel : std_logic;
    signal concat_in : std_logic_vector(7 downto 0);
    signal concat_out : std_logic_vector(15 downto 0);
begin
    uut: entity work.concatenator
        port map (
            concat_sel => concat_sel,
            concat_in => concat_in,
            concat_out => concat_out
        );

    stim_proc: process
    begin
        concat_sel <= '0'; concat_in <= "10101010"; wait for 10 ns;
        concat_sel <= '1'; concat_in <= "11001100"; wait for 10 ns;
        concat_sel <= '0'; concat_in <= "11110000"; wait for 10 ns;
        concat_sel <= '1'; concat_in <= "00001111"; wait for 10 ns;
        wait;
    end process;
end architecture sim;
