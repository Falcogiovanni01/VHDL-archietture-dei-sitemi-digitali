----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2023 12:37:21
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
        clk,req,inputB,rst,read: in std_logic;
        ris,errore: out std_logic;
        output: out std_logic_vector(0 to 7)
  );
end B;

architecture Structural of B is

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
		RDA		: inout  std_logic:='0';							-- Read Data Available
		TBE		: out 	std_logic 	:= '1';					-- Transfer Buffer Emty
		RD		: in  	std_logic := '0';							-- Read Strobe
		WR		: in  	std_logic:='0';							-- Write Strobe
		PE		: out 	std_logic:='0';							-- Parity error		
		FE		: out 	std_logic:='0';							-- Frame error
		OE		: out 	std_logic;							-- Overwrite error
		RST		: in  	std_logic	:= '0');
end component;

component controlloB is
Port ( 
        req,clk,RDA,PE,FE: in std_logic;
        RD,ris: out std_logic;
        write,errore: out std_logic:='0'
  );
end component;

component memoriaB is
generic (N:integer);
Port ( 
        clk: in std_logic;
        read, write: in std_logic:='0';
        output: out std_logic_vector(0 to 7):=(others=> '0');
        input: in std_logic_vector(0 to 7):=(others =>'0');
        counter_value: in std_logic_vector (0 to 3)
 );
end component;

component contatore
Generic( N:integer);
    Port ( clock : in STD_LOGIC;
           rst : in STD_LOGIC; 
           ab : in STD_LOGIC:='0'; 
           output : out STD_LOGIC_VECTOR (0 to 3):=(others =>'0');
           div : out STD_LOGIC:='0'
           );
end component;

signal rda_tmp,rd_tmp,write_tmp,pe_tmp,fe_tmp: std_logic:='0';
signal inputmem_tmp: std_logic_vector(0 to 7):= (others => '0');
signal count: std_logic_vector(0 to 3);
begin

UCB: controlloB
port map(
    clk => clk,
    req => req,
    RDA => rda_tmp,
    rd => rd_tmp,
    ris => ris,
    errore=>errore,
    write => write_tmp,
    PE=> pe_tmp,
    FE=>fe_tmp
);

uartB: UARTcomponent 
port map(
            TXD => open,
            RXD => inputB,
            CLK => clk,
            DBIN => open,
            DBOUT => inputmem_tmp,
            RDA	=> rda_tmp,
            TBE	=> open,
            RD => rd_tmp,
            WR=> open,
            PE => pe_tmp,
            FE => fe_tmp,
            OE => open,
            RST	 => rst
        );
cont:contatore
generic map(N=>4)
port map(
    clock=>clk,
    rst=>rst,
    ab=> write_tmp,
    output=>count,
    div=> open
    );
    
memB: memoriaB

Generic map( N => 4)
port map(
    clk=>clk,
    input=> inputmem_tmp,
    output=> output,
    read=> read,
    write=> write_tmp,
    counter_value=>count
    );
end Structural;
