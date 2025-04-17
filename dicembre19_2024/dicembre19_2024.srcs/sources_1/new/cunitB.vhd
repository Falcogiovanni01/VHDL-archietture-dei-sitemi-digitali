library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cunitB is
    Port (
        clk         : in STD_LOGIC;
        reset       : in STD_LOGIC;
        REQ         : in STD_LOGIC;
        ACK         : out STD_LOGIC;
        
        load_reg    : out STD_LOGIC;
        avvia_somma : out STD_LOGIC
    );
end cunitB;

architecture Behavioral of cunitB is
    type state_type is (WAIT_REQ_0, WAIT_REQ_1, SET_ACK, LOW_ACK, SUM, OK_SUM);
    signal state_curr: state_type := WAIT_REQ_1;
    

begin
   
    -- automa
    process (clk)
    begin
        if reset = '1' then
            
            state_curr <= WAIT_REQ_1;
            ACK <= '0';
            load_reg <= '0';
            avvia_somma <= '0';
            
        elsif rising_edge(clk) then
            case state_curr is
                when WAIT_REQ_1 =>
                   
                    if REQ = '0' then
                       
                        state_curr <= WAIT_REQ_1;
                    else 
                        state_curr <= SET_ACK;
                    end if;

                when SET_ACK =>
                    ACK <= '1';
                    load_reg <= '1';
                    state_curr <= WAIT_REQ_0;

                when WAIT_REQ_0 =>
                    load_reg <= '0';
                    if REQ = '1' then
                        state_curr <= WAIT_REQ_0;
                    else 
                        state_curr <= LOW_ACK;
                    end if;

                when LOW_ACK =>
                    ACK <= '0';
                    state_curr <= SUM;

                when SUM =>
                    avvia_somma <= '1';
                    state_curr <= OK_SUM;
                when OK_SUM => 
                    avvia_somma <= '0';
                    state_curr <= WAIT_REQ_1;

            end case;
        end if;
    end process;
   
end Behavioral;