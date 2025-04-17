----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:33:01
-- Design Name: 
-- Module Name: counter_mod8 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_mod8 is
    port(
        clock : in STD_LOGIC;
        reset : in STD_LOGIC;
		enable : in STD_LOGIC; --questo è l'enable del clock, insieme danno l'impulso di conteggio
        counter : out STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end counter_mod8;

architecture Behavioral of counter_mod8 is

signal c : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');

begin

    counter <= c;
    
    counter_process: process(clock)
    begin
        if (clock'event AND clock = '1') then
          if (reset = '1') then
            c <= (others => '0');
          else
           if (enable='1') then
            c <= STD_LOGIC_VECTOR(unsigned(c) + 1);
           end if;
          end if;
        end if;	
    end process;

end Behavioral;