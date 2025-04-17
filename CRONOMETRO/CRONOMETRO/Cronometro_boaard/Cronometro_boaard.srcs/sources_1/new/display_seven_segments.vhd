----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:30:15
-- Design Name: 
-- Module Name: display_seven_segments - Behavioral
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

entity display_seven_segments is 
    generic(  
        CLKIN_freq : integer := 100000000;  
        CLKOUT_freq : integer := 500);
    port(
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        VALUE : in  STD_LOGIC_VECTOR (31 DOWNTO 0);
        ENABLE : in  STD_LOGIC_VECTOR (7 DOWNTO 0);  
        DOTS : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
        ANODES : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
        CATHODES : out  STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
end display_seven_segments;

architecture Structural of display_seven_segments is

signal counter : STD_LOGIC_VECTOR(2 downto 0); 
signal clock_filter_out : STD_LOGIC := '0';

component counter_mod8 
    port(
        clock : in  STD_LOGIC; 
        reset : in  STD_LOGIC; 
        enable : in STD_LOGIC; 
        counter : out  STD_LOGIC_VECTOR (2 DOWNTO 0) 
    ); 
end component;

component cathodes_manager
    port(
        counter : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
        value : in STD_LOGIC_VECTOR(31 DOWNTO 0); 
        dots : in STD_LOGIC_VECTOR(7 DOWNTO 0);           
        cathodes : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component; 

component anodes_manager
    port(
        counter : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
        enable_digit : in STD_LOGIC_VECTOR(7 DOWNTO 0);           
        anodes : out STD_LOGIC_VECTOR(7 DOWNTO 0) 
    ); 
end component; 

component clock_filter
    generic(
        clock_frequency_in : integer := 100000000; 
        clock_frequency_out : integer := 500);
    port(
        clock_in : in STD_LOGIC;
        reset : in STD_LOGIC;     
        clock_out : out STD_LOGIC 
    ); 
end component;

begin 

    clk_filter : clock_filter
        Generic map(
            clock_frequency_in => CLKIN_freq, 
            clock_frequency_out => CLKOUT_freq 
        )
        Port map(
            clock_in => CLK,
            reset => RST,
            clock_out => clock_filter_out
        );
        
    counter_instance : counter_mod8
        Port map(
            clock => CLK,
            enable => clock_filter_out,
            reset => RST,
            counter => counter
        );
    
    cathodes_instance : cathodes_manager
        Port map( 
            counter => counter,
            value => value,
            dots => dots,
            cathodes => cathodes
        );
    
    anodes_instance : anodes_manager
        Port map( 
            counter => counter,
            enable_digit => enable,
            anodes => anodes
        ); 

end Structural;