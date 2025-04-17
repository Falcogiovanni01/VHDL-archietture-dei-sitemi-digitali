----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 19:55:55
-- Design Name: 
-- Module Name: system - Structural
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

entity system is
    Port (
        start : in STD_LOGIC;
        reset : in STD_LOGIC;
        clock : in STD_LOGIC);
end system;

architecture Structural of system is

    component system_a is
        Port (  start : in STD_LOGIC; -- Start esterno
                reset : in STD_LOGIC; -- Reset esterno
                clock : in STD_LOGIC; -- Clock
                RX : in std_logic; -- Segnale di ricezione, ricevuto da system_b
                TX : out std_logic); -- Segnale di invio, da mandare a system_b
    end component;
       
    component system_b is
        Port (  clock : in STD_LOGIC; -- Clock di sistema
                reset : in STD_LOGIC; -- Reset esterno
                RX : in STD_LOGIC; -- Segnale di ricezione, da mandare a system_a
                TX : out STD_LOGIC; -- Segnale di invio, da ricevere da system_a
                error : out STD_LOGIC; -- Segnale che avvisa della presenza di errori
                data_out : out STD_LOGIC_VECTOR (7 downto 0)); -- Dato salvato in memoria
    end component;

    signal sig_A : STD_LOGIC;
    signal sig_B : STD_LOGIC;
    signal sig_ERR : STD_LOGIC;

begin

    sysA : system_a port map(
        start => start,
        reset => reset,
        clock => clock,
        RX => SIG_A,
        TX => SIG_B);
        
        
    sysB : system_b port map(
        clock => clock,
        reset => reset,
        RX => SIG_B,
        TX => SIG_A,
        error => SIG_ERR,
        data_out => open);


end Structural;
