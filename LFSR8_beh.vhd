LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LFSR8 IS
  PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (7 DOWNTO 0));
END LFSR8;

ARCHITECTURE LFSR8_beh OF LFSR8 IS
  SIGNAL Currstate, Nextstate: std_logic_vector (natural DOWNTO 0);
  SIGNAL feedback: std_logic;
  signal pseudo_rand: std_logic_vector(31 downto 0);
BEGIN

         process(clk)
     
      -- maximal length 32-bit xnor LFSR based on xilinx app note XAPP210
      function lfsr32(x : std_logic_vector(31 downto 0)) return std_logic_vector is
      begin
        return x(30 downto 0) & (x(0) xnor x(1) xnor x(21) xnor x(31));
      end function;
     
    begin
      if rising_edge(clk) then
        if rst='1' then
          pseudo_rand <= (others => '0');
        else
          pseudo_rand <= lfsr32(pseudo_rand);
          output <= "00001001";
        end if;
      end if;
      
    end process;
END LFSR8_beh;