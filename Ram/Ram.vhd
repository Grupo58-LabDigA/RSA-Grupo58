--------------------------------------------------------------------------------
--! @file   rom.vhd
--! @brief  Parametrisable Sync RAM memory
--! @author Bruno Albertini (balbertini@usp.br)
--! @date   20190606
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity ram is
  generic(
    address_size : natural := 128; --setar o numero de palavras maximo
    word_size    : natural := 8
  );
  port(
    ck, wr : in  bit; --wr será ligado ao sinal de que recebeu
	reset  : in bit; --reset assincrono para toda vez que for mandar algo pra criptografar 
    addr   : in  bit_vector(address_size-1 downto 0); 
    data_i : in  bit_vector(word_size-1 downto 0);
    data_o : out bit_vector(word_size-1 downto 0)
  );
end ram;

architecture vendorfree of ram is
  constant depth : natural := 2**address_size;
  type mem_type is array (0 to depth-1) of bit_vector(word_size-1 downto 0);
  signal mem : mem_type;
  signal addres : : integer range 0 to address_size := 0;  -- Numero maximo de endereços 
begin
  wrt: process(ck, reset)
  begin
    if (reset = '1') then
		mem <= (others => '0');
		addres <= 0
	end if;
	if (ck='1' and ck'event) then
      if (wr='1') then
        mem(to_integer(unsigned(addres))) <= data_i;
		addres <= addres + 1;
      end if;
    end if;
  end process;
  data_o <= mem(to_integer(unsigned(addr)));
end vendorfree;