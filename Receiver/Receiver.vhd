library IEEE;
use IEEE.numeric_bit.all;


entity top_rx is
  port(
	clock : in bit;
	data_in : in bit;
	reset : in bit;
   	data_out : out bit_vector(1023 downto 0)
  );
end entity;


architecture arch_top of top_rx is

 --Declaração dos componentes 
	component UART_RX is
	generic (
		CLKS_PER_BIT_g : integer := 434  --SETAR O VALOR CERTO
		);
	port (
		clock_i        : in  bit;
		RX_Serial_i    : in  bit; 
		RX_DV_o        : out bit; 
		RX_Byte_o      : out bit_vector(7 downto 0) 
		);
	end component;

	Component ram is
	generic(
		address_size : natural := 256;
		word_size    : natural := 4
	);
	port( 
		ck, wr, reset  : in  bit;
		data_i  : in  bit_vector(7 downto 0);
		data_o : out bit_vector(1023 downto 0)
	);
	end component;
	
	

  -- Instanciando o componente
constant letras : integer := 1;
signal disp1, disp2, disp3, disp4, disp5, disp6 : bit_vector(7 downto 0);
signal wr 	       : bit;
signal data_rx 	   : bit_vector(7 downto 0);
signal armazenador : bit_vector(1023 downto 0);

begin
    
  -- Conectando os sinais ao componente
  U_RX : UART_RX
	port map(
      clock_i => clock,
      RX_Serial_i  => data_in,
	  RX_DV_o      => wr,
      RX_Byte_o    => data_rx
    );
  
  memoria : ram
	port map(
		ck => clock,
		wr => wr,
		reset => reset,
		data_i => data_rx,
		data_o => armazenador
	);
  
  data_out <= armazenador;
end architecture;
