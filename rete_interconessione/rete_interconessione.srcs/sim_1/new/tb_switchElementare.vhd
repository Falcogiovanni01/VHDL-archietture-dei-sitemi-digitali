----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2025 12:05:26
-- Design Name: 
-- Module Name: tb_switchElementare
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for switchElementare module
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

entity tb_switchElementare is
end tb_switchElementare;

architecture behavior of tb_switchElementare is

    -- Component declaration for the Unit Under Test (UUT)
    component switchElementare
        Port(
            i1 : in std_logic_vector(1 downto 0);
            i2 : in std_logic_vector(1 downto 0); 
            s_sorg : in std_logic; 
            s_dest : in std_logic; 
            enable : in std_logic;  
            u1 : out std_logic_vector(1 downto 0); 
            u2 : out std_logic_vector(1 downto 0) 
        );
    end component;

    -- Signal declarations
    signal i1 : std_logic_vector(1 downto 0) := (others => '0');
    signal i2 : std_logic_vector(1 downto 0) := (others => '0');
    signal s_sorg : std_logic := '0';
    signal s_dest : std_logic := '0';
    signal enable : std_logic := '0';
    signal u1 : std_logic_vector(1 downto 0) := (others => '0');
    signal u2 : std_logic_vector(1 downto 0) := (others => '0');

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: switchElementare
        Port map(
            i1 => i1,
            i2 => i2,
            s_sorg => s_sorg,
            s_dest => s_dest,
            enable => enable,
            u1 => u1,
            u2 => u2
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Test with enable = 0 (should keep both outputs 'U')
        enable <= '0';
        i1 <= "01"; i2 <= "00"; s_sorg <= '0'; s_dest <= '0';
        wait for 10 ns;

        -- Test case 2: Test with enable = 1, selecting input i1 with s_sorg = 0, and s_dest = 0 (should output to u1)
        enable <= '1';
        s_sorg <= '0'; s_dest <= '0'; -- select i1 to u1
        -- OUTPUT: U1 = 01, U2 = 00
        wait for 10 ns;

        -- Test case 3: Test with enable = 1, selecting input i2 with s_sorg = 1, and s_dest = 0 (should output to u2)
        s_sorg <= '1'; -- select i2
        -- OUTPUT: U1 = 00, U2 = 00
        wait for 10 ns;

        -- Test case 4: Test with enable = 1, selecting input i1 with s_sorg = 0, and s_dest = 1 (should output to u2)
        s_sorg <= '0'; s_dest <= '1'; -- select i1 to u2
        -- OUTPUT: U1 = 00, U2 = 01
        wait for 10 ns;

        -- Test case 5: Test with enable = 1, selecting input i2 with s_sorg = 1, and s_dest = 1 (should output to u1)
        s_sorg <= '1'; s_dest <= '1'; -- select i2 to u1
        -- OUTPUT: U1 = 00, U2 = 00
        wait for 10 ns;

        -- Test case 6: Test with both inputs i1 and i2 as '1' and enable = 1, selecting i1 (s_sorg = 0) to u1, s_dest = 0
        i1 <= "11"; i2 <= "11";
        enable <= '1'; s_sorg <= '0'; s_dest <= '0';
        -- OUTPUT: U1 = 11, U2 = 00
        wait for 10 ns;

        -- Test case 7: Test with enable = 0 (both outputs should still be 'U')
        enable <= '0';
        wait for 10 ns;

        -- Test case 8: Test with both inputs i1 and i2 as '1' and enable = 1, selecting i1 (s_sorg = 0) to u1, s_dest = 1
        i1 <= "11"; i2 <= "11";
        enable <= '1'; s_sorg <= '0'; s_dest <= '1';
        -- OUTPUT: U1 = 00, U2 = 11
        wait for 10 ns;

        -- End of simulation
        wait;
    end process;
end behavior;
