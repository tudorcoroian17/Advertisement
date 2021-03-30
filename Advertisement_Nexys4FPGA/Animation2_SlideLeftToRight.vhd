library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Animation2_SlideLeftToRight is
	port ( word   : in std_logic_vector(55 downto 0); --The word to be animated
			 clock  : in std_logic; --Board clock at f = 100MHz
			 aWord  : out std_logic_vector(55 downto 0)); --The animated word
end Animation2_SlideLeftToRight;

architecture arch11 of Animation2_SlideLeftToRight is
signal CLK : std_logic; --New clock at f = 1Hz
signal dummyLetter : std_logic_vector(6 downto 0) := (others => '0'); --Place holder for the last letter being shifted(extra space)
signal tempWord : std_logic_vector(55 downto 0) := (others => '0'); --Dummy word 
signal enable : std_logic := '0'; --Signal to load the word into tempWord if it is empty
component FrequencyDivider2 is
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end component FrequencyDivider2;
begin

ANIM : process (CLK)
	begin		   
		if enable = '0'  then tempWord <= word;
						 	  enable <= '1';
		elsif (CLK = '1' and CLK'EVENT) then tempWord(55 downto 49) <= dummyLetter(6 downto 0); 
													    tempWord(48 downto 42) <= tempWord(55 downto 49); 
														 tempWord(41 downto 35) <= tempWord(48 downto 42); 
														 tempWord(34 downto 28) <= tempWord(41 downto 35); 
														 tempWord(27 downto 21) <= tempWord(34 downto 28);
														 tempWord(20 downto 14) <= tempWord(27 downto 21); 
														 tempWord(13 downto  7) <= tempWord(20 downto 14); 
														 tempWord( 6 downto  0) <= tempWord(13 downto  7);
														 dummyLetter(6 downto 0) <= tempWord(6 downto 0);
		end if;
		aWord <= tempWord;
end process ANIM;
C_FD2 : FrequencyDivider2 port map (clock, CLK);
end arch11;

