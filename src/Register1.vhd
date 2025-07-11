library ieee;
use ieee.std_logic_1164.all;

entity Register1 is
    port (
        input   : in std_logic_vector(15 downto 0);
        write_en, clk : in std_logic;
        output  : out std_logic_vector(15 downto 0)
    );
end entity Register1;

architecture bhv of Register1 is
    signal rgst_temp : std_logic_vector(15 downto 0) := (others => '0');
begin
    -- Assign rgst_temp to output
    output <= rgst_temp;

    -- Process to update register on rising edge of clock
    edit_process : process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                rgst_temp <= input;
            end if;
        end if;
    end process edit_process;
end architecture bhv;
