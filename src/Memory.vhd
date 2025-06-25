library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port(
        clk         : in std_logic;                        -- Clock signal
        MWR         : in std_logic;                        -- Write enable
        MDR         : in std_logic;                        -- Read enable
        M_add       : in std_logic_vector(15 downto 0);    -- 16-bit address
        M_data_in   : in std_logic_vector(15 downto 0);    -- Data input to the memory
        M_data_out  : out std_logic_vector(15 downto 0)    -- Data output from the memory
    );
end entity;

architecture memory_arch of Memory is
  
    type mem_arr is array(0 to 127) of std_logic_vector(15 downto 0);

    signal data : mem_arr := (
        -- Instructions
        0  => "1110001000001010", -- Load 10 to higher bits of R1
        1  => "1001001000000101", -- Load 5 to lower bits of R1
        2  => "0000001000010000", -- Add R1 and R0, store in R2
        3  => "0010010001011000", -- Subtract R1 from R2, store in R3
        4  => "0011010011100000", -- Multiply R2 and R3, store in R4
        5  => "0001001101001111", -- Add 15 to R1, store in R5
        6  => "0100010011110000", -- AND R2 and R3, store in R6
        7  => "0101100101111000", -- OR R4 and R5, store in R7
        8  => "0110110111000000", -- Reserved instruction
        9  => "1010001010000011", -- Load from memory at R2+3 to R1
        10 => "1011010011000010", -- Store R2 to memory at R3+2
        11 => "1100001010000100", -- Branch if R1 == R2 to PC+4*2
        12 => "1101001000001000", -- Jump to PC+8*2, store PC in R1
        13 => "1111011000000000", -- Jump to address in R3, store PC in R2
        14 => "1110001000000110", -- Jump to PC+6*2

        -- Data Section
        15 => "0000000000001010", -- Data for first register
        16 => "0000000011111111", -- Data for second register
        17 => "0001001000110100", -- Data for third register
        18 => "0101011001111000", -- Data for fourth register
        19 => "1001101010111100", -- Data for fifth register
        20 => "1101111000001111", -- Data for sixth register
        21 => "0100001100100001", -- Data for seventh register
        22 => "1000011101100101", -- Data for eighth register
        23 => "1010101111001101", -- Data for ninth register
        24 => "1110111100000001", -- Data for tenth register
 
        others => (others => '0')
    );
begin
   
    memory_access_proc: process(clk)
    begin
        if rising_edge(clk) then
            
            if MWR = '1' then
                data(to_integer(unsigned(M_add(15 downto 1)))) <= M_data_in;
            end if;

          
            if MDR = '1' then
                M_data_out <= data(to_integer(unsigned(M_add(15 downto 1))));
            else
                M_data_out <= (others => '0'); 
            end if;
        end if;
    end process memory_access_proc;
end architecture memory_arch;
