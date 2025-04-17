library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sistema_b is
    Port ( CLK : in STD_LOGIC; -- clock
           RST : in STD_LOGIC; -- reset
           req : in STD_LOGIC; -- segnale req
           ack : out STD_LOGIC; -- segnale ack
           output_finale : out std_logic_vector(3 downto 0); -- output del valore contenuto nel registro R, ovvero risultato della somma
           dato : in STD_LOGIC_VECTOR (3 downto 0) -- dato proveniente dal sistema A
     );
end sistema_b;

architecture Structural of sistema_b is

    component unita_controllo_b
        Port (
            CLK   : in  std_logic;
            RST   : in  std_logic;
            count : in std_logic_vector (2 downto 0); -- valore sommatore mod 8 per capire quanti dati devo ancora ricevere
            req : in std_logic;  -- req da parte di A per B
            
            ack  : out std_logic; -- ack di B per A
            en_c : out std_logic; -- abilita conteggio mod 8
            en_w_acc : out std_logic; -- abilita scrittura accumulatore
            en_write : out std_logic -- abilita scrittura registro finale
        );
    end component;

    component registro
        Port (
          CLK   : in std_logic;
          RST   : in std_logic;
          input : in std_logic_vector(3 downto 0);
          write : in std_logic;
          output: out std_logic_vector(3 downto 0)
         );
    end component;

    component counter
      generic(
            m : integer := 8;  -- questo ci dice fino a che conta il counter
            n : integer := 3   -- questo ci da la lunghezza del vector, il numero di bit
        );
      Port (
            CLK : in std_logic;
            RESET: in std_logic;
            enable: in std_logic;
            y: out std_logic_vector(n-1 downto 0) -- uscita contatore
       );
    end component;

    component carry_lookahead_adder
        Generic (N : integer := 4);
        Port (
            A      : in  std_logic_vector(N-1 downto 0);
            B      : in  std_logic_vector(N-1 downto 0);
            Cin    : in  std_logic;
            Sum    : out std_logic_vector(N-1 downto 0);
            Cout   : out std_logic
        );
    end component;
    
    --segnali interni per le interconnessioni
    signal count : std_logic_vector(2 downto 0);
    signal en_c : std_logic;
    signal en_w_acc : std_logic;
    signal write : std_logic;
    signal sum_p : std_logic_vector(3 downto 0);
    signal data_acc : std_logic_vector(3 downto 0);
    signal overflow : std_logic;

begin

    CU : unita_controllo_b
        port map (
            CLK => CLK,
            RST => RST,
            count => count,
            req => req,
            ack => ack,
            en_c => en_c,
            en_w_acc => en_w_acc,
            en_write => write
        );

    REGISTRO_R : registro
        port map (
              CLK  => CLK,
              RST  => RST,
              input  => data_acc,
              write  => write,
              output  => output_finale
         );

    ACCUMULATORE : registro
        port map (
              CLK  => CLK,
              RST  => RST,
              input  => sum_p,
              write  => en_w_acc,
              output  => data_acc
         );

    CNT_MOD_8 : counter
        generic map (
            m => 8,
            n => 3
        )
        port map (
            CLK  => CLK,
            RESET  => RST,
            enable => en_c,
            y => count
        );
        
    ADDER : carry_lookahead_adder
    generic map (
        N => 4
    )
    port map (
        A  => dato,
        B   => data_acc,
        Cin  => '0',
        Sum  => sum_p,
        Cout  => overflow
    );
    
end Structural;
