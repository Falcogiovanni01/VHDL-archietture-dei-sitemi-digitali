----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2023 12:37:02
-- Design Name: 
-- Module Name: A - Structural
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

entity A is
  Port (
        clk,ris,rst,errore: in std_logic;
        req,outputA: out std_logic
   );
end A;

architecture Structural of A is
component contatore is
Generic( N:integer);
port(
        clock : in STD_LOGIC;
        rst : in STD_LOGIC; 
        ab : in STD_LOGIC; 
        output : out STD_LOGIC_VECTOR (0 to 3);
        div : out STD_LOGIC
);
end component; 

component ROM is
Generic ( N: integer);
    Port ( output : out STD_LOGIC_VECTOR (0 to 7):=(others=>'0');
            counter: in STD_LOGIC_VECTOR (0 to 3);
           read, clk: in STD_LOGIC
);
end component; 

component UARTcomponent is

Generic (
		BAUD_DIVIDE_G : integer := 2;-- 55;
		BAUD_RATE_G   : integer := 32--869
	);
port(   TXD 	: out 	std_logic  	:= '1';					-- Transmitted serial data output
		RXD 	: in  	std_logic := '1';								-- Received serial data input
		CLK 	: in  	std_logic;							-- Clock signal
		DBIN 	: in  	std_logic_vector (7 downto 0) := (others => '0');		-- Input parallel data to be transmitted
		DBOUT 	: out 	std_logic_vector (7 downto 0);		-- Recevived parallel data output
		RDA		: inout  std_logic;							-- Read Data Available
		TBE		: out 	std_logic 	:= '1';					-- Transfer Buffer Emty
		RD		: in  	std_logic := '0';							-- Read Strobe
		WR		: in  	std_logic;							-- Write Strobe
		PE		: out 	std_logic;							-- Parity error		
		FE		: out 	std_logic;							-- Frame error
		OE		: out 	std_logic;							-- Overwrite error
		RST		: in  	std_logic	:= '0'
		);
end component;


component controlloA is
port(
        div,clk,rst,ris,TBE,errore: in std_logic;
            req,write,en:out std_logic
);
end component;

component delay
Port ( input : in STD_LOGIC:='0';
           output : out STD_LOGIC:='0';
           clk : in STD_LOGIC
           );
           end component;

signal tbe_tmp,wr_tmp,div_tmp,en_tmp,delay_write: std_logic;
signal outputROM: std_logic_vector(0 to 7);
signal conta: std_logic_vector(0 to 3);

begin
uartA: UARTcomponent 
port map(
            TXD => outputA,
            RXD => '0',
            CLK => clk,
            DBIN => outputROM,
            DBOUT => open,
            RDA	=> open,
            TBE	=> tbe_tmp,
            RD => open,
            WR=> delay_write,
            PE => open,
            FE => open,
            OE => open,
            RST	 => rst
        );

romA: ROM
    generic map(N => 4)
    port map(
        output => outputROM,
        counter => conta,
        read => wr_tmp,
        clk => clk
    );
    
count: contatore
    generic map(N => 4)
    port map(
        clock => clk,
        rst => rst,
        ab => en_tmp,
        div => div_tmp,
        output => conta
    );
    
UCA: controlloA
    port map(
        div => div_tmp,
        clk => clk,
        rst => rst,
        errore=> errore,
        TBE =>tbe_tmp,
        req => req,
        ris =>ris,
        write => wr_tmp,
        en => en_tmp
    );
    
    del: delay
    port map(
    clk=>clk,
    input=> wr_tmp,
    output=> delay_write
    );
end Structural;
