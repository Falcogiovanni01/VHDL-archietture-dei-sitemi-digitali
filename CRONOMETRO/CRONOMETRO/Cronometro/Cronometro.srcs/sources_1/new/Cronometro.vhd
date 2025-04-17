library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Cronometro is
    port(
    I_HMS : in STD_LOGIC_VECTOR(5 DOWNTO 0); -- input set ore, minuti o secondi
    EN_C : in STD_LOGIC; -- enable cronometro
    SET_HMS : in STD_LOGIC_VECTOR(2 DOWNTO 0); -- segnale set ore, minuti o secondi
    CLK_C : in STD_LOGIC; -- clock cronometro
    RST_C : in STD_LOGIC; -- reset cronometro
    DIV_C : out STD_LOGIC; -- uscita divisore (alta quando il contatore raggiunge il massimo)
    Y : out STD_LOGIC_VECTOR(16 DOWNTO 0) -- uscita corrente (ore, minuti, secondi)
    );
end Cronometro;

architecture Structural of Cronometro is

signal exit_cont : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0'); -- uscite contatori
signal exit_and : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0'); -- uscite porte and

component Cont_mod_N is
 generic(N : in integer);
 port(
    I : in std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0);
    EN : in std_logic;
    SET : in std_logic;
    RST : in std_logic;
    CLK : in std_logic;
    DIV : out std_logic;
    CONT : out std_logic_vector((integer(ceil(log2(real(N))))-1) DOWNTO 0)
    );
end component;

begin
    cont_s : cont_mod_N
    Generic map(
        N => 60
    )
    Port map(
        I => I_HMS,
        EN => EN_C,
        SET => SET_HMS(0),
        CLK => CLK_C,
        RST => RST_C,
        CONT => Y(5 DOWNTO 0),
        DIV => exit_cont(0)
    );
    exit_and(0) <= CLK_C and exit_cont(0);
 
    cont_m : cont_mod_N
    Generic map(
        N => 60
    )
    Port map(
        I => I_HMS,
        EN => EN_C,
        SET => SET_HMS(1),
        CLK => exit_and(0),
        RST => RST_C,
        CONT => Y(11 DOWNTO 6),
        DIV => exit_cont(1)
    );
    exit_and(1) <= exit_and(0) and exit_cont(1);
 
    cont_h : cont_mod_N
    Generic map(
        N => 24
    )
    Port map(
        I => I_HMS(4 DOWNTO 0),
        EN => EN_C,
        SET => SET_HMS(2),
        CLK => exit_and(1),
        RST => RST_C,
        CONT => Y(16 DOWNTO 12),
        DIV => exit_cont(2)
    );
    DIV_C <= exit_cont(2) and (exit_cont(1) and exit_cont(0));
 
end Structural;