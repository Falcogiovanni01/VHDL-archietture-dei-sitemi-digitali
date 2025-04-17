----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2025 16:15:36
-- Design Name: 
-- Module Name: Demux1_2 - Behavioral
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

entity DEM1_2 is

 Port(
 
 A : in STD_LOGIC_VECTOR(1 downto 0);
 S1 : in STD_LOGIC;
 enable : in STD_LOGIC; 
 Y0: out STD_LOGIC_VECTOR (1 downto 0); -- uscite  
 Y1: out STD_LOGIC_VECTOR (1 downto 0)  
 ); 
  -- S1 Y 
  -- 0  MUX1
  -- 1  MUX2

end DEM1_2;

architecture Behavioral of DEM1_2 is

begin
 process (S1, A,enable)
  --variable temp_Y : STD_LOGIC_VECTOR(1 downto 0);
    begin
        -- Impostiamo tutte le uscite su '0' per essere sicuri che non rimangano attive
      --  temp_Y := "00"; 
     if(enable = '1') then
        -- Logica per selezionare l'uscita
        if (S1 = '0') then
             Y0 <= A;
             Y1 <= (others=>'0');
        else  
             Y1 <= A;
             Y0 <= (others=>'0');     
        end if;
      else
        Y0 <= (others => '0');
        Y1 <= (others => '0');
     end if; 
      
    end process;

end Behavioral;
