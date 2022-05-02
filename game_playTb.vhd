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
  Port (clk, en, hit, stay,cycle: in std_logic;
        pwin, dwin, tie, pbust, dbust: inout std_logic;
        playerpoints, dealerpoints: inout std_logic_vector(7 downto 0)
       );
end component;
signal clk, en, hit, stay, start, pwin, dwin, tie, pbust, dbust: std_logic;
signal playerpoints, dealerpoints: std_logic_vector(7 downto 0);
signal cycle: std_logic:= '1';
begin
     dut: game_play port map (
        clk => clk,
        en => en, 
        hit => hit, 
        stay => stay, 
        cycle => cycle,
        pwin => pwin, 
        dwin => dwin, 
        tie => tie,
        pbust => pbust, 
        dbust => dbust,
        playerpoints => playerpoints,
        dealerpoints => dealerpoints
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
        wait for 25 ns;
        hit <= '0';
        stay <= '1';
    end process;
end Behavioral;