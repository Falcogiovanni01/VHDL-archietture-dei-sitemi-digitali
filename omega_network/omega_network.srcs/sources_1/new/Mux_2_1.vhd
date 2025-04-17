library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_1 is
    Port(
        A : in STD_LOGIC_VECTOR(1 downto 0);   -- Ingresso A
        B : in STD_LOGIC_VECTOR(1 downto 0);   -- Ingresso B
        enable : in STD_LOGIC; -- abilitazione
        S : in STD_LOGIC;   -- Selettore
        Y : out STD_LOGIC_VECTOR(1 downto 0)  -- Uscita
    );
end MUX_2_1;

architecture Behavioral of MUX_2_1 is
begin
    -- Logica del MUX 2:1
    process(A, B, S, enable)
    begin
    if(enable = '1') then
        if S = '0' then
            Y <= A;  -- Se il selettore è 0, l'uscita è A
        else
            Y <= B;  -- Se il selettore è 1, l'uscita è B
        end if;
     end if;
    end process;
end Behavioral;
