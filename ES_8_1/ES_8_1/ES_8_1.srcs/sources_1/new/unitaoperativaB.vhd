----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 12:26:08
-- Design Name: 
-- Module Name: unitaoperativaB - Behavioral
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

entity unitaoperativaB is
  Port (
            clk:in std_logic;
            outputA: in std_logic_vector(0 to 3):= (others => '0'); 
            enableUO: in std_logic:='0';
            enable_ent: out std_logic:='0';
            write,read: out std_logic:='0';
            output_memB: in std_logic_vector(0 to 3):= (others => '0');
            sumAB: out std_logic_vector(0 to 3)
   );
end unitaoperativaB;

architecture Behavioral of unitaoperativaB is
type state is (s0,s1,s2,s3,s4,s5);
signal curr:state:=s0;

signal tmp_read,tmp_write: std_logic:='0';
signal tmp_sum: unsigned(0 to 3):= (others => '0');
signal a,b: unsigned(0 to 3);
begin

process(clk)
begin
        if(clk'event and clk ='1') then
           case curr is
           when s0 =>
                if(enableUO = '0') then -- Finchè l'enable è = 0 resto nello stato iniziale
                    curr<=s0; -- ( FINCHè NON ARRIVA REQ IN RETE DI CONTROLLO B )
                else 
                    curr <= s1;
                    enable_ent <= '0'; -- DISABILITI L UNITà DI CONTROLLO IN MANIERA CHE 
                    -- A E B NON POSSANO COMUNICARE COSICCHè HO TEMPO PER ESEGUIRE LA SOMMA.
                end if;
                
           when s1 => -- STATO DI TRANSIZIONE
                tmp_read <= '1'; -- abilito la lettura della memoria
                curr <= s2;
           
           when s2 => 
                tmp_read <= '0'; -- ho letto il dato abbasso il segnae
                curr <= s3;
                
           when s3 =>
           -- MI PREPARO PER EFFETTUARE LA SOMMA
                a <= unsigned(outputA); 
                b <= unsigned(output_memB);
                curr <= s4;
                enable_ent <= '1'; -- ABILITò L ENTITà di controllo B per gestire nuove richieste
           
           when s4 =>
           -- Effettuò la somma e scrivo in memoria
                tmp_sum <= a+b;
                tmp_write <= '1'; -- SALVO IL VALORE 
                enable_ent <= '0'; -- Disabilita nuovamente l'unità di controllo per evitare conflitti
                curr <= s5;
           
           when s5 =>
                tmp_write <= '0';  -- HO LETTO QUINDI SPENGO IL SEGNALE 
                if(enableUO='0')then -- SE L UNITà OPERATIVA è DISABILITà
                    curr <=s5;
                else
                    curr <= s1;
                end if;
            
            when others => curr <= s0;
    end case;
end if;
end process;
read <= tmp_read;
write <= tmp_write;
sumAB <= std_logic_vector(tmp_sum(0 to 3));
end Behavioral;
