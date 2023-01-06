library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.hexpackage.ALL;
use work.types.ALL;
use ieee.numeric_std.ALL;

entity drive is
	port (CLK : in STD_LOGIC; NUM: in Byte; JB1 : out Nibble; JB2 : out Nibble);
end drive;

architecture rtl of drive is

	signal contador: integer range 0 to 50001 := 0;
	signal numero: std_logic_vector(6 downto 0);
	signal N1: std_logic_vector(3 downto 0);
	signal N2: std_logic_vector(3 downto 0);
	signal C: std_logic := '1';
	
	begin

	process(CLK) is
		
		begin
			if rising_edge(CLK) then
				contador <= contador + 1;
				if contador > 50000 then
					contador <= 0;
					C <= not(C);
				end if;
				
				if C = '1' then
					numero <= hex2ssd(Nibble(NUM(7 downto 4)));
					
				else
					numero <= hex2ssd(Nibble(NUM(3 downto 0)));
				end if;
			end if;

	end process;
	
	JB1 <= Nibble(numero(3 downto 0));
	JB2 <= Nibble(C & (numero(6 downto 4)));			

end rtl;

