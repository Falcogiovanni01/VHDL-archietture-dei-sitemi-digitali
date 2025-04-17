library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity A is
  Port (
        clk: in std_logic; 
        risposta: in std_logic; 
        request: out std_logic;           
        output: out std_logic_vector(0 to 3)
   );
end A;

architecture Structural of A is
component counter_modN is
generic (N:integer);
port(
           clk : in  STD_LOGIC; 
           attesa: in std_logic;
           count: out std_logic_vector(0 to N-1);
		   div: out STD_LOGIC
);
end component;

component entita_A is
port(
            ris,div: in std_logic;
            clk:in std_logic;
            inputROM: in std_logic_vector(0 to 3);
            req,read: out std_logic;            
            outputA: out std_logic_vector(0 to 3)
);
end component;

component romA is
    Generic ( N: integer);
    Port ( 
            read, clk: in STD_LOGIC;
            counter: in STD_LOGIC_VECTOR (0 to 3);
            output : out STD_LOGIC_VECTOR (0 to 3)
            );
end component;

signal tmp_div: std_logic:= '0';
signal tmp_read: std_logic:= '0';
signal out_romA: std_logic_vector (0 to 3):= (others => '0');
signal count_tmp: std_logic_vector (0 to 3):= (others => '0');
begin

counter: counter_modN
generic map(N => 4)
port map(
      clk => clk,
      attesa => risposta,
      div => tmp_div,
      count => count_tmp
);

entityA: entita_A
port map(
            ris => risposta,
            div => tmp_div,
            clk => clk,
            inputROM => out_romA,
            req => request,
            read => tmp_read,        
            outputA => output
);

memA: romA
generic map(N => 4)
port map(
        counter => count_tmp,
        read => tmp_read, 
        clk => clk,
        output => out_romA
);

end Structural;
