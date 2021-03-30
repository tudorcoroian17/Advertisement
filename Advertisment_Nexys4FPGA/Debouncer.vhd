LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
	generic (counterSize : integer := 20);  --counter size (20 bits gives 10.5ms with 100MHz clock)
	port (button : in std_logic;  --signal to be debounced
			clock : in std_logic;  --input clock at 100MHz
			result : out std_logic);  --debounced signal
end Debouncer;

architecture arch1 of Debouncer is
signal flipFlops  : std_logic_vector (1 downto 0); --input FlipFlops
signal counterSet : std_logic; --synchronous set to 0
signal counterOut : std_logic_vector (counterSize downto 0) := (others => '0'); --counter output
begin
	counterSet <= flipFlops(1) xor flipFlops(0); --determine when to reset the counter
	
debounce: process (clock)
	begin
		if (clock'event and clock = '1') then flipFlops(1) <= button;
														  flipFlops(0) <= flipFlops(1);
			if counterSet = '1' then counterOut <= (others => '0'); --reset the counter because the input is changing
			elsif counterOut(counterSize) = '0' then counterOut <= counterOut + 1; --count, stability time in not met yet
			elsif counterOut(counterSize) = '1' then result <= flipFlops(1); --stability time is met;
			end if;
		end if;
end process debounce;

end arch1;

