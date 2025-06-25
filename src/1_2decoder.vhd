library ieee;
use ieee.std_logic_1164.all;

package Decoder is
    component decoder_1_2 is
        port (A: in std_logic;      -- 1-bit input
              Y0, Y1: out std_logic); -- 2-bit output
    end component;
end package Decoder;

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity decoder_1_2 is
    port (A: in std_logic;          -- 1-bit input
          Y0, Y1: out std_logic);  -- 2-bit output
end entity;

architecture structure of decoder_1_2 is
    signal A_not: std_logic;        -- Inverted signal for input
begin
    -- Inverting the input signal using a NOT gate
    inst1: INVERTER port map(A => A, Y => A_not);

    -- Assigning outputs
    inst2: AND_1 port map(A => A_not, Y => Y0); -- Output Y0 = NOT(A)
    inst3: AND_1 port map(A => A, Y => Y1);     -- Output Y1 = A

end architecture;
