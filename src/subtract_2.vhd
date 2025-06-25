library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity subtract_2 is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);  
           Y : out STD_LOGIC_VECTOR (15 downto 0)  
         );
end subtract_2;

architecture Behavioral of subtract_2 is
begin
    process (A)
    begin
        
        Y <= A - "0000000000000010";  
    end process;
end Behavioral;

