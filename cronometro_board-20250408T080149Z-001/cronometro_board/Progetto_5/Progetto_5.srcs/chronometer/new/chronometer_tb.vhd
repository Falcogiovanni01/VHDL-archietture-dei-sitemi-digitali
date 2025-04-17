----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 17:13:26
-- Design Name: 
-- Module Name: chronometer_tb - chronometer
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chronometer_tb is
--  Port ( );
end chronometer_tb;

architecture chronometer of chronometer_tb is

    component chronometer is
        Port ( 
            clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            set_sec : in STD_LOGIC;
            set_min : in STD_LOGIC;
            set_hour : in STD_LOGIC;
            in_sec : in STD_LOGIC_VECTOR (5 downto 0);
            in_min : in STD_LOGIC_VECTOR (5 downto 0);
            in_hour : in STD_LOGIC_VECTOR (4 downto 0);
            out_sec : out STD_LOGIC_VECTOR (5 downto 0);
            out_min : out STD_LOGIC_VECTOR (5 downto 0);
            out_hour : out STD_LOGIC_VECTOR (4 downto 0));
    end component;

    signal set_secondi  : STD_LOGIC := '0';
    signal set_minuti   : STD_LOGIC := '0';
    signal set_ore      : STD_LOGIC := '0';
    signal value_secondi: STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
    signal value_minuti : STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
    signal value_ore    : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
    signal reset_e      : STD_LOGIC := '0';
    signal clock        : STD_LOGIC := '0';
    signal secondi      : STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
    signal minuti       : STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
    signal ore          : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');

    signal recoded_chrono : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
    
  --recoded_chrono(31 downto 28) <= (others => '0');
  --recoded_chrono(27 downto 24) <= (others => '0');
    recoded_chrono(23 downto 20) <= std_logic_vector(resize((unsigned(ore) / 10),4));
    recoded_chrono(19 downto 16) <= std_logic_vector(resize((unsigned(ore) mod 10),4));
    recoded_chrono(15 downto 12) <= std_logic_vector(resize((unsigned(minuti) / 10),4));
    recoded_chrono(11 downto 8) <= std_logic_vector(resize((unsigned(minuti) mod 10),4));
    recoded_chrono(7 downto 4) <= std_logic_vector(resize((unsigned(secondi) / 10),4));
    recoded_chrono(3 downto 0) <= std_logic_vector(resize((unsigned(secondi) mod 10),4));


    utt: chronometer port map(
        set_sec => set_secondi,
        set_min => set_minuti,
        set_hour => set_ore,
        in_sec => value_secondi,
        in_min => value_minuti,
        in_hour => value_ore,
        reset => reset_e,
        clock => clock,
        out_sec => secondi,
        out_min => minuti,
        out_hour => ore);
    
    clock_p : process
        begin
            clock <= NOT clock;
            wait for 0.5 ns;
        end process;
        
    main : process 
        begin
            
            value_secondi <= "010111";
            value_minuti <= "000110";
            value_ore <= "01010";
            wait for 40 ns;
            set_secondi <= '0';
            set_minuti <= '0';
            set_ore <= '0';
            wait for 100 ns;
            
            value_secondi <= "011111";
            value_minuti <= "001110";
            value_ore <= "01110";
            wait for 40 ns;
            set_secondi <= '1';
            set_minuti <= '1';
            set_ore <= '1';
            wait for 100 ns;
            set_secondi <= '0';
            set_minuti <= '0';
            set_ore <= '0';
            wait for 100 ns;

            reset_e <= '1';   
            wait for 100 ns;
            reset_e <= '0';
            wait;

            
        end process;
    
end chronometer;
