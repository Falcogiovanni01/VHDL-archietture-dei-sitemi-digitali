----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2025 11:00:06
-- Design Name: 
-- Module Name: MUX4_1 - Behavioral
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

entity MUX4_1 is
    Port ( A0 : in STD_LOGIC;
           A1 : in STD_LOGIC;
           A2 : in STD_LOGIC;
           A3 : in STD_LOGIC;
           S0 : in STD_LOGIC;
           S1 : in STD_LOGIC;
           Y : out STD_LOGIC);
end MUX4_1;

architecture Behavioral of MUX4_1 is
--- INSERISCI I COMPONENTI CHE TI SERVONO : 
component MUX_2_1 is 
    Port(
    A : in STD_LOGIC; 
    B : in STD_LOGIC; 
    S : in STD_LOGIC; 
    Y :out STD_LOGIC
    );
end component;

 -- Segnali intermedi per collegare i MUX 2:1
 signal mux0_out, mux1_out : STD_LOGIC;

begin
-- SONO NECESSARI 3 MUX : 
  -- Primo livello di MUX 2:1
  MUX0: MUX_2_1 port map (
       A => A0,  -- Collega A0 all'ingresso A del MUX 2:1
       B => A1,  -- Collega A1 all'ingresso B del MUX 2:1
       S => S0,  -- Collega S0 al segnale di selezione
       Y => mux0_out  -- Uscita del primo MUX 2:1
  );
  
  MUX1: MUX_2_1 port map(
    A => A2, 
    B => A3, 
    S => S0, 
    Y => mux0_out
  );
  
   MUX2: MUX_2_1 port map(
    A => mux0_out, 
    B => mux0_out, 
    S => S1, 
    Y => mux1_out
  );



end Behavioral;
