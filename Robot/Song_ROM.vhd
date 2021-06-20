--****** Song Rom  ADLD***
library IEEE;
use IEEE.std_logic_1164.all;

Entity Song_ROM is 
	port(Note_Num: 	in  STD_LOGIC_VECTOR (5 downto 0);
		 Octave: 	out  STD_LOGIC_VECTOR (1 downto 0);
		 Note: 		out STD_LOGIC_VECTOR (3 downto 0);
		 Duration: 	out  STD_LOGIC_VECTOR (2 downto 0));
End Song_ROM;

	Architecture Structure of Song_ROM  is
	signal data: STD_LOGIC_VECTOR (8 downto 0);
Begin
		Octave <= data(8 downto 7);
		Note <= data(6 downto 3);
	    Duration <= data(2 downto 0);
	Process(Note_Num)
	Begin
		Case Note_Num is
-- How great thou art

when "000000"  => data <=  "010000001";
when "000001"  => data <=  "101000001";
when "000010"  => data <=  "101000001";
when "000011"  => data <=  "101000001";
when "000100"  => data <=  "100101011";
when "000101"  => data <=  "101000001";
when "000110"  => data <=  "101000001";
when "000111"  => data <=  "101000001";
when "001000"  => data <=  "101010001";
when "001001"  => data <=  "101010001";
when "001010"  => data <=  "100110010";
when "001011"  => data <=  "101010011";
when "001100"  => data <=  "101010001";
when "001101"  => data <=  "101010001";
when "001110"  => data <=  "101010001";
when "001111"  => data <=  "101000011";
when "010000"  => data <=  "100101001";
when "010001"  => data <=  "101000001";
when "010010"  => data <=  "101000001";
when "010011"  => data <=  "100110001";
when "010100"  => data <=  "100110001";
when "010101"  => data <=  "100101101";
when "010110"  => data <=  "101000001";
when "010111"  => data <=  "101000001";
when "011000"  => data <=  "101000001";
when "011001"  => data <=  "100101011";
when "011010"  => data <=  "101000001";
when "011011"  => data <=  "101000001";
when "011100"  => data <=  "101000001";
when "011101"  => data <=  "101010001";
--when "011110"  => data <=  "101010001";
--when "011111"  => data <=  "100110010";
--when "100000"  => data <=  "101010011";
--when "100001"  => data <=  "101010001";
--when "100010"  => data <=  "101010001";
--when "100011"  => data <=  "101010001";
--when "100100"  => data <=  "101000101";
--when "100101"  => data <=  "100101001";
--when "100110"  => data <=  "101000001";
--when "100111"  => data <=  "101000001";
--when "101000"  => data <=  "100110001";
--when "101001"  => data <=  "100110001";
--when "101010"  => data <=  "100101101";
--when "101100"  => data <=  "011000001";
--when "101101"  => data <=  "011000001";
--when "101110"  => data <=  "010001001";
--when "101111"  => data <=  "010101011";
--when "110000"  => data <=  "010011001";
--when "110001"  => data <=  "010001001";
--when "110010"  => data <=  "011100001";
--when "110011"  => data <=  "010001001";
--when "110100"  => data <=  "011010001";
--when "110101"  => data <=  "011000101";
--when "110110"  => data <=  "010001001";
--when "110111"  => data <=  "010001001";
--when "111000"  => data <=  "011100001";
--when "111001"  => data <=  "010011101";
--when "111010"  => data <=  "010110001";
--when "111011"  => data <=  "011010001";
--when "111100"  => data <=  "011000001";
--when "111101"  => data <=  "010101001";
--when "111110"  => data <=  "010000001";
--when "111111"  => data <=  "010000001";


when others => Data <= 	   "010000001";--
			
		End Case;
		
	End process;
End Structure;