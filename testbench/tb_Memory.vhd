library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Memory is
end entity;

architecture behavior of tb_Memory is
    component Memory is
        port(
            clk         : in std_logic;
            MWR         : in std_logic;
            MDR         : in std_logic;
            M_add       : in std_logic_vector(15 downto 0);
            M_data_in   : in std_logic_vector(15 downto 0);
            M_data_out  : out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk_tb       : std_logic := '0';
    signal MWR_tb       : std_logic := '0';
    signal MDR_tb       : std_logic := '0';
    signal M_add_tb     : std_logic_vector(15 downto 0) := (others => '0');
    signal M_data_in_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal M_data_out_tb: std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: Memory
        port map(
            clk         => clk_tb,
            MWR         => MWR_tb,
            MDR         => MDR_tb,
            M_add       => M_add_tb,
            M_data_in   => M_data_in_tb,
            M_data_out  => M_data_out_tb
        );

    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        MWR_tb <= '1';
        MDR_tb <= '0';
        M_add_tb <= "0000000000001111";
        M_data_in_tb <= "1111000011110000";
        wait for 20 ns;

        MWR_tb <= '0';
        MDR_tb <= '1';
        wait for 20 ns;

        MWR_tb <= '1';
        MDR_tb <= '0';
        M_add_tb <= "0000000000010000";
        M_data_in_tb <= "1010101010101010";
        wait for 20 ns;

        MWR_tb <= '0';
        MDR_tb <= '1';
        M_add_tb <= "0000000000001111";
        wait for 20 ns;

        M_add_tb <= "0000000000010000";
        wait for 20 ns;

        wait;
    end process;
end architecture;
