library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 2:1 MUX
entity MUX_2_1 is
    Port ( A : in STD_LOGIC;      -- Ingresso A
           B : in STD_LOGIC;      -- Ingresso B
           S : in STD_LOGIC;      -- Selettore
           Y : out STD_LOGIC);    -- Uscita
end MUX_2_1;

architecture Behavioral of MUX_2_1 is
begin
    -- Processo che implementa la logica del MUX
    process(A, B, S)
    begin
        if (S = '0') then
            Y <= A;  -- Se S=0, l'uscita sarà A
        else
            Y <= B;  -- Se S=1, l'uscita sarà B
        end if;
    end process;
end Behavioral;
