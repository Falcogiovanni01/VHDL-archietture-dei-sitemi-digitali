----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:17:25
-- Design Name: 
-- Module Name: Cronometro_bd - Behavioral
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

entity Cronometro_board is
    port(
        CLK : in STD_LOGIC; 
        BTN_1 : in STD_LOGIC; 
        BTN_2 : in STD_LOGIC; 
        INPUT_SWITCH : in STD_LOGIC_VECTOR(5 DOWNTO 0); 
        ANODES : out STD_LOGIC_VECTOR(7 DOWNTO 0);
        CATHODES : out STD_LOGIC_VECTOR(7 DOWNTO 0)     
       );
        
end Cronometro_board;

architecture Structural of Cronometro_board is

signal btn_1_out_tmp : STD_LOGIC := '0';
signal btn_2_out_tmp : STD_LOGIC := '0';
signal rst_cr_tmp : STD_LOGIC := '0';
signal enable_cr_tmp : STD_LOGIC := '0';
signal set_hms_cr_tmp : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
signal input_hms_cr_tmp : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal clock_1Hz_tmp : STD_LOGIC := '0';
signal enable_display_tmp : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
signal out_tmp : STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');
signal value_tmp : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

component Cronometro
    port(
        I_CRN : in std_logic_vector(5 DOWNTO 0);
        EN_CRN : in std_logic;
        SET_CRN : in std_logic_vector(2 DOWNTO 0);
        RST_CRN : in std_logic;
        CLK_CRN : in std_logic;
        DIV_CRN : out std_logic;
        OUTPUT : out std_logic_vector(16 DOWNTO 0) 
    );
end component;

component ControlUnit
    port(
        CLK_CU: in STD_LOGIC;
        BTN_1 : in STD_LOGIC;
        BTN_2 : in STD_LOGIC;
        SWITCH_IN : in STD_LOGIC_VECTOR(5 DOWNTO 0);
        RST_CR: out STD_LOGIC;
        SET_HMS_CR : out STD_LOGIC_VECTOR(2 DOWNTO 0);
        INPUT_CR : out STD_LOGIC_VECTOR(5 DOWNTO 0);
        EN_DISPLAY : out STD_LOGIC_VECTOR(7 DOWNTO 0);
        EN_CR : out STD_LOGIC
    );
end component;

component display_seven_segments
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
end component;

component ButtonDebouncer
    generic(           
        CLK_period : integer := 10;  -- periodo del clock (in ns)
        btn_noise_time : integer := 10000000 -- durata dell'oscillazione (in ns)
     ); 
    port(
       CLK : in STD_LOGIC;
       RST : in STD_LOGIC;
       BTN : in STD_LOGIC;
       CLEARED_BTN : out STD_LOGIC
    );
end component;

component Conv_Dec_Bin
    generic(N : integer := 6; -- numero di bit del numero binario di input
            M : integer := 2 -- numero di cifre decimali risultanti
    );
    port(
        CLK : in STD_LOGIC;
        input : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        output : out STD_LOGIC_VECTOR(4*M - 1 DOWNTO 0)
    );
end component;

component clock_divider
    generic(
        clock_frequency_in : in integer := 100000000;
        clock_frequency_out : in integer := 1);
    port(
        CLK_IN : in STD_LOGIC;
        CLK_OUT : out STD_LOGIC
    );
end component;

begin

    CRONOM : Cronometro
        Port map(
            I_CRN => input_hms_cr_tmp,
            EN_CRN => enable_cr_tmp,
            SET_CRN => set_hms_cr_tmp,
            CLK_CRN => clock_1Hz_tmp,
            RST_CRN => rst_cr_tmp,
            OUTPUT => out_tmp
        );
    
    CU : ControlUnit
        Port map(
            CLK_CU => CLK,
            BTN_1 => btn_1_out_tmp,
            BTN_2 => btn_2_out_tmp,
            SWITCH_IN => INPUT_SWITCH,
            RST_CR => rst_cr_tmp,
            SET_HMS_CR => set_hms_cr_tmp,
            INPUT_CR => input_hms_cr_tmp,
            EN_DISPLAY => enable_display_tmp,
            EN_CR => enable_cr_tmp
        );

    BD1 : ButtonDebouncer
        Port map(
            CLK => CLK,
            RST => rst_cr_tmp,
            BTN => BTN_1,
            CLEARED_BTN => btn_1_out_tmp
        );
    
    BD2 : ButtonDebouncer
        Port map(
            CLK => CLK,
            RST => rst_cr_tmp,
            BTN => BTN_2,
            CLEARED_BTN => btn_2_out_tmp
        );
    
    DIS : display_seven_segments
        Port map(
            CLK => CLK,
            RST => rst_cr_tmp,
            VALUE => value_tmp,
            ENABLE => enable_display_tmp, 
            DOTS => "00010100", 
            ANODES => ANODES,
            CATHODES => CATHODES
        );
    
    DTB_S : Conv_Dec_Bin
        Generic map(6,2)
        Port map(
            CLK => CLK,
            input => out_tmp(5 DOWNTO 0),
            output => value_tmp(7 DOWNTO 0)
        );
    
    DTB_M : Conv_Dec_Bin
        Generic map(6,2)
        Port map(
            CLK => CLK,
            input => out_tmp(11 DOWNTO 6),
            output => value_tmp(15 DOWNTO 8)
        );
    
    DTB_H : Conv_Dec_Bin
        Generic map(5,2)
        Port map(
            CLK => CLK,
            input => out_tmp(16 DOWNTO 12),
            output => value_tmp(23 DOWNTO 16)
        );
    
    CLK_DIV_FREQ : clock_divider
        Port map(
            CLK_IN => CLK,
            CLK_OUT => clock_1Hz_tmp
        );
    
end Structural;