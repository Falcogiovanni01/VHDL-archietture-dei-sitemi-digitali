library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity registro is
    Port (
          CLK   : in std_logic;
          RST   : in std_logic;
          input : in std_logic_vector(3 downto 0);
          write : in std_logic;
          output: out std_logic_vector(3 downto 0)
         );
end registro;

architecture Behavioral of registro is
    signal reg : std_logic_vector(3 downto 0);
begin
    main: process(CLK)
        begin
            if(CLK'event and CLK='1') then 
                if(RST = '1') then 
                    reg <= "0000";
                elsif(write = '1') then 
                    reg <= input;
                end if;
            end if;
        end process;

    output <= reg;

end Behavioral;
