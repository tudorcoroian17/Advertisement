library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MainAdv is
	port ( LSelU : in std_logic; --Letter Select Up
			 LSelD : in std_logic; --Letter Select Down
			 DSelL : in std_logic; --Display Select Left
			 DSelR : in std_logic; --Display Select Right
			 --Actually selects the register in which the letter for the specified display will be stored
			 ASel  : in std_logic; --Animation Select
			 CLKB   : in std_logic; --Board clock
			 Load  : in std_logic; --Load a word letter by letter
			 cathodes : out std_logic_vector (6 downto 0); --BCD decoder segments
			 anodes   : out std_logic_vector (7 downto 0)); --BCD decoder anodes for Nexys4
end MainAdv;

architecture arch3 of MainAdv is
signal LSelUdb   : std_logic; --Debounced Letter Select Up
signal LSelDdb   : std_logic; --Debounced Letter Select Down
signal DSelLdb   : std_logic; --Debounced Display Select Left
signal DSelRdb   : std_logic; --Debounced Display Select Right
signal ASeldb    : std_logic; --Debounced Animation Select
signal Letter    : std_logic_vector(6 downto 0); --Letter output from LetterSelect
signal ClockA    : std_logic; --Clock at f = 760Hz used in showing the word on the BCD decoder segments
signal Display   : std_logic_vector(7 downto 0); --Display output from DisplaySelect
signal Animation : std_logic_vector(1 downto 0); --Chose an animation
signal Word      : std_logic_vector(55 downto 0) := (others => '1'); --Register where the introduced word it's stored
signal alWord    : std_logic_vector(55 downto 0); --Animated loading word
signal anodeSel  : std_logic_vector(2 downto 0); --Anode selector for MUX
signal aaWord    : std_logic_vector(55 downto 0); --Animated animation word
signal wordOutput: std_logic_vector(55 downto 0); --Word in the final animated form (load or actual animation)

-----------------------------------------------------------------------------------Debouncing the signals from the buttons
component Debouncer is
	port ( button : in std_logic;  --signal to be debounced
			 clock  : in std_logic;  --input clock at 100MHz
			 result : out std_logic);  --debounced signal
end component Debouncer;
------------------------------------------------------------------------------------------------------Selecting the letter
component LetterSelect is
	port ( LetterU : in std_logic; --Letter Select UP
			 LetterD : in std_logic; --Letter Select DOWN
			 LetterO : out std_logic_vector(6 downto 0)); --Output the letter selected
end component LetterSelect;
------------------------------------------------------------------------Divinding the frequency of the CLKB down to 760 Hz
component FrequencyDivider is
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end component FrequencyDivider;
-----------------------------------------------------------------------------------------------------Selecting the display
component DisplaySelect is
	port ( DisplayL : in std_logic; --Move to the left display (count UP)
			 DisplayR : in std_logic; --Move to the right display (count DOWN)
			 DisplayO : out std_logic_vector(7 downto 0)); --Output the selected diplay (have a '1' on 
																		  --the corresponding position) 
end component DisplaySelect;
---------------------------------------------------------------------------------------------------Selecting the animation
component AnimationSelect is
	port ( AnimationS : in std_logic; --Animation Select
			 AnimationO : out std_logic_vector(1 downto 0)); --Chosen animation
end component AnimationSelect;
--------------------------------------------------------------------------------------------Animation for loading the word
component LoadModeDisplay is
	port ( Display : in std_logic_vector(7 downto 0); --Current Display
			 clock   : in std_logic; --Board clock at f = 100MHz
			 word    : in std_logic_vector(55 downto 0); --Previously loaded word to display
			 aWord   : out std_logic_vector(55 downto 0)); --Animated word
end component LoadModeDisplay;
-----------------------------------------------------Selecting anodes of the board and switchs between letter for cathodes
component AnodeSelector is
	port ( clock  : in std_logic; --Clock signal at f = 760Hz
			 anodeS : out std_logic_vector(2 downto 0); --Anode selector for MUX
			 anodeB : out std_logic_vector(7 downto 0)); --Board anodes with 8 entries (Nexys4)
end component AnodeSelector;
-----------------------------------------------------------------Displaying the selected animation on the 7Seg BCD decoder
component AnimationModeDisplay is
	port ( wordM      : in std_logic_vector (55 downto 0);--The word from the main circuit (max 8 letters)
			 clockB     : in std_logic;--Board clock at f = 100MHz
			 AnimationS : in std_logic_vector (1 downto 0); --Animation selector
			 aWordO     : out std_logic_vector (55 downto 0));--Animated word output
end component AnimationModeDisplay;
--------------------------------------------------------------------------------------------------------------------------
begin

LOAD_WORD : process (Letter, Display) --Loading the word in a big register
	begin
		case Display is
			when "10000000" => Word ( 55 downto 49 ) <= Letter; --Load 1st letter
			when "01000000" => Word ( 48 downto 42 ) <= Letter; --Load 2nd letter
			when "00100000" => Word ( 41 downto 35 ) <= Letter; --Load 3rd letter
			when "00010000" => Word ( 34 downto 28 ) <= Letter; --Load 4th letter
			when "00001000" => Word ( 27 downto 21 ) <= Letter; --Load 5th letter
			when "00000100" => Word ( 20 downto 14 ) <= Letter; --Load 6th letter
			when "00000010" => Word ( 13 downto  7 ) <= Letter; --Load 7th letter
			when "00000001" => Word (  6 downto  0 ) <= Letter; --Load 8th letter
			when others => null;
		end case;
end process LOAD_WORD;
FINAL : process (anodeSel, Load)
	begin
		case Load is
			when '1' => wordOutput <= alWord; --When Load is active show Load mode display
			when '0' => wordOutput <= aaWord; --When Load is inactive show actual chosen animation
			when others => null; --Do nothing
		end case;
		case anodeSel is --Show letter on the display very fast so it seems simultaneous 
			when "000" => cathodes <= wordOutput( 6 downto  0); 
			when "001" => cathodes <= wordOutput(13 downto  7); 
			when "010" => cathodes <= wordOutput(20 downto 14); 
			when "011" => cathodes <= wordOutput(27 downto 21); 
			when "100" => cathodes <= wordOutput(34 downto 28); 
			when "101" => cathodes <= wordOutput(41 downto 35); 
			when "110" => cathodes <= wordOutput(48 downto 42); 
			when "111" => cathodes <= wordOutput(55 downto 49); 
			when others => null;
		end case;
end process FINAL;
----------------------------------------------------------------------------------------------------------------Debouncers
C1 : Debouncer port map ( LSelU, CLKB, LSelUdb );
C2 : Debouncer port map ( LSelD, CLKB, LSelDdb );
C3 : Debouncer port map ( DSelL, CLKB, DSelLdb );
C4 : Debouncer port map ( DSelR, CLKB, DSelRdb );
C5 : Debouncer port map ( ASel , CLKB, ASeldb  );
-------------------------------------------------------------------------------------------------------------Letter select
C6 : LetterSelect port map ( LSelUdb, LSelDdb, Letter );
------------------------------------------------------------------------------------------------Frequency divider (760 Hz)
C7 : FrequencyDivider port map ( CLKB, ClockA );
------------------------------------------------------------------------------------------------------------Display select
C8 : DisplaySelect port map ( DSelLdb, DSelRdb, Display );
----------------------------------------------------------------------------------------------------------Animation select
C9 : AnimationSelect port map ( ASeldb, Animation); 
---------------------------------------------------------------------------------------------------------Load mode display
C10: LoadModeDisplay port map ( Display, CLKB, Word, alWord);
------------------------------------------------------------------------------------------------------------Anode selector
C11: AnodeSelector port map ( clockA, anodeSel, anodes );
----------------------------------------------------------------------------------------------------Animation mode display
C12: AnimationModeDisplay port map ( Word, CLKB, Animation, aaWord );
end arch3;

