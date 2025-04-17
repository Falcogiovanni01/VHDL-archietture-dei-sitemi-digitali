----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 17:46:31
-- Design Name: 
-- Module Name: chrono_display - Structural
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

entity chrono_display is
    Port (
        clock : in STD_LOGIC; -- Clock della board, fornito dai constraint
        reset : in STD_LOGIC; -- Pulsanti di reset
        shift : in STD_LOGIC; -- Pulsante che abilita lo shift degli indirizzi di memoria
        read_sw : in STD_LOGIC; -- Switch che abilita la lettura
        write_sw : in STD_LOGIC; -- Switch che abilita la scrittura
        set_sec : in STD_LOGIC; -- Pulsante che abilita la sovrascrittura dei secondi
        set_min : in STD_LOGIC; -- Pulsante che abilita la sovrascrittura dei minuti
        set_hour : in STD_LOGIC; -- Pulsante che abilita la sovrascrittura delle ore
        value6_in : in STD_LOGIC_VECTOR (5 downto 0); -- Dati letti da sei switch per secondi, minuti o ore
        led : out STD_LOGIC_VECTOR (2 downto 0);  -- Led che indica l'indirizzo della memoria (per semplificare lo shift di indirizzo all'utente)
        anodes : out  STD_LOGIC_VECTOR (7 downto 0); -- Cifre su display
        cathodes : out STD_LOGIC_VECTOR (7 downto 0)); -- Segmenti delle cifre su display
end chrono_display;

architecture Structural of chrono_display is

    component display_seven_segments is
        Generic(    
           CLKIN_freq : integer := 100000000; 
           CLKOUT_freq : integer := 500);
        Port ( CLK : in  STD_LOGIC;
               RST : in  STD_LOGIC;
               VALUE : in  STD_LOGIC_VECTOR (31 downto 0);
               ENABLE : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali cifre abilitare
               DOTS : in  STD_LOGIC_VECTOR (7 downto 0); -- decide quali punti visualizzare
               ANODES : out  STD_LOGIC_VECTOR (7 downto 0);
               CATHODES : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component chronometer is
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
    end component;
    
    component clock_divider is
         generic(
            clock_frequency_in : integer := 100000000; -- Frequenza di Clock in ingresso: di default è quello della board (100MHz)
            clock_frequency_out : integer := 500); -- Frequenza di Clock in uscita: di default è 500Hz
        Port ( clock_in : in  STD_LOGIC; -- Clock in ingresso
               reset : in STD_LOGIC; -- Segnale di reset
               clock_out : out  STD_LOGIC); -- Clock "rallentato" in uscita
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
    
    component gen_mux_2_1 is
        Generic( Size : natural); -- Dimensione dei dati
        Port ( a0 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 1
               a1 : in STD_LOGIC_VECTOR(Size-1 downto 0); -- Input 2
               en : in STD_LOGIC; -- Segnale di Enable: l'output cambia quando si ha '1'
               s : in STD_LOGIC; -- Segnale di Selezione dell'Input
               y : out STD_LOGIC_VECTOR(Size-1 downto 0)); -- Output
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
    
    component button_debouncer is
        Generic (                       
            CLK_period: integer := 10; -- Valore predefinito del periodo di clock (default = 10 ns = 100MHz)
            btn_noise_time: integer := 10000000 -- Numero di cicli di clock (abbastanza grande da verificare se alla fine il pulsante è premuto o meno)
        );
        Port ( reset : in STD_LOGIC; -- Segnale di reset esterno
               clock : in STD_LOGIC; -- Clock di ingresso
               btn : in STD_LOGIC; -- Pulsante realmente premuto
               cleared_btn : out STD_LOGIC); -- Segnale del pulsante "pulito"
    end component;

    signal chrono_clock : STD_LOGIC := '0'; -- Clock di 1Hz, da usare per il cronometro

    -- Segnali di uscita del cronometro, da ricodificare per il display
    signal chrono_sec : STD_LOGIC_VECTOR (5 downto 0);
    signal chrono_min : STD_LOGIC_VECTOR (5 downto 0);
    signal chrono_hour : STD_LOGIC_VECTOR (4 downto 0);

    signal sig_chrono : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- Segnale ricodificato del cronometro, da stampare su display o salvare in memoria
    signal chrono_read : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- Segnale ricodificato da leggere dalla memoria
    signal chrono_out : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- Segnale da mostrare su display
    
    signal clr_shift : STD_LOGIC; -- Pulsante di shift "pulito" dal debouncer
    signal mem_addr : STD_LOGIC_VECTOR (2 downto 0); -- Indirizzo di memoria dove si legge o scrive un segnale

begin

    -- Debouncer del pulsante di switch per avere un solo spostamento in memoria alla pressione del pulsante
    db_op: button_debouncer port map(
        reset => '0',
        clock => clock,
        btn => shift,
        cleared_btn => clr_shift);

    -- Clock Divider che prende il clock della macchina (100Mhz) e fornisce uno di 1Hz (periodo = 1s)
    clk_chrono: clock_divider generic map(
        clock_frequency_in => 100000000,
        clock_frequency_out => 1)
        port map(
            clock_in => clock,
            reset => '0',
            clock_out => chrono_clock);
        
    -- Cronometro, sfruttando chrono_clock si ha un aggiornamento al secondo
    chrono: chronometer port map(
        clock => chrono_clock,
        reset => reset,
        set_sec => set_sec,
        set_min => set_min,
        set_hour => set_hour,
        in_sec => value6_in,
        in_min => value6_in,
        in_hour => value6_in (4 downto 0),
        out_sec => chrono_sec,
        out_min => chrono_min,
        out_hour => chrono_hour);
        
    -- Ricodificazione dei dati: ogni cifra decimale del cronometro occupa una locazione di 4 bit (il display driver riserva 4 bit per ogni cifra)
    sig_chrono(23 downto 20) <= std_logic_vector(resize((unsigned(chrono_hour) / 10),4)); -- Cifra 6
    sig_chrono(19 downto 16) <= std_logic_vector(resize((unsigned(chrono_hour) mod 10),4)); -- Cifra 5
    sig_chrono(15 downto 12) <= std_logic_vector(resize((unsigned(chrono_min) / 10),4)); -- Cifra 4
    sig_chrono(11 downto 8) <= std_logic_vector(resize((unsigned(chrono_min) mod 10),4)); -- Cifra 3
    sig_chrono(7 downto 4) <= std_logic_vector(resize((unsigned(chrono_sec) / 10),4)); -- Cifra 2
    sig_chrono(3 downto 0) <= std_logic_vector(resize((unsigned(chrono_sec) mod 10),4));  -- Cifra 1
    
    led <= mem_addr; -- Stampa dell'indirizzo su led
    
    -- Contatore per gli indirizzi: la memoria è di 8 locazioni, dunque avremo modulo 8 e abilitazione tramite pulsante
    addr_cnt: gen_counter generic map(
        size => 3,
        module => 8)
        port map(
            clock => clock,
            reset => reset,
            enable => clr_shift,
            set => '0',
            value => "000",
            counter => mem_addr);   
      
    -- Memoria in cui vengono salvati i dati da salvare o leggere su display, con indirizzo fornito dal contatore
    chrono_mem: MEM generic map(
        Mem_size => 8,
        Addr_size => 3,
        Data_size => 32)
        port map(
            reset => reset,
            data_in => sig_chrono, -- L'input di scrittura è sempre dato dal cronometro
            addr => mem_addr, -- Indirizzo di memoria
            write => read_sw, -- Quando lo switch è '1' si effettua la scrittura
            read => write_sw, -- Quando lo switch è '1' si effettua la lettura
            data_out => chrono_read); -- Dato letto dalla memoria  
    
    -- Multiplexer: si occupa della visualizzazione su display, scegliendo tra il cronometro e il timestamp salvato in memoria
    read_mux: gen_mux_2_1 generic map( Size => 32)
        port map(
            a0 => sig_chrono, -- Dato del cronometro
            a1 => chrono_read, -- Dato in memoria
            en => '1',
            s => read_sw, -- Quando lo switch è '1' allora si mostra il dato in memoria
            y => chrono_out);  -- Dato su display
      
    -- Display: mostra le cifra su display  
    display: display_seven_segments port map(
        CLK => clock, -- Il clock deve essere quello della macchina, siccome si devono alternare le cifre a velocità elevatissime
        RST => reset,
        VALUE => chrono_out, -- Dato da mostrare fornito dal Multiplexer, o è il cronometro o un intertempo salvato
        ENABLE => "00111111", -- Siccome è un cronometro, non ci servono due cifre
        DOTS => "00010100", -- I punti sono messi in modo da dividere secondi, minuti e ore
        ANODES => anodes, -- Output su anodi
        CATHODES => cathodes); -- Output su catodi
                    
end Structural;
