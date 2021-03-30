library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Animation4_ShowOneByOne is
	port ( word  : in std_logic_vector (55 downto 0);--The word to be animated (max 8 letters)
			 clock : in std_logic;--Board clock at f = 100MHz
			 aWord : out std_logic_vector (55 downto 0));--Animated word
end Animation4_ShowOneByOne;

architecture arch10 of Animation4_ShowOneByOne is
signal CLK : std_logic; --New clock at f = 1Hz
signal counter : std_logic_vector(3 downto 0) := (others => '0'); --Counter on 4 bits
component FrequencyDivider2 is
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end component FrequencyDivider2;
begin

COUNT : process (CLK)
	begin
		if (CLK = '1' and CLK'EVENT) then counter <= counter + 1; --Get to the next state
		end if;
		if (counter(3) = '1' and counter(0) = '1') then counter <= (others => '0'); --Reset the counter when reaching state 9
		end if;
end process COUNT;

ShowOBO : process (counter)
	begin
		case counter is
			when "0000" => aWord(55 downto 49) <= word(55 downto 49); --Show 1st letter
			when "0001" => aWord(48 downto 42) <= word(48 downto 42); --Show 2nd letter
			when "0010" => aWord(41 downto 35) <= word(41 downto 35); --Show 3rd letter
			when "0011" => aWord(34 downto 28) <= word(34 downto 28); --Show 4th letter
			when "0100" => aWord(27 downto 21) <= word(27 downto 21); --Show 5th letter
			when "0101" => aWord(20 downto 14) <= word(20 downto 14); --Show 6th letter
			when "0110" => aWord(13 downto  7) <= word(13 downto  7); --Show 7th letter
			when "0111" => aWord( 6 downto  0) <= word( 6 downto  0); --Show 8th letter
			when others => aWord <= (others => '0'); --Reinitialize the animated word to be blank
		end case;
end process ShowOBO;

C_FD2 : FrequencyDivider2 port map (clock, CLK);
end arch10;

