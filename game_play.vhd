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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game_play is
  Port (clk, en, hit, stay,start: std_logic;
        );
end game_play;

architecture Behavioral of game_play is
type state is (start_game, deal, playerturns, dealerturns, result);
signal curr: state;
signal dealEn, pturnEn: std_logic;
signal dealHit, dealStay: std_logic;
begin
    process(clk) begin
        if rising_edge(clk) then
            if en= '1' then
                case curr is
                    when start_game => 
                        curr <= deal;
                        dealEn <= '1';
                    when deal => 
                        curr <= playerturns;
                        pturnEn <= '1';
                    when playerturns =>
                        if hit = '1' then
                            curr <= playerturns;
                        elsif stay = '1'then
                            curr <= dealerturns;
                        end if;
                    when dealerturns => 
                        if dealHit = '1' then
                            curr <= dealerturns;
                        elsif dealStay = '1'then
                            curr <= result;
                        end if;
                     when result => 
                        
                end case;
            end if;
        end if;
    end process;

end Behavioral;
