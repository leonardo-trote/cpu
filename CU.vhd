library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity CU is
	Port( 
		CLK : in STD_LOGIC;
		DATA : in STD_LOGIC_VECTOR(7 DOWNTO 0);
		zFlag, cFlagOUTALU : in std_logic;
		
		WE : out STD_LOGIC; 
		ADDR : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		OP: out ALUOpT;
		EN: out STD_LOGIC:= '0';
		SEL: out STD_LOGIC_VECTOR(5 DOWNTO 0);
		cFlagINALU: out std_logic;
		sA,sC: out STD_LOGIC:= '0');

end CU;

architecture rtl of CU is
	type StateT is (Fetch1, Fetch2, Decode, Execute);
	signal state: StateT := Fetch1;
	signal PC: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal SP: STD_LOGIC_VECTOR(7 downto 0) := "11111111";
	
	signal FLAG: bit := '0';
	signal RD: STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal RR: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	signal zFlagAux, cFlagOUTAux: std_logic := '0';
	signal DATAAux : STD_LOGIC_VECTOR(7 DOWNTO 0);

	
	begin
		
		
		RD <= DATA(3 downto 2);
		RR <= DATA(1 downto 0);
		
		process(CLK) is
			begin
			if rising_edge(CLK) then
				case state is
					when Fetch1 =>	
						sA <= '0';
						case FLAG IS
							when '0' => 
								ADDR <= PC;
							when '1' => 
								ADDR <= DATA;
								PC <= STD_LOGIC_VECTOR(unsigned(DATA));
								FLAG <= '0';
						end case;
							
						state <= Fetch2;
						
					when Fetch2 =>
						PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
					
						state <= Decode;
					
					when Decode =>
						sC <= '1'; 
						EN <= '1';
					   SEL <= RD & RD & RR;
						DATAAux <= DATA;
						
						case DATA(7 downto 4) is
							--Acesso de memoria			
							when "0000" =>
								case DATA(1 downto 0) is
									when "00" => --ldi
										sA <= '0';
										sC <= '0';	
										ADDR <= PC;
										PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
										
									when "01" => --push
										sA <= '0';	
										ADDR <= SP;
										SP <= STD_LOGIC_VECTOR(unsigned(SP) - 1);
										EN <= '0';
										SEL <= RD & RR & RD;
										
									when "10" => --pop
										sA <= '0';
										sC <= '0';	
										ADDR <= STD_LOGIC_VECTOR(unsigned(SP) + 1);
										SP <= STD_LOGIC_VECTOR(unsigned(SP) + 1);
										
									when others =>
										report "Unimplemented";
								end case;
								
							when "0001" => --ld
								sA <= '1'; 
								sC <= '0';
								SEL <= RD & RR & RD;
							
							when "0010" => --st
								sA <= '1'; 
								WE <= '1';
								EN <= '0';
								SEL <= RD & RR & RD;
							
							--Aritmetica
							
							when "0011" =>
									OP <= aoMOV;
						
							when "0100" =>
								sA <= '1';
								case DATA(1 downto 0) is
									when "00" => --inc
										OP <= aoINC;
									when "01" => --dec
										OP <= aoDEC;
									when others =>
										report "Unimplemented";
								end case;
							
							when "0101" => --add
								OP <= aoADD;
									
							when "0110" => --sub
								OP <= aoSUB;
								
							when "0111" => --cp
								EN <= '0';
								OP <= aoSUB;
								
							when "1000" => 
								case DATA(1 downto 0) is
									when "00" => --neg
										OP <= aoNEG;
							--Logica
									when "01" => --not
										OP <= aoNOT;
									when others =>
										report "Unimplemented";
								end case;
								
							when "1001" => --and
								OP <= aoAND;
							when "1010" => --or
								OP <= aoOR;	
							when "1011" => --xor
								OP <= aoXOR;
							when "1100" => --tst
								OP <= aoAND;
								EN <= '0';
							when "1101" =>
								case DATA(1 downto 0) is
									when "00" => --lsl
										OP <= aoLSL;
									when "01" => --lsr
										OP <= aoLSR;
									when "10" => --rol
										OP <= aoROL;
										
									when "11" => --ror
										OP <= aoROR;
									when others =>
										report "Unimplemented";
								end case;
						
							--Saltos
							when "1111" => 
								EN <= '0';
								case DATA(3 downto 0) is
									when "0000" => --jpm
										sA <= '0';
										ADDR <= PC;
										FLAG <= '1';
									when "0001" => --brz
									
										case zFlagAux is
											when '1' =>
												sA <= '0';
												ADDR <= PC;
												FLAG <= '1';
											when '0' => 
												PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
											when others => report "Unimplemented";
										end case;

									when "0010" => --brnz
									
										case zFlagAux is
											when '0' =>
												sA <= '0';
												ADDR <= PC;
												FLAG <= '1';
											when '1' => 
												PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
											when others => report "Unimplemented";
										end case;
									
									when "0011" => --brcs
										case cFlagOUTAux is
											when '1' =>
												sA <= '0';
												ADDR <= PC;
												FLAG <= '1';
											when '0' => 
												PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
											when others => report "Unimplemented";
										end case;

									
									when "0100" => --brcc
										case cFlagOUTAux is
											when '0' =>
												sA <= '0';
												ADDR <= PC;
												FLAG <= '1';
											when '1' => 
												PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
											when others => report "Unimplemented";
										end case;

									when others =>
										report "Unimplemented";
								end case;
							
							when others =>
								report "Unimplemented";
						end case;
						state <= Execute;
					when Execute =>
						if to_integer(unsigned(DATAAux(7 downto 4))) > 3 or to_integer(unsigned(DATAAux(7 downto 4))) < 15 then
							zFlagAux <= zFlag;
							cFlagOUTAux <= cFlagOUTALU;
						end if;
						EN <= '0';
						WE <= '0';
						state <= Fetch1;
				end case;
			end if;
		end process;
		
		cFlagINALU <= cFlagOUTAux;

end rtl;