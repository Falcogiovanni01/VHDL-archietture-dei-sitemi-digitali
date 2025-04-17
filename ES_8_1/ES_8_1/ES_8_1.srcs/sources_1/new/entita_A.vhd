----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2023 18:29:16
-- Design Name: 
-- Module Name: entita_A - Behavioral
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

entity entita_A is
    Port (
            ris,div: in std_logic;
            clk:in std_logic;
            inputROM: in std_logic_vector(0 to 3):= (others => '0');
            req: out std_logic;
            read: out std_logic:='0';            
            outputA: out std_logic_vector(0 to 3):= (others => '0')
     );
end entita_A;

architecture Behavioral of entita_A is
type state is (s0,s1,s2,s3,s4,s5,s6);
signal curr:state:= s0;
signal reqtmp:std_logic:='0';
signal input_tmp:std_logic_vector(0 to 3):= (others => '0'); -- vettore per salvare dato corrente
begin

process(clk)

    begin
        if(clk'event and clk ='1') then
        
        case curr is 
        when s0 =>
        -- stato iniziale attende che div si abbassa per iniziare la trasmissione
                 if(div ='1') then
                    curr <= s0;
                 else 
                    curr <= s1;
                    read <='1'; -- attivo il segnale di lettura dalla rom
                  end if;
        when s1 => -- STATO DI TRANSIZIONE
                read <= '0';
                curr <= s2;        
   
        when s2 => -- viene salvato il dato da inviare a B in un vettore temporaneo
                input_tmp <= inputROM;
                reqtmp <= '1'; -- il dato è pronto ora tengo alto req_tmp fino all'arrivo della risposta.
                curr <= s3; -- invio il segnale di richiesta.
        
        when s3 =>
                if( ris = '0') then
                    curr <= s3; -- rimane in attesa
                else -- risposta alta, significa che B ha risposto 
                    curr <= s4; -- posso andare avanti e abbasso req( lo faccio nello stato successivo)
                end if;
        when s4 => -- STATO DI TRANSIZIONE
                reqtmp <='0';
                curr<= s5;                
        when s5 => 
                if( div = '1') then -- div alto : il contatore ha scandito tutta la rom quindi 
                    curr <= s0;-- torniamo nello stato iniziale
                else
                    read <= '1'; -- se ha finito di mandare il messaggio i-esimo
                    curr <= s6; -- ma div non è alto vado nello stato successivo e la macchina 
                end if; -- si appresta a inviare il dato successivo 
                    
        when s6 => 
                read <='0';
                if(ris='0') then  -- Se ris è = 0 read è ancora alto quindi posso tornare indietro, perchè
                    curr<=s2;-- B ha risposto e posso andare avanti 
                else  -- B è alto, sta ancora eseguendo e devo attendere.  
                    curr<=s6;
                end if; 
                               
        when others => curr <= s0;
        end case;
   end if;
end process;
outputA <= input_tmp;
req <= reqtmp; 
end Behavioral;
