----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2024 13:14:31
-- Design Name: 
-- Module Name: flip_flop_d - Dataflow
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

entity flip_flop_d is
    Port ( d : in STD_LOGIC; -- Dato di ingresso
           enable : in STD_LOGIC; -- Segnale di abilitazione alla lettura di d, spesso tempificato
           q : out STD_LOGIC); -- Dato salvato in uscita
end flip_flop_d;

architecture Dataflow of flip_flop_d is

begin

    ff: process(enable)
    begin
        if(rising_edge(enable)) then -- Serve che venga abilitato l'enable
            q <= d; -- Sovrascrittura di q
        end if;
    end process;

end Dataflow;
