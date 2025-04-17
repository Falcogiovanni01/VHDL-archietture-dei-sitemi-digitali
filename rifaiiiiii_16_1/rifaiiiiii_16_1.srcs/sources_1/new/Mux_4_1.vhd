library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 4:1 MUX
entity Mux4_1 is
    Port ( A0 : in STD_LOGIC;
           A1 : in STD_LOGIC;
           A2 : in STD_LOGIC;
           A3 : in STD_LOGIC;
           S0 : in STD_LOGIC;
           S1 : in STD_LOGIC;
           Y : out STD_LOGIC);
end Mux4_1;

architecture Structural of Mux4_1 is

    -- Declare the 2:1 MUX component
    component MUX_2_1 is
        Port(
            A : in STD_LOGIC; 
            B : in STD_LOGIC; 
            S : in STD_LOGIC; 
            Y : out STD_LOGIC
        );
    end component;

    -- Signals to connect intermediate MUXes
    signal mux0_out, mux1_out : STD_LOGIC;

begin
    -- First level of 2:1 MUXes
    MUX0: MUX_2_1 port map (
        A => A0,  -- Input A0 to MUX0
        B => A1,  -- Input A1 to MUX0
        S => S0,  -- Selection input S0 for MUX0
        Y => mux0_out  -- Output of the first 2:1 MUX
    );
  
    MUX1: MUX_2_1 port map(
        A => A2,  -- Input A2 to MUX1
        B => A3,  -- Input A3 to MUX1
        S => S0,  -- Selection input S0 for MUX1
        Y => mux1_out  -- Output of the second 2:1 MUX
    );
  
    -- Second level of 2:1 MUXes to select between mux0_out and mux1_out based on S1
    MUX2: MUX_2_1 port map(
        A => mux0_out,  -- Output of the first MUX
        B => mux1_out,  -- Output of the second MUX
        S => S1,  -- Selection input S1 for MUX2
        Y => Y  -- Final output Y
    );

end Structural;
