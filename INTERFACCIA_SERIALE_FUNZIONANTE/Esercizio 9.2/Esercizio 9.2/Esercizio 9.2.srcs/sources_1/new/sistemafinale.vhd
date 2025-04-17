----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2023 10:50:39
-- Design Name: 
-- Module Name: sistemafinale - Structural
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

entity sistemafinale is
  Port ( 
        
        rst,clk: in std_logic;
        read:in std_logic;
        output: out std_logic_vector(0 to 7)
  );
end sistemafinale;

architecture Structural of sistemafinale is

    component A is
  Port (
        clk,rst: in std_logic;
        ris,errore: in std_logic:='0';
        req: out std_logic:='0';
        outputA: out std_logic
   );
    end component;    

    component B is
  Port ( 
        clk,inputB,rst,read: in std_logic;
        req: in std_logic:='0';
        ris,errore: out std_logic:='0';
        output: out std_logic_vector(0 to 7)
  );
    end component;    
    
signal data,reqtmp,ristmp,errore_tmp:std_logic;

begin

entita_A: A
port map(
    ris => ristmp,
    clk => clk,
    rst=> rst,
    errore=>errore_tmp,
    outputA => data,
    req => reqtmp
);

entita_B: B 
port map(
    inputB => data,
    ris => ristmp,
    clk => clk,
    rst=> rst,
    errore=>errore_tmp,
    read => read,
    output => output,
    req => reqtmp
);

end Structural;
