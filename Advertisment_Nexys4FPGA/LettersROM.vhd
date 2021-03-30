library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LettersROM is
	port ( dataIn : in std_logic_vector (4 downto 0); --Addresses for the letters
			 dataOut : out std_logic_vector (6 downto 0)); --Contents (actual letters)
end LettersROM;

architecture Behavioral of LettersROM is
type mem is array (0 to 2**5 - 1) of std_logic_vector(6 downto 0);
constant my_Rom : mem := ( --Active low for the cathodes (segments a to g)
	 ------ abcdefg -----
    0  => "0001000", --A
    1  => "1100000", --B
    2  => "0110001", --C
    3  => "1000001", --D
    4  => "0110000", --E
    5  => "0111000", --F
    6  => "0100000", --G
    7  => "1101000", --H
    8  => "1001111", --I
    9  => "0000011", --J
    10 => "1111000", --K
    11 => "1110001", --L
    12 => "0101010", --M
    13 => "1101010", --N
    14 => "0000001", --O
    15 => "0011000", --P
	 16 => "0001100", --Q
    17 => "0010000", --R
    18 => "0100100", --S
    19 => "0001111", --T
    20 => "1000001", --U
    21 => "1100011", --V
    22 => "1000000", --W
    23 => "1001000", --X
    24 => "1000100", --Y
    25 => "0010010", --Z
    26 => "1111111", --Space
	 --It shouldn't get to these states, but oh, well
    27 => "0000000", --none
    28 => "0000000", --none
    29 => "0000000", --none
    30 => "0000000", --none
    31 => "0000000");--none
begin
ROMMEM : process (dataIn)
	begin
		case dataIn is                            --Output a letter based on the specified input
			when "00000" => dataOut <= my_rom(0);  --A
			when "00001" => dataOut <= my_rom(1);  --B
			when "00010" => dataOut <= my_rom(2);  --C
			when "00011" => dataOut <= my_rom(3);  --D
			when "00100" => dataOut <= my_rom(4);  --E
			when "00101" => dataOut <= my_rom(5);  --F
			when "00110" => dataOut <= my_rom(6);  --G
			when "00111" => dataOut <= my_rom(7);  --H
			when "01000" => dataOut <= my_rom(8);  --I
			when "01001" => dataOut <= my_rom(9);  --J
			when "01010" => dataOut <= my_rom(10); --K
			when "01011" => dataOut <= my_rom(11); --L
			when "01100" => dataOut <= my_rom(12); --M
			when "01101" => dataOut <= my_rom(13); --N
			when "01110" => dataOut <= my_rom(14); --O
			when "01111" => dataOut <= my_rom(15); --P
			when "10000" => dataOut <= my_rom(16); --Q
			when "10001" => dataOut <= my_rom(17); --R
			when "10010" => dataOut <= my_rom(18); --S
			when "10111" => dataOut <= my_rom(19); --T
			when "10100" => dataOut <= my_rom(20); --U
			when "10101" => dataOut <= my_rom(21); --V
			when "10110" => dataOut <= my_rom(22); --W
			when "10011" => dataOut <= my_rom(23); --X
			when "11000" => dataOut <= my_rom(24); --Y
			when "11001" => dataOut <= my_rom(25); --Z
			when "11010" => dataOut <= my_rom(26); --Space
			when others  => dataOut <= my_rom(31); --none (digit 8)
		end case;
end process ROMMEM;
end Behavioral;

