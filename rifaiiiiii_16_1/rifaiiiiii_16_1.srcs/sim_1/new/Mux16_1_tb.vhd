library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench for the 16:1 MUX
entity Mux16_1_tb is
end Mux16_1_tb;

architecture behavior of Mux16_1_tb is

    -- Component declaration for the MUX16_1
    component Mux16_1 is
        Port ( I : in  STD_LOGIC_VECTOR (0 to 15);  -- 16 inputs
               S0 : in STD_LOGIC;  -- Selection inputs
               S1 : in STD_LOGIC;
               S2 : in STD_LOGIC;
               S3 : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    -- Signals for the inputs and outputs of the MUX
    signal I : STD_LOGIC_VECTOR (0 to 15); -- 16 inputs
    signal S0, S1, S2, S3 : STD_LOGIC;    -- Selection signals
    signal Y : STD_LOGIC;                  -- Output signal

begin

    -- Instantiate the Mux16_1
    uut: Mux16_1 port map (
        I => I,
        S0 => S0,
        S1 => S1,
        S2 => S2,
        S3 => S3,
        Y => Y
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Select input I(0)
        I <= "1111000000000000";           -- Set input 0 to '1'
        S0 <= '0'; S1 <= '0'; S2 <= '0'; S3 <= '0';  -- Select input I(0)
        wait for 10 ns;        -- Wait for 10 ns

        -- Test case 2: Select input I(1)
      -- Test case 2: Select input I(5) (mux2)
        I <= "0000111100000000";           -- Set input 5 to '1'
        S0 <= '0'; S1 <= '1'; S2 <= '0'; S3 <= '1';  -- Select input I(5)
        wait for 10 ns;
        
        -- Test case 3: Select input I(10) (mux3)
        I <= "0000000011110000";           -- Set input 10 to '1'
        S0 <= '1'; S1 <= '0'; S2 <= '1'; S3 <= '0';  -- Select input I(10)
      
        wait for 10 ns;

        -- Test case 4: Select input I(3)
      I <= "0000000000001111";           -- Set input 0 to '1'
       
        S0 <= '1'; S1 <= '1'; S2 <= '1'; S3 <= '1';  -- Select input I(3)
        wait for 10 ns;


        -- End the simulation
        wait;
    end process;

end behavior;
