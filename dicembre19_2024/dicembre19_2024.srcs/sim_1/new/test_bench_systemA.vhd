----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2025 13:52:08
-- Design Name: 
-- Module Name: test_bench_systemA - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_bench_systemA is
end test_bench_systemA;

architecture sim of test_bench_systemA is

    -- Signal per il collegamento al modulo A (sistema)
    signal start : std_logic := '0';
    signal reset : std_logic := '0';
    signal clock : std_logic := '0';
    signal output : std_logic_vector(3 downto 0):= (others=>'0');
   signal ack : std_logic := '0'; 
   signal req : std_logic := '0'; 
    -- Generazione del clock (per esempio, periodico)
    constant clk_period : time := 20 ns;
    
begin

    -- Instanzia il modulo A
    uut: entity work.A
    port map (
        start => start,
        reset => reset,
        clock => clock,
        req => req,
        output => output,
       ack => ack
    );

    -- Processo per la generazione del clock
    clk_gen: process
    begin
        while (true) loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Processo per stimolare il comportamento del design
    stim_proc: process
    begin
        -- Inizializzazione
        reset <= '1';
        start <= '0';
       ack <= '0'; 
        wait for 40 ns;

        -- Test: Reset del sistema
        reset <= '0';  -- disabilita il reset
        wait for 40 ns;
        
        -- Test: Attivazione del segnale di avvio
        start <= '1';
        wait for 100 ns;
        ack <= '1';  -- Fine del ciclo di avvio
        
        wait for 180 ns;
       ack<= '0';
        
        -- Simulazione di altre operazioni
        wait for 200 ns;

      
        wait;
    end process;

end sim;
