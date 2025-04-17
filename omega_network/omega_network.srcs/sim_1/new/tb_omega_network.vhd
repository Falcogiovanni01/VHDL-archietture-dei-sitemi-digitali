LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_omega_network IS
END tb_omega_network;

ARCHITECTURE behavior OF tb_omega_network IS 

    COMPONENT omega_network
    PORT(
        data_in_0  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_in_1  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_in_2  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_in_3  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        src        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        dst        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out_0 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out_1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out_2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out_3 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Signals
    SIGNAL in_0, in_1, in_2, in_3 : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL src  : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (others => '0');  -- inizializzazione
    SIGNAL dst  : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (others => '0');  -- inizializzazione
    SIGNAL out_0, out_1, out_2, out_3 : STD_LOGIC_VECTOR(1 DOWNTO 0)  ;
    
BEGIN
    -- Instantiate the omega network
    uut: omega_network PORT MAP (
        data_in_0 => in_0,
        data_in_1 => in_1,
        data_in_2 => in_2,
        data_in_3 => in_3,
        src => src,
        dst => dst,
        data_out_0 =>out_0,
        data_out_1 =>out_1,
        data_out_2 =>out_2,
        data_out_3 =>out_3
    );
    
    -- Stimulus process
    stim_proc: PROCESS
    BEGIN    
        -- Set initial values for inputs
        in_0 <= "00";  -- Input 0
        in_1 <= "01";  -- Input 1
        in_2 <= "10";  -- Input 2
        in_3 <= "11";  -- Input 3
     
        -- Wait 10 ns before making the first input change
        wait for 10 ns; 
        
        -- Test case 1: Set source and destination to 00, expected output = data_in_0 to data_out_0
        src <= "00";  -- Source = 00
        dst <= "00";  -- Destination = 00
        -- DATA OUT_0 DEVE ESSERE ALTO
        wait for 20 ns;
        
        -- Test case 2: Set source to 01 and destination to 00, expected output = data_in_1 to data_out_1
        src <= "01";  -- Source = 01
        dst <= "00";  -- Destination = 00
        wait for 20 ns;
        
        -- Test case 3: Set source to 00 and destination to 01, expected output = data_in_0 to data_out_0
        src <= "00";  -- Source = 00
        dst <= "01";  -- Destination = 01
        wait for 20 ns;
        
        -- Test case 4: Set source to 10 and destination to 01, expected output = data_in_2 to data_out_2
        src <= "10";  -- Source = 10
        dst <= "01";  -- Destination = 01
        wait for 10 ns;
        
        -- Test case 5: Set source to 11 and destination to 10, expected output = data_in_3 to data_out_3
        src <= "11";  -- Source = 11
        dst <= "10";  -- Destination = 10
        wait for 20 ns;
        
        --
        wait for 20 ns; 
        
        src <= "10"; 
        dst <= "11"; 
        wait for 20ns; 
        wait for 20ns ; 
        src <= "00"; 
        dst <= "10" ; 
        



        -- End of stimulus process
        wait;
    END PROCESS;
END behavior;
