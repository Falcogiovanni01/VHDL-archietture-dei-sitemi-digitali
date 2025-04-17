library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

-- Multiplexer 2:1 con larghezza parametrizzabile
-- Seleziona uno dei due ingressi in base al segnale di selezione
ENTITY mux_21 IS
    GENERIC (
        width : INTEGER RANGE 0 TO 17 := 8  -- Larghezza parametrizzabile dei segnali
    );
    PORT (
        input_0, input_1 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);  -- Ingressi del multiplexer
        select_input : IN STD_LOGIC;                                 -- Segnale di selezione
        output : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)            -- Uscita selezionata
    );
END mux_21;

ARCHITECTURE rtl OF mux_21 IS

BEGIN
    -- Logica di selezione: 
    -- Se select_input = '0', seleziona input_0
    -- Se select_input = '1', seleziona input_1
    -- Altrimenti (caso non previsto), imposta l'uscita a zero
    output <= input_0 WHEN select_input = '0' ELSE
              input_1 WHEN select_input = '1' ELSE
              (OTHERS => '0');
END rtl;