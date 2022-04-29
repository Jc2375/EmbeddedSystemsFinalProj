library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div is
  Port (Clock: in std_logic;
        Div: out std_logic );
end clock_div;

architecture clock_div of clock_div is
      signal count : std_logic_vector (25 downto 0) := (others => '0');
begin
    process(Clock)
    begin
        if rising_edge(Clock) then
        if(not( count="11101110011010110010100000")) then
        Div <= '0';
            count <= std_logic_vector(unsigned(count) + 1); 
            elsif(count="11101110011010110010100000") then
                Div <= '1';
            count <="00000000000000000000000000"; 
            end if;
    end if;
    end process;

end;