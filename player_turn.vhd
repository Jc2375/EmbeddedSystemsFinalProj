----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2022 10:54:53 PM
-- Design Name: 
-- Module Name: player_turn - Behavioral
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

entity player_turn is
  Port ( clk, en:in std_logic;
            new_card: in std_logic_vector(7 downto 0);
            points: in std_logic_vector(7 downto 0);
            updatedpoints: out std_logic_vector(7 downto 0):= (others => '0'));
end player_turn;

architecture Behavioral of player_turn is

begin
 process(clk) begin
        if rising_edge(clk) then
            if en= '1' then
               if unsigned(new_card) > 13 OR unsigned(new_card) = 0 then
                    updatedpoints <= std_logic_vector(unsigned(points) + 6);
               else
                    updatedpoints <= std_logic_vector(unsigned(points) + unsigned(new_card));
               end if;
                
            end if;
        end if;
    end process;

end Behavioral;
