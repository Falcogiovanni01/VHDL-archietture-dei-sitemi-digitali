----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2024 13:07:11
-- Design Name: 
-- Module Name: shift_register - Behavioral
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

entity shift_register is
    Generic(
        Size : positive := 4); -- Dimensione del registro (con valore predefinito in modo da rappresentarne la schematic)
    Port(
        value_in : in STD_LOGIC; -- Valore da inserire una o due volte
        data_in : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Registro su cui inserire il valore
        load : in STD_LOGIC; -- Abilitazione del caricamento su registro
        clock : in STD_LOGIC; -- Segnale di tempificazione
        shift_en : in STD_LOGIC; -- Segnale di abilitazione allo shift effettivo
        direction : in STD_LOGIC; -- Direzione dello shift ('0' se destra, '1' se sinistra)
        length : in STD_LOGIC; -- Numero di inserimenti ('0' un inserimento, '1' due inserimenti)
        data_out : out STD_LOGIC_VECTOR(Size-1 downto 0)); -- Valore (o coppia di valori) che esce dal registro dopo lo shift  
end shift_register;

architecture Structural of shift_register is

    component gen_mux_2_1 is
        Generic( Size : natural); -- Dimensione dei dati
        Port ( a0 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 1
               a1 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 2
               en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando � '1'
               s : in STD_LOGIC; -- Segnale di Selezione dell'Input
               y : out STD_LOGIC_VECTOR(Size-1 downto 0)); -- Output
    end component;
    
    component mux_4_1 is
        Port ( a : in STD_LOGIC_VECTOR (3 downto 0); -- I 4 Input, in un vettore
               en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando � '1'
               s : in STD_LOGIC_VECTOR (1 downto 0); -- Segnali codificati di Selezione dell'Input
               y : out STD_LOGIC); -- Output
    end component;
    
    component flip_flop_d is
        Port ( d : in STD_LOGIC; -- Dato di ingresso
               enable : in STD_LOGIC; -- Segnale di abilitazione alla lettura di d, spesso tempificato
               q : out STD_LOGIC); -- Dato salvato in uscita
    end component;

    type mux_4_data IS ARRAY (Size-1 downto 0) of STD_LOGIC_VECTOR(3 downto 0); -- Definiamo un typedef per un array di vettori per i vari multiplexer 4:1
    signal mux_in : mux_4_data; -- Definiamo tale array, dove terremo i vari valori con cui sar� possibile sostituire in shift il dato originale

    signal clock_ff : STD_LOGIC; -- Segnale che abilita i flip flop
    signal ff_in : STD_LOGIC_VECTOR(Size-1 downto 0); -- Dato temporaneo in ingresso al flip-flop (deciso da mux_in)
    signal ff_out : STD_LOGIC_VECTOR(Size-1 downto 0); -- Dato temporaneo in uscita dal flip-flop (sar� sia rielaborato che l'output)
    signal data_tmp : STD_LOGIC_VECTOR(Size-1 downto 0); -- Dato temporaneo su cui salvare in caso di doppio shift (serve rifare l'operazione)
    
begin
    
    data_out <= ff_out; -- Salvataggio dell'output
    clock_ff <= clock AND shift_en; -- I flip flop devono essere si tempificati, ma anche attivi solo in fase di shift

    -- Siccome la dimensione dei dati � generic, ci serve un numero variabile di componenti: ne dichiareremo alcuni per ogni bit
    component_manager: for i in Size-1 downto 0 generate
        
        -- Un Multiplexer 4:1 si occupa di selezionare la modalit� di shift, fornendo il dato che poi sostituiremo
        shifter_mux: mux_4_1 port map(
            a => mux_in(i), -- a(0): shift di 1 a destra, a(1): shift di 2 a destra, a(2): shift di 1 a sinistra, a(3): shift di 2 a sinistra
            en => '1', -- Abilitazione perennemente attiva
            s(0) => length, -- Permette di scegliere fra a(0)/a(2) o a(1)/a(3) 
            s(1) => direction, -- Permette di scegliere fra a(0)/a(1) o a(2)/a(3)
            y => data_tmp(i)); -- Questo sar� il dato con il quale si effettuer� la sostituzione
    
        -- Un Multiplexer 2:1 che permette una modifica dei dati solo quando si ha un'abilitazione
        loader_mux: gen_mux_2_1 generic map(Size => 1)
            port map(
                a0(0) => data_in(i), -- In caso di non shift il dato in uscita deve essere quello originale
                a1(0) => data_tmp(i), -- In caso di shift si avr� il nuovo dato, proveniente dal multiplexer 4:1
                en => '1', -- Abilitazione perennemente attiva
                s => load, -- Il load funge da selezione
                y(0) => ff_in(i)); -- L'uscita sar� ci� che effettivamente entrer� nel flip flop, o il dato originale o lo shiftato
               
        -- Un Flip-Flop D che sovrascrive i registri         
        ff_gen: flip_flop_d port map(
            d => ff_in(i), -- Dato in ingresso
            enable => clock, -- Abilitazione tempificata dal clock
            q => ff_out(i)); -- Dato modificato

    end generate;

    -- Dobbiamo specificare agli shifter_mux cosa sostituire: dipender� dalla Size 
    linkage_2 : if (Size = 2) generate
        msb: mux_in(1) <= value_in & ff_out(0) & value_in & value_in;
        lsb: mux_in(0) <= value_in & value_in & value_in & ff_out(1); 
    end generate;
    
    -- Altro caso particolare, dove esiste anche un valore intermedio
    linkage_3 : if (Size = 3) generate
        msb: mux_in(2) <= ff_out(0) & ff_out(1) & value_in & value_in;
        middle_bit: mux_in(1) <= value_in & ff_out(0) & value_in & ff_out(2);
        lsb: mux_in(0) <= value_in & value_in & ff_out(2) & ff_out (1);
    end generate;

    -- Caso generale: i quattro estremi sono sempre gli stessi e gli eventuali intermedi sono ricorsivi
    linkage_size: if (Size > 3) generate
        msb: mux_in(Size-1) <= ff_out(Size-3) & ff_out(Size-2) & value_in & value_in;
        msb_min : mux_in(Size-2) <= ff_out(Size-4) & ff_out(Size-3) & value_in & ff_out(Size-1);
        middle_bits: for i in Size-3 downto 2 generate
            mux_in(i) <= ff_out(i-2) & ff_out(i-1) & ff_out(i+2) & ff_out(i+1);
        end generate;
        lsb_max : mux_in(1) <= value_in & ff_out(0) & ff_out(3) & ff_out(2);
        lsb : mux_in(0) <= value_in & value_in & ff_out(2) & ff_out(1);
    end generate;

end Structural;


architecture Behavioral of shift_register is

    signal data_tmp : STD_LOGIC_VECTOR(Size-1 downto 0);  -- Registro temporaneo per sostituire
    
begin
    
    data_out <= data_tmp; -- Sovrascrittura dell'Output
    
    main: process(clock) -- Processo tempificato
        begin
            if (rising_edge(clock)) then
                -- Caricamento del dato
                if (load = '1') then    
                    data_tmp <= data_in;
                -- Operazione di shift
                elsif (shift_en = '1') then
                    -- Le varie situazioni di shift
                    if (length = '0' AND direction = '0') then
                        data_tmp <= value_in & data_tmp (Size-1 downto 1);
                    elsif (length = '0' AND direction = '1') then
                        data_tmp <= data_tmp(Size-2 downto 0) & value_in;
                    elsif (length = '1' AND direction = '0') then
                        data_tmp <= value_in & value_in & data_tmp (Size-1 downto 2);
                    else 
                        data_tmp <= data_tmp(Size-3 downto 0) & value_in & value_in;
                    end if;
                end if;
            end if;                                              
        end process;            

end Behavioral;

