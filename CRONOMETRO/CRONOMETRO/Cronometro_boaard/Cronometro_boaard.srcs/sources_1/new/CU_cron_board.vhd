----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:21:47
-- Design Name: 
-- Module Name: CU_cron_board - Behavioral
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

entity ControlUnit is
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
end ControlUnit; 

architecture Behavioral of ControlUnit is
type stato is (SET_H, SET_M, SET_S, START);

signal stato_corr : stato := SET_H;
signal input_cr_tmp : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal set_hms_cr_tmp : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
signal enable_cr_tmp : STD_LOGIC := '0';
signal enable_display_tmp : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
signal rst_cr_tmp : STD_LOGIC := '0';

begin

    proc : process(CLK_CU)
        begin
            if(rising_edge(CLK_CU)) then
                if(BTN_2 = '1') then
                    set_hms_cr_tmp <= "000";
                    stato_corr <= SET_H;
                    rst_cr_tmp <= '1';
                    enable_display_tmp <= (others => '0');
                else
                    rst_cr_tmp <= '0';
                case stato_corr is
                    when SET_H =>
                        if(BTN_1 = '1') then
                            input_cr_tmp <= SWITCH_IN; 
                            set_hms_cr_tmp <= "100";
                            stato_corr <= SET_M;
                        end if;
                    
                    when SET_M =>
                        set_hms_cr_tmp <= "000";
                        if(BTN_1 = '1') then
                            input_cr_tmp <= SWITCH_IN;
                            set_hms_cr_tmp <= "010";
                            stato_corr <= SET_S;
                        end if;
                    
                    when SET_S =>
                        set_hms_cr_tmp <= "000";
                        if(BTN_1 = '1') then
                            input_cr_tmp <= SWITCH_IN;
                            set_hms_cr_tmp <= "001";
                            stato_corr <= START;
                        end if;
                    
                    when START =>
                        set_hms_cr_tmp <= "000";
                        enable_cr_tmp <= '1';
                        enable_display_tmp <= "00111111";
                        stato_corr <=START;
                end case;
                end if;
            end if;
       end process;

INPUT_CR <= input_cr_tmp;
SET_HMS_CR <= set_hms_cr_tmp;
EN_CR <= enable_cr_tmp;
EN_DISPLAY <= enable_display_tmp;
RST_CR <= rst_cr_tmp;

end Behavioral;
