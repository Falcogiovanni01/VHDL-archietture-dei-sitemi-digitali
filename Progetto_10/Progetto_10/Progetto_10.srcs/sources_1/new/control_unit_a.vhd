----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2024 11:51:36
-- Design Name: 
-- Module Name: control_unit_a - Behavioral
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

entity control_unit_a is
        Port (  TBE : in STD_LOGIC; -- Richiesta di dati da inviare
                start : in STD_LOGIC; -- Start esterno
                clock : in STD_LOGIC; -- Clock di sistema
                reset : in STD_LOGIC; -- Reset di sistema
                WR : out STD_LOGIC; -- Abilitazione all'invio dati
                read : out STD_LOGIC; -- Abilitazione alla lettura su ROM
                c_enable : out STD_LOGIC); -- Abilitazione del contatore
end control_unit_a;

architecture behavioral of control_unit_a is

type state is (idle,wait_request,sending,wait_confirm,cnt_update);
signal current_state : state := idle;
signal next_state : state;

begin

state_trasition : process (clock, tbe, start, current_state)
begin
    case current_state is
    
        -- Fase di Idle: si parte solo dopo lo start
        when idle =>
            if(start = '1') then 
                next_state <= wait_request;
            else 
                next_state <= idle;
            end if;
        
        -- Fase di attesa di una richiesta (fino a quando non si alza TBE)            
        when wait_request =>
            if(TBE = '0') then 
                next_state <= wait_request;
            else 
                next_state <= sending;
            end if;
            
        -- Fase di invio del dato (deve essere alto fino a quando non abbiamo finito)
        when sending =>
            if(TBE ='1') then 
                next_state <= sending;
            else 
                next_state <= wait_confirm;
            end if;
            
        -- Fase di attesa per un secondo TBE, per confermare il corretto invio           
        when wait_confirm =>
            if(TBE = '0') then 
                next_state <= wait_confirm;
            else
                next_state <= cnt_update;
            end if;
        
        -- Fase di aggiornamento del contatore che precede l'idle
        when cnt_update =>
            next_state <= idle;  
              
         end case;
end process;
    
stato_uscita : process (clock)
    begin
    case current_state is
        
        -- Fase di Idle: si parte solo dopo lo start
        when idle =>
            WR <= '0';
            read <= '0';
            c_enable <= '0';
        
        -- Fase di attesa di una richiesta (fino a quando non si alza TBE)
        when wait_request =>
            WR <= '0';
            read <= '1';
            c_enable <= '0';  
            
        -- Fase di invio del dato (deve essere alto fino a quando non abbiamo finito)
        when sending =>
            WR <= '1';
            read <= '1';
            c_enable <= '0'; 
            
        -- Fase di attesa per un secondo TBE, per confermare il corretto invio
        when wait_confirm =>
            WR <= '0';
            read <= '0';
            c_enable <= '0'; 
            
        -- Fase di aggiornamento del contatore che precede l'idle
        when cnt_update =>
            WR <= '0';
            read <= '0';
            c_enable <= '1';
            
       end case;               
      
    end process;


    -- Tempificatore degli stati
    CLKP : process (clock,reset)
    begin
        if (rising_edge(clock)) then
            if (reset = '0') then
                current_state <= next_state;
            else
                current_state <= idle;
            end if;
        end if;
    end process; 
        

end behavioral;
