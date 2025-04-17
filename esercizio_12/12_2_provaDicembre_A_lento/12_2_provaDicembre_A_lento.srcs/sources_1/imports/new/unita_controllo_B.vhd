library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity unita_controllo_B is
    Port (
        CLK   : in  std_logic;
        RST   : in  std_logic;
        count : in std_logic_vector (2 downto 0); -- valore sommatore mod 8 per capire quanti dati devo ancora ricevere
        req : in std_logic;  -- req da parte di A per B
        
        ack  : out std_logic; -- ack di B per A
        en_c : out std_logic; -- abilita conteggio mod 8
        en_w_acc : out std_logic; -- abilita scrittura accumulatore
        en_write : out std_logic -- abilita scrittura registro finale
    );
end unita_controllo_B;

architecture Behavioral of unita_controllo_B is
    type state_type is (IDLE, SEND_ACK, DONE, INCR_CNT, WRITE);
    signal current_state : state_type := IDLE;
    signal next_state : state_type;

begin

     rfr: process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    update: process(current_state, req)
    begin

        case current_state is
            when IDLE =>
                ack <= '0';
                en_c <= '0';
                en_w_acc <= '0';
                en_write <= '0';
                if req = '1' then
                    next_state <= SEND_ACK;
                else
                    next_state <= IDLE;
                end if;

            when SEND_ACK =>
                ack <= '1';
                en_c <= '0';
                en_w_acc <= '0';
                en_write <= '0';
                if req = '0' then
                    next_state <= DONE; 
                else
                    next_state <= SEND_ACK;               
                end if;

            when DONE =>
                ack <= '0';
                en_c <= '0';
                en_w_acc <= '1';
                en_write <= '0';
                next_state <= INCR_CNT;
                
            when INCR_CNT =>
                ack <= '0';
                en_c <= '1';
                en_w_acc <= '0';
                en_write <= '0';
                if count = "111" then
                    next_state <= WRITE;
                else
                    next_state <= IDLE;
                end if;

            when WRITE =>
                ack <= '0';
                en_c <= '0';
                en_w_acc <= '0';
                en_write <= '1';
                next_state <= IDLE;
                
            when others =>
                ack <= '0';
                en_c <= '0';
                en_w_acc <= '0';
                en_write <= '0';
                next_state <= IDLE;
        end case;
    end process;

end Behavioral;