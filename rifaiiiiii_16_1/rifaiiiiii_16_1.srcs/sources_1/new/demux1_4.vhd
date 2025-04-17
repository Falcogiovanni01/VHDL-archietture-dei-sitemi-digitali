library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Demux1_4 is
    Port (
        A : in STD_LOGIC;                           -- Ingresso
        Y : out STD_LOGIC_VECTOR(0 to 3);            -- Uscite
        S1 : in STD_LOGIC;                           -- Selezione
        S2 : in STD_LOGIC                            -- Selezione
    );
end Demux1_4;

architecture Behavioral of Demux1_4 is
begin
    process (S1, S2, A)
        variable temp_Y : STD_LOGIC_VECTOR(0 to 3); -- Variabile per memorizzare le uscite temporanee
    begin
        -- Impostiamo tutte le uscite su '0' per evitare che restino attive
        temp_Y := "0000"; 

        -- Logica per selezionare l'uscita in base ai segnali di selezione S1 e S2
        if (S1 = '0' and S2 = '0') then
            temp_Y(0) := A;  -- MUX1 1000
        elsif (S1 = '0' and S2 = '1') then
            temp_Y(1) := A;  -- MUX2 0100
        elsif (S1 = '1' and S2 = '0') then
            temp_Y(2) := A;  -- MUX3 0010
        elsif (S1 = '1' and S2 = '1') then
            temp_Y(3) := A;  -- MUX4 0001
        end if;

        -- Assegniamo il valore alla variabile segnale
        Y <= temp_Y;
    end process;
end Behavioral;
