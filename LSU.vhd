library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity LSU is
	Port(
	CLK : in STD_LOGIC;
	WE : in STD_LOGIC; 
	EN : in STD_LOGIC;
	ADDR : in STD_LOGIC_VECTOR(7 DOWNTO 0);
	DATAIN : in STD_LOGIC_VECTOR(7 DOWNTO 0);
	DATAOUT : out STD_LOGIC_VECTOR(7 DOWNTO 0);
	DISPLAY_OUT : out STD_LOGIC_VECTOR(7 DOWNTO 0));
	
end LSU;

architecture rtl of LSU is

	signal reg_display: STD_LOGIC_VECTOR(7 DOWNTO 0);
	type ramT is array(0 to 255)of STD_LOGIC_VECTOR(7 downto 0);
	
 -- count_icc
  signal ram: ramT := (
      0 => "11110000", -- count_icc.asm: 2:       jmp @main
      1 => "00100000", --
     32 => "00000000", -- count_icc.asm: 5: main: ldi  r0, 0
     34 => "00000100", -- count_icc.asm: 6:       ldi  r1, 0x18
     35 => "00011000", --
     36 => "01000000", -- count_icc.asm: 7: loop: inc  r0
     37 => "00100001", -- count_icc.asm: 8:       st   r0, [r1]
     38 => "00001000", -- count_icc.asm:10:       ldi  r2, 0
     40 => "00001100", -- count_icc.asm:11:       ldi  r3, 0
     42 => "01001100", -- count_icc.asm:12:       inc  r3
     43 => "01001010", -- count_icc.asm:13:       incc  r2
     44 => "11110100", -- count_icc.asm:14:       brcc @loop
     45 => "00100100", --
     others => "00000000");



begin
	process(CLK) is
	  begin
		  if rising_edge(CLK) then
			  if WE = '1' then
			    if ADDR = "00011000" then
				   reg_display <= DATAIN;
				  else
					  ram(to_integer(unsigned(ADDR))) <= DATAIN;
				  end if;
			  end if;
		  end if;
	end process;
  DATAOUT <= ram(to_integer(unsigned(ADDR)));
  DISPLAY_OUT <= reg_display;
end rtl;