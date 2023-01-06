library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RU is
	Port ( CLK : in STD_LOGIC;
			 EN : in STD_LOGIC;
			 SEL : in STD_LOGIC_VECTOR(5 DOWNTO 0);
			 Z : in STD_LOGIC_VECTOR(7 DOWNTO 0);
			 A : out STD_LOGIC_VECTOR(7 DOWNTO 0);
			 B : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end RU;

architecture rtl of RU is

	type registradores is array(0 to 3)of STD_LOGIC_VECTOR(7 downto 0);
	signal regist: registradores := (others => (others => '0'));

begin
	
	A <= regist(to_integer(unsigned(SEL(3 downto 2))));
	B <= regist(to_integer(unsigned(SEL(1 downto 0))));

	process(CLK) is
	begin
		if rising_edge(CLK) and EN = '1' then
			regist(to_integer(unsigned(SEL(5 downto 4)))) <= Z;
		end if;
	end process;
		
end rtl;