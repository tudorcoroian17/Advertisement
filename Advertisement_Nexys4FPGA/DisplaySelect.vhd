library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplaySelect is
	port ( DisplayL : in std_logic; --Move to the left display (count UP)
			 DisplayR : in std_logic; --Move to the right display (count DOWN)
			 DisplayO : out std_logic_vector(7 downto 0)); --Output the selected diplay (have a '1' on the corresponding position) 
end DisplaySelect;

architecture arch6 of DisplaySelect is
signal counterOut : std_logic_vector(2 downto 0) := (others => '0'); --Output the current state of the counter
signal counter    : std_logic_vector(2 downto 0) := (others => '0'); --Internal state of the counter
begin

COUNT : process (DisplayL, DisplayR)
	begin
		counterOut <= counter;
		if (DisplayL = '1' and DisplayL'EVENT) then counter <= counter + 1; --Get to the left display (next state)
		elsif (DisplayR = '1' and DisplayR'EVENT) then counter <= counter - 1; --Get to the right display (previous state)
		end if;
		case counterOut is
			when "000"  => DisplayO <= "00000001"; --Select 1st display
			when "001"  => DisplayO <= "00000010"; --Select 2nd display
			when "010"  => DisplayO <= "00000100"; --Select 3rd display
			when "011"  => DisplayO <= "00001000"; --Select 4th display
			when "100"  => DisplayO <= "00010000"; --Select 5th display
			when "101"  => DisplayO <= "00100000"; --Select 6th display
			when "110"  => DisplayO <= "01000000"; --Select 7th display
			when "111"  => DisplayO <= "10000000"; --Select 8th display
			when others => DisplayO <= (others => '0'); --Error
		end case;
end process COUNT;
end arch6;

