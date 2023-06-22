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
 
        "0000" when "00110000", -- 0 
        "0001" when "00110001", -- 1 
        "0010" when "00110010", -- 2 
        "0011" when "00110011", -- 3 
        "0100" when "00110100", -- 4 
        "0101" when "00110101", -- 5 
        "0110" when "00110110", -- 6 
        "0111" when "00110111", -- 7 
        "1000" when "00111000", -- 8 
        "1001" when "00111001", -- 9  ` 
        "1010" when "01100001", -- a 
        "1011" when "01100010", -- b 
        "1100" when "01100011", -- c 
        "1101" when "01100100", -- d 
        "1110" when "01100101", -- e 
        "1111" when "01100110", -- f 

        "0000" when others;
	binary <= disp;
end architecture;


