----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2025 13:11:56
-- Design Name: 
-- Module Name: control_unit - Behavioral
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


entity control_unit is
  Port (
  s0 : in std_logic; -- bit meno significiativo nel segnale di sorgente
  d1 : in std_logic; -- bit più significativo nel segnale di destinazione
  enable : out std_logic_vector( 3 downto 0)  
   );
end control_unit;

architecture Behavioral of control_unit is

begin
    
    cu_process : process (s0, d1) 
    
    begin 
    
        case s0 is 
            when '0' =>
                if(d1='0') then  -- 00
                enable <= "0101"; 
                elsif(d1='1') then -- 01
                enable <= "1001";
                else 
                enable <= (others=>'0');
                end if;
            
            when '1' => 
                if(d1='0') then --10
                    enable<= "0110" ; 
                elsif (d1 = '1') then  --11
                    enable <= "1010" ; 
                else
                 enable <= (others =>'0'); 
                end if;
            
            when others =>
                enable <= (others =>'0');
            end case;
      end process; 

end Behavioral;
