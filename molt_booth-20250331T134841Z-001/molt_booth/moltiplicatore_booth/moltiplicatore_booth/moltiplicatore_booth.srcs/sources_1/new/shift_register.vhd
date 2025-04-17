library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Registro a scorrimento a 17 bit con caricamento parallelo e scorrimento a destra
-- Utilizzato nell'algoritmo di Booth per gestire i registri A e Q
ENTITY shift_register IS
    PORT (
        data_load : IN STD_LOGIC_VECTOR(16 DOWNTO 0);      -- Dati da caricare in parallelo
        shift_in : IN STD_LOGIC;                           -- Bit di ingresso per lo scorrimento
        clock, reset, enable_load, enable_shift : IN STD_LOGIC;  -- Segnali di controllo
        data_out : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)       -- Contenuto del registro
    );
END shift_register;

ARCHITECTURE behavioural OF shift_register IS

    SIGNAL register_value : STD_LOGIC_VECTOR(16 DOWNTO 0); -- Valore corrente memorizzato nel registro

BEGIN

    -- Processo di aggiornamento del registro sincronizzato sul fronte di salita del clock
    shift_process : PROCESS (clock)
    BEGIN
        IF (clock'event AND clock = '1') THEN
            IF (reset = '1') THEN
                -- Reset sincrono: azzera il contenuto del registro
                register_value <= (OTHERS => '0');
            ELSE
                IF (enable_load = '1') THEN --caricamento iniziale del moltiplicatore
                    -- Caricamento parallelo dei dati
                    register_value <= data_load;
                ELSIF (enable_shift = '1') THEN
                    -- Scorrimento a destra: tutti i bit si spostano di una posizione
                    -- e il nuovo bit più significativo viene preso dall'ingresso seriale
                    register_value(15 DOWNTO 0) <= register_value(16 DOWNTO 1);
                    register_value(16) <= shift_in;
                END IF;
            END IF;

        END IF;
    END PROCESS;

    -- Assegnazione del valore interno all'uscita
    data_out <= register_value;
END behavioural;