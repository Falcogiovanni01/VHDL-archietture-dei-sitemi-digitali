library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registro is
  Port ( 
        clk    : in std_logic;  -- Segnale di clock
        reset  : in std_logic;  -- Reset sincrono
        dato   : in std_logic_vector (3 downto 0); -- Ingresso dati
        load   : in std_logic;  -- Segnale di carico
        uscita : out std_logic_vector (3 downto 0) -- Uscita del registro
  );
end registro;

architecture Behavioral of registro is
  signal reg : std_logic_vector (3 downto 0);  -- Registro interno
begin

process (clk)
begin
    if rising_edge(clk) then  
        if reset = '1' then   
            reg <= "0000";  -- Reset del registro
        elsif load = '1' then
            reg <= dato;  -- Carica il valore in dato nel registro
        end if;
    end if;
end process;

uscita <= reg;  -- Assegna l'uscita al valore del registro

end Behavioral;