library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

--Divides the frequency of the default board CLK signal
--To be used for all the animations
--T = 1s and f = 1Hz

entity FrequencyDivider2 is
	generic (counterSize : integer := 26); --counter size 26 to reduce frequency from 100MHz down to 1Hz
	port (clock : in std_logic; --clock input
			newClock : out std_logic); --clock output
end FrequencyDivider2;

architecture arch4 of FrequencyDivider2 is
signal counter : std_logic_vector (counterSize downto 0) := (others => '0'); --counter in state 0
signal number  : std_logic_vector (counterSize downto 0) := (others => '1'); --final state
begin
fDivider: process (CLOCK)
	begin
		if (clock = '1' and clock'event) then counter <= counter + 1; --increment counter state if rising edge of clock
			if counter(counterSize) = '1' then newClock <= '1'; --output newClock at f = 1 Hz	
				if counter = number then counter <= (others => '0'); -- reset counter when reaching final state
				end if;
			else newClock <= '0'; --no clock if counter not in final state
			end if;
		end if;
end process fDivider;
end arch4;

