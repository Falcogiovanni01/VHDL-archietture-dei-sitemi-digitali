----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 00:10:34
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

entity clock_divider is
	 generic(
        clock_frequency_in : integer := 100000000; -- Frequenza di Clock in ingresso: di default è quello della board (100MHz)
        clock_frequency_out : integer := 500); -- Frequenza di Clock in uscita: di default è 500Hz
    Port ( clock_in : in  STD_LOGIC; -- Clock in ingresso
		   reset : in STD_LOGIC; -- Segnale di reset
           clock_out : out  STD_LOGIC); -- Clock "rallentato" in uscita
end clock_divider;

architecture Behavioral of clock_divider is

signal clock_tmp: std_logic := '0'; -- Segnale temporaneo per l'Output

constant count_max_value : integer := (clock_frequency_in/clock_frequency_out)-1; -- Numero di cicli di clock in ingresso corrispondente ad uno in uscita

begin

    clock_out <= clock_tmp; -- Salvataggio dell'Output

    count_for_division: process(clock_in)
        variable counter : integer := 0; -- Definiamo una variabile di conteggio
        begin
            if rising_edge(clock_in) then
                -- Caso di reset: ripristiniamo conteggio e uscita
                if reset = '1' then
                    counter := 0;
                    clock_tmp <= '0';
                else
                    -- Caso in cui si è raggiunto il rapporto desiderato
                    if counter = count_max_value then
                        clock_tmp <=  '1'; -- Alziamo il clock in uscita
                        counter := 0; -- E resettiamo il contatore
                    else
                        clock_tmp <=  '0'; -- Manteniamo bassa l'uscita
                        counter := counter + 1; -- E incrementiamo il contatore
                    end if;
                end if;
            end if;
        
        end process;


end Behavioral;

