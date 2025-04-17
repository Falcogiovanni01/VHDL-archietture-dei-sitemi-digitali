----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 12:26:21
-- Design Name: 
-- Module Name: entita_B - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity entita_B is
 Port ( 
        req,div,clk: in std_logic;
        enable_ent: in std_logic:='0';
        outputA: in std_logic_vector(0 to 3):= (others =>'0');
        outputB: out std_logic_vector(0 to 3):= (others =>'0');
        enableUO: out std_logic:='0';
        ris: out std_logic
 );
end entita_B;

architecture Behavioral of entita_B is
type state is(s0,s1,s2,s3,s4);
signal curr:state:=s0;
signal tmpinput:std_logic_vector(0 to 3):= (others =>'0');
signal enableUO_tmp,ris_tmp: std_logic:='0';

begin

process(clk)
begin
        if(clk'event and clk ='1') then
        case curr is
        
        when s0 => 
                -- Attendo il segnale di inizio comunicazione
                if(req='0') then 
                    curr <= s0;
               else 
                    curr <= s1; -- INIZIO LA COMUNICAZIONE E ABILITò l unità operativa
                    enableUO_tmp <= '1';
                    ris_tmp<= '1'; -- AVVISO A LA RICEZIONE DEL MESSAGIO
                    
               end if;
      when s1 => 
               if(enable_ent='0') then  -- ora l unità operativa sta effettuando i calcoli e mi tiene bloccato
                   curr <= s1;
               else
                   enableUO_tmp <= '0'; -- l unità operativa ha finito e posso andare avanti
                   curr <= s2;
                        
               end if;
      when s2 =>
                -- verifica se la richiesta di A è ancora attiva
                 if (req='0') then 
                      ris_tmp <= '0'; -- disabilita la risposta ( il dato è stato elaborato)
                      curr <= s3;
                    else -- altrienti attendo
                       curr <= s2;
                    end if;
      when s3 => 
                -- verifica se il ciclo di trasmissione è terminato.
                if(div='0') then 
                   curr <= s4; -- Se non è finito, passa allo stato s4 per elaborare il prossimo dato  
                 else 
                    curr <= s0; -- Se il ciclo è completato, torna allo stato iniziale
                 end if;           
      when s4 => 
                -- Attende una nuova richiesta di A per riprendere la comunicazione
                if(req='0') then 
                   curr <= s4; -- Rimane in attesa 
                 else 
                   curr <= s1;  -- Riparte la comunicazione  
                   enableUO_tmp<= '1'; -- Riattiva l'unità operativa 
                   ris_tmp<= '1';-- Riattiva il segnale di risposta
                 end if;
      when others => curr <= s0;
end case;
end if;
end process;
ris <= ris_tmp;
enableUO <= enableUO_tmp;
outputB <= outputA;

end Behavioral;
