library ieee;
use ieee.std_logic_1164.all;

package Decoder is
    component decoder_2_4 is
        port (A, B: in std_logic;  -- 2-bit input
              Y0, Y1, Y2, Y3: out std_logic); -- 4-bit output
    end component;
end package Decoder;

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity decoder_2_4 is
    port (A, B: in std_logic;  -- 2-bit input
          Y0, Y1, Y2, Y3: out std_logic); -- 4-bit output
end entity;

architecture structure of decoder_2_4 is
    signal A_not, B_not: std_logic; -- Inverted signals for inputs
begin
    -- Inverting the input signals using NOT gates
    inst1: INVERTER port map(A => A, Y => A_not);
    inst2: INVERTER port map(A => B, y => B_not);

    -- AND gates to generate the outputs
    inst3: AND_2 port map(A => A_not, B => B_not, Y => Y0); -- "00"
    inst4: AND_2 port map(A => A_not, B => B, Y => Y1);     -- "01"
    inst5: AND_2 port map(A => A, B => B_not, Y => Y2);     -- "10"
    inst6: AND_2 port map(A => A, B => B, Y => Y3);         -- "11"

end architecture;
