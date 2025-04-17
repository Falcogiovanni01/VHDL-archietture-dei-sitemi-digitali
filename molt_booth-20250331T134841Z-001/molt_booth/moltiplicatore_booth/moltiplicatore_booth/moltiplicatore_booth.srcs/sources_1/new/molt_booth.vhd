library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Moltiplicatore di Booth per numeri a 8 bit con segno
-- Implementa l'algoritmo di Booth per la moltiplicazione binaria
ENTITY molt_booth IS
    PORT (
        clock, reset, start : IN STD_LOGIC;                -- Segnali di controllo
        multiplicand, multiplier : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Operandi di ingresso
--stop: out std_logic; --a che serve?
        product : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);       -- Risultato della moltiplicazione
        operation_complete : OUT STD_LOGIC                 -- Segnale di completamento operazione
    );
END molt_booth;

ARCHITECTURE structural OF molt_booth IS
    COMPONENT unita_controllo IS
        PORT (
        booth_bits : IN STD_LOGIC_VECTOR(1 DOWNTO 0);     
        clock, reset, start : IN STD_LOGIC;               
        iteration_count : IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
        load_multiplicand, enable_count, load_result, enable_shift : OUT STD_LOGIC;  
        select_addsub, perform_subtract, operation_done : OUT STD_LOGIC              
    );

    END COMPONENT;

    COMPONENT unita_operativa IS
        PORT (
        multiplicand, multiplier : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
        clock, reset : IN STD_LOGIC;                                
        load_result, enable_shift, load_multiplicand, subtract_op, select_input, enable_count : IN STD_LOGIC; 
        iteration_count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);        
        product : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)                
    );

    END COMPONENT;

    -- Segnali di interconnessione tra unità di controllo e unità operativa
    SIGNAL lsb_bits : STD_LOGIC_VECTOR(1 DOWNTO 0);        -- Bit meno significativi per l'algoritmo di Booth
    SIGNAL ctrl_select_aq, ctrl_subtract, ctrl_load_aq : STD_LOGIC;
    SIGNAL ctrl_clock : STD_LOGIC;
    
    SIGNAL counter_value : STD_LOGIC_VECTOR(2 DOWNTO 0);   -- Contatore per tracciare le iterazioni
    SIGNAL internal_product : STD_LOGIC_VECTOR(16 DOWNTO 0); -- Risultato interno (include bit extra)
    SIGNAL enable_count, load_adder : STD_LOGIC;
    SIGNAL count_complete : STD_LOGIC;
    SIGNAL enable_shift : STD_LOGIC;
    SIGNAL load_multiplicand : STD_LOGIC;
    SIGNAL process_done : STD_LOGIC;                       -- Segnale di completamento interno
    SIGNAL reset_to_uo : STD_LOGIC;                        -- Segnale di reset per l'unità operativa
    
BEGIN
    -- Istanziazione dell'unità di controllo
    -- Gestisce la sequenza delle operazioni dell'algoritmo di Booth
    UC : unita_controllo PORT MAP
    (
        lsb_bits, clock, reset, start,
        counter_value,
        load_multiplicand, enable_count, ctrl_load_aq, enable_shift,
        ctrl_select_aq, ctrl_subtract, process_done
    );

    -- Istanziazione dell'unità operativa
    -- Esegue le operazioni aritmetiche e di shift richieste dall'algoritmo
    UO : unita_operativa PORT MAP
    (
        multiplicand, multiplier, clock, reset, ctrl_load_aq, enable_shift, load_multiplicand,
        ctrl_subtract, ctrl_select_aq, enable_count, counter_value, internal_product
    );

    -- Connessione dei segnali tra le unità
    lsb_bits <= internal_product(1 DOWNTO 0); -- Invio all'unità di controllo i due bit meno significativi del registro A.Q
    product <= internal_product(16 DOWNTO 1); -- Estrazione del risultato finale
    
    -- la UO viene resettata sia se arriva un reset dall'esterno sia se l'operazione di moltiplicazione termina
-- reset_to_uo <= reset or process_done;

    operation_complete <= process_done;
END structural;

