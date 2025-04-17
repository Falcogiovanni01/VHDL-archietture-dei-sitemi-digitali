----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 17:35:12
-- Design Name: 
-- Module Name: system_ab_tb - Behavioral
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

entity system_ab_tb is
end system_ab_tb;
          
architecture system_ab of system_ab_tb is

    component system is
        Port (
            start : in STD_LOGIC;
            reset : in STD_LOGIC;
            clock : in STD_LOGIC);
    end component;
        
    signal STRT, RST, CLK, SIG_A, SIG_B, SIG_ERR : std_logic := '0';

begin
    
    sys : system
        port map(
        start => STRT,
        reset => RST,
        clock => CLK);
        
     CLKP : process
        begin
            CLK <= '1';
            wait for 5 ns;
            CLK <= '0';
            wait for 5 ns;
        end process;
        
     test : process
        begin
            RST <= '1';
            wait for 30 ns;
            RST <= '0';
            wait for 15 ns;
            STRT <= '1';
            wait for 200ns;
           
            wait;
        end process;

end system_ab;
