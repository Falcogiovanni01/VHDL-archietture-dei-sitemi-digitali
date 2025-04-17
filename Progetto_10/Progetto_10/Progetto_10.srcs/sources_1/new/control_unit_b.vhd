----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2024 11:51:36
-- Design Name: 
-- Module Name: control_unit_b - Behavioral
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

entity control_unit_b is
    Port (  RDA: in STD_LOGIC; -- Segnale di lettura disponibile
            OE: in STD_LOGIC; -- Errore di overrun
            PE: in STD_LOGIC; -- Errore di parità
            FE : in STD_LOGIC; -- Errore di framing
            clock : in STD_LOGIC; -- Clock di sistema
            reset : in STD_LOGIC; -- Reset di sistema
            c_enable : out STD_LOGIC; -- Abilitatore del counter
            RD : out STD_LOGIC; -- Segnale di conferma lettura del dato
            write : out STD_LOGIC; -- Abilitazione al salvataggio del dato
            error : out STD_LOGIC); -- Segnalazione degli errori
end control_unit_b;

architecture Behavioral of control_unit_b is

    type state is (idle,verify,error_report,wait_ending);
    signal current_state: state := idle;
    signal next_state : state;

begin

    transizione_stato : process (clock, RDA, OE, PE, FE, current_state)
    begin
        
        case current_state is
        
            -- Fase di idle: la macchina si avvia quando riceve un segnale di ricevimento dati (ossia se RDA è alto)
            when idle => 
                if (RDA = '1') then next_state <= verify;
                else next_state <= idle;
                end if; 
        
            -- Fase di verifica degli errori
            when verify => 
                if (OE = '1' or PE = '1' or FE = '1') then next_state <= error_report;
                else next_state <= wait_ending;
                end if; 
                
           -- Fase di eventuale output dell'errore
            when error_report =>
                if (RDA = '1') then 
                    next_state <= wait_ending;
                else
                    next_state <= idle;
                end if;                
                    
            -- Fase di attesa che RDA si abbassi e si ritorni all'idle
            when wait_ending => 
                if (RDA = '1') then 
                    next_state <= wait_ending;
                else
                    next_state <= idle;
                end if;    
                            
        end case;
    end process;
    
    
    stato_uscita : process (clock)
    begin
        case next_state is
            when idle =>
                c_enable <= '0';
                write <= '0';
                RD <= '0';
                error <= '0';
            when verify =>
                c_enable <= '1';
                write <= '1';
                RD <= '1';
                error <= '0';
            when error_report =>
                c_enable <= '0';
                write <= '0';
                RD <= '0';
                error <= '1';
            when wait_ending =>
                c_enable <= '0';
                write <= '0';
                RD <= '0';
                error <= '0';
               end case;
               end process;
               
                
    
    -- Tempificazione degli stati
    CLKP : process (clock,reset)
    begin
        if (rising_edge(clock)) then
            if (reset = '0') then
                current_state <= next_state;
            else
                current_state <= idle;
            end if;
        end if;
    end process;  

end Behavioral;
