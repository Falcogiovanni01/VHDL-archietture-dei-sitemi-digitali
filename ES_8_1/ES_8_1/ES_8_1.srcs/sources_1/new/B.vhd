----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 16:09:46
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity B is
    Port (
        clk,rst: in std_logic;
        request: in std_logic;
        input: in std_logic_vector(0 to 3);
        risposta: out std_logic
     );
end B;

architecture Structural of B is

component delay is
port(
        clk: in std_logic;
        input: in std_logic;
        input_delay: out std_logic
);
end component;

component counter_modN is
generic (N:integer);
port(
           clk : in  STD_LOGIC;
           attesa: in std_logic;
           count: out std_logic_vector(0 to 3);
		   div: out STD_LOGIC
);
end component;

component entita_B is
port(
        req,div,clk: in std_logic;
        enable_ent: in std_logic:='1';
        outputA: in std_logic_vector(0 to 3);
        outputB: out std_logic_vector(0 to 3);
        enableUO,ris: out std_logic
);
end component;

component memoriaB is
 generic (N:integer);
 Port ( 
        clk: in std_logic;
        read,write: in std_logic;
        inputSomma: in std_logic_vector(0 to 3);
        count: in std_logic_vector(0 to 3);
        output: out std_logic_vector(0 to 3)
 );
end component;

component unitaoperativaB is
 Port (
            clk:in std_logic;
            outputA: in std_logic_vector(0 to 3); 
            enableUO: in std_logic;
            enable_ent: out std_logic;
            write,read: out std_logic;
            output_memB: in std_logic_vector(0 to 3);
            sumAB: out std_logic_vector(0 to 3)
   );
end component;

signal tmp_div,tmp_read,tmp_write,tmp_enUO,tmp_enB,attesa_delay: std_logic:= '0';
signal count_tmp: std_logic_vector (0 to 3):= (others => '0');
signal out_entB: std_logic_vector (0 to 3):= (others => '0');
signal valore_memoriaB: std_logic_vector (0 to 3):= (others => '0');
signal tmp_sum: std_logic_vector(0 to 3):= (others => '0');
signal a,b: unsigned(0 to 3):= (others => '0');

begin
a <= unsigned(out_entB);
b <= unsigned(valore_memoriaB);
tmp_sum <= std_logic_vector(a+b);

ritardo:delay
port map(
      clk => clk,
      input => tmp_enB,
      input_delay => attesa_delay
);

count:counter_modN
generic map(N => 8)
port map(
      clk => clk,
      attesa => attesa_delay,
      count => count_tmp,
      div => tmp_div
);

entityB: entita_B
port map(
            req => request,
            enable_ent => tmp_enB,
            div => tmp_div,
            clk => clk,
            outputA => input,
            outputB => out_entB,
            enableUO => tmp_enUO,
            ris => risposta
);

memB:memoriaB
generic map(N => 8)
port map(
        clk => clk,
        inputSomma => tmp_sum,
        output => valore_memoriaB,
        count => count_tmp,
        read => tmp_read,
        write => tmp_write
);

uoB: unitaoperativaB
port map(
            clk => clk,
            outputA => out_entB,
            enableUO => tmp_enUO,
            enable_ent => tmp_enB,
            write => tmp_write,
            read => tmp_read,
            output_memB => valore_memoriaB,
            sumAB => tmp_sum
);

end Structural;
