library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity carry_lookahead_adder is
    Generic (N : integer := 4); -- Numero di bit
    Port (
        A      : in  std_logic_vector(N-1 downto 0);
        B      : in  std_logic_vector(N-1 downto 0);
        Cin    : in  std_logic;
        Sum    : out std_logic_vector(N-1 downto 0);
        Cout   : out std_logic
    );
end carry_lookahead_adder;

architecture Behavioral of carry_lookahead_adder is
    signal P, G : std_logic_vector(N-1 downto 0); -- Propagate and Generate signals
    signal C    : std_logic_vector(N downto 0);   -- Carry signals
begin
    
    P <= A xor B;   -- Propagate
    G <= A and B;   -- Generate

    -- Logica Carry
    C(0) <= Cin;
    gen_carry: for i in 0 to N-1 generate
        C(i+1) <= G(i) or (P(i) and C(i));
    end generate;

    -- Calcolo della Somma
    Sum <= P xor C(N-1 downto 0);

    -- Carry finale
    Cout <= C(N);

end Behavioral;