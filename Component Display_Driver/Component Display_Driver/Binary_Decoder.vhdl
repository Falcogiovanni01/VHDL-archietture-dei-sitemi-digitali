library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Binary_Decoder is
    generic(
        length_log : positive := 1
    );
    port(
        input : in std_logic_vector(length_log - 1 downto 0);
        output : out std_logic_vector(2**length_log - 1 downto 0)
    );
end Binary_Decoder;

architecture Behavioral of Binary_Decoder is

begin
    process(input)
        variable pos : positive := to_integer(unsigned(input));
        begin
            output <= (others => '0');
            output(to_integer(unsigned(input))) <= '1';
    end process;
end Behavioral ; -- Behavioral