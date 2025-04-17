----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2024 11:51:36
-- Design Name: 
-- Module Name: system_a - Behavioral
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

entity system_a is
    Port (  start : in STD_LOGIC; -- Start esterno
            reset : in STD_LOGIC; -- Reset esterno
            clock : in STD_LOGIC; -- Clock
            RX : in std_logic; -- Segnale di ricezione, ricevuto da system_b
            TX : out std_logic); -- Segnale di invio, da mandare a system_b
end system_a;

architecture structural of system_a is

    component control_unit_a is
            Port (  TBE : in STD_LOGIC; -- Richiesta di dati da inviare
                    start : in STD_LOGIC; -- Start esterno
                    clock : in STD_LOGIC; -- Clock di sistema
                    reset : in STD_LOGIC; -- Reset di sistema
                    WR : out STD_LOGIC; -- Abilitazione all'invio dati
                    read : out STD_LOGIC; -- Abilitazione alla lettura su ROM
                    c_enable : out STD_LOGIC); -- Abilitazione del contatore
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
    
    component ROM_8x8 is
        Port ( reset : in STD_LOGIC; -- Input di reset
               read : in STD_LOGIC; -- Abilitazione alla lettura
               addr : in STD_LOGIC_VECTOR (2 downto 0); -- Input di indirizzamento
               data : out STD_LOGIC_VECTOR (7 downto 0)); -- Dato letto in Output
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

    signal tbe_sig : STD_LOGIC := '0'; -- Segnale TBE per la richiesta di dati da inviare
    signal wr_sig : STD_LOGIC := '0'; -- Segnale di abilitazione all'invio dati
    signal count_enable : STD_LOGIC := '0'; -- Segnale di abilitazione del contatore
    signal read_sig : STD_LOGIC := '0'; -- Segnale che abilita la lettura nella ROM
    signal sys_clock : STD_LOGIC := '0'; -- Clock "rallentato" dal divider
    signal address : std_logic_vector(2 downto 0); -- Indirizzo della locazione di memoria
    signal data_sig : std_logic_vector(7 downto 0); -- Dato da trasferire
    
begin

    -- ROM del Sistema A
    mem_rom : ROM_8x8 port map (       
        reset => reset, 
        read => read_sig,
        addr => address,
        data => data_sig);
    
    -- Control Unit del sistema A
    cu_a : control_unit_a Port map (
        TBE => tbe_sig,
        start => start,
        clock => sys_clock,
        reset => reset,
        WR => wr_sig,
        read => read_sig,
        c_enable => count_enable);
        
    -- Contatore degli indirizzi nella ROM
    cnt_a : gen_counter generic map(
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
        
    -- Dispositivo UART-RS232
    uart :  Rs232RefComp
     port map (
        TXD 	=> TX,
    	RXD 	=> RX,				
    	CLK 	=> sys_clock,
		DBIN 	=> data_sig,
		TBE	    => tbe_sig,				
		RD		=> '-',	-- system_a non deve leggere, ma solo inviare dati			
		WR		=> wr_sig,									
		RST	    => reset);

end structural;
