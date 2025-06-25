library ieee;
use ieee.std_logic_1164.all;

package Decoder is
    component decoder_3_8 is
        port (A, B, C: in std_logic; -- 3-bit input
              Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7: out std_logic); -- 8-bit output
    end component;
end package Decoder;

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity decoder_3_8 is
    port (A, B, C: in std_logic; -- 3-bit input
          Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7: out std_logic); -- 8-bit output
end entity;



architecture structure of decoder_3_8 is
    signal A_not, B_not, C_not: std_logic; -- Inverted signals for inputs
begin
    -- Inverting the input signals using NOT gates
    inst1:INVERTER port map(a => A, y => A_not);
    inst2: INVERTER port map(a => B, y => B_not);
    inst3:INVERTER port map(a => C, y => C_not);

    -- AND gates to generate the outputs
    inst4: AND_3 port map(a => A_not, b => B_not, c => C_not, y => Y0); -- "000"
    inst5: AND_3 port map(a => A_not, b => B_not, c => C, y => Y1);     -- "001"
    inst6: AND_3 port map(a => A_not, b => B, c => C_not, y => Y2);     -- "010"
    inst7: AND_3 port map(a => A_not, b => B, c => C, y => Y3);         -- "011"
    inst8: AND_3 port map(a => A, b => B_not, c => C_not, y => Y4);     -- "100"
    inst9: AND_3 port map(a => A, b => B_not, c => C, y => Y5);         -- "101"
    inst10: AND_3 port map(a => A, b => B, c => C_not, y => Y6);        -- "110"
    inst11: AND_3 port map(a => A, b => B, c => C, y => Y7);            -- "111"

end architecture;
