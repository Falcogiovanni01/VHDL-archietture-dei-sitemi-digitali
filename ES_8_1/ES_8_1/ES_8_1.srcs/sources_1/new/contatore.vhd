----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2023 17:02:23
-- Design Name: 
-- Module Name: contatore - Behavioral
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
use ieee.std_logic_unsigned.all;----------------- nuova libreria per fare i +1 nel count
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_modN is
    generic( 
        N:integer := 8 -- N  
        );
    Port ( clk : in  STD_LOGIC;
           attesa: in std_logic;
           count: out std_logic_vector(0 to 3):=(others => '0');
		   div: out STD_LOGIC:='0'
		   );
end counter_modN;

architecture Behavioral of counter_modN is


type state is (s0,s1);
signal curr: state:= s0;
signal count_tmp: std_logic_vector(0 to 3):=(others => '0');
begin

counter_process: process(clk)
    begin
    
        if(clk' event and clk ='1') then
        case curr is
        when s0 => if(attesa = '0') then
                    curr <= s0;
                   elsif(attesa = '1') then
                       curr <= s1;
                       if(count_tmp = 3) then
                        div <= '1';
                        --count_tmp <= (others => '0');
                        else 
                            div <= '0';
                            count_tmp <= count_tmp + 1;
                        end if;
                    end if;
        when s1 => if(attesa = '1') then
                    curr <= s1;
                   else
                    curr <= s0;
                   end if;
        when others => curr <= s0;
          end case;
        end if;
end process;
count <= count_tmp;
end Behavioral;

