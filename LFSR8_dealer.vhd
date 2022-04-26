LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
ENTITY LFSR8_dealer IS
  PORT (Clk, Rst: IN std_logic;
        output: OUT std_logic_vector (7 DOWNTO 0));
END LFSR8_dealer;

ARCHITECTURE LFSR8_dealer OF LFSR8_dealer IS
  SIGNAL Currstate, Nextstate: std_logic_vector (7 DOWNTO 0);
  SIGNAL feedback: std_logic;
  signal mid :std_logic_vector(7 downto 0);
BEGIN

  StateReg: PROCESS (Clk,Rst)
  BEGIN
    IF (Rst = '1') THEN
      Currstate <= "00000101";
    ELSIF (Clk = '1' AND Clk'EVENT) THEN
      Currstate <= Nextstate;
    END IF;
  END PROCESS;
  
  feedback <= Currstate(5) XOR Currstate(3) XOR Currstate(1) XOR Currstate(0);
  Nextstate <= feedback & Currstate(7 DOWNTO 1);
  mid(3 downto 0) <= Currstate(3 downto 0);
  mid(7 downto 4) <= "0000";
  output <= mid;

END LFSR8_dealer;