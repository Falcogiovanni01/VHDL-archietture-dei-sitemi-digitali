----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2025 12:05:26
-- Design Name: 
-- Module Name: switchElementare - Behavioral
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


entity switchElementare is
    
  Port (
  -- input 
  i1 : in std_logic_vector(1 downto 0);
  i2 : in std_logic_vector(1 downto 0); 
  -- selezione sorgente
  s_sorg : in std_logic; 
  -- selezione destinazione
  s_dest : in std_logic; 
  -- ENABLE 
  enable : in std_logic; 
  -- output 
  u1 : out std_logic_vector(1 downto 0); 
  u2 : out std_logic_vector(1 downto 0) 
  
    );
  
end switchElementare;

architecture Behavioral of switchElementare is

component MUX_2_1 is 
    Port(
        A : in STD_LOGIC_VECTOR(1 downto 0);   
        B : in STD_LOGIC_VECTOR(1 downto 0);   
        enable : in STD_LOGIC; 
        S : in STD_LOGIC;   
        Y : out STD_LOGIC_VECTOR(1 downto 0)  
    );
end component; 

component DEM1_2 is
 Port(
     A : in STD_LOGIC_VECTOR(1 downto 0);
     S1 : in STD_LOGIC;
     enable : in STD_LOGIC; 
     Y0: out STD_LOGIC_VECTOR (1 downto 0);   
     Y1: out STD_LOGIC_VECTOR (1 downto 0)  
 ); 
 end component;

Signal mid_sig : STD_LOGIC_VECTOR(1 downto 0) := (others=> 'U') ;

begin

    mux : MUX_2_1 
        Port map ( 
            A => i1, 
            B => i2,
            enable => enable,
            S => s_sorg, 
            Y => mid_sig
            ); 
            
     demux : DEM1_2  
        Port map( 
            A => mid_sig,
            S1 => s_dest, 
            enable => enable,
            y0 => u1,
            y1 => u2
            );

end Behavioral;
