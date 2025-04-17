----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2025 11:37:13
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
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;  
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity A is
 Port (
   -- AVVIO :
  -- AVVIO :
  start : in std_logic; 
  reset : in std_logic; 
  clock : in std_logic; 
  -- check
--  cont_value : in std_logic_vector( 2 downto 0); 
--  enable_cont : out std_logic; 
--  reset_cont : out std_logic; 
--  read : out std_logic; 
--  -- trasmissione : 
  req : out std_logic; 
 ack : in std_logic; 
  output : out std_logic_vector(3 downto 0)  
 
  );
end A;

architecture Structural of A is
   -- Dichiarazione componenti
    component UCA 
        Port (
           start : in std_logic; 
          reset : in std_logic; 
          clock : in std_logic; 
          -- check
          cont_value : in std_logic_vector( 2 downto 0); 
          enable_cont : out std_logic; 
          reset_cont : out std_logic; 
          read : out std_logic; 
          -- trasmissione : 
          req : out std_logic; 
          ack : in std_logic;           
          inputROM : in std_logic_vector ( 3 downto 0);
          output : out std_logic_vector(3 downto 0)    
        );
    end component;
    
    component cont_generic 
    generic(N :in integer := 8);
        port(
    clock : in std_logic;
    reset : in std_logic;
    enable_contatore : in std_logic;   
    cont  : out std_logic_vector((integer(ceil(log2(real(N))))-1) downto 0)
   -- div : out std_logic 
    ); 
    end component;
    
    component ROM_N_8 
    generic(
        len_add : positive := 3  -- 3 bit per indirizzare 8 locazioni
    );    
    port ( 
        CLK_rom : in std_logic;
        address : in std_logic_vector(len_add - 1 downto 0); -- 3 bit
        read : in std_logic;
        dout : out std_logic_vector(3 downto 0)  -- Uscita da 4 bit
    );
    end component; 

signal temp_cont_value : std_logic_vector(2 downto 0);

signal temp_EN_cont : std_logic;
signal temp_read : std_logic;
signal temp_RESET_CONT : std_logic;
signal temp_END_COUNT : std_logic;

-- uscita
signal temp_rom_data : std_logic_vector(3 downto 0);


begin

   UCA_instance: UCA 
        port map (
            start => start,
            reset => reset,
            clock => clock,
            enable_cont => temp_EN_cont,  
            reset_cont => temp_RESET_CONT,
            cont_value => temp_cont_value,
            read => temp_read,
            req => req,
            ack => ack,
            inputROM => temp_rom_data ,
            output => output
        );
        
          
   contatore : cont_generic
          port map(
            clock => clock ,
            reset  =>  reset,
            enable_contatore  =>  temp_EN_cont ,  
            cont   =>  temp_cont_value
           -- div  =>  out std_logic 
            ); 

    rom :   ROM_N_8 
        port map(
            CLK_rom  =>  clock,
            address  =>  temp_cont_value, 
            read  =>  temp_read,
            dout  =>  temp_rom_data   
            ); 
            
      output <= temp_rom_data;
end Structural;
