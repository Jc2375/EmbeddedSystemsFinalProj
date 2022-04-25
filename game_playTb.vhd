----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2022 10:33:06 PM
-- Design Name: 
-- Module Name: game_playTb - Behavioral
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

entity game_playTb is
--  Port ( );
end game_playTb;

architecture Behavioral of game_playTb is
component game_play is
  Port (clk, en, hit, stay,start: in std_logic;
        pwin, dwin, pbust, dbust: out std_logic;
        CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end component;
signal clk, en, hit, stay, start, pwin, dwin, pbust, dbust, cs, sdin, sclk, dc, res, vbat, vdd : std_logic;

begin
     dut: game_play port map (
        clk => clk,
        en => en, 
        hit => hit, 
        stay => stay, 
        start => start, 
        pwin => pwin, 
        dwin => dwin, 
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
        hit <= '1';
        wait for 1000ns;
        hit <= '0';
        stay <= '1';
    end process;
end Behavioral;
