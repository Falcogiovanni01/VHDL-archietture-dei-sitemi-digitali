library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Sommatore a propagazione di riporto (Ripple Carry Adder) a 8 bit
-- Somma due operandi a 8 bit con riporto in ingresso
ENTITY ripple_carry IS
    PORT (
        X, Y : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Operandi di ingresso
        c_in : IN STD_LOGIC;                                 -- Riporto in ingresso
        c_out : OUT STD_LOGIC;                               -- Riporto in uscita
        Z : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)            -- Risultato della somma
    );
END ripple_carry;

ARCHITECTURE structural OF ripple_carry IS
    COMPONENT full_adder IS
       PORT (
        input_a, input_b : IN STD_LOGIC;           -- Bit di ingresso da sommare
        carry_in : IN STD_LOGIC;                   -- Riporto in ingresso
        carry_out, sum : OUT STD_LOGIC             -- Riporto in uscita e risultato della somma
    );
    END COMPONENT;

    -- Segnali interni per la propagazione del riporto tra i full adder
    SIGNAL internal_carry : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    -- Full adder per il bit meno significativo (bit 0)
    -- Utilizza il riporto in ingresso esterno
    FA0 : full_adder PORT MAP(X(0), Y(0), c_in, internal_carry(0), Z(0));

    -- Full adder per i bit intermedi (bit 1-6)
    -- Ogni full adder riceve il riporto dal full adder precedente
    FA1to6 : FOR i IN 1 TO 6 GENERATE
        FA : full_adder PORT MAP(X(i), Y(i), internal_carry(i - 1), internal_carry(i), Z(i));
    END GENERATE;

    -- Full adder per il bit più significativo (bit 7)
    -- Il riporto in uscita diventa il riporto in uscita dell'intero sommatore
    FA7 : full_adder PORT MAP(X(7), Y(7), internal_carry(6), c_out, Z(7));

END structural;