library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register1 is
    port (
        input         : in std_logic_vector(15 downto 0);
        write_en, clk : in std_logic;
        init_value    : in std_logic_vector(15 downto 0); -- Initialization value
        output        : out std_logic_vector(15 downto 0)
    );
end entity Register;

architecture bhv of Register1 is
    signal rgst_temp: std_logic_vector(15 downto 0) := (others => '0');
begin
    output <= rgst_temp;

    -- Process for writing data to the register
    edit_process: process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                rgst_temp <= input;
            end if;
        end if;
    end process;

    -- Initialization process
    initialize_process: process
    begin
        rgst_temp <= init_value; -- Set the initial value
        wait; -- Prevent re-triggering
    end process;

end bhv;
