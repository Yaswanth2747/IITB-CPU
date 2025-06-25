library ieee;
use ieee.std_logic_1164.all;

entity tb_Register1 is
end entity tb_Register1;

architecture behavior of tb_Register1 is
    component Register1
        port (
            input   : in std_logic_vector(15 downto 0);
            write_en, clk : in std_logic;
            output  : out std_logic_vector(15 downto 0)
        );
    end component;

    signal input   : std_logic_vector(15 downto 0) := (others => '0');
    signal write_en, clk : std_logic := '0';
    signal output  : std_logic_vector(15 downto 0);

begin
    uut: Register1
        port map (
            input   => input,
            write_en => write_en,
            clk     => clk,
            output  => output
        );

    clk_process :process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process clk_process;

    stim_proc: process
    begin
        input <= "0000000000000001";
        write_en <= '0';
        wait for 20 ns;

        write_en <= '1';
        wait for 20 ns;

        input <= "0000000000000010";
        write_en <= '0';
        wait for 20 ns;

        write_en <= '1';
        wait for 20 ns;

        wait;
    end process stim_proc;

end architecture behavior;
