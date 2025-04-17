----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2023 11:01:26
-- Design Name: 
-- Module Name: A_tb - Behavioral
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
--C_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity A_tb is
--  Port ( );
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERI
end A_tb;

architecture Behavioral of A_tb is
component A
                   Port (clk,rst: in std_logic;
                            outputA: out std_logic

   );
end component;

for all: A use entity work.A(Structural);

constant CLKA_period : time := 10ns;
signal clkA, reset, databus: std_logic;
begin
systemA: A port map(clk => clkA, rst => reset, outputA => databus);

clkA_proc: process
    begin
        clkA <= '0';
        wait for CLKA_period/2;
        clkA <= '1';
        wait for CLKA_period/2;
    end process;
    
    
sim_process: process
begin
    reset <= '1';
    wait for 10ns;
    reset <= '0';
    wait;
end process;

end Behavioral;