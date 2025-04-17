library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sistema_a is
    Port ( CLK : in STD_LOGIC; -- clock
           RST : in STD_LOGIC; -- reset
           start : in STD_LOGIC; -- segnale start
           ack : in STD_LOGIC;  -- segnale ack
           req : out STD_LOGIC; -- segnale req
           dato : out STD_LOGIC_VECTOR (3 downto 0)); -- dato da inviare a B
end sistema_a;

architecture Structural of sistema_a is

    component unita_controllo_a
        Port (
            CLK         : in  std_logic;
            RST         : in  std_logic;
            start       : in std_logic; -- quando inizia il programma -> a leggere da rom
            count       : in std_logic_vector (2 downto 0); -- valore conteggio contatore mod 8
            ack       : in  std_logic; -- Acknowledgment da sistema B
            
            req       : out std_logic; -- Req al sistema B
            read        : out std_logic; -- abilita lettura dalla Rom
            en_c      : out std_logic -- abilita conteggio contatore indirizzi rom        
        );
    end component;

    component ROM
        port(
            clk : in std_logic;
            address : in std_logic_vector(2 downto 0);  
            read : in std_logic;                              
            dout : out std_logic_vector(3 downto 0) 
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

    --segnali interni per le interconnessioni
    signal read : std_logic;
    signal address : std_logic_vector(2 downto 0);
    signal en_c : std_logic;
    

begin

    CU : unita_controllo_a
        port map (
            CLK => CLK,
            RST => RST,
            start  => start,
            count => address,
            ack => ack,
            req => req,
            read => read,
            en_c => en_c
        );

    ROM_8_4 : ROM
        port map(
            clk => CLK,
            address => address,
            read => read,
            dout => dato
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
            y => address
        );
    
end Structural;
