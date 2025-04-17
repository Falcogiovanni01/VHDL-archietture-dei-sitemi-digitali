----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 16:13:25
-- Design Name: 
-- Module Name: ROM_8x8 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_8x8 is
    Port ( reset : in STD_LOGIC; -- Input di reset
           read : in STD_LOGIC; -- Abilitazione alla lettura
           addr : in STD_LOGIC_VECTOR (2 downto 0); -- Input di indirizzamento
           data : out STD_LOGIC_VECTOR (7 downto 0)); -- Dato letto in Output
end ROM_8x8;

architecture Behavioral of ROM_8x8 is

    type rom_type is array (7 downto 0) of std_logic_vector(7 downto 0); -- Definiamo un array di vettori
    
    -- Inizializziamo la rom
    constant ROM : rom_type := (         
            0  => "00001001",
            1  => "10110011",
            2  => "10101001",
            3  => "11111001",
            4  => "10001000",
            5  => "10101001",
            6  => "00010110",
            7  => "10111100");

begin

    main: process(reset, read, addr)
        begin
            -- Situazione di reset
            if (reset = '1') then
                data <= ROM(0);
            -- Situazione di lettura
            elsif (read = '1') then
                data <= ROM(to_integer(unsigned(addr)));
            end if;
        end process;

end Behavioral;
