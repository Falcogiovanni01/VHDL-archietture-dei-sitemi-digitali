LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_ROM_N_8 IS
END TB_ROM_N_8;

ARCHITECTURE behavior OF TB_ROM_N_8 IS 

    -- Component della ROM da testare
    COMPONENT ROM_N_8
        GENERIC(
            len_add : positive := 3
        );
        PORT(
            CLK_rom : IN std_logic;
            address : IN std_logic_vector(len_add - 1 DOWNTO 0);
            read    : IN std_logic;
            dout    : OUT std_logic_vector(3 DOWNTO 0)
        );
    END COMPONENT;

    -- Segnali di test
    SIGNAL CLK_rom  : std_logic := '0';
    SIGNAL address  : std_logic_vector(2 DOWNTO 0) := "000";
    SIGNAL read     : std_logic := '0';
    SIGNAL dout     : std_logic_vector(3 DOWNTO 0);

    -- Clock period definitions
    CONSTANT clk_period : time := 10 ns;

BEGIN

    -- Instanzia la ROM
    uut: ROM_N_8 
        PORT MAP (
            CLK_rom => CLK_rom,
            address => address,
            read    => read,
            dout    => dout
        );

    -- Processo per generare il clock
    clk_process: process
    begin
        while now < 200 ns loop
            CLK_rom <= '0';
            wait for clk_period / 2;
            CLK_rom <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo di test manuale
    stim_proc: process
    begin        
        wait for 20 ns;  -- Attende per stabilità iniziale

        read <= '1';  -- Abilita la lettura
        
        -- Settaggio manuale degli indirizzi con attesa
        address <= "000"; wait for clk_period;
        address <= "001"; wait for clk_period;
        address <= "010"; wait for clk_period;
        address <= "011"; wait for clk_period;
        address <= "100"; wait for clk_period;
        address <= "101"; wait for clk_period;
        address <= "110"; wait for clk_period;
        address <= "111"; wait for clk_period;

        read <= '0';  -- Disabilita lettura
        wait for clk_period;

        -- Fine simulazione
        wait;
    end process;

END behavior;
