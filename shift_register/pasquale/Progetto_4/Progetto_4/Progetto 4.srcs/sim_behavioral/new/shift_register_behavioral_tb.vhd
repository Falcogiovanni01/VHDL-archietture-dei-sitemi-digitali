----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2024 15:31:22
-- Design Name: 
-- Module Name: shift_register_structural_tb - shift_register
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity shift_register_structural_tb is
end shift_register_structural_tb;

architecture shift_register_structural of shift_register_structural_tb is

    signal input : STD_LOGIC := '0';
    signal data : STD_LOGIC_VECTOR (5-1 downto 0) := "10110";
    signal output : STD_LOGIC_VECTOR (5-1 downto 0) := (others => '0');
    signal direction : STD_LOGIC := '0';
    signal length : STD_LOGIC := '0';
    signal clock : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    
    constant clock_period : TIME := 10 ns;

begin

    utt : entity work.shift_register(behavioral) generic map(Size => 5)
        port map(
            data_in => data,
            value_in => input,
            load => load,
            clock => clock,
            shift_en => enable,
            direction => direction,
            length => length,
            data_out => output);

    time_proc : process
        begin
            clock <= NOT (clock);
            wait for clock_period/2;
            clock <= NOT (clock);
            wait for clock_period/2;
        end process;
    
    main : process 
        begin 
            
            load <= '0';
            wait for 20 ns;
            enable <= '0';
            wait for 20 ns;
            direction <= '0';
             enable <= '1';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
             wait for 20 ns;
            input <= '0';
            wait for 20 ns; wait for 20 ns;
          
            
            
            direction <= '1';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            
            load <= '0';
            wait for 20 ns;
            enable <= '1';
            wait for 20 ns;
            direction <= '0';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;

            direction <= '1';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            
            load <= '1';
            wait for 20 ns;
            enable <= '0';
            wait for 20 ns;
            direction <= '0';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;

            direction <= '1';
            wait for 20 ns;
            length <= '0';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            
            input <= '1';
            wait for 20 ns;
            length <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            input <= '0';
            wait for 20 ns;
            input <= '1';
            wait for 20 ns;
            wait;
        end process;

end shift_register_structural;