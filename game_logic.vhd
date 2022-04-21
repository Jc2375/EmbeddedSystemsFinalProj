----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2022 05:58:48 PM
-- Design Name: 
-- Module Name: game_logic - Behavioral
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

entity game_logic is
  Port ( clk, en: in std_logic;
  Player_points, Dealer_points: in std_logic_vector(4 downto 0);
        pwin,dwin, pbust, dbust: out std_logic := '0'
  );
end game_logic;

architecture Behavioral of game_logic is
    signal p, d: unsigned(4 downto 0);
    
begin
    p <= unsigned(Player_points);
    d <= unsigned(Dealer_points);
    process(clk) begin
        if rising_edge(clk) then
            if en= '1' then
                if  p > 21  then
                    pbust<= '1'; dwin <= '1';
                elsif d > 21 then
                    dbust <= '1'; pwin <= '1';
                elsif p = 21 OR p > d then
                    pwin <= '1'; 
                else
                    dwin <= '1';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
