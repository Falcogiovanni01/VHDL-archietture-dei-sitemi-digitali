

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlloA is
  Port (
            div, clk, rst,ris,TBE,errore: in std_logic;
            req,write,en:out std_logic:='0'
  
   );
end controlloA;

architecture Behavioral of controlloA is
type state is (s_rst,s0,s1,s2,s3,s4,s5);
signal curr:state:=s_rst;
signal write_tmp,en_tmp: std_logic:='0';

begin
        process(clk)
            begin
                if(clk'event and clk ='0') then
                 case curr is
                 
                 when s_rst =>
                    if(rst='1') then
                    curr<= s0;
                    else
                    curr<=s_rst;
                    end if;
                   
                   when s0 =>
                   if(ris='1')then
                   curr<=s0;
                   else
                       curr<=s1;
                       req<='1';
                       end if;
                       
                   when s1 =>
                   en_tmp<='0';
                        if(ris='1') then
                        curr<=s2;
                        req<='0';
                        else
                        curr<= s1;
                        end if;
                   
                   when s2 =>
                   write_tmp<='1';
                        curr<=s3;
                   
                        
                   when s3 =>
                        write_tmp<='0';
                        if(TBE = '0') then
                        curr <= s3;
                        else
                        curr <= s4; 
                        end if;
                        
                   when s4 =>
                       if(ris='1') then
                       curr<= s4;
                       elsif(errore ='0') then
                        en_tmp<='1';
                        curr<=s5;
                        else 
                        curr <= s5;
                        end if;
                        
                     when s5=>  
                         en_tmp<='0';
                        if(div='1') then
                            curr<=s_rst;
                            else
                            curr<=s1;
                            req<='1';
                            end if;
                       
                       when others => curr <= s_rst;
end case;                               
end if;
end process;
write<=write_tmp;
en<=en_tmp;
end Behavioral;
