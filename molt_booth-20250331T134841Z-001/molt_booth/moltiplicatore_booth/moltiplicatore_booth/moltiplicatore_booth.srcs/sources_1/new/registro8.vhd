library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Registro a 8 bit con reset sincrono e segnale di caricamento
ENTITY registro8 IS
    PORT (
        data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);         -- Dati in ingresso
        clock, reset, enable : IN STD_LOGIC;               -- Segnali di controllo
        data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)        -- Dati in uscita
    );
END registro8;

ARCHITECTURE behavioural OF registro8 IS
    SIGNAL internal_value : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Valore memorizzato internamente
BEGIN

    -- Processo di aggiornamento del registro sincronizzato sul fronte di salita del clock
    register_process : PROCESS (clock)
    BEGIN
        IF (clock'event AND clock = '1') THEN
            IF (reset = '1') THEN
                -- Reset sincrono: azzera il contenuto del registro
                internal_value <= (OTHERS => '0');
            ELSE
                IF (enable = '1') THEN
                    -- Caricamento del nuovo valore quando enable è attivo
                    internal_value <= data_in;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    -- Assegnazione del valore interno all'uscita
    data_out <= internal_value;
END behavioural;