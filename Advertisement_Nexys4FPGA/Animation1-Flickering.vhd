library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Animation1_Flickering is
	port ( word  : in std_logic_vector (55 downto 0);--The word to be animated (max 8 letters)
			 clock : in std_logic;--Board clock at f = 100MHz
			 aWord : out std_logic_vector (55 downto 0));--Animated word
end Animation1_Flickering;

architecture arch9 of Animation1_Flickering is
signal CLK : std_logic; --New clock at f = 1Hz
component FrequencyDivider2 is
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end component FrequencyDivider2;


begin
Flicker : process (CLK)
	begin
		if (CLK = '1' and CLK'EVENT) then aWord <= word; --Output the word on the rising edge of the clock
											  else aWord <= (others => '0'); -- Output 0 otherwise
		end if;	
end process Flicker;
	
C_FD2  : FrequencyDivider2 port map (clock, CLK);
end arch9;

