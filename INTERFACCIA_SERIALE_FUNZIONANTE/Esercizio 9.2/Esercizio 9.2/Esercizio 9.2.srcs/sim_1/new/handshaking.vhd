----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2023 11:00:43
-- Design Name: 
-- Module Name: handshaking - Behavioral
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
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity handshaking is
--  Port ( );
end handshaking;

architecture Behavioral of handshaking is
component A  
                    Port ( --input : in STD_LOGIC_VECTOR (7 downto 0);
                          outputA : out STD_LOGIC;
                          clk: in STD_LOGIC;
                          rst: in STD_LOGIC
                          );
 end component;
 for all: A use entity work.A(Structural);
 component B
                    Port ( clk,inputB,rst,read: in std_logic;
                              output: out std_logic_vector(0 to 7)
        );
end component;

for all: B use entity work.B(Structural);
signal databus: std_logic;
signal clkA,clkB, reset, read: std_logic;
signal outputB: STD_LOGIC_VECTOR (0 to 7);

constant CLKA_period : time := 16ns;
constant CLKB_period : time := 1ns;

begin
systemA: A port map(clk => clkA, rst => reset, outputA => databus);
systemB :B port map( clk => clkB, rst => reset, inputB => databus, output => outputB, read=>read);

 clkA_proc: process
    begin
        clkA <= '0';
        wait for CLKA_period/2;
        clkA <= '1';
        wait for CLKA_period/2;
    end process;
  clkB_proc: process
    begin
        clkB <= '0';
        wait for CLKB_period/2;
        clkB <= '1';
        wait for CLKB_period/2;
    end process;
    
    
sim_process: process
begin
    reset <= '1';
    wait for 20ns;
    reset <= '0';
    wait for 600ns;
    read <= '1';
    wait for 20ns;
    read <= '0';
    wait for 20ns;
    read <= '1';
    wait for 20ns;
    read <= '0';
    wait for 20ns;
    read <= '1';
    wait for 20ns;
    read <= '0';    
    wait;
end process;

end Behavioral;
