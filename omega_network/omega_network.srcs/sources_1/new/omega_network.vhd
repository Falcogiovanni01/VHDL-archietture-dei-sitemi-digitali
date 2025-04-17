----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2025 15:14:41
-- Design Name: 
-- Module Name: omega_network - Structural
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


entity omega_network is
 Port (
     -- input
     data_in_0 : in STD_LOGIC_VECTOR(1 downto 0); -- dato in ingresso nella prima posizione sorgente
     data_in_1 : in STD_LOGIC_VECTOR(1 downto 0); -- seconda
     data_in_2 : in STD_LOGIC_VECTOR(1 downto 0); -- terza
     data_in_3 : in STD_LOGIC_VECTOR(1 downto 0); -- quarta
     -- selezione
     src : in STD_LOGIC_VECTOR(1 downto 0); -- sorgente in ingresso allo switch
     dst : in STD_LOGIC_VECTOR(1 downto 0);-- destinazione di uscita
     -- output
     data_out_0 : out STD_LOGIC_VECTOR(1 downto 0);
     data_out_1 : out STD_LOGIC_VECTOR(1 downto 0); 
     data_out_2 : out STD_LOGIC_VECTOR(1 downto 0); 
     data_out_3 : out STD_LOGIC_VECTOR(1 downto 0) 
      
 
 
  );
end omega_network;

architecture Structural of omega_network is

    component control_unit 
        port (
        s0 : in std_logic; -- bit meno significiativo nel segnale di sorgente
        d1 : in std_logic; -- bit più significativo nel segnale di destinazione
        enable : out std_logic_vector( 3 downto 0)  
  
       ); 
       end component; 
       
     component switchElementare 
        port(
          i1 : in std_logic_vector(1 downto 0);
          i2 : in std_logic_vector(1 downto 0);          
          s_sorg : in std_logic;         
          s_dest : in std_logic;          
          enable : in std_logic;         
          u1 : out std_logic_vector(1 downto 0); 
          u2 : out std_logic_vector(1 downto 0) 
  
        );
        end component; 
        
signal switch_0_to_2 : STD_LOGIC_VECTOR(1 downto 0) := ( others=>'0'); -- segnale di intermezzo dallo switch 0 al 2
signal switch_0_to_3 : STD_LOGIC_VECTOR(1 downto 0) := ( others=>'0'); -- dallo 0 al tre
signal switch_1_to_2 : STD_LOGIC_VECTOR(1 downto 0) := ( others=>'0');-- dal 1 al due
signal switch_1_to_3 : STD_LOGIC_VECTOR(1 downto 0) := ( others=>'0');-- dal 1 al 3
signal enable_sig : STD_LOGIC_VECTOR(3 downto 0) := ( others=>'0'); -- mappatura enable


begin

    cu : control_unit 
        port map(
            s0 => src(0),
            d1 => dst(1),
            enable =>enable_sig
            );
            
    switch_0 : switchElementare
        port map(
            enable => enable_sig(0),
            i1 => data_in_0, 
            i2 => data_in_2, 
            s_sorg => src(1),
            s_dest => dst(1),
            u1 => switch_0_to_2,
            u2 => switch_0_to_3
          );
          
      switch_1 : switchElementare
        port map(
            enable => enable_sig(1),
            i1 => data_in_1, 
            i2 => data_in_3, 
            s_sorg => src(1),
            s_dest => dst(1),
            u1 => switch_1_to_2,
            u2 => switch_1_to_3
          );
          
    switch_2 : switchElementare
        port map(
            enable => enable_sig(2),
            i1 => switch_0_to_2, 
            i2 => switch_1_to_2, 
            s_sorg => src(0),
            s_dest => dst(0),
            u1 => data_out_0,
            u2 => data_out_1
          );
          
    switch_3 : switchElementare
        port map(
            enable => enable_sig(3),
            i1 => switch_0_to_3, 
            i2 => switch_1_to_3, 
            s_sorg => src(0),
            s_dest => dst(0),
            u1 => data_out_2,
            u2 => data_out_3
          );

end Structural;
