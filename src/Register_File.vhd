library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Register_File is
    port (
        RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
        RF_D3: in std_logic_vector(15 downto 0);
        RF_D1, RF_D2: out std_logic_vector(15 downto 0);
        clk, RF_write: in std_logic;
        R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0)
    );
end entity Register_File;

architecture Behavioural of Register_File is
    component Register1 is
        port (
            input: in std_logic_vector(15 downto 0);
            write_en, clk: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
    end component;

    signal write_en: std_logic_vector(7 downto 0);
    type reg_array is array (7 downto 0) of std_logic_vector(15 downto 0);
    signal reg_out: reg_array := (
        "0000000000000001", 
        "0000000000000010", 
        "0000000000000011", 
        "0000000000000100", 
        "0000000000000101", 
        "0000000000000110", 
        "0000000000000111", 
        "0000000000000000"
    );
begin
    process(RF_A3, RF_write)
    begin
        write_en <= (others => '0');
        if RF_write = '1' then
            case RF_A3 is
                when "000" => write_en(0) <= '1';
                when "001" => write_en(1) <= '1';
                when "010" => write_en(2) <= '1';
                when "011" => write_en(3) <= '1';
                when "100" => write_en(4) <= '1';
                when "101" => write_en(5) <= '1';
                when "110" => write_en(6) <= '1';
                when "111" => write_en(7) <= '1';
                when others => null;
            end case;
        end if;
    end process;

    gen_registers: for i in 0 to 7 generate
        reg_inst: Register1
            port map (
                input => RF_D3,
                write_en => write_en(i),
                clk => clk,
                output => reg_out(i)
            );
    end generate;

    RF_D1 <= reg_out(to_integer(unsigned(RF_A1)));
    RF_D2 <= reg_out(to_integer(unsigned(RF_A2)));

    R0 <= reg_out(0);
    R1 <= reg_out(1);
    R2 <= reg_out(2);
    R3 <= reg_out(3);
    R4 <= reg_out(4);
    R5 <= reg_out(5);
    R6 <= reg_out(6);
    R7 <= reg_out(7);
end Behavioural;
