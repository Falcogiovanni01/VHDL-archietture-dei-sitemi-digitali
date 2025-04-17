library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Unità di controllo per il moltiplicatore di Booth
-- Gestisce la sequenza delle operazioni dell'algoritmo attraverso una macchina a stati finiti
ENTITY unita_controllo IS
    PORT (
        booth_bits : IN STD_LOGIC_VECTOR(1 DOWNTO 0);      -- Bit per la codifica di Booth (Q1,Q0)
        clock, reset, start : IN STD_LOGIC;                -- Segnali di controllo esterni
        iteration_count : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Contatore delle iterazioni
        load_multiplicand, enable_count, load_result, enable_shift : OUT STD_LOGIC;  -- Segnali di controllo
        select_addsub, perform_subtract, operation_done : OUT STD_LOGIC              -- Segnali di controllo
    );
END unita_controllo;

ARCHITECTURE Behavioral OF unita_controllo IS
    -- Stati della macchina a stati finiti
    TYPE state IS (idle, acquisisci_op, wait_sr, avvia_scan, avvia_shift, incr_count, fine);
    SIGNAL current_state, next_state : state;

BEGIN

--selM <= q0;-- in ogni istante la selezione del mux è data dal bit meno significativo di A.Q (q0)

-- Registro di stato: memorizza lo stato corrente della FSM
    reg_stato : PROCESS (clock)
    BEGIN
        IF (rising_edge(clock)) THEN
            IF (reset = '1') THEN
                current_state <= idle;  -- Reset: torna allo stato iniziale
            ELSE
                current_state <= next_state;  -- Aggiorna lo stato
            END IF;
        END IF;
    END PROCESS;
    
    -- Logica combinatoria: determina lo stato successivo e i segnali di uscita
    comb : PROCESS (current_state, start, iteration_count, booth_bits)
    BEGIN

-- Attenzione! questo process si attiva ogni volta che c'è una variazione nei segnali della sensitivity list
-- current_state e count per loro natura variano sempre in corrispodenza del fronte di salita del clock
-- start viene dall'esterno: se non varia (sale e scende) col fronte del clock, si potrebbe avere una situazione
-- in cui il next_state varia ma non ha modo da stabilizzarsi (perché current_state non è ancora variato)
-- quando il moltiplicatore sar? messo su board, START dovrà essere generato come uscita del button debouncer

        -- Inizializzazione dei segnali di controllo (valori di default)
        enable_count <= '0';
        perform_subtract <= '0';
        select_addsub <= '0';
        load_result <= '0';
        load_multiplicand <= '0';
        operation_done <= '0';
        enable_shift <= '0';

        CASE current_state IS

            WHEN idle =>
                -- Stato di attesa: aspetta il segnale di start
                IF (start = '1') THEN
                    next_state <= acquisisci_op;
                ELSE
                    next_state <= idle;
                END IF;
                
            WHEN acquisisci_op =>
                -- Acquisizione operandi: carica i valori nei registri
                load_multiplicand <= '1';  -- Carica il moltiplicando nel registro M
                load_result <= '1';        -- Carica il moltiplicatore nello shift register A.Q
                next_state <= wait_sr;

            WHEN wait_sr =>
                -- Stato di attesa per stabilizzazione dei registri
                next_state <= avvia_scan;

            WHEN avvia_scan =>
                -- Analisi dei bit di Booth per determinare l'operazione da eseguire
                IF (booth_bits = "01") THEN
                    -- Caso 01: Addizione (A = A + M)
                    select_addsub <= '1';
                    load_result <= '1';
                    next_state <= avvia_shift;
                ELSIF (booth_bits = "10") THEN
                    -- Caso 10: Sottrazione (A = A - M)
                    perform_subtract <= '1';
                    select_addsub <= '1';
                    load_result <= '1';
                    next_state <= avvia_shift;
                ELSIF (booth_bits = "00" OR booth_bits = "11") THEN
                    -- Casi 00 e 11: Nessuna operazione
                    next_state <= avvia_shift;
                END IF;

            WHEN avvia_shift =>
                -- Esecuzione dello shift aritmetico a destra
                enable_shift <= '1';

                -- Verifica se è l'ultima iterazione
                IF (iteration_count = "111") THEN
                    next_state <= fine;
                ELSE
                    next_state <= incr_count;
                END IF;

            WHEN incr_count =>
                -- Incremento del contatore delle iterazioni
                enable_count <= '1';
                next_state <= avvia_scan;

            WHEN fine =>
                -- Completamento dell'operazione
                operation_done <= '1';
                next_state <= idle;

        END CASE;

    END PROCESS;
END Behavioral;