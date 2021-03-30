library IEEE;																										
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AND7 is
	port ( dataIn : in std_logic_vector (6 downto 0); --Vector as first input
			 dot    : in std_logic; --Single bit as second input
			 dataOut: out std_logic_vector (6 downto 0)); --Vector as output
end AND7;

architecture Behavioral of AND7 is

begin
prAND : process (dot, dataIn)
	begin
		dataOut(6) <= dataIn(6) and dot;
		dataOut(5) <= dataIn(5) and dot;
		dataOut(4) <= dataIn(4) and dot;
		dataOut(3) <= dataIn(3) and dot;
		dataOut(2) <= dataIn(2) and dot;
		dataOut(1) <= dataIn(1) and dot;
		dataOut(0) <= dataIn(0) and dot;
end process prAND;
end Behavioral;

