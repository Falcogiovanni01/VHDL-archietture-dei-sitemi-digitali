library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY ROM_N_8 IS
    GENERIC(
        len_add : positive := 3  -- 3 bit per indirizzare 8 locazioni
    );
    
    PORT ( 
        CLK_rom : in std_logic;
        address : in std_logic_vector(len_add - 1 downto 0); -- 3 bit
        read : in std_logic;
        dout : out std_logic_vector(3 downto 0)  -- Uscita da 4 bit
    );
END ROM_N_8;

ARCHITECTURE Behavioral of ROM_N_8 is

TYPE MEMORY_N_4 IS ARRAY (0 to 7) OF std_logic_vector(3 downto 0);

constant ROM_N_8 : MEMORY_N_4 := (
    "0000", -- Indirizzo 0
    "0001", -- Indirizzo 1
    "0010", -- Indirizzo 2
    "0011", -- Indirizzo 3
    "0100", -- Indirizzo 4
    "0101", -- Indirizzo 5
    "0110", -- Indirizzo 6
    "0111"  -- Indirizzo 7
);

BEGIN

 main : process(CLK_rom)
 begin
    if rising_edge(CLK_rom) then
        if(read = '1') then
            dout <= ROM_N_8(to_integer(unsigned(address)));
        end if;
    end if;           
end process main;

END Behavioral;
