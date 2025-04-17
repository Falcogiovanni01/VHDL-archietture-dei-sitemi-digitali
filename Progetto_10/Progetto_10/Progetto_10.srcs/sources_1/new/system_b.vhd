----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2024 11:51:36
-- Design Name: 
-- Module Name: system_b - Behavioral
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

entity system_b is
    Port (  clock : in STD_LOGIC; -- Clock di sistema
            reset : in STD_LOGIC; -- Reset esterno
            RX : in STD_LOGIC; -- Segnale di ricezione, da mandare a system_a
            TX : out STD_LOGIC; -- Segnale di invio, da ricevere da system_a
            error : out STD_LOGIC; -- Segnale che avvisa della presenza di errori
            data_out : out STD_LOGIC_VECTOR (7 downto 0)); -- Dato salvato in memoria
end system_b;

architecture structural of system_b is

    component control_unit_b is
        Port (  RDA: in STD_LOGIC; -- Segnale di lettura disponibile
                OE: in STD_LOGIC; -- Errore di overrun
                PE: in STD_LOGIC; -- Errore di parità
                FE : in STD_LOGIC; -- Errore di framing
                clock : in STD_LOGIC; -- Clock di sistema
                reset : in STD_LOGIC; -- Reset di sistema
                c_enable : out STD_LOGIC; -- Abilitatore del counter
                RD : out STD_LOGIC; -- Segnale di conferma lettura del dato
                write : out STD_LOGIC; -- Abilitazione al salvataggio del dato
                error : out STD_LOGIC); -- Segnalazione degli errori
    end component;
    
    component clock_divider is
         generic(
            clock_frequency_in : integer := 100000000; -- Frequenza di Clock in ingresso: di default è quello della board (100MHz)
            clock_frequency_out : integer := 500); -- Frequenza di Clock in uscita: di default è 500Hz
        Port ( clock_in : in  STD_LOGIC; -- Clock in ingresso
               reset : in STD_LOGIC; -- Segnale di reset
               clock_out : out  STD_LOGIC); -- Clock "rallentato" in uscita
    end component;
    
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

    component MEM is
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
    end component;
    
    component Rs232RefComp is
        Port ( 
            TXD 	: out std_logic  	:= '1';
            RXD 	: in  std_logic;					
            CLK 	: in  std_logic;					--Master Clock
            DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
            DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
            RDA	: inout std_logic;						--Read Data Available(1 quando il dato Ã¨ disponibile nel registro rdReg)
            TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare Ã¨ stato caricato nello shift register)
            RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
            WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
            PE		: out std_logic;					--Parity Error Flag
            FE		: out std_logic;					--Frame Error Flag
            OE		: out std_logic;					--Overwrite Error Flag
            RST		: in  std_logic	:= '0');			--Master Reset
    end component;

    signal RDA : STD_LOGIC; -- Segnale di ricevimento dati
    signal OE, PE, FE : STD_LOGIC; -- Segnali di errore ricevimento dati (Overrun, Parity, Framing)
    signal count_enable : STD_LOGIC; -- Segnale che abilita il contatore
    signal RD : STD_LOGIC; -- Segnale di abilitazione alla lettura del dato ricevuto
    signal write_sig : STD_LOGIC; -- Segnale di abilitazione alla scrittura su memoria
    signal error_sig : STD_LOGIC; -- Segnale di conferma presenza errori
    signal sys_clock : STD_LOGIC; -- Clock del sistema "rallentato" dal divider
    signal address : STD_LOGIC_VECTOR(2 downto 0); -- Indirizzo di memoria su cui scrivere
    signal data_sig : STD_LOGIC_VECTOR(7 downto 0); -- Dato da scrivere in memoria

begin

    error <= '1' when error_sig = '1' else '0' when reset = '1'; -- Impostiamo a 0 il segnale di errore nel caso in cui il reset è alto
    
    -- Control Unit del sistema B
    cu_b : control_unit_b port map(
        RDA => RDA,
        OE => OE,
        PE => PE,
        FE => FE,
        clock => sys_clock,
        reset => reset,
        c_enable => count_enable,
        RD => RD,
        write => write_sig,
        error => error_sig);
        
    -- Contatore degli indirizzi nella ROM
    cnt_b : gen_counter generic map(
        size => 3,
        module => 8)
        Port map ( 
            clock => count_enable,
            reset => reset,
            enable => '1',
            set => '0',
            value => (others => '0'),
            counter => address);
        
    -- Clock Divider: le specifiche Diligent raccomandano 50MHz (il clock della macchina è 100MHz)
    div : clock_divider generic map(
        clock_frequency_in => 100000000,
        clock_frequency_out => 50000000)
        Port map (
            reset => reset,
            clock_in => clock,
            clock_out => sys_clock);
       
    -- Memoria scrivibile del sistema
    memory : MEM generic map(
        Mem_size => 8,
        Addr_size => 3,
        Data_size => 8)
        port map(
            write => write_sig,
            read => write_sig, -- Leggiamo assieme alla scrittura
            reset => reset,
            data_in => data_sig,
            addr => address,
            data_out => data_out);
        
    -- Dispositivo UART-RS232     
    UART : Rs232RefComp port map(
        TXD => TX,
        RXD => RX,                                      
        CLK => sys_clock,
        DBIN => (others=> '-'),
        DBOUT => data_sig,
        RDA => RDA,
        RD => RD,
        WR => '0',
        PE => PE,
        OE => OE,
        FE => FE,
        RST => reset);

end structural;
