library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Char_Decoder is
    port(
        chara : in std_logic_vector(4 downto 0);
        symbol : out std_logic_vector(6 downto 0)
    );
end Char_Decoder;

architecture Behavioral of Char_Decoder is
constant zero	: std_logic_vector(6 downto 0) := "1000000";
constant one	: std_logic_vector(6 downto 0) := "1111001";
constant two	: std_logic_vector(6 downto 0) := "0100100";
constant three	: std_logic_vector(6 downto 0) := "0110000";
constant four	: std_logic_vector(6 downto 0) := "0011001";
constant five	: std_logic_vector(6 downto 0) := "0010010";
constant six	: std_logic_vector(6 downto 0) := "0000010";
constant seven	: std_logic_vector(6 downto 0) := "1111000";
constant eight	: std_logic_vector(6 downto 0) := "0000000";
constant nine	: std_logic_vector(6 downto 0) := "0010000";
constant a	: std_logic_vector(6 downto 0) := "0001000";
constant b	: std_logic_vector(6 downto 0) := "0000011";
constant c	: std_logic_vector(6 downto 0) := "1000110";
constant d	: std_logic_vector(6 downto 0) := "0100001";
constant e	: std_logic_vector(6 downto 0) := "0000110";
constant f	: std_logic_vector(6 downto 0) := "0001110";
constant g	: std_logic_vector(6 downto 0) := "1000010";
constant h	: std_logic_vector(6 downto 0) := "0001011";
constant i	: std_logic_vector(6 downto 0) := "1001111";
constant j	: std_logic_vector(6 downto 0) := "1100001";
constant l	: std_logic_vector(6 downto 0) := "1000111";
constant n	: std_logic_vector(6 downto 0) := "1001000";
constant o	: std_logic_vector(6 downto 0) := "0100011";
constant p	: std_logic_vector(6 downto 0) := "1001100";
constant q	: std_logic_vector(6 downto 0) := "0011000";
constant r	: std_logic_vector(6 downto 0) := "0101111";
constant s	: std_logic_vector(6 downto 0) := "0010010";
constant t	: std_logic_vector(6 downto 0) := "0000111";
constant u	: std_logic_vector(6 downto 0) := "1000001";
constant y	: std_logic_vector(6 downto 0) := "0010001";
constant white	: std_logic_vector(6 downto 0) := "1111111";
constant quest	: std_logic_vector(6 downto 0) := "0101100";


begin
    with chara select
    symbol <= zero when "00000",
              one when "00001",
              two when "00010",
            three when "00011",
             four when "00100",
             five when "00101",
              six when "00110",
            seven when "00111",
            eight when "01000",
             nine when "01001",
                a when "01010",
                b when "01011",
                c when "01100",
                d when "01101",
                e when "01110",
                f when "01111",
                g when "10000",
                h when "10001",
                i when "10010",
                j when "10011",
                l when "10100",
                n when "10101",
                o when "10110",
                p when "10111",
                q when "11000",
                r when "11001",
                s when "11010",
                t when "11011",
                u when "11100",
                y when "11101",
            white when "11110",
            quest when "11111",
                (others => '-') when others;

end Behavioral ; -- Behavioral