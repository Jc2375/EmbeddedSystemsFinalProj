----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 10:28:39 PM
-- Design Name: 
-- Module Name: game_top - Structural
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

entity game_top is
  Port ( clk : in std_logic;
        JA: inout std_logic_vector(7 downto 0);
         --pwin, dwin, tie, pbust, dbust: inout std_logic:= '0';
         CS  	: out STD_LOGIC:= '0';
		SDIN	: out STD_LOGIC:= '0';
		SCLK	: out STD_LOGIC:= '0';
		DC		: out STD_LOGIC:= '0';
		RES	: out STD_LOGIC:= '0';
		VBAT	: out STD_LOGIC:= '0';
		VDD	: out STD_LOGIC:= '0'   );
end game_top;

architecture Structural of game_top is
component PmodKYPD is
    Port ( 
			  clk : in  STD_LOGIC;
			  JA : inout  STD_LOGIC_VECTOR (7 downto 0) ;-- PmodKYPD is designed to be connected to JA 
			 Result: out std_logic_vector(3 downto 0) ); 
end component;
component PmodOLEDCtrl is
	Port ( 
		CLK 	: in  STD_LOGIC;
		RST 	: in  STD_LOGIC;
		 Player_points, Dealer_points, hit, stay : in std_logic_vector(7 downto 0);
		 pwin, dwin, tie, pbust, dbust: in std_logic;
		CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end component;
component game_play is
  Port (clk, en,gameplay_en,hitAvailablecross1, hitAvailablecross2, hit, stay, cycle: in std_logic;
        pwin, dwin, tie, pbust, dbust: inout std_logic;
        playerpoints, dealerpoints: inout std_logic_vector(7 downto 0)
        );
end component;
component clock_div is
  Port (Clock: in std_logic;
        Div: out std_logic );
end component;
type state is (deal, turn, finish);
signal curr: state := deal; 
signal playerpoints,pastplayer_points, pastdealer_points,  dealerpoints : std_logic_vector(7 downto 0) := (others => '0');
signal past_result: std_logic_vector(3 downto 0);
signal cycle, en, hit, stay, start: std_logic := '0';
signal gameplay_en: std_logic;
signal pwin, dwin, tie, pbust, dbust: std_logic ;
signal JA_decoded: std_logic_vector(3 downto 0);
signal hit1, stay1: std_logic_vector(7 downto 0);
signal hitAvailable: std_logic := '1';
signal hitAvailcross1,hitAvailcross2: std_logic := '0';
begin
    clock: clock_div port map(
        Clock => clk,
        Div => en
   );
   
    pmodoled: PmodOLEDCtrl port map(
        CLK => clk,
        RST=> '0',
        Player_points => playerpoints,
        Dealer_points => dealerpoints,
        hit => hit1,
        stay => stay1,
        pwin => pwin,
        dwin => dwin,
        tie => tie,
        dbust => dbust,
        pbust => pbust,
        CS => CS,
        SDIN => SDIN, 
        SCLK => SCLK ,
        DC => DC ,
        RES => RES ,
        VBAT => VBAT, 
        VDD => VDD
        );
    gameplay: game_play port map(
        clk => clk,
        en => gameplay_en,
        gameplay_en => gameplay_en,  --SWITCH??
        hitAvailablecross1 => hitAvailcross1,
         hitAvailablecross2 => hitAvailcross2,
        hit => hit, 
        stay => stay,
        cycle => cycle,
        pwin => pwin,
        dwin => dwin,
        tie => tie,
        dbust => dbust,
        pbust => pbust,
        playerpoints => playerpoints,
        dealerpoints => dealerpoints
    );
    keypad: PmodKYPD port map(
        clk => clk,
        JA => JA,
        Result => JA_decoded
    );
  
    game: process(clk) begin
        if rising_edge(clk) then
            if en = '1' then
                case curr is 
                    when deal => 
                        gameplay_en <= '1';
                        if pastdealer_points= "00000000" then 
                            pastdealer_points<= dealerpoints;
                            pastplayer_points <= playerpoints;
                            curr <= deal;
                        elsif pastdealer_points < dealerpoints AND pastplayer_points < playerpoints then
                            pastdealer_points<= dealerpoints;
                            pastplayer_points <= playerpoints;
                            curr <= deal;
                        elsif pastdealer_points = dealerpoints AND pastplayer_points = playerpoints then
                          --if they havent changed and finished dealing
                            if JA_decoded = "0001" AND hitAvailable = '1' then 
                                hit <= '1';
                                hit1 <="00000001";
                                stay <= '0';
                                stay1 <= "00000000";
                                curr <= turn;
                                cycle <= '0';
                                hitAvailable<= '0';
                                gameplay_en <= '1';
                            elsif JA_decoded = "0010" then 
                                stay <= '1';
                                stay1 <= "00000001";
                                hit <= '0';
                                hit1 <="00000000";
                                curr <= turn;
                                cycle <= '0';
                                gameplay_en <= '1';
                            else 
                                hit <= '0';
                                hit1 <="00000000";
                                stay <= '0';
                                stay1 <= "00000001";
                                curr <= deal;
                                cycle <= '0';
                                gameplay_en <= '0'; 
                            end if;
                        end if;
                   when turn =>
                       if pbust = '1' OR dbust = '1' then 
                            curr <= finish;
                            hit <= '0';
                            stay <= '0';
                            gameplay_en <= '0';

                        elsif JA_decoded = "0001" AND hitAvailable = '1' then 
                            if hitAvailcross1 = '0' then 
                                hitAvailcross1 <= '1';
                                hitAvailcross2 <= '0';
                            else 
                                hitAvailcross1 <= '0';
                                hitAvailcross2 <= '1';
                            end if;
                            hit <= '1';
                            hit1 <="00000001";
                            stay1 <= "00000000";
                            stay <= '0';
                            curr <= turn;
                            hitAvailable <= '0';
                            gameplay_en <= '1';
                        elsif JA_decoded = "0010" then 
                            hit <= '0';
                            stay <= '1';
                            hit1 <="00000000";
                            stay1 <= "00000001";
                            curr <= finish;
                            hitAvailable <= '1';
                            gameplay_en <= '1';
                        elsif JA_decoded = "1111" then                             
                            hitAvailable <= '1';                            
                            hit <= '0';
                           stay <= '0';
                          hit1 <="00000000";
                          curr <= turn;
                         gameplay_en <= '1';
                        else 
        --                   gameplay_en <= '0';  ** HAD THIS YESTERDAY BUT JUST TESTING AROUND
                            curr <= turn;
                            hit <= '0';
                            stay <= '0';
                           hit1 <="00000001";
                            stay1 <= "00000001";
                        end if;

                    when finish => 
                     --   gameplay_en <= '1';
                        stay <= '0';
                        hit <= '0';
                        hit1 <="00000000";
                        stay1 <= "00000000";
                        pastdealer_points<= "00000000";
                            pastplayer_points <= "00000000";
                            
                        if JA_decoded = "0011" then -- play again 
                            curr <= deal;
                            gameplay_en <= '1';
                            cycle <= '1';      hitAvailable <= '1';    hitAvailcross1 <= '0';       hitAvailcross2 <= '0';
                        end if;
                            
                end case;
            end if;
        end if;
    end process;
end Structural;
