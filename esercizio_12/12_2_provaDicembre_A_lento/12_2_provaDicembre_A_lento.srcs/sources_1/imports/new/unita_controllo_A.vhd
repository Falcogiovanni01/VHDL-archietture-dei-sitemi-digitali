library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity unita_controllo_a is
    Port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        start       : in std_logic; -- quando inizia il programma -> a leggere da rom
        count       : in std_logic_vector (2 downto 0); -- valore conteggio contatore mod 8
        ack       : in  std_logic; -- Acknowledgment da sistema B
        
        req       : out std_logic; -- Req al sistema B
        read        : out std_logic; -- abilita lettura dalla Rom
        en_c      : out std_logic -- abilita conteggio contatore indirizzi rom        
    );
end unita_controllo_a;

architecture Behavioral of unita_controllo_a is
    type state_type is (IDLE, LOAD, SEND_REQ, DONE, INCR_CNT);
    signal current_state : state_type := IDLE;
    signal next_state : state_type;

begin

    
    rf: process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    
    update: process(current_state, start, ack)
    begin
        case current_state is
            when IDLE =>
                en_c <= '0';
                read <= '0';
                req <= '0';
                if start = '1' then
                    next_state <= LOAD;   
                end if;

            when LOAD =>
                en_c <= '0';
                read <= '1';
                req <= '0';
                next_state <= SEND_REQ;
                
            when SEND_REQ =>
                en_c <= '0';
                read <= '1';
                req <= '1';
                if ack = '1' then
                    next_state <= DONE;
                else
                    next_state <= SEND_REQ;
                end if;
                
            when DONE =>
                en_c <= '0';
                read <= '0';
                req <= '0';
                if ack = '0' then
                    next_state <= INCR_CNT;
                else
                    next_state <= DONE;
                end if;
                
            when INCR_CNT =>
                en_c <= '1';
                read <= '0';
                req <= '0';
                if count = "111" then
                    next_state <= IDLE;
                else
                    next_state <= LOAD;
                end if;

            when others =>
                en_c <= '0';
                read <= '0';
                req <= '0';
                next_state <= IDLE;
        end case;
    end process;

end Behavioral;