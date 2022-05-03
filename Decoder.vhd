----------------------------------------------------------------------------------
-- Company: Digilent Inc 2011
-- Engineer: Michelle Yu  
-- Create Date:      17:18:24 08/23/2011 
--
-- Module Name:    Decoder - Behavioral 
-- Project Name:  PmodKYPD
-- Target Devices: Nexys3
-- Tool versions: Xilinx ISE 13.2
-- Description: 
--	This file defines a component Decoder for the demo project PmodKYPD. 
-- The Decoder scans each column by asserting a low to the pin corresponding to the column 
-- at 1KHz. After a column is asserted low, each row pin is checked. 
-- When a row pin is detected to be low, the key that was pressed could be determined.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decoder is
    Port (
			  clk, rst : in  STD_LOGIC;
          Row : in  STD_LOGIC_VECTOR (3 downto 0);
			 Col : out  STD_LOGIC_VECTOR (3 downto 0);
          DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0));
end Decoder;

architecture Behavioral of Decoder is
signal prev_decodeOut: std_logic_vector(3 downto 0);
signal sclk :STD_LOGIC_VECTOR(19 downto 0);
begin
	process(clk)
		begin
		if rst = '1' then 
		    DecodeOut <= "1111"; 
		elsif clk'event and clk = '1' then
			-- 1ms
			if sclk = "00011000011010100000" then 
				--C1
				Col<= "0111";
				sclk <= sclk+1;
			-- check row pins
			elsif sclk = "00011000011010101000" then	
				--R1
				if Row = "0111" then
					DecodeOut <= "0001";	--1
					prev_decodeOut <= "0001";
				--R2
				elsif Row = "1011" then
					DecodeOut <= "0100"; --4
					prev_decodeOut <= "0100";
				--R3
				elsif Row = "1101" then
					DecodeOut <= "0111"; --7
					prev_decodeOut <= "0111";
				--R4
				elsif Row = "1110" then
					DecodeOut <= "0000"; --0
					prev_decodeOut <= "0000";
				end if;
				sclk <= sclk+1;
			-- 2ms
			elsif sclk = "00110000110101000000" then	
				--C2
				Col<= "1011";
				sclk <= sclk+1;
			-- check row pins
			elsif sclk = "00110000110101001000" then	
				--R1
				if Row = "0111" then		
					DecodeOut <= "0010"; --2
					prev_decodeOut <= "0010";
				--R2
				elsif Row = "1011" then
					DecodeOut <= "0101"; --5
					prev_decodeOut <= "0101";
				--R3
				elsif Row = "1101" then
					DecodeOut <= "1000"; --8
					prev_decodeOut <= "1000";
				--R4
				elsif Row = "1110" then
					DecodeOut <= "1111"; --F
					prev_decodeOut <= "1111";
				end if;
				sclk <= sclk+1;	
			--3ms
			elsif sclk = "01001001001111100000" then 
				--C3
				Col<= "1101";
				sclk <= sclk+1;
			-- check row pins
			elsif sclk = "01001001001111101000" then 
				--R1
				if Row = "0111" then
					DecodeOut <= "0011"; --3	
					prev_decodeOut <= "0011";
				--R2
				elsif Row = "1011" then
					DecodeOut <= "0110"; --6
					prev_decodeOut <= "0110";
				--R3
				elsif Row = "1101" then
					DecodeOut <= "1001"; --9
					prev_decodeOut <= "1001";
				--R4
				elsif Row = "1110" then
					DecodeOut <= "1110"; --E
					prev_decodeOut <= "1110";
				end if;
				sclk <= sclk+1;
			--4ms
			elsif sclk = "01100001101010000000" then 			
				--C4
				Col<= "1110";
				sclk <= sclk+1;
			-- check row pins
			elsif sclk = "01100001101010001000" then 
				--R1
				if Row = "0111" then
					DecodeOut <= "1010"; --A
					prev_decodeOut <= "1010";
				--R2
				elsif Row = "1011" then
					DecodeOut <= "1011"; --B
					prev_decodeOut <= "1011";
				--R3
				elsif Row = "1101" then
					DecodeOut <= "1100"; --C
					prev_decodeOut <= "1100";
				--R4
				elsif Row = "1110" then
					DecodeOut <= "1101"; --D
					prev_decodeOut <= "1101";
				end if;
				sclk <= "00000000000000000000";	
			else
				sclk <= sclk+1;	
			end if;
		end if;
	end process;
		
		
						 
end Behavioral;

