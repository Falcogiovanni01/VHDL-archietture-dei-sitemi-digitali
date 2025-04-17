library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Testbench per il moltiplicatore di Booth
ENTITY mbooth_tb IS
END mbooth_tb;

ARCHITECTURE behavioural OF mbooth_tb IS
    COMPONENT molt_booth IS
        PORT (
        clock, reset, start : IN STD_LOGIC;                
        multiplicand, multiplier : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
        product : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);      
        operation_complete : OUT STD_LOGIC                
    );

    END COMPONENT;

    -- Definizione del periodo di clock per la simulazione
    CONSTANT clk_period : TIME := 20 ns;

    -- Segnali per gli operandi di ingresso e il risultato
    SIGNAL multiplicand, multiplier : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL product : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    -- Segnali di controllo
    SIGNAL clock_sig, reset_sig, start_sig : STD_LOGIC;
    SIGNAL operation_done : STD_LOGIC;
    
    -- Segnale per terminare la simulazione
    SIGNAL end_simulation : STD_LOGIC := '0';

BEGIN
    -- Istanziazione del componente da testare (Unit Under Test)
    uut : molt_booth PORT MAP(clock_sig, reset_sig, start_sig, multiplicand, multiplier, product, operation_done);

    -- Processo per la generazione del clock
    clk_process : PROCESS
    BEGIN
        WHILE (end_simulation = '0') LOOP
            clock_sig <= '1';
            WAIT FOR clk_period/2;
            clock_sig <= '0';
            WAIT FOR clk_period/2;
        END LOOP;
        WAIT;
    END PROCESS;

-- SIMULARE PER 9000 NS

    -- Processo principale di simulazione
    sim : PROCESS

    BEGIN

        WAIT FOR 100 ns;

        -- Reset iniziale del sistema
        reset_sig <= '1';
        WAIT FOR 20 ns;

        reset_sig <= '0';

-- ------------------------------------- operazione numero 1:

-- 15*3=45 (002D)

        -- Impostazione dei valori per la prima moltiplicazione: 15 * 3
        multiplicand <= "00000010";  -- 15 in binario 00001111, lo sostituisco con 1
        multiplier <= "00000010";    -- 3 in binario

-- start deve essere visto da clk_div: poiché sarà generato dal button debouncer si aggiungerà anche il clk_div

-- al button debouncer e il segnale di start deve durare quanto il periodo del clk rallentato

        WAIT FOR 40 ns;

        -- Avvio della moltiplicazione
        start_sig <= '1';

        WAIT FOR 20 ns;

        start_sig <= '0';

        -- Attesa per il completamento dell'operazione
        WAIT FOR 600 ns;

        -- Reset del sistema per la prossima operazione
        reset_sig <= '1';
        WAIT FOR 20 ns;

        reset_sig <= '0';

-- ------------------------------------- operazione numero 2:

-- 15*(-3)=-45 (0053)

        -- Impostazione dei valori per la seconda moltiplicazione: 15 * (-3)
        multiplicand <= "00001111";  -- 15 in binario
        multiplier <= "11111101";    -- -3 in complemento a 2

        WAIT FOR 40 ns;

        -- Avvio della moltiplicazione
        start_sig <= '1';

        WAIT FOR 20 ns;

        start_sig <= '0';

        WAIT;

    END PROCESS;
END behavioural;