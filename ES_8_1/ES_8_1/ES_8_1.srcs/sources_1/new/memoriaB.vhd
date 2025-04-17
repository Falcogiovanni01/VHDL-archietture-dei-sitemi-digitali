----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2023 17:45:51
-- Design Name: 
-- Module Name: memoriaB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity memoriaB is
  generic ( 
    N:integer := 16
    );
 Port ( 
        clk: in std_logic;
        read,write: in std_logic;
        inputSomma: in std_logic_vector(0 to 3);
        count: in std_logic_vector(0 to 3);
        output: out std_logic_vector(0 to 3)
 );
end memoriaB;

architecture Behavioral of memoriaB is
type mem is array (0 to N-1) of std_logic_vector(0 to 3);
signal mem_tmp: mem:= (
-- PRIMI 8 DA LEGGERE
"0000",
"0001",
"0010",
"0011",
"0000",
"0000",
"0000",
"0000",
others => "0000"     -- QUELLI CHE SARANNO "SOVRASCRITTI"
);

signal valore:std_logic_vector(0 to 3);

begin
    process(clk)
        begin
            if(clk'event and clk = '1') then
                if(read = '1') then
                   valore <= mem_tmp(TO_INTEGER(unsigned(count(0 to 3))));
                 elsif(write = '1') then
                   mem_tmp((N/2)+TO_INTEGER(unsigned(count(0 to 3)))) <= inputSomma;
                 end if;
                end if;
    end process;
   output <= valore;
end Behavioral;
