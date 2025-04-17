----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2023 12:28:16
-- Design Name: 
-- Module Name: delay - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay is
    Port ( input : in STD_LOGIC:='0';
           output : out STD_LOGIC:='0';
           clk : in STD_LOGIC);
end delay;

architecture Behavioral of delay is

begin
process(clk) 
begin
    if(clk='1' and clk'event) then
        output <= input;
    end if;
end process;
end Behavioral;
