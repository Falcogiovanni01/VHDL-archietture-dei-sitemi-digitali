library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ric_sequence_tb is
-- Entity vuota per il testbench
end ric_sequence_tb;

architecture Behavioral of ric_sequence_tb is
    -- Dichiarazione dei segnali per testare il modulo
    signal M            : std_logic := '0';
    signal a            : std_logic := '0';
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal load_m       : std_logic := '0';
    signal load_a       : std_logic := '0';
    signal y            : std_logic;

    constant clock_period : time := 10 ns; -- Periodo del clock (100 MHz)
    
begin
    -- Instanziare l'unità sotto test (UUT)
    uut: entity work.ric_sequence
        port map (
            M => M,
            a => a,
            clk => clk,
            rst => rst,
            load_m => load_m,
            load_a => load_a,
            y => y
        );

    -- Generazione del segnale di clock
    clk_process: process
    begin
        clk <= '0';
        wait for clock_period / 2;
        clk <= '1';
        wait for clock_period / 2;
    end process;

    -- Stimoli del testbench
    stim_proc: process
    begin
        -- Resetta il sistema
        rst <= '1';
        wait for clock_period;
        rst <= '0';
        wait for clock_period;

        -- Modalità 0 (sequenze non sovrapposte)
        M <= '0';
        load_m <= '1'; -- Abilita il caricamento della modalità
        wait for clock_period;
        load_m <= '0';
        wait for clock_period;

        -- Sequenza: 101 (non sovrapposta)
        a <= '1'; load_a <= '1'; wait for clock_period;
        a <= '0'; load_a <= '1'; wait for clock_period;
        a <= '1'; load_a <= '1'; wait for clock_period;
        load_a <= '0'; -- Pausa
        wait for clock_period;

        -- Sequenza: 010 (non valida)
        a <= '0'; load_a <= '1'; wait for clock_period;
        a <= '1'; load_a <= '1'; wait for clock_period;
        a <= '0'; load_a <= '1'; wait for clock_period;
        load_a <= '0'; -- Pausa
        wait for clock_period;
        
        rst <= '1';
        wait for clock_period;
        rst <= '0';
        wait for clock_period;

        -- Modalità 1 (sequenze sovrapposte)
        M <= '1';
        load_m <= '1'; -- Abilita il caricamento della modalità
        wait for clock_period;
        load_m <= '0';
        wait for clock_period;

        -- Sequenza: 101 (sovrapposta)
        a <= '1'; load_a <= '1'; wait for clock_period;
        a <= '0'; load_a <= '1'; wait for clock_period;
        a <= '1'; load_a <= '1'; wait for clock_period; -- `y` dovrebbe andare a '1'
        a <= '0'; load_a <= '1'; wait for clock_period; -- Inizia una nuova sequenza
        a <= '1'; load_a <= '1'; wait for clock_period; -- `y` dovrebbe andare di nuovo a '1'
        load_a <= '0'; -- Pausa
        wait for clock_period;

        -- Concludere il test
        wait;
    end process;

end Behavioral;