library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 16:1 MUX
entity Mux16_1 is
    Port ( I : in  STD_LOGIC_VECTOR (0 to 15);  -- 16 inputs
           S0 : in STD_LOGIC;  -- Selection inputs
           S1 : in STD_LOGIC;
           S2 : in STD_LOGIC;
           S3 : in STD_LOGIC;
           Y : out STD_LOGIC);
end Mux16_1;

architecture Structural of Mux16_1 is

    -- Component declaration for 4:1 MUX
    component MUX4_1 is
        port ( 
            A0 : in STD_LOGIC;
            A1 : in STD_LOGIC;
            A2 : in STD_LOGIC;
            A3 : in STD_LOGIC;
            S0 : in STD_LOGIC;
            S1 : in STD_LOGIC;
            Y : out STD_LOGIC);
    end component; 

    -- Signals to connect the outputs of the 4:1 MUXes
    signal mux1, mux2, mux3, mux4 : STD_LOGIC; 

begin
    -- First level of 4:1 MUXes
    MUX_4_1_1 : MUX4_1 port map (
        A0 => I(0),
        A1 => I(1),
        A2 => I(2),
        A3 => I(3),
        S0 => S0,
        S1 => S1,
        Y => mux1
    );

    MUX_4_1_2 : MUX4_1 port map (
        A0 => I(4),
        A1 => I(5),
        A2 => I(6),
        A3 => I(7),
        S0 => S0,
        S1 => S1,
        Y => mux2
    );

    MUX_4_1_3 : MUX4_1 port map (
        A0 => I(8),
        A1 => I(9),
        A2 => I(10),
        A3 => I(11),
        S0 => S0,
        S1 => S1,
        Y => mux3
    );

    MUX_4_1_4 : MUX4_1 port map (
        A0 => I(12),
        A1 => I(13),
        A2 => I(14),
        A3 => I(15),
        S0 => S0,
        S1 => S1,
        Y => mux4
    );

    -- Second level of 4:1 MUX to combine the results
    MUX_4_1_5 : MUX4_1 port map (
        A0 => mux1,
        A1 => mux2,
        A2 => mux3,
        A3 => mux4,
        S0 => S2,
        S1 => S3,
        Y => Y
    );

end Structural;
