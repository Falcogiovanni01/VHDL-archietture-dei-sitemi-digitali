library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Sorgenti_Destinazioni is
end tb_Sorgenti_Destinazioni;

architecture behavior of tb_Sorgenti_Destinazioni is

    -- Componenti del DUT
    component Sorgenti_Destinazioni is
        Port ( 
            I : in STD_LOGIC_VECTOR (0 to 15);  -- 16 sorgenti
            S0 : in STD_LOGIC;  -- Selezione per MUX
            S1 : in STD_LOGIC;
            S2 : in STD_LOGIC;
            S3 : in STD_LOGIC;
            S4 : in STD_LOGIC; 
            S5 : in STD_LOGIC; 
            D: out STD_LOGIC_VECTOR (0 to 3)  -- 4 destinazioni
        );
    end component;

    -- Segnali per il testbench
    signal I : STD_LOGIC_VECTOR (0 to 15);
    signal S0, S1, S2, S3, S4 ,S5: STD_LOGIC;
    signal D : STD_LOGIC_VECTOR (0 to 3);

begin

    -- Istanza del DUT (Device Under Test)
    uut: Sorgenti_Destinazioni
        port map (
            I => I,
            S0 => S0,
            S1 => S1,
            S2 => S2,
            S3 => S3,
            S4 => S4,
            S5 => S5,
            D => D
        );

    -- Stimolo (Generazione delle vettoriali e delle selezioni)
    process
    begin
    wait for 500 ns; 
        -- Inizializzazione delle sorgenti (I) con valori distinti per testare le selezioni
     I <= "1110000100101100"; 
     S0 <= '1';
     S1 <= '1';
     S2 <= '1'; 
     S3 <= '0';
     S4 <= '0';
     S5 <= '0';     
        -- Terminazione del processo di simulazione
        -- 1111000000000000 ( S0 = 1 , S1, S2 S3 = 0 E s4 E s4 = 0 
    
    wait for 10 ns;
    
     I <= "1110000000000000";  -- MUX 0 
     S0 <= '0'; -- 00
     S1 <= '0';
     S2 <= '0'; 
     S3 <= '0';
     S4 <= '0';
     S5 <= '0';    
    wait for 10 ns;
            --    
     I <= "0000111100000000";  -- MUX 1
     S0 <= '0'; -- 00
     S1 <= '1';
     S2 <= '0'; 
     S3 <= '1';
     S4 <= '0';
     S5 <= '1';    
    wait for 10 ns;
    
     I <= "0000111100000000";  -- errore
     S0 <= '0'; -- 00
     S1 <= '0';
     S2 <= '0'; 
     S3 <= '0';
     S4 <= '1';
     S5 <= '0';    
     wait for 10 ns;
    
        
   I <= "0000000011110000";  -- MUX 2
    S0 <= '1';  -- Seleziona MUX 2
    S1 <= '0';
    S2 <= '1'; 
    S3 <= '0';
    S4 <= '1'; 
    S5 <= '0'; 

	wait for 10 ns;
	  I <= "0000000000001111";  -- MUX3
     S0 <= '1'; -- 00
     S1 <= '1';
     S2 <= '1'; 
     S3 <= '1';
     S4 <= '1';
     S5 <= '1';    
        wait;
    end process;

end behavior;
