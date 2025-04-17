----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2025 11:52:22
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
PORT(
        B1 : IN STD_LOGIC;
        B2 : IN STD_LOGIC;
        S1 : IN STD_LOGIC; -- switch per D
        S2 : IN STD_LOGIC; -- switch per M
        CLK : IN STD_LOGIC;
        led: OUT STD_LOGIC

);end control_unit;

architecture Behavioral of control_unit is

COMPONENT ButtonDebouncer IS
GENERIC (
            CLK_period: integer := 10;
            btn_noise_time: integer := 10000000
);

PORT (  RST : in STD_LOGIC;
        CLK : in STD_LOGIC;
        BTN : in STD_LOGIC;
        CLEARED_BTN : out STD_LOGIC);

end COMPONENT;

COMPONENT ric_sequence is
   Port (
            M      : in  std_logic;  -- Modalità (0: non sovrapposte, 1: sovrapposte)
            a     : in  std_logic;  -- dato
            clk     : in  std_logic;
            rst : in std_logic; --segnale di reset
            --clock_frequency_in : integer := 50000000;
            --clock_frequency_out : integer := 500;
            load_m : in std_logic;
            load_a: in std_logic;
            y     : out std_logic   -- Segnale di uscita: alto se la sequenza 101 è riconosciuta
    );

end COMPONENT;

SIGNAL cleared_i : STD_LOGIC ;
SIGNAL cleared_m : STD_LOGIC;


begin
deb_i : ButtonDebouncer
PORT MAP(
            RST => '0',
            CLK => CLK,
            BTN => B1,
            CLEARED_BTN => cleared_i
);

deb_m : ButtonDebouncer
PORT MAP(
            RST => '0',
            CLK => CLK,
            BTN => B2,
            CLEARED_BTN => cleared_m
);

ric : ric_sequence
PORT MAP(
            M => S2,
            a => S1, 
            clk => CLK, 
            rst => '0',
            load_m => cleared_m,
            load_a => cleared_i,
            y => led

);

end Behavioral;
