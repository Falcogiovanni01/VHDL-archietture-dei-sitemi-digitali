----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2025 11:36:04
-- Design Name: 
-- Module Name: Cronometro_sim - Behavioral
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

entity Cronometro_sim is
end Cronometro_sim;

architecture Behavioral of Cronometro_sim is
component Cronometro is
    port(
        I_HMS : in STD_LOGIC_VECTOR(5 DOWNTO 0);
        EN_C : in STD_LOGIC;
        SET_HMS : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        CLK_C : in STD_LOGIC;
        RST_C : in STD_LOGIC;
        DIV_C : out STD_LOGIC;
        Y : out STD_LOGIC_VECTOR(16 DOWNTO 0)
    );
end component;

signal I_sim : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal EN_sim : STD_LOGIC := '0';
signal SET_sim: STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
signal CLK_sim : STD_LOGIC := '0';
signal RST_sim : STD_LOGIC := '0';
signal DIV_sim : STD_LOGIC := '0';
signal Y_sim : STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');

constant CLK_PERIOD : time := 10 ns;

begin
    uut: Cronometro
    Port map(
        I_HMS => I_sim,
        EN_C => EN_sim,
        SET_HMS => SET_sim,
        CLK_C => CLK_sim,
        RST_C => RST_sim,
        DIV_C => DIV_sim,
        Y => Y_sim
    );
 
    clk_process: process
        begin
            CLK_sim <= '0';
            wait for CLK_PERIOD/2;
            CLK_sim <= '1';
            wait for CLK_PERIOD/2;
    end process clk_process;
 
--    stim_proc: process
--        begin
--            wait for 100 ns;
--            SET_sim <= "000";
--            RST_sim <= '1';
--            wait for 10 ns;
--            RST_sim <= '0';
--            wait for 10 ns; 
--            EN_sim <= '1';
--            wait for 10ns;
--            wait;
--    end process stim_proc;
    
    stim_proc: process
        begin
            wait for 20ns;
            RST_sim <= '1';
            wait for 10ns;
            RST_sim <= '0';
            wait for 10ns;
            I_sim <= "111011";
            SET_sim <= "010";
            wait for 10ns;
            SET_sim <= "000";
            wait for 10ns;
            EN_sim <= '1';
            wait for 10ns;
            wait;
    end process stim_proc;

--    stim_proc: process
--    begin
--        wait for 20ns;
--        RST_sim <= '1';
--        wait for 10ns;
--        RST_sim <= '0';
--        wait for 10ns;
--        I_sim <= "111011";
--        SET_sim <= "010";
--        wait for 10ns;
--        I_sim <= "010111";
--        SET_sim <= "100";
--        wait for 10ns;
--        SET_sim <= "000";
--        wait for 10ns;
--        EN_sim <= '1';
--        wait for 10ns;
--        wait;
--    end process stim_proc;


end Behavioral;

