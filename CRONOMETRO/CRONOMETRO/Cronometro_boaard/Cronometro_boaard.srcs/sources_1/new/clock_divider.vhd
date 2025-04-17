----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:36:02
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider is
    generic(
        clock_frequency_in : in integer := 100000000;
        clock_frequency_out : in integer := 1);
    port(
        CLK_IN : in STD_LOGIC;
        CLK_OUT : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is

signal clk_tmp : STD_LOGIC := '0';
signal counter : integer := 0;
constant count_max_value : integer := (clock_frequency_in/clock_frequency_out) - 1;

begin
    
    process(CLK_IN)
        begin
            if rising_edge(CLK_IN) then
                counter <= counter + 1;
            if(counter = 49999999) then
                clk_tmp <= NOT clk_tmp; -- 
                counter <= 0; -- resetto il contatore
            end if; 
            end if; 
        CLK_OUT <= clk_tmp;
    end process;

end Behavioral;