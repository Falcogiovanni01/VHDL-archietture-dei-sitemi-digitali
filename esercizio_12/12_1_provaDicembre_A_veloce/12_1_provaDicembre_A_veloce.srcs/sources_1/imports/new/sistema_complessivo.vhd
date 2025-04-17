library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sistema_complessivo is
    Port (
        CLK_A : in STD_LOGIC; -- clock sistema A
        CLK_B : in STD_LOGIC; -- clock sistema B
        RST : in STD_LOGIC; -- segnale di reset
        start : in STD_LOGIC; -- segnale di start
        output_finale : out STD_LOGIC_VECTOR(3 downto 0) -- somma calcolata, contenuta nel registro R
    );
end sistema_complessivo;

architecture Structural of sistema_complessivo is

    component sistema_a
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            start : in STD_LOGIC;
            ack : in STD_LOGIC;
            req : out STD_LOGIC;
            dato : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component sistema_b
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            req : in STD_LOGIC;
            ack : out STD_LOGIC;
            output_finale : out STD_LOGIC_VECTOR(3 downto 0);
            dato : in STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- segnali interni per l'interconnessione tra sistema_a e sistema_b
    signal req_signal : STD_LOGIC;
    signal ack_signal : STD_LOGIC;
    signal dato_signal : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Istanza del sistema_a
    inst_SISTEMA_A : sistema_a
        port map (
            CLK => CLK_A,
            RST => RST,
            start => start,
            ack => ack_signal,
            req => req_signal,
            dato => dato_signal
        );

    -- Istanza del sistema_b
    inst_SISTEMA_B : sistema_b
        port map (
            CLK => CLK_B,
            RST => RST,
            req => req_signal,
            ack => ack_signal,
            output_finale => output_finale,
            dato => dato_signal
        );

end Structural;