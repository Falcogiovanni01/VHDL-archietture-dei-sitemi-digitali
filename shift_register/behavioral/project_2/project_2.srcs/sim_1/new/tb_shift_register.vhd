----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2024 11:40:19
-- Design Name: 
-- Module Name: tb_shift_register_M1_Y0 - Behavioral
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

entity tb_shift_register_M1_Y0 is
end tb_shift_register_M1_Y0;

architecture sim of tb_shift_register_M1_Y0 is
    constant N : integer := 4;
    signal clk, rst, M, Y, X : std_logic := '0';
    signal output : std_logic;
    signal temp_out : std_logic_vector(N-1 downto 0);  -- Per monitorare il registro interno

    component shift_register is
        generic (N : integer := 4);
        port (
            Y : in std_logic;
            M : in std_logic;
            X : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            output : out std_logic;
            temp_out : out std_logic_vector(N-1 downto 0)  -- Debug
        );
    end component;

   
begin
    uut: shift_register
        generic map (N => N)
        port map (Y => Y, M => M, X => X, clk => clk, rst => rst, output => output, temp_out => temp_out);

    clk_process: process
    begin
        while true loop
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
        end loop;
    end process;

    stimulus: process
    begin
        rst <= '1'; wait for 20 ns; rst <= '0'; -- Reset
        Y <= '0'; M <= '1'; -- Shift di 1 verso sinistra
        X <= '1'; wait for 20 ns;
        X <= '0'; wait for 20 ns;
        X <= '1'; wait for 20 ns;
        
        wait for 20ns;
        
        rst <= '1'; wait for 20 ns; rst <= '0';
        Y <= '0'; M <= '0';
        X <= '1'; wait for 20 ns;
        X <= '0'; wait for 20 ns;
        X <= '1'; wait for 20 ns;
        wait;
    end process;
end sim;