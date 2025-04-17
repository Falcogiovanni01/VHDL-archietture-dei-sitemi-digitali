----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2024 20:14:12
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Generic ( 
        Mem_size : positive; -- Numero di locazioni di memoria
        Addr_size : positive; -- Numero di bit per l'indirizzo (Mem_size può essere al più 2^Addr_size)
        Data_size : positive); -- Dimensione dei dati in memoria
    Port ( reset : in STD_LOGIC; -- Input di reset
           data_in : in STD_LOGIC_VECTOR (Data_size-1 downto 0); -- Dato fornito in ingresso
           addr : in STD_LOGIC_VECTOR (Addr_size-1 downto 0); -- Input di indirizzamento
           write : in STD_LOGIC; -- Abilitazione alla scrittura
           read : in STD_LOGIC; -- Abilitazione alla lettura
           data_out : out STD_LOGIC_VECTOR (Data_size-1 downto 0)); -- Dato letto in Output
end MEM;

architecture Behavioral of MEM is

    signal tmp : STD_LOGIC_VECTOR (Data_size-1 downto 0) := (others => '0'); -- Dato temporaneo

    type mem_type is array (Mem_size-1 downto 0) of std_logic_vector(Data_size-1 downto 0); -- Definiamo un array di vettori
    signal data : mem_type := (others => (others => '0')); -- Definiamo la memoria (inizializzata a 0)

begin

    data_out <= tmp;
        
    process(reset, write, read)
        variable index: integer := 0;
        begin
            if (reset = '1') then
                data <= (others => (others => '0'));
                index := 0;
            elsif(unsigned(addr) < Mem_size) then
                index := to_integer(unsigned(addr));
                -- Caso di scrittura
                if (write = '1') then
                    data(index) <= data_in;
                    -- Caso di lettura immediata (Read AND Write = '1')
                    if (read = '1') then
                        tmp <= data_in;
                    end if;
                -- Caso di lettura
                elsif (read = '1') then
                    tmp <= data(index);
                end if;                    
            end if;
        end process;

end Behavioral;
