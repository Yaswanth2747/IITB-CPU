library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        PC_in  : in std_logic_vector(15 downto 0); -- Input value to load into the PC
        PC_en  : in std_logic;                    -- Enable signal for updating PC
        clk    : in std_logic;                    -- Clock signal
        PC_out : out std_logic_vector(15 downto 0) -- Output of the PC
    );
end entity PC;

architecture arc_PC of PC is
    signal PC_temp : std_logic_vector(15 downto 0) := (others => '0'); -- Internal PC register initialized to 0
begin
    PC_out <= PC_temp;

    process(clk)
    begin
        if rising_edge(clk) then
            if PC_en = '1' then
                PC_temp <= PC_in; -- Load new value into PC when enabled
            end if;
        end if;
    end process;

end architecture arc_PC;