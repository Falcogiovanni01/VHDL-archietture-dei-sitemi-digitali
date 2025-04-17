----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 17:55:30
-- Design Name: 
-- Module Name: B_tb - Behavioral
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

entity B_tb is
--  Port ( );
end B_tb;

architecture Behavioral of B_tb is
component A 
    Port ( 
            clk: in std_logic;
            risposta: in std_logic;
            request: out std_logic;           
            output: out std_logic_vector(0 to 3)
       );
   end component;

component B 
    Port (  clk,rst: in std_logic;
            request: in std_logic;
            input: in std_logic_vector(0 to 3);
            risposta: out std_logic
        );
   end component;

   constant CLK_periodA : time := 20ns;
   constant CLK_periodB : time := 10ns;
   --ricorda: il limite di frequenza sta nel contatore, ovvero il segnale di ris deve essere alto per almeno un colpo di clock del sistema A, altrimenti il contatore non lo vede e non si incrementa
   signal rst,r,clkA,clkB,ris : STD_LOGIC := '0';
   signal data :  STD_LOGIC_VECTOR(0 to 3);

begin
    entita1: A port map(clk => clkA, request => r, risposta => ris, output => data);
    
    entita2: B port map(clk => clkB, rst => rst, request => r, risposta => ris, input => data);

    clkA_proc: process
    begin
        clkA <= '0';
        wait for CLK_periodA/2;
        clkA <= '1';
        wait for CLK_periodA/2;
    end process;
    
    clkB_proc: process
    begin
        clkB <= '0';
        wait for CLK_periodB/2;
        clkB <= '1';
        wait for CLK_periodB/2;
    end process;

end Behavioral;