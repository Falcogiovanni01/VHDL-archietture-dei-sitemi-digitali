----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:43:01
-- Design Name: 
-- Module Name: Cronometro_board_tb - Behavioral
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

entity Cronometro_board_tb is
end Cronometro_board_tb;

architecture Behavioral of Cronometro_board_tb is

component Cronometro_board is
    port(
        CLK : in STD_LOGIC; -- clock sistema
        BTN_1 : in STD_LOGIC; -- bottone per set
        BTN_2 : in STD_LOGIC; -- bottone per reset
        IN_SWITCH : in STD_LOGIC_VECTOR(5 DOWNTO 0); -- ingresso
        ANODES : out STD_LOGIC_VECTOR(7 DOWNTO 0); -- segnali associati agli anodi delle 8 cifre
        CATHODES : out STD_LOGIC_VECTOR(7 DOWNTO 0) -- segnali associati ai catodi comuni delle 8 cifre (compreso il punto)
    );
end component;

signal SWITCH_IN_tb : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal BTN_1_tb : STD_LOGIC := '0';
signal BTN_2_tb : STD_LOGIC := '0';
signal CLK_tb : STD_LOGIC := '0';
signal ANODES_tb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
signal CATHODES_tb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');

constant CLK_PERIOD : time := 10 ns;

begin

    uut: Cronometro_board
        Port map(
            CLK =>CLK_tb,
            BTN_1=>BTN_1_tb,
            BTN_2=>BTN_2_tb,
            IN_SWITCH=> SWITCH_IN_tb,
            ANODES =>ANODES_tb,
            CATHODES=>CATHODES_tb
        );
    
    clk_process: process
    begin
        CLK_tb <= '0';
        wait for CLK_PERIOD/2;
        CLK_tb <= '1';
        wait for CLK_PERIOD/2;
    end process clk_process;
    
    stim_proc: process
        begin
            wait for 20ns; 
            BTN_2_tb <= '1'; 
            wait for 15ms; 
            BTN_2_tb <= '0'; 
            wait for 20ns; -- set delle ore
            SWITCH_IN_tb <= "001001"; --setto ore 9:00:00 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto ore 9:00:00 
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 20ns; 
            SWITCH_IN_tb <= "001010"; 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto min 9:10:00
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 20ns;
            SWITCH_IN_tb <= "000000"; 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto sec 9:10:00
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 20ns; -- set delle ore
            SWITCH_IN_tb <= "001111"; 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto ore 15:00:00 
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 20ns; 
            SWITCH_IN_tb <= "011110"; 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto min 15:30:00
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 20ns;
            SWITCH_IN_tb <= "001010"; 
            wait for 20ns; 
            BTN_1_tb <= '1'; --setto sec 15:30:10
            wait for 15ms; 
            BTN_1_tb <= '0'; 
            wait for 40ms; 
            BTN_2_tb <= '1'; 
            wait for 15ms; 
            BTN_2_tb <= '0'; 
            wait for 20ns; 
            wait;
        end process stim_proc;

end Behavioral;
