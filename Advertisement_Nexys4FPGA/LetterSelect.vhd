library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LetterSelect is
	port ( LetterU : in std_logic; --Letter Select UP
			 LetterD : in std_logic; --Letter Select DOWN
			 LetterO : out std_logic_vector(6 downto 0)); --Output the letter selected
end LetterSelect;

architecture arch5 of LetterSelect is
component LettersROM is
	port ( dataIn : in std_logic_vector (4 downto 0); --Addresses for the letters
			 dataOut : out std_logic_vector (6 downto 0)); --Contents (actual letters)
end component LettersROM;
signal counter      : std_logic_vector (4 downto 0) := (others => '0'); --Cycles through all the letters (states between 0 and 26 = 27 characters)
signal counterReset : std_logic; --Asynchronous RESET
signal counterSet   : std_logic; --Asynchronous SET to state 26 ('11010')
signal counterOut   : std_logic_vector (4 downto 0) := (others => '0'); --Outputs current letter (state) of the counter
begin

COUNT : process (LetterU, LetterD) --Cycles through all the letters
	begin
		counterOut <= counter;
		if (LetterU = '1' and LetterU'EVENT) then counter <= counter + 1; --get to the next state
		elsif (LetterD = '1' and LetterD'EVENT) then counter <= counter - 1; --get to previous state
		end if;
		--Sets counter to state 0 if it reached reached state 27
		counterReset <= counterOut(4) and counterOut(3) and not(counterOut(2)) and counterOut(1) and counterOut(0);
		if counterReset = '1' then counter <= (others => '0');
		end if;
		--Sets counter to state 26 if it reached state 31 (going back from 0)
		counterSet   <= counterOut(4) and counterOut(3) and counterOut(2) and counterOut(1) and counterOut(0);
		if counterSet = '1' then counter <= "11010";
		end if;
end process COUNT;

ROMM : LettersROM port map (counterOut, LetterO);

end arch5;

