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
  Port ( clk, en: in std_logic;
        JA: in std_logic_vector(7 downto 0);
         pwin, dwin, tie, pbust, dbust: inout std_logic:= '0';
         CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC   );
end game_top;

architecture Structural of game_top is
component PmodKYPD is
    Port ( 
			  clk : in  STD_LOGIC;
			  JA : inout  STD_LOGIC_VECTOR (7 downto 0) -- PmodKYPD is designed to be connected to JA 
			  ); -- digit to display on the seven segment display 
end component;
component PmodOLEDCtrl is
	Port ( 
		CLK 	: in  STD_LOGIC;
		RST 	: in  STD_LOGIC;
		 Player_points, Dealer_points: in std_logic_vector(7 downto 0);
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
  Port (clk, en, hit, stay,start: in std_logic;
        pwin, dwin, tie, pbust, dbust: inout std_logic;
        playerpoints, dealerpoints: inout std_logic_vector(7 downto 0)
        );       
end component;

signal playerpoints, dealerpoints : std_logic_vector(7 downto 0);
signal hit, stay, start: std_logic := '0';
--signal pwin1, dwin1, tie1, pbust1, dbust1: std_logic ;
signal JA_input: std_logic_vector(7 downto 0);
begin
    pmodoled: PmodOLEDCtrl port map(
        CLK => clk,
        RST=> '0',
        Player_points => playerpoints,
        Dealer_points => dealerpoints,
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
        en => en,  --SWITCH??
        hit => hit, 
        stay => stay,
        start => start,
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
        JA => JA_input -- NOT USED??? do i even need this, aslo ja_ inpnut recieves nothing rn, just using JA
    );
  
    game: process(clk) begin
        if rising_edge(clk) then
            if en = '1' then
                start <= '1';
                if JA = "00000001" then 
                    hit <= '1';
                    stay <= '0';
                elsif JA = "00000010" then 
                    stay <= '1';
                    hit <= '0';
                else 
                    hit <= '0';
                    stay <= '0';
                end if;
            end if;
        end if;
    end process;
end Structural;
