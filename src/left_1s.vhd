library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left_1s is
    port (
        input  : in std_logic_vector(15 downto 0);   
        output : out std_logic_vector(15 downto 0)   
    );
end entity left_1s;

architecture str of left_1s is
begin
    --
    output <= input(14 downto 0) & "0";  -- Concatenate '0' and input(15 downto 1)
end architecture str;
