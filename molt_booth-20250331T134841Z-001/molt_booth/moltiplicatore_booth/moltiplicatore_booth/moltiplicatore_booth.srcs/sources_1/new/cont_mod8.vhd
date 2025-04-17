library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Contatore modulo 8 (conta da 0 a 7)
-- Incrementa il valore quando enable_count è attivo
ENTITY cont_mod8 IS
    PORT (
        clk, rst : IN STD_LOGIC;                    -- Segnale di clock e reset
        enable_count : IN STD_LOGIC;                -- Abilita il conteggio quando alto
        counter_value : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)  -- Valore corrente del contatore (3 bit)
    );
END cont_mod8;

ARCHITECTURE behavioural OF cont_mod8 IS
    -- Registro interno per memorizzare il valore corrente del contatore
    SIGNAL current_count : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

BEGIN
    -- Processo di conteggio sincronizzato sul fronte di salita del clock
    counter_process : PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            -- Reset asincrono: azzera il contatore
            IF (rst = '1') THEN
                current_count <= (OTHERS => '0');
            ELSE
                -- Incrementa il contatore solo quando enable_count è attivo
                IF (enable_count = '1') THEN
                    current_count <= STD_LOGIC_VECTOR(unsigned(current_count) + 1);
-- c <= c + "111"; posso fare direttamente questa somma se importo IEEE.std_logic_unsigned.ALL
-- preferibile non farlo perché sono package non standard
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Assegna il valore interno all'uscita
    counter_value <= current_count;

END behavioural;