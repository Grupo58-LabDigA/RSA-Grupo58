library ieee;
use ieee.numeric_bit.all;

entity Multiplier is
    generic (
        n : positive := 8
      );
    port (
        a : in bit_vector(n-1 downto 0);
        b : in bit_vector(n-1 downto 0);
        result : out bit_vector (2*n - 1 downto 0)
    );
end entity Multiplier;

architecture Behavioral of Multiplier is
	signal input_1: unsigned(n-1 downto 0);
    signal input_2: unsigned(n-1 downto 0);
    signal result1: unsigned(2*n - 1 downto 0);

	begin
    input_1 <= unsigned(a);
    input_2 <= unsigned(b);
    result1 <= input_1*input_2;
    result <= bit_vector(result1);
end architecture;