----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2023 11:47:01
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
use IEEE.math_real."log2";
use IEEE.math_real."ceil";
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memoriaB is
  Generic(N:integer);
   Port (
        clk: in std_logic;
        read, write: in std_logic:='0';
        output: out std_logic_vector(0 to 7):=(others=> '0');
        input: in std_logic_vector(0 to 7):=(others =>'0');
        counter_value: in std_logic_vector (0 to 3)
        );
end memoriaB;

architecture Behavioral of memoriaB is
type memoria is array (0 to N-1) of std_logic_vector(0 to 7);
signal mem: memoria:=(others => (others => '0'));
signal output_tmp:std_logic_vector(0 to 7):=(others=> '0');
begin
process(clk)
variable count_read: integer:=0;
    begin
        if(clk='1' and clk'event) then
            if(write='1') then
                 mem(to_integer(unsigned(counter_value(0 to 3))))<= input;
             elsif(read ='1') then
                 output_tmp<= mem(count_read);
                if(count_read = N-1) then
                   count_read:=0;
                else 
                   count_read:= count_read +1;
                end if;
            end if;
         end if;
    end process;

output <= output_tmp;
end Behavioral;
