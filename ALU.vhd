library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity ALU is
	Port ( OP : in ALUOpT;
	cFlagIN : in STD_LOGIC;
	A : in STD_LOGIC_VECTOR(7 DOWNTO 0);
	B : in STD_LOGIC_VECTOR(7 DOWNTO 0);
	Z : out STD_LOGIC_VECTOR(7 DOWNTO 0);
	zFlag, cFlagOUT : out std_logic);	
end ALU;

architecture rtl of ALU is
	
   signal A9: unsigned(8 DOWNTO 0);
	signal B9: unsigned(8 DOWNTO 0);
	signal C9: unsigned(8 DOWNTO 0);	
	signal Z9: unsigned(8 DOWNTO 0);
	
	begin
	
	A9 <= '0' & unsigned(A);
	B9 <= '0' & unsigned(B);
	C9 <= unsigned'("00000000") & cFlagIN; --nao ta conextado
	
	with OP select
	   Z9 <= B9 when aoMOV,
				A9 + unsigned'("1") when aoINC,
		      A9 - unsigned'("1") when aoDEC,
				A9 + C9 when aoINCC, 
				A9 + C9 - unsigned'("1") when aoDECB,
				A9 + B9 when aoADD,
				A9 - B9 when aoSUB,
				not A9 + unsigned'("1") when aoNEG,
				
				not(A9) when aoNOT,
				(A9 and B9) when aoAND,
				(A9 or B9) when aoOR,
				(A9 xor B9) when aoXOR, 
				
				(A9(7 downto 0) & '0') when aoLSL, 
				(A9(0) & '0' & A9(7 downto 1)) when aoLSR, 
				(A9(7 downto 0) & cFlagIN) when aoROL, 
				(A9(0) & cFlagIn & A9(7 downto 1))when aoROR; 
				
	Z <= STD_LOGIC_VECTOR(Z9(7 downto 0));
	cFlagOUT <= Z9(8);
	
	ZFlag <= '1' when Z9(7 downto 0) = "00000000" else '0';
	

end rtl;