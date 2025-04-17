library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Unità operativa del moltiplicatore di Booth
-- Implementa la parte datapath dell'algoritmo di moltiplicazione
ENTITY unita_operativa IS
    PORT (
        multiplicand, multiplier : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Operandi di ingresso
        clock, reset : IN STD_LOGIC;                                -- Segnali di sincronizzazione
        load_result, enable_shift, load_multiplicand, subtract_op, select_input, enable_count : IN STD_LOGIC; -- Segnali di controllo
        iteration_count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);         -- Contatore delle iterazioni
        product : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)                 -- Risultato della moltiplicazione
    );
END unita_operativa;

ARCHITECTURE structural OF unita_operativa IS

    COMPONENT adder_sub IS
        PORT (
        operand_a, operand_b : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
        operation_sel : IN STD_LOGIC;                            
        result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);               
        carry_out : OUT STD_LOGIC                                
    );

    END COMPONENT;

    COMPONENT registro8 IS
        PORT (
        data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);         
        clock, reset, enable : IN STD_LOGIC;              
        data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)       
    );

    END COMPONENT;

    COMPONENT mux_21 IS
            GENERIC (
        width : INTEGER RANGE 0 TO 17 := 8 
    );
    PORT (
        input_0, input_1 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);  
        select_input : IN STD_LOGIC;                                 
        output : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)           
    );

    END COMPONENT;
    
    COMPONENT shift_register IS
        PORT (
        data_load : IN STD_LOGIC_VECTOR(16 DOWNTO 0);     
        shift_in : IN STD_LOGIC;                          
        clock, reset, enable_load, enable_shift : IN STD_LOGIC;  
        data_out : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)       
    );

    END COMPONENT;

--component FFD is
--port( clock, reset, d: in std_logic;
--y: out std_logic);
--end component;

    COMPONENT cont_mod8 IS
        PORT (
        clk, rst : IN STD_LOGIC;                   
        enable_count : IN STD_LOGIC;               
        counter_value : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

    END COMPONENT;

    -- Segnali interni per l'interconnessione dei componenti
    SIGNAL stored_multiplicand : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Valore del moltiplicando memorizzato
    SIGNAL initial_reg_value : STD_LOGIC_VECTOR(16 DOWNTO 0);  -- Valore iniziale per il registro A.Q
    SIGNAL reg_input : STD_LOGIC_VECTOR(16 DOWNTO 0);          -- Ingresso del registro A.Q
    SIGNAL reg_output : STD_LOGIC_VECTOR(16 DOWNTO 0);         -- Uscita del registro A.Q
    SIGNAL adder_result : STD_LOGIC_VECTOR(7 DOWNTO 0);        -- Risultato dell'operazione di somma/sottrazione
    
    SIGNAL updated_reg_value : STD_LOGIC_VECTOR(16 DOWNTO 0);  -- Valore aggiornato dopo la somma/sottrazione
    SIGNAL carry_out : STD_LOGIC;                              -- Riporto in uscita dell'adder (non utilizzato)
    SIGNAL shift_in_bit : STD_LOGIC;                           -- Bit di ingresso per lo shift
    
BEGIN

    -- 1) Memorizzazione del moltiplicando in un registro
    M_REG : registro8 PORT MAP(multiplier, clock, reset, load_multiplicand, stored_multiplicand);

    -- 2) Preparazione dei valori per il registro A.Q
    
    -- Valore iniziale: 8 bit a 0 + moltiplicando + 1 bit a 0
    initial_reg_value <= "00000000" & multiplicand & "0";
    
    -- Valore aggiornato dopo la somma/sottrazione: risultato dell'adder + parte bassa del registro
    updated_reg_value <= adder_result & reg_output(8 DOWNTO 0);

    -- Multiplexer per selezionare l'ingresso del registro A.Q
    MUX_REG_INPUT : mux_21 GENERIC MAP(width => 17) PORT MAP(initial_reg_value, updated_reg_value, select_input, reg_input);
    
    -- 3) Gestione dell'ingresso seriale per lo shift aritmetico
    shift_in_bit <= reg_output(16);  -- Replica del bit più significativo (shift aritmetico)

    -- 4) Registro A.Q per memorizzare il risultato parziale
    SHIFT_REG : shift_register PORT MAP(reg_input, shift_in_bit, clock, reset, load_result, enable_shift, reg_output);
    
    -- 5) Sommatore/sottrattore per le operazioni aritmetiche
    ARITHMETIC_UNIT : adder_sub PORT MAP(reg_output(16 DOWNTO 9), stored_multiplicand, subtract_op, adder_result, carry_out);

    -- 6) Contatore per tenere traccia delle iterazioni
    ITERATION_COUNTER : cont_mod8 PORT MAP(clock, reset, enable_count, iteration_count);

    -- 7) Assegnazione dell'uscita
    product <= reg_output;

END structural;