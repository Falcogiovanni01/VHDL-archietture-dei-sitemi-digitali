library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Display_Driver is
    port(
        enable : in std_logic;
        stringa : in std_logic_vector(47 downto 0);
        clock : in std_logic;
        cathodes : out std_logic_vector(7 downto 0);
        anodes : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Structural of Display_Driver is

    component Char_Decoder is
        port(
            chara : in std_logic_vector(4 downto 0);
            symbol : out std_logic_vector(6 downto 0)
        );
    end component;

    component  Counter is
        generic(
                module_log : positive := 3
        );
        Port (
                reset : in STD_LOGIC;
                enable : in STD_LOGIC;
                clock : in  STD_LOGIC;
                count : out STD_LOGIC_VECTOR(module_log-1 downto 0);
                count_max : out  STD_LOGIC;
                ripple : out STD_LOGIC
        ); 
    end component;

    component Mux is
        generic(
            selection_depth : positive := 3;
            vector_length : positive := 6
        );
        port(
            input : in std_logic_vector(2**selection_depth*vector_length-1 downto 0);
            sel : in std_logic_vector(selection_depth-1 downto 0);
            output : out std_logic_vector(vector_length-1 downto 0)
        );
    end component;

    component clock_divider is
        generic(
                clock_in_freq : integer := 100000000;
                clock_out_freq : integer := 500
        );
        Port (
                reset : in STD_LOGIC;
                clock_in : in  STD_LOGIC;
                clock_out : out  STD_LOGIC
        ); 
    end component;

    component Binary_Decoder is
        generic(
            length_log : positive := 3
        );
        port(
            input : in std_logic_vector(length_log - 1 downto 0);
            output : out std_logic_vector(2**length_log - 1 downto 0)
        );
    end component;

    signal decoded_char : std_logic_vector(6 downto 0);
    signal encoded_char : std_logic_vector(5 downto 0);
    signal alimentazione : std_logic;

    signal update_signal : std_logic;
    signal position : std_logic_vector(2 downto 0);
    signal notanodes : std_logic_vector(7 downto 0);

    begin
        mux48_6 : Mux port map (stringa, position, encoded_char);
        cdecoder : Char_Decoder port map (encoded_char(4 downto 0), decoded_char);
        cathodes <= encoded_char(5)&decoded_char;

        anodes <= not notanodes;
        counter8 : Counter port map (enable, update_signal, clock, position);
        divider : clock_divider port map (enable, clock, update_signal);
        bdecoder : Binary_Decoder port map (position, notanodes);

end Structural ; -- Structural