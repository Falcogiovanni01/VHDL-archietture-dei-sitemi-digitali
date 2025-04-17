library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
    generic(
			clock_in_freq : integer := 100000000;
			clock_out_freq : integer := 250
    );
    Port (
            reset : in STD_LOGIC;
            clock_in : in  STD_LOGIC;
            clock_out : out  STD_LOGIC
    ); 
end clock_divider;

architecture Behavioral of clock_divider is

    signal count_max : std_logic := '0';

    constant count_max_value : integer := (clock_in_freq/clock_out_freq)-1;

    begin

        clock_out <= count_max;

        process(clock_in, reset)

            variable counter : integer range 0 to count_max_value := 0;
        begin

            if( reset = '0') then
                counter := 0;
                count_max <= '0';
            elsif rising_edge(clock_in) then
                if counter = count_max_value then
                    count_max <=  '1';
                    counter := 0;
                else
                    count_max <=  '0';
                    counter := counter + 1;
                end if;
            end if;
    end process;


end Behavioral;

