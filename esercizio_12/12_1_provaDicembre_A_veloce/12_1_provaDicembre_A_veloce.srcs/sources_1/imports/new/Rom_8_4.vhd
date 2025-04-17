library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    port(
        clk : in std_logic;
        address : in std_logic_vector(2 downto 0);  
        read : in std_logic;                              
        dout : out std_logic_vector(3 downto 0) 
    );   
end ROM;

architecture behavioral of ROM is 
type MEMORY_8_4 is array (0 to 7) of std_logic_vector(3 downto 0);
constant ROM_8_4 : MEMORY_8_4 := (
        "0001",
        "0001", 
        "0001",
        "0001", 
        "0001", 
        "0001", 
        "0001", 
        "0001"
    );
                                      
begin
    rom_process: process(clk)
    begin
         if(clk'event and clk='1') then	  
           if read = '1' then
              dout <= ROM_8_4(to_integer(unsigned(address)));
           end if;
         end if;
    end process;
end behavioral;