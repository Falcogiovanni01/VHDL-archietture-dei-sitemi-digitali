----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2024 13:19:29
-- Design Name: 
-- Module Name: mux_4_1 - Structural
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

entity mux_4_1 is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0); -- I 4 Input, in un vettore
           en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando è '1'
           s : in STD_LOGIC_VECTOR (1 downto 0); -- Segnali codificati di Selezione dell'Input
           y : out STD_LOGIC); -- Output
end mux_4_1;

architecture Structural of mux_4_1 is

    component gen_mux_2_1 is
        Generic( Size : natural); -- Dimensione dei dati
        Port ( a0 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 1
               a1 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 2
               en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando è '1'
               s : in STD_LOGIC; -- Segnale di Selezione dell'Input
               y : out STD_LOGIC_VECTOR(Size-1 downto 0)); -- Output
    end component;

    signal u : STD_LOGIC_VECTOR (1 downto 0) := (others => '0'); -- Segnali di uscita intermedi

begin

    -- Multiplexer al primo livello, che sceglie fra a(0) e a(1)
    mux00: gen_mux_2_1 generic map (Size => 1) 
    port map(
       a0(0) => a(0),
       a1(0) => a(1),
       en => en,
       s => s(0),
       y(0) => u(0));
        
    -- Multiplexer al primo livello, che sceglie fra a(2) e a(3)
    mux01: gen_mux_2_1 generic map (Size => 1) 
    port map(
       a0(0) => a(2),
       a1(0) => a(3),
       en => en,
       s  => s(0),
       y(0)  => u(1));
    
    -- Multiplexer al secondo livello, che sceglie fra gli output del primo livello    
    mux1: gen_mux_2_1 generic map (Size => 1) 
    port map(
       a0(0) => u(0),
       a1(0) => u(1),
       en => en,
       s  => s(1),
       y(0)  => y);

end Structural;
