----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2025 11:13:48
-- Design Name: 
-- Module Name: UCA - Behavioral
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

entity UCA is
  Port (
  -- AVVIO :
  start : in std_logic; 
  reset : in std_logic; 
  clock : in std_logic; 
  -- check
  cont_value : in std_logic_vector( 2 downto 0); 
  enable_cont : out std_logic; 
  reset_cont : out std_logic; 
  read : out std_logic; 
  -- trasmissione : 
  req : out std_logic; 
  ack : in std_logic;
  inputROM : in std_logic_vector ( 3 downto 0); 
  output : out std_logic_vector(3 downto 0)  
  
   );
end UCA;

architecture Behavioral of UCA is

type state is ( idle, preparazioneDato, start_tx, waitAck1 , okAck, waitAck2, incrementCount); 

signal state_current : state := idle;
signal input_tmp:std_logic_vector(0 to 3):= (others => '0'); -- vettore per salvare dato corrente
begin
    
 main : process(clock) 
    begin 
        if(rising_edge(clock)) then 
            if(reset = '1') then 
                state_current <= idle; 
            else   
                case state_current is 
                    when idle =>
                        if(start = '0') then 
                            reset_cont <= '1';
                            state_current <= idle; 
                         else 
                             reset_cont <= '0';
                            state_current <= preparazioneDato; 
                         end if; 
                    when preparazioneDato =>
                        read <= '1'; 
                         enable_cont <= '0'; 
                        state_current <= start_tx;
                    when start_tx =>
                     --   read <= '0' ; 
                        req <= '1'; 
                        state_current <= waitAck1; 
                     when waitAck1 => 
                     read <= '0' ;
                     input_tmp <= inputROM ; 
                        if( ack = '0') then 
                            state_current <= waitAck1 ; 
                        else 
                            state_current <= okAck; 
                        end if; 
                     when okAck => 
                        req <= '0'; 
                        state_current <= waitAck2 ; 
                     when waitAck2 => 
                        if(ack = '1') then 
                            state_current <= waitAck2;
                        else 
                            state_current <= incrementCount ; 
                        end if ;
                      when incrementCount => 
                        enable_cont <= '1'; 
                        if( cont_value = "111") then 
                            state_current <= idle; 
                        else 
                            state_current <= preparazioneDato; 
                        end if; 
                   when others =>
                        state_current <= idle;
                    
                    
              end case; 
          end if; 
        end if; 
        end process ;
output <= input_tmp ; 
end Behavioral;
