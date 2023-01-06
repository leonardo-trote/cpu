library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--fazer novo mux

entity mux2 is
	port(A, B: in STD_LOGIC_VECTOR(7 DOWNTO 0);
	S : in STD_LOGIC;
	O : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end mux2;

architecture rtl of mux2 is
begin
  p_mux : process(A,B,S)
  begin
    if(S='0') then
      O <= A;
    else
      O <= B;
    end if;
  end process p_mux;
end rtl;
