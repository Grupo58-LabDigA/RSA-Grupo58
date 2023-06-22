--------------------------------------------------------------------------------
--! @file   rom.vhd
--! @brief  Parametrisable Sync RAM memory
--! @author Bruno Albertini (balbertini@usp.br)
--! @date   20190606
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic(
    address_size : natural := 6;
    word_size    : natural := 4
  );
  port(
    ck, wr, reset : in  std_logic;
    --addr   : in  std_logic_vector(address_size-1 downto 0);
    data_i   : in  std_logic_vector(7 downto 0);
    data_o  : out std_logic_vector(address_size*8-1 downto 0)
  );
end ram;

architecture vendorfree of ram is
  signal counter : integer := 0;
  constant depth : natural := 2**address_size;
  type mem_type is array (0 to depth-1) of std_logic_vector(word_size-1 downto 0);
  signal convertido : std_logic_vector(3 downto 0);
  signal mem : mem_type;
  
  component decoder is

  port(
	ascii: in std_logic_vector(7 downto 0);
	binary: out std_logic_vector(3 downto 0)
	);
	end component;

begin

  decodificador : decoder
  port map(
	ascii => data_in,
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
  
  g1: for i in 1 to adrress_size generate 
	data_o(i*word_size-1 downto i*word_size-3) <= mem(i-1);
end vendorfree;