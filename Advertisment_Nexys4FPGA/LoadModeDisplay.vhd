library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LoadModeDisplay is
	port ( Display : in std_logic_vector(7 downto 0); --Current Display
			 clock   : in std_logic; --Board clock at f = 100MHz
			 word    : in std_logic_vector(55 downto 0); --Previously loaded word to display
			 aWord   : out std_logic_vector(55 downto 0)); --Animated word
end LoadModeDisplay;

architecture arch8 of LoadModeDisplay is
signal tempWord : std_logic_vector(55 downto 0) := (others => '0'); --Word after the ANDgates-array
signal CLK : std_logic; --New clock at f = 1Hz
component AND7 is
	port ( dataIn : in std_logic_vector (6 downto 0); --Vector as first input
			 dot    : in std_logic; --Single bit as second input
			 dataOut: out std_logic_vector (6 downto 0)); --Vector as output
end component AND7;

component FrequencyDivider2 is
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end component FrequencyDivider2;

begin
ANIM : process (CLK, word, Display)
	begin
		if Display(0) = '1' then aWord(55 downto 49) <= tempWord(55 downto 49);--1st letter animated
								  else aWord(55 downto 49) <= word(55 downto 49);--1st letter
		end if;
		if Display(1) = '1' then aWord(48 downto 42) <= tempWord(48 downto 42);--2ns letter animated
								  else aWord(48 downto 42) <= word(48 downto 42);--2ns letter
		end if;
		if Display(2) = '1' then aWord(41 downto 35) <= tempWord(41 downto 35);--3rd letter animated
								  else aWord(41 downto 35) <= word(41 downto 35);--3rd letter
		end if;
		if Display(3) = '1' then aWord(34 downto 28) <= tempWord(34 downto 28);--4th letter animated
								  else aWord(34 downto 28) <= word(34 downto 28);--4th letter
		end if;
		if Display(4) = '1' then aWord(27 downto 21) <= tempWord(27 downto 21);--5th letter animated
								  else aWord(27 downto 21) <= word(27 downto 21);--5th letter
		end if;
		if Display(5) = '1' then aWord(20 downto 14) <= tempWord(20 downto 14);--6th letter animated
								  else aWord(20 downto 14) <= word(20 downto 14);--6th letter
		end if;
		if Display(6) = '1' then aWord(13 downto  7) <= tempWord(13 downto  7);--7th letter animated
								  else aWord(13 downto  7) <= word(13 downto  7);--7th letter
		end if;
		if Display(7) = '1' then aWord( 6 downto  0) <= tempWord( 6 downto  0);--8th letter animated
								  else aWord( 6 downto  0) <= word( 6 downto  0);--8th letter
		end if;
end process ANIM;

C_AND1 : AND7 port map (word(55 downto 49), CLK, tempWord(55 downto 49));
C_AND2 : AND7 port map (word(48 downto 42), CLK, tempWord(48 downto 42));
C_AND3 : AND7 port map (word(41 downto 35), CLK, tempWord(41 downto 35));
C_AND4 : AND7 port map (word(34 downto 28), CLK, tempWord(34 downto 28));
C_AND5 : AND7 port map (word(27 downto 21), CLK, tempWord(27 downto 21));
C_AND6 : AND7 port map (word(20 downto 14), CLK, tempWord(20 downto 14));
C_AND7 : AND7 port map (word(13 downto  7), CLK, tempWord(13 downto  7));
C_AND8 : AND7 port map (word( 6 downto  0), CLK, tempWord( 6 downto  0));

C_FD2  : FrequencyDivider2 port map (clock, CLK);
end arch8;

