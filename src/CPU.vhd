library ieee; use ieee.std_logic_1164.all;
entity CPU is 
    port(
        clk: in std_logic; 
        reset: in std_logic; 
        R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0); 
        opcode_out : out std_logic_vector(3 downto 0)
    ); 
end entity;

architecture cpu of CPU is
    component datapath is 
        port( 
            clk,reset: in std_logic;
            state: in std_logic_vector(3 downto 0); 
            opcode_out: out std_logic_vector(3 downto 0);
            zselect: out std_logic;
            R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0)
        ); 
    end component;

    component FSM is 
        port( 
            zselect: in std_logic; 
            opcode: in std_logic_vector(3 downto 0); 
            clk,reset: in std_logic; 
            fsm_out_state: out std_logic_vector(3 downto 0)
        ); 
    end component;

    signal state, opcode : std_logic_vector(3 downto 0); 
    signal z: std_logic;

begin 
    opcode_out <= opcode;
    
    path_of_data: datapath 
        port map(
            clk => clk, 
            reset => reset, 
            state => state, 
            opcode_out => opcode, 
            zselect => z,
            R0 => R0, 
            R1 => R1, 
            R2 => R2, 
            R3 => R3, 
            R4 => R4, 
            R5 => R5, 
            R6 => R6, 
            R7 => R7
        );

    machine_of_finite_states: FSM 
        port map(
            zselect => z, 
            opcode => opcode, 
            clk => clk, 
            reset => reset, 
            fsm_out_state => state
        );
end architecture;