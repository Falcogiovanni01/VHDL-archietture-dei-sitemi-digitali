----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:37:24
-- Design Name: 
-- Module Name: decimalToBinary - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity Conv_Dec_Bin is
    generic(
     N : integer := 6; --  numero di bit del numero binario di input.
     M : integer := 2 -- il numero di cifre decimali risultanti.
    );
    Port ( 
        CLK : in STD_LOGIC;
        input : in STD_LOGIC_VECTOR (N-1 downto 0);
        output : out STD_LOGIC_VECTOR (4*M-1 downto 0)
    );
end Conv_Dec_Bin;

architecture Behavioral of Conv_Dec_Bin is
    -- Supponendo N bit per l'input binario e M cifre decimali
begin
    
    process(CLK)
        variable binary_digit: STD_LOGIC_VECTOR(3 downto 0);
        variable i: INTEGER range 0 to M-1;
        variable decimal_value: INTEGER;
        variable temp_value: INTEGER;
        variable tmp: INTEGER;
    begin
        if rising_edge(CLK) then
            -- Conversione da binario a decimale
            decimal_value := to_integer(signed(input));
        
            if input(N-1) = '1' then
                -- Se il bit più significativo è 1, il numero è negativo
                decimal_value := -decimal_value;
            end if;

            temp_value := abs(decimal_value);

            for i in 0 to M-1 loop
                -- Estrai ogni cifra e convertila in binario
                tmp := temp_value mod 10;
                binary_digit := std_logic_vector(to_unsigned(tmp, 4));
                temp_value := temp_value / 10;
                -- Assegna ogni cifra binaria all'output
                output(4*i+3 downto 4*i) <= binary_digit;
            end loop;
        end if;
    end process;
end Behavioral;
