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
-- Description: Questo modulo rappresenta un semplice switch elementare, che collega due ingressi a due uscite
--              utilizzando un MUX per selezionare l'ingresso e un DEMUX per selezionare l'uscita.
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
    -- Ingressi: i1 e i2 sono i dati di input
    i1 : in std_logic_vector(1 downto 0);
    i2 : in std_logic_vector(1 downto 0); 
    
    -- Selezione della sorgente: s_sorg controlla quale ingresso viene scelto
    s_sorg : in std_logic; 
    
    -- Selezione della destinazione: s_dest controlla quale uscita viene attivata
    s_dest : in std_logic; 
    
    -- Segnale di abilitazione (ENABLE): attiva o disattiva il funzionamento del circuito
    enable : in std_logic; 
    
    -- Uscite: u1 e u2 sono i dati di output
    u1 : out std_logic_vector(1 downto 0); 
    u2 : out std_logic_vector(1 downto 0)
  );
end switchElementare;

architecture Structural of switchElementare is

  -- Componente MUX 2:1
  component MUX_2_1 is 
    Port(
        A : in STD_LOGIC_VECTOR(1 downto 0);   -- Ingresso A
        B : in STD_LOGIC_VECTOR(1 downto 0);   -- Ingresso B
        enable : in STD_LOGIC;                  -- Segnale di abilitazione
        S : in STD_LOGIC;                       -- Selezione
        Y : out STD_LOGIC_VECTOR(1 downto 0)    -- Uscita
    );
  end component; 

  -- Componente DEMUX 1:2
  component DEM1_2 is
    Port(
        A : in STD_LOGIC_VECTOR(1 downto 0);   -- Ingresso
        S1 : in STD_LOGIC;                      -- Selezione
        enable : in STD_LOGIC;                  -- Segnale di abilitazione
        Y0: out STD_LOGIC_VECTOR(1 downto 0);   -- Uscita 0
        Y1: out STD_LOGIC_VECTOR(1 downto 0)    -- Uscita 1
    ); 
  end component;

  -- Segnale intermedio per connettere MUX e DEMUX
  Signal mid_sig : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

begin

  -- Istanziazione del MUX 2:1
  mux : MUX_2_1 
    Port map ( 
        A => i1, 
        B => i2,
        enable => enable,
        S => s_sorg, 
        Y => mid_sig
    ); 

  -- Istanziazione del DEMUX 1:2
  demux : DEM1_2  
    Port map( 
        A => mid_sig,         -- Segnale intermedio proveniente dal MUX
        S1 => s_dest,         -- Selezione della destinazione
        enable => enable,     -- Abilitazione
        Y0 => u1,             -- Uscita 1
        Y1 => u2              -- Uscita 2
    );

end Structural;
