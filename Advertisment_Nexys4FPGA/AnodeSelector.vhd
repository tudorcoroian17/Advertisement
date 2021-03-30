library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AnodeSelector is
	port ( clock  : in std_logic; --Clock signal at f = 760Hz
			 anodeS : out std_logic_vector(2 downto 0); --Anode selector for MUX
			 anodeB : out std_logic_vector(7 downto 0)); --Board anodes with 8 entries (Nexys4)
end AnodeSelector;

architecture arch14 of AnodeSelector is
signal counter : std_logic_vector (2 downto 0) := (others => '0'); --Counter on 3 bits
begin
AN : process (clock)
	begin
		if (clock = '1' and clock'EVENT) then counter <= counter + 1; --Increment internal state of the counter
		end if;
		case counter is
			when "000" => anodeB <= "11111110"; --Activate 8th anode
			when "001" => anodeB <= "11111101"; --Activate 7th anode
			when "010" => anodeB <= "11111011"; --Activate 6th anode
			when "011" => anodeB <= "11110111"; --Activate 5th anode
			when "100" => anodeB <= "11101111"; --Activate 4th anode
			when "101" => anodeB <= "11011111"; --Activate 3rd anode
			when "110" => anodeB <= "10111111"; --Activate 2nd anode
			when "111" => anodeB <= "01111111"; --Activate 1st anode
			when others => null;
		end case;
		anodeS <= counter;
end process AN;
end arch14;

