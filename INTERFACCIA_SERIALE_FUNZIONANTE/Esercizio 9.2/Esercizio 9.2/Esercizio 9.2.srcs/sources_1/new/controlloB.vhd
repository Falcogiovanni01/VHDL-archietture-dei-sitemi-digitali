----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2023 11:58:22
-- Design Name: 
-- Module Name: controlloB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlloB is
  Port ( RDA,clk: in std_logic;
        req,PE,FE: in std_logic:='0';
        RD,ris,write,errore:out std_logic:='0'
  );
end controlloB;

architecture Behavioral of controlloB is
type state is (s0,s1,s2);
signal curr:state:=s0;
signal write_tmp: std_logic:='0';

begin
        process(clk)
            begin
                if(clk'event and clk ='0') then
                case curr is
        
                   when s0 =>
                       if(req = '1') then
                       curr<=s1;
                       ris<='1';
                       else 
                       curr<=s0;
                       end if;             
                       
                   when s1 =>
                   if(RDA = '1') then
                            RD <= '1';
                            if(PE = '1' or FE = '1') then
                                curr <= s2;
                                errore <= '1';
                            else 
                                write_tmp <= '1'; 
                                curr <= s2;
                                errore<= '0';
                            end if;
                        else 
                            curr <= s1;
                        end if;

                   when s2 =>
                        write_tmp <= '0';
                        RD <= '0';   
                        if(req = '0') then
                           curr<= s0;
                           ris <= '0';
                        else 
                        curr <= s2;
                        end if; 
     
                    when others => curr <= s1;
end case;       
end if;
end process;
write<=write_tmp;
--read<=read_tmp;
end Behavioral;
