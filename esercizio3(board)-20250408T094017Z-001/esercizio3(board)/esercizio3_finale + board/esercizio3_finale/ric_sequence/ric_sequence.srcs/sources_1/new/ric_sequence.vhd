----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2024 12:01:20
-- Design Name: 
-- Module Name: esercizio3 - Behavioral
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


entity ric_sequence is
    Port (
        M      : in  std_logic;  -- Modalità (0: non sovrapposte, 1: sovrapposte)
        a     : in  std_logic;  -- dato
        clk     : in  std_logic;
        rst : in std_logic; --segnale di reset
        --clock_frequency_in : integer := 50000000;
        --clock_frequency_out : integer := 500;
        load_m : in std_logic;
        load_a: in std_logic;
        y     : out std_logic   -- Segnale di uscita: alto se la sequenza 101 è riconosciuta
    );

end ric_sequence;

architecture Behavioral of ric_sequence is
type state_sig  is (sM, s0, s1, s2, s3, s4, s5, s6, s7);
signal curr_state : state_sig;

begin 
y_state: process(clk)
begin
if rising_edge(clk) then
    if(rst='1') then
        curr_state <= sM;
        y <= '0';
     else
        case curr_state is
            when sM =>               --blocco di codice che setta la modalirà di funzionamento guardando l'abilitazione e il valore di M
                if(load_m = '1') then     
                    if(M = '0') then
                        curr_state <= s0;
                        y <= '0';
                    else 
                        curr_state <= s5;
                        y <= '0';
                    end if;
                 end if;
            when s0 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s4;
                        y <= '0';
                     else
                        curr_state <= s1;
                        y <= '0';
                     end if;
                end if;
                
              when s1 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s3;
                        y <= '0';
                     else
                        curr_state <= s2;
                        y <= '0';
                     end if;
                end if;
                
                when s2 =>
                if(load_a = '1') then
                    if(a = '-')then
                        curr_state <= s0;
                        y <= '0';
                     
                     end if;
                end if;
                
                when s3 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s0;
                        y <= '0';
                     else
                        curr_state <= s0;
                        y <= '1';
                     end if;
                end if;
                
                when s4 =>
                if(load_a = '1') then
                    if(a = '-')then
                        curr_state <= s2;
                        y <= '0';
                     end if;
                end if;
                
                
                when s5 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s5;
                        y <= '0';
                     else
                        curr_state <= s6;
                        y <= '0';
                     end if;
                end if;
                
                when s6 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s7;
                        y <= '0';
                     else
                        curr_state <= s6;
                        y <= '0';
                     end if;
                end if;
                
                when s7 =>
                if(load_a = '1') then
                    if(a = '0')then
                        curr_state <= s5;
                        y <= '0';
                     else
                        curr_state <= s5;
                        y <= '1';
                     end if;
                end if;
 
         end case;
        end if;
       end if;
      end process;     
                
 end Behavioral;
