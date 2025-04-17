----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2025 16:34:37
-- Design Name: 
-- Module Name: B - Structural
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

entity B is
 Port (
     req     : in STD_LOGIC;                                 -- segnale di richiesta invio proveniente dal sistema A
    clock   : in STD_LOGIC;                                 -- segnale di clock del sistema B
    reset   : in STD_LOGIC;                                 -- segnale di reset del sistema B
    data_A  : in STD_LOGIC_VECTOR (3 downto 0);             -- elemento proveniente dalla ROM del sistema A
   -- avvio_sum : in std_logic;
    ack     : out STD_LOGIC;                                -- segnale di ack che deve essere inviato al sistema A
    output_b: out STD_LOGIC_VECTOR(3 downto 0)
    
  );
end B;

architecture Structural of B is
        component cunitB
        Port (
            clk         : in STD_LOGIC;
            reset       : in STD_LOGIC;
            REQ         : in STD_LOGIC;
            ACK         : out STD_LOGIC;        
            load_reg    : out STD_LOGIC;
            avvia_somma : out STD_LOGIC
        );
    end component;
    
       component registro
        Port (
        clk    : in std_logic;  -- Segnale di clock
        reset  : in std_logic;  -- Reset sincrono
        dato   : in std_logic_vector (3 downto 0); -- Ingresso dati
        load   : in std_logic;  -- Segnale di carico
        uscita : out std_logic_vector (3 downto 0) -- Uscita del registro
        );
    end component;
    
       component adderCLA
        Port (
            X, Y : in std_logic_vector(3 downto 0);   --vogliamo sommare due stringhe di 4 bit ciascuna
            cin : in std_logic;
            somma : out std_logic_vector(3 downto 0);
            avvia_somma: in std_logic;  
            cout : out std_logic
        );
    end component;
    
    signal load_signal : std_logic;
    signal sum_enable  : std_logic;
    signal reg_output  : std_logic_vector(3 downto 0);
    signal sum_result  : std_logic_vector(3 downto 0);
    signal carry_out   : std_logic;
    signal reg2_output : std_logic_vector(3 downto 0);
    
begin  

      UCB: cunitB
        Port map (
        clk         => clock,
        reset       => reset,
        REQ         => req,
        ACK         => ack,        
        load_reg    => load_signal,
        avvia_somma => sum_enable
        );
    
     reg: registro
        Port map(
        clk    => clock,  -- Segnale di clock
        reset  => reset,  -- Reset sincrono
        dato   => data_A,-- Ingresso dati
        load   => load_signal,  -- Segnale di carico
        uscita => reg_output -- Uscita del registro
        );
        
    
     sommatore: adderCLA
        Port map (
            X => data_A, 
            Y => reg2_output, --vogliamo sommare due stringhe di 4 bit ciascuna
            cin => '0', -- riporto iniziale
            avvia_somma => sum_enable,
            somma => sum_result,
            cout => carry_out
        );
        reg2 : registro 
            Port map ( 
             clk    => clock,  -- Segnale di clock
             reset  => reset,  -- Reset sincrono
            dato   => sum_result,-- Ingresso dati
            load   => load_signal,  -- Segnale di carico
            uscita =>  reg2_output -- Uscita del registro
        );
            
        
  output_b <= sum_result ;   

end Structural;
