library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_bench_system_B is
end test_bench_system_B;

architecture Behavioral of test_bench_system_B is

    -- Dichiarazione dei segnali
    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';
   -- signal     : std_logic := '0';  -- Aggiunto il segnale di start
    signal req      : std_logic := '0';
    signal ack      : std_logic := '0';
    signal output_b : std_logic_vector(3 downto 0);
    signal data_A : std_logic_vector(3 downto 0);
        -- Generazione del clock (per esempio, periodico)
    constant clk_period : time := 20 ns;
    -- Istanziamento dell'unità da testare (System B)
    component B is
        Port (
         req     : in STD_LOGIC;                                 -- segnale di richiesta invio proveniente dal sistema A
        clock   : in STD_LOGIC;                                 -- segnale di clock del sistema B
        reset   : in STD_LOGIC;                                 -- segnale di reset del sistema B
        data_A  : in STD_LOGIC_VECTOR (3 downto 0);             -- elemento proveniente dalla ROM del sistema A
        ack     : out STD_LOGIC;                                -- segnale di ack che deve essere inviato al sistema A
        output_b: out STD_LOGIC_VECTOR(3 downto 0)
    
        );
    end component;

begin
    -- Istanziamento dell'unità B
    UUT: B
        Port map ( 
            req => req,
            reset => reset,
            clock => clock,
            data_A => data_A,
            ack => ack,
            output_b => output_b
        );

    -- Generazione del clock
    clk_process: process
    begin
        while (true) loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimoli per il testbench
    stim_proc: process
    begin
        -- Test 1: Invia il valore 1
        reset <= '1';    -- Attiva il reset
        req <= '0';    -- Assicura che start sia 0 all'inizio
        wait for 20 ns;
        reset <= '0';    -- Disattiva il reset
       -- start <= '1';    -- Attiva il segnale start per avviare il sistema
        req <= '1';      -- Invia la richiesta per il test
        wait for 20 ns;
     
        data_A <= "0010";
        wait for 40 ns; 
        req <= '0';      -- Termina la richiesta
        wait for 40 ns;  -- Aspetta un po' per osservare l'output
      
       
     
         -- Test 2: Invia il valore 0001
          
        req <= '0';      -- Assicura che la richiesta sia 0 all'inizio
        wait for 20 ns;
          
        req <= '1';      -- Invia la richiesta per il test
        wait for 30 ns;
        data_A <= "0001"; -- Valore 0001 da inviare
        wait for 20 ns;
        req <= '0';      -- Termina la richiesta
        wait for 40 ns;  -- Aspetta un po' per osservare l'output
    
        -- Termina la simulazione
        wait;
    end process;

end Behavioral;
