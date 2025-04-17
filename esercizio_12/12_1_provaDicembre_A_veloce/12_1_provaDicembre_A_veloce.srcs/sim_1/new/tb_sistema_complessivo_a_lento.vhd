library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_sistema_complessivo is
end tb_sistema_complessivo;

architecture Behavioral of tb_sistema_complessivo is

    -- Component under test (CUT)
    component sistema_complessivo
        Port (
            CLK_A : in STD_LOGIC;
            CLK_B : in STD_LOGIC;
            RST : in STD_LOGIC;
            start : in STD_LOGIC;
            output_finale : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Testbench signals
    signal CLK_A_tb : STD_LOGIC := '0';
    signal CLK_B_tb : STD_LOGIC := '0';
    signal RST_tb : STD_LOGIC := '1';
    signal start_tb : STD_LOGIC := '0';
    signal output_finale_tb : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock periods
    constant CLK_A_PERIOD : time := 10 ns;  -- CLK_A piu' veloce
    constant CLK_B_PERIOD : time := 25 ns;  -- CLK_B piu' lento

begin
    
    -- Instanza del sistema complessivo
    CUT : sistema_complessivo
        port map (
            CLK_A => CLK_A_tb,
            CLK_B => CLK_B_tb,
            RST => RST_tb,
            start => start_tb,
            output_finale => output_finale_tb
        );
    
    -- Processo per generare CLK_A
    process
    begin
        while true loop
            CLK_A_tb <= '0';
            wait for CLK_A_PERIOD / 2;
            CLK_A_tb <= '1';
            wait for CLK_A_PERIOD / 2;
        end loop;
    end process;
    
    -- Processo per generare CLK_B
    process
    begin
        while true loop
            CLK_B_tb <= '0';
            wait for CLK_B_PERIOD / 2;
            CLK_B_tb <= '1';
            wait for CLK_B_PERIOD / 2;
        end loop;
    end process;
    
    -- Stimuli process
    process
    begin
        -- Reset iniziale
        RST_tb <= '1';
        wait for 50 ns;
        RST_tb <= '0';
        
        -- Avvio del sistema
        wait for 20 ns;
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        
        -- Simulazione in esecuzione per un po'
        wait for 500 ns;
        
        -- Fine simulazione
        wait;
    end process;
    
end Behavioral;
