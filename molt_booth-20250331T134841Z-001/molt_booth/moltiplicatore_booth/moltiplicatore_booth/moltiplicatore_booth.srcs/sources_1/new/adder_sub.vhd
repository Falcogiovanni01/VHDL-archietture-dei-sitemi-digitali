library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entità che implementa un sommatore/sottrattore a 8 bit
-- Quando cin = 0: Z = X + Y
-- Quando cin = 1: Z = X - Y (complemento a 2)
ENTITY adder_sub IS
    PORT (
        operand_a, operand_b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Operandi di ingresso
        operation_sel : IN STD_LOGIC;                            -- Selezione operazione: 0=somma, 1=sottrazione
        result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);               -- Risultato dell'operazione
        carry_out : OUT STD_LOGIC                                -- Riporto in uscita
    );
END adder_sub;

ARCHITECTURE structural OF adder_sub IS
    COMPONENT ripple_carry IS
        PORT (
            X, Y : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            c_in : IN STD_LOGIC;
            c_out : OUT STD_LOGIC;
            Z : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

    -- Segnale per memorizzare il complemento del secondo operando
    SIGNAL inverted_operand : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    
    -- Generazione del complemento a 1 di operand_b quando operation_sel = 1
    -- Lascia operand_b invariato quando operation_sel = 0
    complemento_operand : FOR i IN 0 TO 7 GENERATE
        inverted_operand(i) <= operand_b(i) XOR operation_sel;
    END GENERATE;
    
    -- Istanziazione del sommatore a propagazione di riporto
    -- operation_sel viene usato anche come carry in iniziale per completare
    -- l'operazione di complemento a 2 in caso di sottrazione
    adder : ripple_carry PORT MAP(operand_a, inverted_operand, operation_sel, carry_out, result);
    
END structural;