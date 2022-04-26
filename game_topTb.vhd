----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 11:11:28 PM
-- Design Name: 
-- Module Name: game_topTb - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity game_topTb is
--  Port ( );
end game_topTb;

architecture Behavioral of game_topTb is
component game_top is
  Port ( clk, en: in std_logic;
        JA: in std_logic_vector(7 downto 0);
        pwin, dwin, tie, pbust, dbust: inout std_logic;
         CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC   );
end component;
signal clk , en :std_logic;
signal JA1: std_logic_vector(7 downto 0) := (others => '0');

signal pwin, dwin, tie, pbust, dbust: std_logic ;
begin
    gametop: game_top port map(
        clk => clk,
         en => en,
         JA => JA1,
         pwin => pwin,
        dwin => dwin,
        tie => tie,
        pbust => pbust,
        dbust => dbust
    );
    
    process begin
            clk <= '0';
            wait for 4 ns;
            clk <= '1';
            wait for 4 ns;
        end process;
    
        -- en process @ 125 MHz / 1085 = ~115200 Hz
    process begin
            en <= '0';
            wait for 8 ns;
            en <= '1';
            wait for 8000 ns;
    end process;
    process begin 
        wait until en <= '1';
        wait for 24 ns;
        JA1 <= "00000001";
        wait for 1000ns;
        JA1 <= "00000010";
    end process;
end Behavioral;
