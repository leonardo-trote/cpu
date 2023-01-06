library IEEE;
use IEEE.STD_LOGIC_1164.all;

package types is
	
	subtype Nibble is std_logic_vector(3 downto 0);
	subtype Byte is std_logic_vector(7 downto 0);
	
	type ALUOpT is (
						--aoLDI,
						--aoPUSH,
						--aoPOP,
						--aoLD,
						--aoST,
						
						aoMOV,
						aoINC,
						aoDEC, 
						aoINCC, 
						aoDECB, 
						aoADD, 
						aoSUB, 
						
						aoNEG, 
						
						aoNOT, 
						aoAND, 
						aoOR, 
						aoXOR, 

						aoLSL, 
						aoLSR, 
						aoROL,
						aoROR 
						
						--aoIJMP,
						--aoJMP,
						--aoBRZ,
						--aoBRNZ,
						--aoBRCS,
						--aoBRCC
					);
end types;