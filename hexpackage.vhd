library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.types.ALL;

package hexpackage is
	
	function hex2ssd ( HEX : Nibble ) return std_logic_vector ;
	
end hexpackage;

package body hexpackage is
	
	function hex2ssd ( HEX : Nibble ) return std_logic_vector is

		variable DISP: std_logic_vector(6 downto 0);

	begin
		if HEX = "0000" then 
			DISP := "0111111"; --0
		elsif HEX = "0001" then 
			DISP := "0000110"; --1
		elsif HEX = "0010" then 
			DISP := "1011011"; --2
		elsif HEX = "0011" then 
			DISP := "1001111"; --3
		elsif HEX = "0100" then 
			DISP := "1100110"; --4
		elsif HEX = "0101" then 
			DISP := "1101101"; --5
		elsif HEX = "0110" then 
			DISP := "1111101"; --6
		elsif HEX = "0111" then 
			DISP := "0000111"; --7
		elsif HEX = "1000" then 
			DISP := "1111111"; --8
		elsif HEX = "1001" then 
			DISP := "1100111"; --9
		elsif HEX = "1010" then 
			DISP := "1110111"; --a
		elsif HEX = "1011" then 
			DISP := "1111100"; --b
		elsif HEX = "1100" then 
			DISP := "0111001"; --c
		elsif HEX = "1101" then 
			DISP := "1011110"; --d
		elsif HEX = "1110" then 
			DISP := "1111001"; --e
		elsif HEX = "1111" then 
			DISP := "1110001"; --f
		end if;
	
	return DISP;
	
	end function;

end package body;

