----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2024 15:31:22
-- Design Name: 
-- Module Name: shift_register_structural_tb - shift_register
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
use work.all;

entity destro_sinistro_1 is
end destro_sinistro_1;

architecture shift_register_structural of destro_sinistro_1 is

    signal input : STD_LOGIC := '0';
    signal data : STD_LOGIC_VECTOR (5-1 downto 0) := "00000";
    signal output : STD_LOGIC_VECTOR (5-1 downto 0) := (others => '0');
    signal direction : STD_LOGIC := '0';
    signal length : STD_LOGIC := '0';
    signal clock : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    
    constant clock_period : TIME := 10 ns;

begin

    utt : entity work.shift_register(behavioral) generic map(Size => 5)
        port map(
            data_in => data,
            value_in => input,
            load => load,
            clock => clock,
            shift_en => enable,
            direction => direction,
            length => length,
            data_out => output);

    time_proc : process
        begin
            clock <= NOT (clock);
            wait for clock_period/2;
            clock <= NOT (clock);
            wait for clock_period/2;
        end process;
    
    main : process 
begin 
    -- 1. Caricamento iniziale del valore "1000"
    load <= '1'; 
    data <= "00001"; 
    wait for 20 ns;
    
    load <= '0'; -- Disabilita il caricamento
    wait for 20 ns;

    -- 2. Inizia lo shift a destra (bit si sposta a destra a ogni ciclo)
    enable <= '1';  -- Abilita lo shift
    direction <= '1';  -- '0' = shift a destra
    length <= '0';     -- Shift di 1 posizione per volta
    wait for 20 ns;

    -- Prima transizione: 1000 ? 0100
    enable <= '1'; 
    wait for 20 ns;
    enable <= '0'; 
    wait for 20 ns;

    -- Seconda transizione: 0100 ? 0010
    enable <= '1'; 
    wait for 20 ns;
    enable <= '0'; 
    wait for 20 ns;

    -- Terza transizione: 0010 ? 0001
    enable <= '1'; 
    wait for 20 ns;
    enable <= '0'; 
    wait for 20 ns;

    -- Test completato
    wait;
end process;

end shift_register_structural;
