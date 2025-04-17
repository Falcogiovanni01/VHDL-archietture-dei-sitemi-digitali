----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:11:47
-- Design Name: 
-- Module Name: Cont_mod_N - Behavioral
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
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cont_mod_N is
    generic (N : in integer);
    Port ( 
        I : in std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0);
        enable : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        div : out std_logic;
        cont : out std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0)
    );
end Cont_mod_N;

architecture Behavioral of Cont_mod_N is

begin
    process(clk, set, reset)
        variable ctg : integer range 0 to N-1 := 1;
    begin
        if(reset = '1') then
            ctg := 1;
            cont <= (others => '0');
            div <= '0';
        elsif(set = '1') then
            ctg := to_integer(unsigned(I));
            cont <= std_logic_vector(to_unsigned(ctg, cont'length));
            if(ctg = N-1) then
                div <= '1';
            else div <= '0';
            end if;
            ctg := ctg+1;
        elsif(falling_edge(clk)) then
            if(enable = '1') then
                if(ctg < N) then
                    cont <= std_logic_vector(to_unsigned(ctg, cont'length));
                        if(ctg = N-1) then
                            div <= '1';
                        else div <= '0';
                        end if;
                   ctg := ctg+1;
                else div <= '0';
                      cont <= (others => '0');
                      ctg := 1;
                end if;
            end if;
        end if;
     end process;
end Behavioral;
