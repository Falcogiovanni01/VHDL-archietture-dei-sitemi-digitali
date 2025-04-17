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

entity gen_mux_2_1 is
    Generic( Size : natural); -- Dimensione dei dati
    Port ( a0 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 1
           a1 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 2
           en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando si ha '1'
           s : in STD_LOGIC; -- Segnale di Selezione dell'Input
           y : out STD_LOGIC_VECTOR(Size-1 downto 0)); -- Output
end gen_mux_2_1;

architecture Behavioral of gen_mux_2_1 is

begin

    main: process (a0, a1, en, s) -- Processo che si avvia a variazioni degli input o di en o s (sensibility list)
    begin 
        if (en = '1') then -- Abilitazione
            if (s = '0') then  -- Ingresso 0 selezionato
                y <= a0;
            else  -- Ingresso 1 selezionato
                y <= a1;         
            end if;
        end if;
    end process;

end Behavioral;
