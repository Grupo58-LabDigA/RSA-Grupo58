library ieee;
use ieee.numeric_bit.all;

entity decoder is

  port(
	ascii: out bit_vector(7 downto 0);
	binary: in bit_vector(3 downto 0)
    
  );
end decoder;

architecture decoder_arch of decoder is
signal disp : bit_vector(7 downto 0);
begin
    with ascii select disp <=
 
        "00110000" when "0000", -- 0 
        "00110001" when "0001" , -- 1 
        "00110010" when "0010", -- 2 
        "00110011" when "0011", -- 3 
        "00110100" when "0100", -- 4 
        "00110101" when "0101", -- 5 
        "00110110" when "0110", -- 6 
        "00110111" when "0111", -- 7 
        "00111000" when "1000", -- 8 
        "00111001" when "1001", -- 9  ` 
        "01100001" when "1010", -- a 
        "01100010" when "1011", -- b 
        "01100011" when "1100", -- c 
        "01100100" when "1101", -- d 
        "01100101" when "1110", -- e 
        "01100110" when "1111", -- f 

        "00000000" when others;
	ascii <= disp;
end architecture;


