library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is

  port(
	ascii: in std_logic_vector(7 downto 0);
	binary: out std_logic_vector(3 downto 0)
    
  );
end decoder;

architecture decoder_arch of decoder is
signal disp : std_logic_vector(3 downto 0);
begin
    with ascii select disp <=
 
        "0000" when x"30", -- 0 
        "0001" when x"31", -- 1 
        "0010" when x"32", -- 2 
        "0011" when x"33", -- 3 
        "0100" when x"34", -- 4 
        "0101" when x"35", -- 5 
        "0110" when x"36", -- 6 
        "0111" when x"37", -- 7 
        "1000" when x"38", -- 8 
        "1001" when x"39", -- 9  ` 
        "1010" when x"61", -- a 
        "1011" when x"62", -- b 
        "1100" when x"63", -- c 
        "1101" when x"64", -- d 
        "1110" when x"65", -- e 
        "1111" when x"66", -- f 

        "0000" when others;
	binary <= disp;
end architecture;


