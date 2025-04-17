library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;  
entity cont_generic is
    generic(N :in integer := 8);
        port(
    clock : in std_logic;
    reset : in std_logic;
 --   load : in std_logic_vector((integer(ceil(log2(real(N))))-1) downto 0); 
    enable_contatore : in std_logic;  
  --  enable_caricamento: in std_logic; 
    cont  : out std_logic_vector((integer(ceil(log2(real(N))))-1) downto 0)
   --div : out std_logic 
    ); 
end cont_generic;


architecture behavioral of cont_generic is
    constant DIM : integer := integer(ceil(log2(real(N))));
    signal temp : unsigned(DIM-1 downto 0);  -- Rimosso inizializzatore (sarà nel processo)
begin 
    process(clock)
    begin
        if falling_edge(clock) then  -- Uso del fronte di discesa
            if reset = '1' then
                temp <= (others => '0');  
               -- div <= '0';  
--            elsif enable_caricamento = '1' then
--                temp <= unsigned(load);  -- Caricamento valore da load
--                div <= '0';
            elsif enable_contatore = '1' then
                if temp = to_unsigned(N-1, DIM) then
                  --  div <= '1';
                    temp <= (others => '0');  -- Reset del contatore
                else                
                    temp <= temp + 1;  
                --    div <= '0';
                end if;
            end if;
        end if;
    end process;

    cont <= std_logic_vector(temp);  -- Conversione da unsigned a std_logic_vector
end behavioral;