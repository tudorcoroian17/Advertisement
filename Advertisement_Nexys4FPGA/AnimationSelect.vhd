library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AnimationSelect is
	port ( AnimationS : in std_logic; --Animation Select
			 AnimationO : out std_logic_vector(1 downto 0)); --Chosen animation
end AnimationSelect;

architecture arch7 of AnimationSelect is
signal counter : std_logic_vector(1 downto 0) := (others => '0'); --Internal state
signal counterOut : std_logic_vector(1 downto 0) := (others => '0'); --Output the state of the counter
begin
COUNT : process (AnimationS)
	begin
		counterOut <= counter;
		if (AnimationS = '1' and AnimationS'EVENT) then counter <= counter + 1; --Get to next animation (state)
		end if;
		AnimationO <= counterOut;
end process COUNT;
end arch7;

