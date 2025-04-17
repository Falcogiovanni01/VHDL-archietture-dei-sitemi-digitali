
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sistemafinale_tb is
--  Port ( );
end sistemafinale_tb;

architecture Behavioral of sistemafinale_tb is
component sistemafinale is
    Port (
           output : out STD_LOGIC_VECTOR (0 to 7);
           clk : in STD_LOGIC;
           rst : in std_logic;
           read: in std_logic
           );
end component;
signal output: STD_LOGIC_VECTOR (0 to 7);

signal clk, rst,read: std_logic;
constant CLK_PERIOD: time := 1ns;

begin
    utt: sistemafinale port map(output => output, clk => clk, rst => rst, read => read);

    proc_clk: process
    begin
        clk <= '1';
        wait for CLK_PERIOD/2;
        clk <= '0';
        wait for CLK_PERIOD/2;
    end process;
    
    process
        begin
        rst<='1';
        wait for 5 ns;
        rst <= '0';
        wait for 700ns;
        read <= '1';
        wait for 2 ns;
        read <= '0';
        wait for 2 ns;
        read <= '1';
        wait for 2 ns;
        read <= '0';
        wait for 2 ns;
        read <= '1';
        wait for 2 ns;
        read <= '0';
        wait for 2ns;
        read <= '1';
        wait for 2 ns;
        read <= '0';
        wait;
        
        end process;
end Behavioral;