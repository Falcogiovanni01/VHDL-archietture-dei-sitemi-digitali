library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux is
    generic(
        selection_depth : positive;
        vector_length : positive := 1
    );
    port(
        input : in std_logic_vector(2**selection_depth*vector_length-1 downto 0);
        sel : in std_logic_vector(selection_depth-1 downto 0);
        output : out std_logic_vector(vector_length-1 downto 0)
    );
end entity;

architecture behavioral of Mux is
    begin
    output <= input(vector_length*(to_integer(unsigned(sel))+1)-1 downto vector_length*to_integer(unsigned(sel)));

end architecture;