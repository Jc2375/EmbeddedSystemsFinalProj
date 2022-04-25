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
  Port (clk, en, hit, stay,start: in std_logic;
        pwin, dwin, pbust, dbust: out std_logic;
        CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end game_play;

architecture Behavioral of game_play is
component player_turn is
  Port ( clk, en:in std_logic;
            new_card: in std_logic_vector(7 downto 0);
            points: in std_logic_vector(7 downto 0);
            updatedpoints: out std_logic_vector(7 downto 0));
end component;
component LFSR8 IS
  PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (7 DOWNTO 0));
END component;
component game_logic is
  Port ( clk, en: in std_logic;
  Player_points, Dealer_points: in std_logic_vector(7 downto 0);
        pwin,dwin, pbust, dbust: out std_logic := '0'
  );
end component;
component PmodOLEDCtrl is
	Port ( 
		CLK 	: in  STD_LOGIC;
		RST 	: in  STD_LOGIC;
		 Player_points, Dealer_points: in std_logic_vector(7 downto 0);
		CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end component;

signal resetRandomGenerator: std_logic := '0'; -- not used so far
type state is (start_game, deal, playerturns, dealerturns, result);
signal curr: state := start_game;
signal dealEn, pturnEn, dturnEn, calculate_result: std_logic := '0';
signal dealHit, dealStay: std_logic;
signal newcard: std_logic_vector(7 downto 0);
signal playerpoints, dealerpoints, playerpoints2, dealerpoints2: std_logic_vector(7 downto 0) :=(others => '0');
signal count: std_logic_vector(1 downto 0):=(others => '0'); --used to deal two hands in deal state
begin
    
    player: player_turn port map(
        clk => clk,
        en => pturnEn, 
        new_card => newcard,
        points => playerpoints,
        updatedpoints => playerpoints2
    );
    dealer: player_turn port map(
        clk => clk,
        en => dturnEn, 
        new_card => newcard,
        points => dealerpoints,
        updatedpoints => dealerpoints2
    );
    random_generator: LFSR8 port map(
        Clk => clk,
        Rst => resetRandomGenerator, 
        output => newcard
        
    );
    gamelogic: game_logic port map(
        clk => clk,
        en => calculate_result,
        Player_points => playerpoints,
        Dealer_points => dealerpoints,
        pwin => pwin,
        dwin => dwin,
        pbust => pbust,
        dbust => dbust
    );
    pmodoled: PmodOLEDCtrl port map(
        CLK => clk,
        RST=> '0',
        Player_points => playerpoints,
        Dealer_points => dealerpoints,
        CS => CS,
        SDIN => SDIN, 
        SCLK => SCLK ,
        DC => DC ,
        RES => RES ,
        VBAT => VBAT, 
        VDD => VDD
    );
    
    process(clk) begin
        if rising_edge(clk) then
            if en= '1' then
                case curr is
                    when start_game => 
                        curr <= deal;
                        pturnEn <= '1';
                        dturnEn <= '1';
                        
                    when deal => 
                        if unsigned(count)  = 2 then
                            pturnEn <= '0';
                            dturnEn <= '0';
                            if unsigned(playerpoints) > 21 then 
                                curr <= result;
                                calculate_result <= '1';
                            elsif hit = '1' AND unsigned(playerpoints) < 21 then 
                                curr <= playerturns;
                                pturnEn <= '1';
                            elsif stay = '1' AND unsigned(dealerpoints) < 16 then
                                curr <= dealerturns;
                                dturnEn <= '1';
                            elsif stay = '1' AND unsigned(dealerpoints) > 16 then
                                curr <= result;
                                calculate_result <= '1';
                            else
                                curr <= deal; --(basically after it has dealt two cards each and it hasnt recieved user input yet, keep looping until u do. )
                            end if;
                        else
                            count <= std_logic_vector(unsigned(count)+1);
                        end if;
                        
                    when playerturns =>
                        if hit = '1' then
                            curr <= playerturns;
                        elsif stay = '1'then
                            if unsigned(dealerpoints) < 16 then
                                curr <= dealerturns;
                                dturnEn <= '1';
                                pturnEn <= '0';
                            else
                                curr <= result;
                                dturnEn <= '0';
                                pturnEn <= '0';
                            end if;
                        end if;
                    when dealerturns => 
                        if unsigned(dealerpoints) < 16 then
                            curr <= dealerturns;
                        else
                            curr <= result;
                            dturnEn <= '0';
                            calculate_result <= '1';
                        end if;
                    when result => 
                          curr <= start_game;
                          calculate_result <= '0';
                end case;
            end if;
        end if;
    end process;

end Behavioral;
