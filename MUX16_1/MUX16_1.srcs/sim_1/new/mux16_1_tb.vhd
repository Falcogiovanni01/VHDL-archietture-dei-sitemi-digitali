library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the testbench
entity mux16_1_tb is
end mux16_1_tb;

architecture behavior of mux16_1_tb is

    -- Component declaration for the MUX16_1
    component Mux16_1 is
        Port ( I : in  STD_LOGIC_VECTOR (0 to 15);  -- 16 ingressi
               S0 : in STD_LOGIC;                  -- Ingressi di selezione
               S1 : in STD_LOGIC;
               S2 : in STD_LOGIC;
               S3 : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    -- Signals to connect to the MUX16_1
    signal I : STD_LOGIC_VECTOR (0 to 15); -- 16 ingressi
    signal S0, S1, S2, S3 : STD_LOGIC;    -- Selettori
    signal Y : STD_LOGIC;                  -- Uscita

begin

    -- Instantiate the MUX16_1 component
    uut: Mux16_1 port map (
        I => I,
        S0 => S0,
        S1 => S1,
        S2 => S2,
        S3 => S3,
        Y => Y
    );

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1: Selezionare l'ingresso I(0) quando S0=0, S1=0, S2=0, S3=0
        I <= (others => '0'); -- inizializzazione di tutti gli ingressi a '0'
        S0 <= '0';
        S1 <= '0';
        S2 <= '0';
        S3 <= '0';
        wait for 10 ns; -- attende 10 ns

        -- Test case 2: Selezionare l'ingresso I(1) quando S0=1, S1=0, S2=0, S3=0
        I(0) <= '1'; -- Impostiamo I(0) a '1'
        I(1) <= '0'; -- Impostiamo I(1) a '0'
        S0 <= '1';
        S1 <= '0';
        S2 <= '0';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 3: Selezionare l'ingresso I(2) quando S0=0, S1=1, S2=0, S3=0
        I(0) <= '0'; -- Impostiamo I(0) a '0'
        I(2) <= '1'; -- Impostiamo I(2) a '1'
        S0 <= '0';
        S1 <= '1';
        S2 <= '0';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 4: Selezionare l'ingresso I(3) quando S0=1, S1=1, S2=0, S3=0
        I(2) <= '0'; -- Impostiamo I(2) a '0'
        I(3) <= '1'; -- Impostiamo I(3) a '1'
        S0 <= '1';
        S1 <= '1';
        S2 <= '0';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 5: Selezionare l'ingresso I(4) quando S0=0, S1=0, S2=1, S3=0
        I(3) <= '0'; -- Impostiamo I(3) a '0'
        I(4) <= '1'; -- Impostiamo I(4) a '1'
        S0 <= '0';
        S1 <= '0';
        S2 <= '1';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 6: Selezionare l'ingresso I(5) quando S0=1, S1=0, S2=1, S3=0
        I(4) <= '0'; -- Impostiamo I(4) a '0'
        I(5) <= '1'; -- Impostiamo I(5) a '1'
        S0 <= '1';
        S1 <= '0';
        S2 <= '1';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 7: Selezionare l'ingresso I(6) quando S0=0, S1=1, S2=1, S3=0
        I(5) <= '0'; -- Impostiamo I(5) a '0'
        I(6) <= '1'; -- Impostiamo I(6) a '1'
        S0 <= '0';
        S1 <= '1';
        S2 <= '1';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 8: Selezionare l'ingresso I(7) quando S0=1, S1=1, S2=1, S3=0
        I(6) <= '0'; -- Impostiamo I(6) a '0'
        I(7) <= '1'; -- Impostiamo I(7) a '1'
        S0 <= '1';
        S1 <= '1';
        S2 <= '1';
        S3 <= '0';
        wait for 10 ns;

        -- Test case 9: Selezionare l'ingresso I(8) quando S0=0, S1=0, S2=0, S3=1
        I(7) <= '0'; -- Impostiamo I(7) a '0'
        I(8) <= '1'; -- Impostiamo I(8) a '1'
        S0 <= '0';
        S1 <= '0';
        S2 <= '0';
        S3 <= '1';
        wait for 10 ns;

        -- Test case 10: Selezionare l'ingresso I(15) quando S0=1, S1=1, S2=1, S3=1
        I(8) <= '0'; -- Impostiamo I(8) a '0'
        I(15) <= '1'; -- Impostiamo I(15) a '1'
        S0 <= '1';
        S1 <= '1';
        S2 <= '1';
        S3 <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;
end behavior;
