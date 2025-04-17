library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

-- Full Adder a 1 bit
-- Somma due bit di ingresso più un riporto in ingresso
ENTITY full_adder IS
    PORT (
        input_a, input_b : IN STD_LOGIC;           -- Bit di ingresso da sommare
        carry_in : IN STD_LOGIC;                   -- Riporto in ingresso
        carry_out, sum : OUT STD_LOGIC             -- Riporto in uscita e risultato della somma
    );
END full_adder;
ARCHITECTURE rtl OF full_adder IS

BEGIN
    -- Calcolo del bit di somma usando XOR a tre ingressi
    sum <= input_a XOR input_b XOR carry_in;
    
    -- Calcolo del riporto in uscita
    -- Si ha riporto quando almeno due degli ingressi sono a 1
    carry_out <= (input_a AND input_b) OR (carry_in AND (input_a XOR input_b));

END rtl;