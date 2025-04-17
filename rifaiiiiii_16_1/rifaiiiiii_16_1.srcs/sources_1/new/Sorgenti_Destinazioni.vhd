library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sorgenti_Destinazioni is
    Port ( 
        I : in STD_LOGIC_VECTOR (0 to 15);  -- 16 sorgenti
        S0 : in STD_LOGIC;  -- Selezione per MUX
        S1 : in STD_LOGIC;
        S2 : in STD_LOGIC;
        S3 : in STD_LOGIC;
        --
        S4 : in STD_LOGIC; 
        S5: in STD_LOGIC;
        D: out STD_LOGIC_VECTOR (0 to 3)  -- 4 destinazioni
    );
end Sorgenti_Destinazioni;

architecture Behavioral of Sorgenti_Destinazioni is

    -- Componenti
    component MUX16_1 is
        Port ( 
            I : in STD_LOGIC_VECTOR (0 to 15);  -- 16 ingressi
            S0 : in STD_LOGIC;
            S1 : in STD_LOGIC;
            S2 : in STD_LOGIC;
            S3 : in STD_LOGIC;
            Y : out STD_LOGIC
        );
    end component;

    component Demux1_4 is
        Port (
            A : in STD_LOGIC;
            Y : out STD_LOGIC_VECTOR (0 to 3);
            S1 : in STD_LOGIC;
            S2 : in STD_LOGIC
        );
    end component;

    -- Segnale intermedio
    signal mux_out : STD_LOGIC:='0';

begin

    -- Istanza del MUX16_1 per selezionare una delle 16 sorgenti
    MUX_1 : MUX16_1 
        port map (
            I => I,           -- Collegamento delle 16 sorgenti
            S0 => S0,         -- Selezione S0
            S1 => S1,         -- Selezione S1
            S2 => S2,         -- Selezione S2
            S3 => S3,         -- Selezione S3
            Y => mux_out      -- Uscita del MUX
        );

    -- Istanza del DEMUX1_4 per distribuire l'uscita a 4 destinazioni
    DEMUX_1 : Demux1_4
        port map (
            A => mux_out,     -- Uscita dal MUX
            Y => D, -- Collegamento alle 4 destinazioni
            S1 => S4,         -- Selezione per DEMUX
            S2 => S5          -- Selezione per DEMUX
        );

end Behavioral;
