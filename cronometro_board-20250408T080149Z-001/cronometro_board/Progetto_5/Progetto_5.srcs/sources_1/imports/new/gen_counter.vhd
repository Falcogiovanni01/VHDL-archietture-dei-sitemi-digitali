----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2024 16:13:31
-- Design Name: 
-- Module Name: gen_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity gen_counter is
    generic(
            size   : natural; -- Numero di bit usati
            module : natural  -- Modulo (deve essere minore o uguale di 2^size)
    );
    port ( clock   : in  STD_LOGIC; -- Segnale di clock
           reset   : in  STD_LOGIC; -- Segnale di reset
           enable  : in  STD_LOGIC; -- Segnale di abilitazione
           set     : in  STD_LOGIC; -- Permette di settare un valore stabilito
           value   : in  STD_LOGIC_VECTOR(size-1 downto 0); -- Valore stabilito
           counter : out STD_LOGIC_VECTOR(size-1 downto 0)); -- Dato del counter in uscita
end gen_counter;

architecture Behavioral of gen_counter is

    signal c : std_logic_vector (size-1 downto 0) := (others => '0'); -- Segnale temporaneo di conteggio

begin

    counter <= c; -- Sovrascrittura dell'uscita

    counter_process: process(clock)
        begin    
            -- Operazione tempificata dal clock
            if rising_edge(clock) then   
                -- Operazione di Set: si sovrascrive l'attuale conteggio con un valore prefissato
                if (set = '1') then
                    if (unsigned(value) < module) then -- Il valore deve essere in range, però
                        c <= value;
                    end if;
                -- Operazione di Reset: si sovrascrive l'attuale conteggio con 0
                elsif (reset = '1') then
                    c <= (others => '0');
                -- Operazione di Conteggio: si incrementa il contatore
                elsif (enable = '1') then
                    -- Se si raggiunge il modulo si ricomincia da 0, altrimenti si prosegue
                    if (unsigned(c) = module-1) then
                        c <= (others => '0');
                    else 
                        c <= std_logic_vector(unsigned(c) + 1);
                    end if;
                end if;
            end if;
        end process;

end Behavioral;