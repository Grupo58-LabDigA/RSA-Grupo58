library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity intermediario is
	generic(
    address_size : natural := 128; --setar o numero de palavras maximo
	);
	port(
    wr       : in  std_logic; -- ligar ao recebi byte do receiver
    reset : in  std_logic; --resetar o contador
    wr_out     : out std_logic; -- saida da escrita para RAM
    addr   : out  std_logic_vector(address_size-1 downto 0); --saida do endereço para a RAM 
	reset_out : out std_logic -- saida do reset para a RAM
    );
end intermediario;

architecture inter_arch of intermediario is
  signal addres : integer range 0 to address_size := 0;  -- Numero maximo de endereços 
   
begin
	process(wr)
	begin
		if (reset = '1') then
			addres = 0;
		end if;a
		if (wr = '1') then
			addres = addres + 1;
		end if;
	end process;

	addr <= std_logic_vector(to_unsigned(addres, address_size-1));
	reset_out <= reset;
	wr_out <= wr;
end inter_arch; 