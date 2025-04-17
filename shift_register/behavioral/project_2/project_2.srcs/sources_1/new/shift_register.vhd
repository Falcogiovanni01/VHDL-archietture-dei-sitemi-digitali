library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_register is
    generic(
        N: integer := 4
    );
 Port (
    Y : in std_logic; --ingresso che serve per decidere se shiftare di uno o due posizioni
    M: in std_logic; --ingresso utilizzato per decidere se shiftare verso destra o sinistra
    X: in std_logic; --input

    clk: in std_logic;
    rst: in std_logic;

    output: out std_logic;
    temp_out : out std_logic_vector(N-1 downto 0)  -- Debug: registro interno
 );
end shift_register;

architecture Behavioral of shift_register is

signal temp : std_logic_vector (N-1 downto 0);

begin
    process(clk, rst)
    begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            temp <= (others => '0');
        else
            if(Y = '0') then --se y=0 si shifta solo di una posizione
                if(M = '0') then --se M=0 si imposta lo scorrimento verso destra
                    temp(0) <= X;
                    temp(N-1 downto 1) <= temp(N-2 downto 0);
                 else        --gestiamo il caso in cui M=1 e si imposta lo scorrimento verso sinistra
                    temp(N-1) <= X;
                    temp(N-2 downto 0) <= temp(N-1 downto 1); --?
                 end if;
             else    --gestiamo il caso in cui Y=1 e si shifta di due posizioni
                if(M = '0') then --se M=0 si imposta lo scorrimento verso destra
                    temp(1 downto 0) <= (X & temp(0));
                    temp(N-1 downto 2) <= temp(N-3 downto 0);
                 else        --gestiamo il caso in cui M=1 e si imposta lo scorrimento verso sinistra
                    temp(N-1 downto N-2) <= (temp(N-1) & X);
                    temp(N-3 downto 0) <= temp(N-1 downto 2);  --?
                 end if;

          end if;
         end if;
       end if;

end process;

with M select 
       output <= temp(0) when '0', 
       temp(N-1) when '1',
       '-' when others;

temp_out <= temp;
end Behavioral;
