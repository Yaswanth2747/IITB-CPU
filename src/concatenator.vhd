library ieee;
use ieee.std_logic_1164.all;

entity concatenator is
    port (
        concat_sel: in std_logic; -- IR_12, Selection line: 0 for LHI, 1 for LLI
        concat_in: in std_logic_vector(7 downto 0); -- IR_7to0
        concat_out: out std_logic_vector(15 downto 0) -- Output 16-bit vector
    );
end entity;

architecture behavior of concatenator is
begin
    process(concat_sel, concat_in)
    begin
        if concat_sel = '0' then -- LHI operation
            concat_out <= concat_in & "00000000";
        else -- LLI operation
            concat_out <= "00000000" & concat_in;
        end if;
    end process;
end behavior;

