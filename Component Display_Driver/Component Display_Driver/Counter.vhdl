library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    generic(
			module_log : positive
    );
    Port (
            reset : in STD_LOGIC;
            enable : in STD_LOGIC;
            clock : in  STD_LOGIC;
            count : out STD_LOGIC_VECTOR(module_log-1 downto 0);
            count_max : out  STD_LOGIC;
            ripple : out STD_LOGIC
    ); 
end Counter;

architecture Behavioral of Counter is


    signal count_value : std_logic_vector(module_log-1 downto 0);
    constant count_max_value : std_logic_vector(module_log-1 downto 0) := (others => '1');

    begin
        count <= count_value;
        count_max <= '1' when count_value = count_max_value else '0';
        ripple <= '1' when count_value = count_max_value and enable = '1' else '0';

        process(clock, reset)

            variable counter : integer range 0 to 2**module_log-1 := 0;
            begin
                if reset = '0' then
                    counter := 0;
                elsif rising_edge(clock) and enable = '1' then
                    if counter = 2**module_log-1 then
                        counter := 0;
                    else
                        counter := counter + 1;
                    end if;
                end if;
                count_value <= std_logic_vector(to_unsigned(counter, module_log));
    end process;


end Behavioral;

