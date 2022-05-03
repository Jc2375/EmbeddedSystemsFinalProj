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
  Port ( clk, en, rst: in std_logic;
  Player_points, Dealer_points: in std_logic_vector(7 downto 0);
        pwin,dwin, pbust, dbust, tie, updateP, updateD: out std_logic := '0'
  );
end game_logic;

architecture Behavioral of game_logic is
    signal p, d: unsigned(7 downto 0);
    
begin
    p <= unsigned(Player_points);
    d <= unsigned(Dealer_points);
    process(clk) begin
        if rising_edge(clk) then
            
            if en= '1' then
                if rst = '1' then 
                    pwin <= '0';
                    dwin <= '0';
                    pbust <= '0';
                    dbust <= '0';
                    tie <= '0';
                    updateD <= '1'; updateP <= '1';
                elsif  p > 21  then
                    pbust <= '1'; dwin <= '1'; pwin <= '0'; dbust <= '0'; updateD <= '0'; updateP <= '0';
                elsif d > 21 then
                    dbust <= '1'; pwin <= '1'; dwin <= '0'; pbust <= '0';updateD <= '0'; updateP <= '0';
                elsif p = 21 OR p > d then
                    pwin <= '1';  updateD <= '0'; updateP <= '0';
                elsif p = d then 
                    tie <= '1'; updateD <= '0'; updateP <= '0'; pwin <= '0'; dwin <= '0';
                else
                    dwin <= '1'; updateD <= '0'; updateP <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
