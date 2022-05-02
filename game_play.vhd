----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2022 06:41:19 PM
-- Design Name: 
-- Module Name: game_play - Behavioral
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

entity game_play is
  Port (clk, en, gameplay_en, hitAvailablecross1, hitAvailablecross2, hit, stay, cycle: in std_logic;
        pwin, dwin, tie, pbust, dbust: inout std_logic;
        playerpoints, dealerpoints: inout std_logic_vector(7 downto 0)
       );
end game_play;

architecture Behavioral of game_play is
component player_turn is
  Port ( clk, en, rst, update:in std_logic;
            new_card: in std_logic_vector(7 downto 0);
            points: in std_logic_vector(7 downto 0);
            updatedpoints: out std_logic_vector(7 downto 0));
end component;
component LFSR8_player IS
  PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (7 DOWNTO 0));
END component;
component LFSR8_dealer IS
  PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (7 DOWNTO 0));
END component;
component game_logic is
  Port ( clk, en, rst: in std_logic;
  Player_points, Dealer_points: in std_logic_vector(7 downto 0);
        pwin,dwin, tie, pbust, dbust, updateP, updateD: inout std_logic := '0'
  );
end component;
signal resetRandomGenerator: std_logic := '0'; -- not used so far
type state is (generate_initialCards, start_game, deal, playerturns, dealerturns, result);
signal curr: state := generate_initialCards;
signal dealEn, pturnEn, dturnEn, calculate_result: std_logic := '0';
signal dealHit, dealStay: std_logic;
signal newcard,newcard1: std_logic_vector(7 downto 0);
signal  playerpoints2, dealerpoints2: std_logic_vector(7 downto 0) :=(others => '0');
signal count: std_logic_vector(1 downto 0):=(others => '0'); --used to deal two hands in deal state
signal  updateP, updateD, rst_cards, rst_gmlogic :std_logic := '0';
signal beginning :std_logic:= '1';
signal hitAvailable: std_logic:= '1';
signal lastAvailcross: std_logic := '1';
begin
    
    player: player_turn port map(
        clk => clk,
        en => pturnEn, 
        rst => rst_cards,
        update => updateP,
        new_card => newcard,
        points => playerpoints,
        updatedpoints => playerpoints
    );
    dealer: player_turn port map(
        clk => clk,
        en => dturnEn, 
        rst => rst_cards,
        update => updateD,
        new_card => newcard1,
        points => dealerpoints,
        updatedpoints => dealerpoints
    );
    random_generator_player: LFSR8_player port map(
        Clk => clk,
        Rst => resetRandomGenerator, 
        output => newcard
        
    );
    random_generator_dealer: LFSR8_dealer port map(
        Clk => clk,
        Rst => resetRandomGenerator, 
        output => newcard1
    );
    gamelogic: game_logic port map(
        clk => clk,
        en => calculate_result,
        rst => rst_gmlogic,
        Player_points => playerpoints2,
        Dealer_points => dealerpoints2,
        pwin => pwin,
        dwin => dwin,
        tie => tie,
        pbust => pbust,
        dbust => dbust,
        updateP => updateP,
        updateD => updateD
    );
    
    process(clk) begin
        if rising_edge(clk) then
            if en= '1'  then
                resetRandomGenerator <= '0';
                playerpoints2 <= playerpoints;
                dealerpoints2 <= dealerpoints;
                case curr is
                    when generate_initialCards =>
                        resetRandomGenerator <= '1';
                        curr <= start_game;
                        rst_gmlogic <= '1';
                        calculate_result <= '1';
                    when start_game => 
                            
                            curr <= deal;
                            rst_gmlogic <= '0';
                            rst_cards <= '0';
                            pturnEn <= '1';
                            dturnEn <= '1';
                            calculate_result <= '0';

                        
                    when deal => 
                        if unsigned(count)  = 1 then
                            pturnEn <= '0';
                            dturnEn <= '0';
                            if unsigned(playerpoints) > 21 then 
                                curr <= result;
                                calculate_result <= '1';
                                count <= "00";
                              --  rst_cards <= '1';
                            elsif hit = '1' AND unsigned(playerpoints) < 21 AND hitAvailable = '1' then 
                                curr <= playerturns;
                                pturnEn <= '1';
                                count <= "00";
                                hitAvailable <= '0';
                            elsif stay = '1' AND unsigned(dealerpoints) < 16 then
                                curr <= dealerturns;
                                dturnEn <= '1';
                                count <= "00";
                            elsif stay = '1' AND unsigned(dealerpoints) > 16 then
                                curr <= result;
                                calculate_result <= '1';
                              --  rst_cards <= '1';
                                count <= "00";
                            else
                                curr <= deal; --(basically after it has dealt two cards each and it hasnt recieved user input yet, keep looping until u do. )
                            end if;
                        else
                            count <= std_logic_vector(unsigned(count)+1);
                        end if;
                        
                    when playerturns =>
                        if hitAvailablecross1 = '1' AND lastAvailcross = '1' then 
                            hitAvailable <= '1';
                            lastAvailcross <= '0';
                        elsif hitAvailablecross2 = '1' AND lastAvailcross = '0' then
                            hitAvailable <= '1';
                            lastAvailcross <= '1';
                        end if;
                        if unsigned(playerpoints) >= 21 then 
                            curr <= result;
                            calculate_result <= '1';
                            pturnEn <= '0';
                          --  rst_cards <= '1';
                        elsif hit = '1' AND unsigned(playerpoints) < 21 AND hitAvailable = '1' then
                            curr <= playerturns;
                            pturnEn <= '1';
                            hitAvailable <= '0';
                       
                        elsif stay = '1'AND unsigned(playerpoints) < 21 then
                            if unsigned(dealerpoints) < 16 then
                                curr <= dealerturns;
                                dturnEn <= '1';
                                pturnEn <= '0';
                            else
                                curr <= result;
                                dturnEn <= '0';
                                pturnEn <= '0';
                               -- rst_cards <= '1';
                            end if;
                                          
                        else
                            curr <= playerturns; -- waiting for input
                            pturnEn <= '0';
                        end if;
                    when dealerturns => 
                        if unsigned(dealerpoints) < 16 then
                            curr <= dealerturns;
                        else
                            curr <= result;
                            dturnEn <= '0';
                            calculate_result <= '1';
                            --rst_cards <= '1';
                        end if;
                    when result => 
                          
                          if cycle = '1' then
                             rst_cards <= '1'; 
                              curr <= start_game;
                              pturnEn <= '1';
                              dturnEn <= '1';
                              lastAvailcross <= '1';
                              calculate_result <= '1';
                              rst_gmlogic <= '1';
                              hitAvailable <= '1';
                          end if;
                          
                end case;
            end if;
        end if;
    end process;

end Behavioral;
