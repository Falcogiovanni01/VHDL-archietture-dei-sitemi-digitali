----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:10:42
-- Design Name: 
-- Module Name: Cronometro - Behavioral
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
use IEEE.MATH_REAL.ALL;

entity Cronometro is
    Port ( 
        I_CRN : in std_logic_vector(5 DOWNTO 0);
        EN_CRN : in std_logic;
        SET_CRN : in std_logic_vector(2 DOWNTO 0);
        RST_CRN : in std_logic;
        CLK_CRN : in std_logic;
        DIV_CRN : out std_logic;
        OUTPUT : out std_logic_vector(16 DOWNTO 0)    
    );
end Cronometro;

architecture Structural of Cronometro is
component Cont_mod_N is
    generic (N : in integer);
    Port ( 
        I : in std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0);
        enable : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        div : out std_logic;
        cont : out std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0)
    );
end component;
signal out_cnt : std_logic_vector(2 DOWNTO 0) := (others => '0');
signal out_and : std_logic_vector(1 DOWNTO 0) := (others => '0');
begin
    cont_sec : Cont_mod_N
        Generic map(
            N => 60
        )
        Port map(
            I => I_CRN,
            enable => EN_CRN,
            reset => RST_CRN,
            set => SET_CRN(0),
            clk => CLK_CRN,
            div => out_cnt(0),
            cont => OUTPUT(5 DOWNTO 0)
        );
        out_and(0) <= CLK_CRN and out_cnt(0);
        
      cont_min : Cont_mod_N
        Generic map(
            N => 60
        )
        Port map(
            I => I_CRN,
            enable => EN_CRN,
            reset => RST_CRN,
            set => SET_CRN(1),
            clk => out_and(0),
            div => out_cnt(1),
            cont => OUTPUT(11 DOWNTO 6)
        );
        out_and(1) <= out_and(0) and out_cnt(1);
       
       cont_hour : Cont_mod_N
        Generic map(
            N => 24
        )
        Port map(
            I => I_CRN(4 DOWNTO 0),
            enable => EN_CRN,
            reset => RST_CRN,
            set => SET_CRN(2),
            clk => out_and(1),
            div => out_cnt(2),
            cont => OUTPUT(16 DOWNTO 12)
        );
        DIV_CRN <= out_cnt(2) and (out_cnt(1) and out_cnt(0));
end Structural;
