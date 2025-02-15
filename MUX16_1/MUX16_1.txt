----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2025 15:34:05
-- Design Name: 
-- Module Name: Mux16_1 - Behavioral
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

entity Mux16_1 is
    Port ( I : in  STD_LOGIC_VECTOR (0 to 15);  -- 16 ingressi
           S0 : in STD_LOGIC; -- ingressi di selezione
           S1 : in STD_LOGIC;
           S2 : in STD_LOGIC;
           S3 : in STD_LOGIC;
           Y : out STD_LOGIC);
end Mux16_1;

architecture Behavioral of Mux16_1 is

component MUX4_1 is
    port ( 
       A0 : in STD_LOGIC;
       A1 : in STD_LOGIC;
       A2 : in STD_LOGIC;
       A3 : in STD_LOGIC;
       S0 : in STD_LOGIC;
       S1 : in STD_LOGIC;
       Y : out STD_LOGIC);
       end component; 
signal mux1, mux2, mux3, mux4 : STD_LOGIC; 

begin
-- SONO NECESSARI 5 MUX 
-- 4 PER PRELEVARE LE SINGOLE USCITE
-- 1 PER "CONGIUNGERE I SINGOLI VALORI ALL USCITA FINALE"
 -- Primo livello di MUX 2:1
  MUX_1 : MUX4_1 port map (
       A0 =>I(0),
       A1 =>I(1),
       A2 =>I(2),
       A3 =>I(3),
       S0 =>S0,
       S1 =>S1,
       Y =>mux1
  );
  MUX_2 : MUX4_1 port map (
       A0 =>I(4),
       A1 =>I(5),
       A2 =>I(6),
       A3 =>I(7),
       S0 =>S0,
       S1 =>S1,
       Y =>mux2
  );
  MUX_3: MUX4_1 port map (
       A0 =>I(8),
       A1 =>I(9),
       A2 =>I(10),
       A3 =>I(11),
       S0 =>S0,
       S1 =>S1,
       Y =>mux3
  );
  
   MUX_4 : MUX4_1 port map (
       A0 =>I(12),
       A1 =>I(13),
       A2 =>I(14),
       A3 =>I(15),
       S0 =>S0,
       S1 =>S1,
       Y =>mux4
  );
  
    MUX5 : MUX4_1 port map (
       A0 =>mux1,
       A1 =>mux2,
       A2 =>mux3,
       A3 =>mux4,
       S0 =>S2,
       S1 =>S3,
       Y =>Y
        );
   
   
end Behavioral;
