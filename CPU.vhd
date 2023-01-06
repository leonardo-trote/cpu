library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity CPU is
	Port ( CLK_50MHZ : in STD_LOGIC;
			J1, J2 : out Nibble );
end CPU;

architecture rtl of CPU is
	signal ADDR : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal ADDR_MUX : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal MUX_C : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal OP: ALUOpT;
	signal EN: STD_LOGIC;
	signal SEL : STD_LOGIC_VECTOR(5 DOWNTO 0);
	signal sA, sC: STD_LOGIC;
	
	signal Z, A, B, O: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal WE : STD_LOGIC;
	signal DATAIN : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal DATAOUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal DISPLAY_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	signal cFlagIN : std_logic;
	signal zFlag, cFlagOUT : std_logic;
	signal S: std_logic;	
	
	begin

		--alu gera carry - instrucos - incc usa carry
		CU: entity work.CU port map(CLK_50MHZ, DATAOUT, zFlag, cFlagOUT, WE, ADDR, OP, EN, SEL, cFlagIN, sA, sC);
		RU: entity work.RU port map(CLK_50MHZ, EN, SEL, MUX_C, A, B);
		LSU: entity work.LSU port map(CLK_50MHZ, WE, EN, ADDR_MUX, B, DATAOUT, DISPLAY_OUT);
		ALU: entity work.ALU port map(OP, cFlagIN, A, B, Z, zFlag, cFlagOUT);
		mux2: entity work.mux2 port map(ADDR,A,sA,ADDR_MUX);
		mux2c: entity work.mux2c port map(DATAOUT,Z,sC,MUX_C);
		drive: entity work.drive port map(CLK_50MHZ, DISPLAY_OUT, J1, J2);		

end rtl;