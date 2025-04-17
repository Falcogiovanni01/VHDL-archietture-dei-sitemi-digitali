----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2025 11:22:58
-- Design Name: 
-- Module Name: cont_mod_N - Behavioral
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
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cont_mod_N is
    generic(N : in integer := 60);
    port(
        I : in STD_LOGIC_VECTOR((integer(ceil(log2(real(N))))-1) DOWNTO 0); --input
        EN : in STD_LOGIC; -- enable
        SET : in STD_LOGIC; -- segnale per settare l'ingresso
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        CONT : out STD_LOGIC_VECTOR((integer(ceil(log2(real(N))))-1) downto 0); -- uscita del contatore mod N
        DIV : out STD_LOGIC -- uscita divisore (alta quando il contatore raggiunge il massimo)
    );
end cont_mod_N;

architecture Behavioral of cont_mod_N is
    begin
        process(CLK, RST, SET)
            variable c: INTEGER range 0 to N-1 := 1;
            begin
                if(RST = '1') then
                    c := 1;
                    CONT <= (others => '0');
                    DIV <= '0';
                elsif(SET = '1') then
                    c := to_integer(unsigned(I));
                    CONT <= std_logic_vector(to_unsigned(c, CONT'length));
                    if c = N-1 then
                        DIV <= '1'; 
                    else
                        DIV <= '0';
                    end if;
                c := c + 1;
                elsif (falling_edge(CLK)) then
                    if EN = '1' then
                        if(c < N) then
                            CONT <= std_logic_vector(to_unsigned(c, CONT'length));
                            if c = N-1 then
                                DIV <= '1'; 
                            else
                                DIV <= '0';
                            end if;
                            c := c + 1;
                        else
                            DIV <= '0';
                            CONT <= (others => '0');
                            c := 1; 
                        end if; 
                    end if;
                end if; 
        end process;
 
end Behavioral;

