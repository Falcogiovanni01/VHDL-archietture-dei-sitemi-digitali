----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 16:52:28
-- Design Name: 
-- Module Name: chronometer - Structural
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

entity chronometer is
    Port ( 
        clock : in STD_LOGIC; -- Clock del cronometro (in un contesto standard deve essere 1Hz)
        reset : in STD_LOGIC; -- Segnale di reset
        set_sec : in STD_LOGIC; -- Abilitazione alla sovrascrittura dei secondi
        set_min : in STD_LOGIC; -- Abilitazione alla sovrascrittura dei minuti
        set_hour : in STD_LOGIC; -- Abilitazione alla sovrascrittura delle ore
        in_sec : in STD_LOGIC_VECTOR (5 downto 0); -- Dato di sovrascrittura dei secondi
        in_min : in STD_LOGIC_VECTOR (5 downto 0); -- Deto di sovrascrittura dei minuti
        in_hour : in STD_LOGIC_VECTOR (4 downto 0); -- Dato di sovrascrittura delle ore
        out_sec : out STD_LOGIC_VECTOR (5 downto 0); -- Secondi in Output
        out_min : out STD_LOGIC_VECTOR (5 downto 0); -- Minuti in Output
        out_hour : out STD_LOGIC_VECTOR (4 downto 0)); -- Ore in Output
end chronometer;

architecture Structural of chronometer is

    component gen_counter is
        generic(
                size   : natural; -- Numero di bit usati
                module : natural  -- Modulo (deve essere minore o uguale di 2^size)
        );
        port ( clock   : in  STD_LOGIC; -- Segnale di clock
               reset   : in  STD_LOGIC; -- Segnale di reset
               enable  : in  STD_LOGIC; -- Segnale di abilitazione
               set     : in  STD_LOGIC; -- Permette di settare un valore stabilito
               value   : in  STD_LOGIC_VECTOR(size-1 downto 0); -- Valore stabilito
               counter : out STD_LOGIC_VECTOR(size-1 downto 0)); -- Dato del counter in uscita
    end component;
    
    signal sig_sec : STD_LOGIC_VECTOR (5 downto 0); -- Segnale temporaneo per i secondi (serve per abilitare il minuto)
    signal sig_min : STD_LOGIC_VECTOR (5 downto 0); -- Segnale temporaneo per i minuti (serve per abilitare l'ora)

    signal en_min : STD_LOGIC; -- Abilitazione allo scandire del minuto
    signal en_hour : STD_LOGIC; -- Abilitazione allo scandire dell'ora

begin  
    
    -- Contatore dei secondi, tempificato dal clock
    cnt_sec: gen_counter generic map(
        size => 6,
        module => 60)
        port map(
            clock => clock,
            reset => reset,
            enable => '1', -- Sempre abilitato, è solo scandito dal clock
            set => set_sec,
            value => in_sec,
            counter => sig_sec);    

    out_sec <= sig_sec; -- Sovrascriviamo i secondi in uscita

    -- Funzione che si occupa di aggiornare il minuto ogni 60 secondi
    min_manager: process(clock, sig_sec)
    begin
        if(rising_edge(clock)) then
            if(sig_sec = "111010") then 
                en_min <= '1';
            else
                en_min <= '0';
            end if;
        end if;       
    end process;      
    
    -- Contatore dei minuti, tempificato dall'enable (ogni 60 secondi)
    cnt_min: gen_counter generic map(
        size => 6,
        module => 60)
        port map(
            clock => clock,
            reset => reset,
            enable => en_min,
            set => set_min,
            value => in_min,
            counter => sig_min);      

    out_min <= sig_min; -- Sovrascriviamo i minuti in uscita

    -- Funzione che si occupa di aggiornare l'ora ogni 60 minuti (al secondo 59)
    hour_manager: process(clock, sig_min, sig_sec)
    begin
        if(rising_edge(clock)) then
            if(sig_sec = "111010" AND sig_min = "111011") then -- L'abilitazione avviene solo quando si ha anche il secondo 59
                en_hour <= '1';
            else
                en_hour <= '0';
            end if;
        end if;        
    end process;   

    -- Contatore delle ore, tempificato dall'enable (ogni 60 minuti)
    cnt_hour: gen_counter generic map(
        size => 5,
        module => 24)
        port map(
            clock => clock,
            reset => reset,
            enable => en_hour,
            set => set_hour,
            value => in_hour,
            counter => out_hour);     
            
end Structural;
