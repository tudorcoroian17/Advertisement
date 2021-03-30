library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AnimationModeDisplay is
	port ( wordM      : in std_logic_vector (55 downto 0);--The word from the main circuit (max 8 letters)
			 clockB     : in std_logic;--Board clock at f = 100MHz
			 AnimationS : in std_logic_vector (1 downto 0); --Animation selector
			 aWordO     : out std_logic_vector (55 downto 0));--Animated word output
end AnimationModeDisplay;

architecture arch13 of AnimationModeDisplay is
signal animWord1 : std_logic_vector(55 downto 0) := (others => '0'); --Animated word place holder for animation 1
signal animWord2 : std_logic_vector(55 downto 0) := (others => '0'); --Animated word place holder for animation 2
signal animWord3 : std_logic_vector(55 downto 0) := (others => '0'); --Animated word place holder for animation 3
signal animWord4 : std_logic_vector(55 downto 0) := (others => '0'); --Animated word place holder for animation 4
----------------------------------------------------------------------------------------------------------------Animation1
component Animation1_Flickering is
	port ( word  : in std_logic_vector (55 downto 0);--The word to be animated (max 8 letters)
			 clock : in std_logic;--Board clock at f = 100MHz
			 aWord : out std_logic_vector (55 downto 0));--Animated word
end component Animation1_Flickering;
----------------------------------------------------------------------------------------------------------------Animation2
component Animation2_SlideLeftToRight is
	port ( word   : in std_logic_vector(55 downto 0); --The word to be animated
			 clock  : in std_logic; --Board clock at f = 100MHz
			 aWord  : out std_logic_vector(55 downto 0)); --The animated word
end component Animation2_SlideLeftToRight;
----------------------------------------------------------------------------------------------------------------Animation3
component Animation3_SlideRightToLeft is
	port ( word   : in std_logic_vector(55 downto 0); --The word to be animated
			 clock  : in std_logic; --Board clock at f = 100MHz
			 aWord  : out std_logic_vector(55 downto 0)); --The animated word
end component Animation3_SlideRightToLeft;
----------------------------------------------------------------------------------------------------------------Animation4
component Animation4_ShowOneByOne is
	port ( word  : in std_logic_vector (55 downto 0);--The word to be animated (max 8 letters)
			 clock : in std_logic;--Board clock at f = 100MHz
			 aWord : out std_logic_vector (55 downto 0));--Animated word
end component Animation4_ShowOneByOne;
--------------------------------------------------------------------------------------------------------------------------
begin
ANIMATION : process (AnimationS)
	begin
		case AnimationS is
			when "00" => aWordO <= animWord1; --Connect Animation1 to output
			when "01" => aWordO <= animWord2; --Connect Animation2 to output
			when "10" => aWordO <= animWord3; --Connect Animation3 to output
			when "11" => aWordO <= animWord4; --Connect Animation4 to output
			when others => null;
		end case;
end process ANIMATION;
ANIM1 : Animation1_Flickering port map ( wordM, clockB, animWord1 );
ANIM2 : Animation2_SlideLeftToRight port map ( wordM, clockB, animWord2 );
ANIM3 : Animation3_SlideRightToLeft port map ( wordM, clockB, animWord3 );
ANIM4 : Animation4_ShowOneByOne port map ( wordM, clockB, animWord4 );
end arch13;

