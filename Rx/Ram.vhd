--------------------------------------------------------------------------------
--! @file   rom.vhd
--! @brief  Parametrisable Sync RAM memory
--! @author Bruno Albertini (balbertini@usp.br)
--! @date   20190606
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;


entity ram is
  generic(
    address_size : natural := 32;
    word_size    : natural := 4
  );
  port(
    ck, wr, reset : in  bit;
    --addr   : in  bit_vector(address_size-1 downto 0);
    data_i   : in  bit_vector(7 downto 0);
    data_o  : out bit_vector(word_size*address_size - 1 downto 0)
  );
end ram;

architecture vendorfree of ram is
  signal counter : integer := 0;
  --constant depth : natural := 2**address_size;
  type mem_type is array (0 to address_size-1) of bit_vector(3 downto 0);
  signal convertido : bit_vector(3 downto 0);
  signal mem : mem_type;
  
  signal intermediario: bit_vector(word_size*address_size-1 downto 0) := (others=>'0');
  
  component decoder is

  port(
	ascii: in bit_vector(7 downto 0);
	binary: out bit_vector(3 downto 0)
	);
	end component;

begin
 

  decodificador : decoder
  port map(
	ascii => data_i,
	binary => convertido
  );
  
  
  wrt: process(ck)
  begin
	--if reset = '0' then
		--mem <= (others => (others => '0'));
		--counter <= 0;
	if(ck='1' and ck'event) then
		if (wr='1') then
			mem(counter) <= convertido;
			counter <= counter + 1;
		end if;
	end if;
  end process;
  
  
  g1: for i in 1 to address_size generate 
	intermediario(i*4-1 downto i*4-4) <= mem(i-1);
  
  end generate g1;
  
  data_o <= intermediario;
	
end vendorfree;
