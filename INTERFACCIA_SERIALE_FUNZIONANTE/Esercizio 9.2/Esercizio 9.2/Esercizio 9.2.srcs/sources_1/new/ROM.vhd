----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2023 10:37:47
-- Design Name: 
-- Module Name: ROM - Behavioral
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
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ROM is
    Generic ( N: integer);
    Port ( 
           read, clk: in STD_LOGIC;
           counter: in STD_LOGIC_VECTOR (0 to 3);
           output : out STD_LOGIC_VECTOR (0 to 7):=(others => '0')
            );
end ROM;

architecture Behavioral of ROM is
type rom_type is array (0 to N-1) of std_logic_vector(0 to 7);
signal romA: rom_type:=( "11000100",
                                            "00011010",
                                            "00101100",
                                            "00111111");
signal temp: std_logic_vector(0 to 7);

begin
 process(clk)
begin
if(clk='1' and clk'event) then
    if(read ='1') then
        temp <= romA(TO_INTEGER(unsigned(counter(0 to 3))));
    end if;
  end if;
        
end process;
output <= temp;
end Behavioral;