library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adderCLA is
    Port(
        X          : in std_logic_vector(3 downto 0);  -- Ingresso 4 bit
        Y          : in std_logic_vector(3 downto 0);  -- Ingresso 4 bit
        cin        : in std_logic;                      -- Cin (riporto in ingresso)
        avvia_somma: in std_logic;                      -- Segnale per avviare la somma
        somma      : out std_logic_vector(3 downto 0);  -- Risultato della somma
        cout       : out std_logic                       -- Riporto in uscita
    );
end adderCLA;

architecture Behavioral of adderCLA is
    signal P, G, C : STD_LOGIC_VECTOR (3 downto 0); -- Propagazione, generazione, riporto
    signal C4      : STD_LOGIC;                     -- Riporto finale
begin

    -- Calcolo della propagazione e generazione
    P <= X xor Y;
    G <= X and Y;
    
    -- Calcolo del riporto
    C(0) <= cin;
    C(1) <= G(0) or (P(0) and C(0));
    C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and C(0));
    C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and C(0));
    C4   <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or (P(3) and P(2) and P(1) and G(0)) or (P(3) and P(2) and P(1) and P(0) and C(0));
    
    -- Controllo del segnale avvia_somma
    process (avvia_somma, P, C)
    begin
        if avvia_somma = '1' then
            -- Calcolo della somma e del riporto
            somma <= P xor C;
            cout <= C4;
        else
            -- Quando avvia_somma è basso, non somma
            somma <= "0000"; 
            cout <= '0';      
        end if;
    end process;

end Behavioral;