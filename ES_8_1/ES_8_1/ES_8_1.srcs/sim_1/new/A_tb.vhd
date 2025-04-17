----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 17:51:24
-- Design Name: 
-- Module Name: A_tb - Behavioral
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
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity A_tb is
end;

architecture bench of A_tb is

  component A
    Port (
          clk,rst: in std_logic;
          risposta: in std_logic;
          request: out std_logic;           
          output: out std_logic_vector(0 to 3)
     );
  end component;

  signal clk,rst: std_logic;
  signal risposta: std_logic;
  signal request: std_logic;
  signal output: std_logic_vector(0 to 3) ;
  constant CLK_period : time := 10ns;
  
begin

  uut: A port map ( clk      => clk,
                    rst      => rst,
                    risposta => risposta,
                    request  => request,
                    output   => output );

  stimulus: process
  begin
        clk <= '0';
        wait for CLK_period/2;
        clk <= '1';
        wait for CLK_period/2;
    end process;

sis_1: process
        begin   
         wait for 50ns;
         risposta <= '1';
         wait for 50ns;
         risposta <= '0';
         wait for 50ns;
         risposta <= '1';
         wait for 50ns;
         risposta <= '0';
         wait for 50ns;
         risposta <= '1';
         wait for 50ns;
         risposta <= '0';
         wait for 50ns;
         risposta <= '1';
         wait for 50ns;
         risposta <= '0';
         wait;
        end process;    


end;
  