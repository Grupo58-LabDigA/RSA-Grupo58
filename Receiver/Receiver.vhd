library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
	clock : in std_logic;
	data_in : in std_logic;
	reset : in std_logic;
   --finish : in std_logic;
	display1, display2, display3, display4, display5, display6 : out std_logic_vector(7 downto 0)
  );
end entity;


architecture arch_top of top is

 --Declaração dos componentes 
component UART_RX is
  generic (
    CLKS_PER_BIT_g : integer := 434  --SETAR O VALOR CERTO
    );
  port (
    clock_i        : in  std_logic;
    RX_Serial_i    : in  std_logic; 
    RX_DV_o        : out std_logic; 
    RX_Byte_o      : out std_logic_vector(7 downto 0) 
    );
end component;

component display is
  port (
    input: in   std_logic_vector(7 downto 0); -- ASCII 8 bits
    output: out std_logic_vector(7 downto 0)  -- ponto + abcdefg
  );
end component;

component ShiftRegister is
    generic (
        WIDTH : integer := 1 -- setar o tamanho certo de palavras
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        enable   : in  std_logic;
		finish   : in  std_logic;
        shift_in : in  std_logic_vector(7 downto 0);
        shift_out: out std_logic_vector(WIDTH*8-1 downto 0)
    );
end component;

	component reg is
	generic (
        letras : integer := 1
    );
    port (
        clk      : in  std_logic;
        enable   : in  std_logic;
		  reset 	  : in  std_logic;
        data_in : in  std_logic_vector(7 downto 0);
        data_out :out std_logic_vector(letras*8-1 downto 0)
		  
    );
	end component;
	component negador is
    port (
        data_in  : in  std_logic_vector(7 downto 0);
        data_out :out std_logic_vector(7 downto 0)
		  
    );
	end component;
	
	component ram is
	generic(
		address_size : natural := 128;
		word_size    : natural := 8
	);
	port( 
		ck, wr, reset  : in  std_logic;
		--addr    : in  bit_vector(address_size-1 downto 0);
		data_i  : in  std_logic_vector(word_size-1 downto 0);
		data_o : out std_logic_vector(word_size-1 downto 0)
	);
	end component;
	
	

  -- Instanciando o componente
constant letras : integer := 1;
signal disp1, disp2, disp3, disp4, disp5, disp6 : std_logic_vector(7 downto 0);
signal wr 	       : std_logic;
signal data_rx 	   : std_logic_vector(7 downto 0);
signal armazenador : std_logic_vector(letras*8-1 downto 0);
signal a1, a2, a3, a4, a5, a6 : std_logic_vector(7 downto 0);
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
  display_01 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a1
	 );
  display_02 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a2
	 );	
  display_03 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a3
	 );
  display_04 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a4
	 );	
  display_05 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a5
	 );	
  display_06 : display
	 port map(
		input => armazenador(7 downto 0),
		output => a6
	 );
  
  negador_01 : negador
   port map(
		data_in => a1,
		data_out => display1
		);
  
  negador_02 : negador
   port map(
		data_in => a2,
		data_out => display2
		);
		
  negador_03 : negador
   port map(
		data_in => a3,
		data_out => display3
		);	

  negador_04 : negador
   port map(
		data_in => a4,
		data_out => display4
		);

  negador_05 : negador
   port map(
		data_in => a5,
		data_out => display5
		);		

	negador_06 : negador
   port map(
		data_in => a6,
		data_out => display6
		);
		
end architecture;
		

----------------------------------------------------------------------
-- Arquivo original https://www.nandland.com
----------------------------------------------------------------------
-- Este arquivo contem um receptor UART. Este receptor pode receber
-- 8 bits de dados seriais, um start bit, um stop bit,
-- e sem bit de paridade.  Quando a recepção esta completa 
-- RX_DV_o vai estar em valor alto por um ciclo de clock.
-- 
-- Exemplo de como configurar CLKS_PER_BIT_g:
-- CLKS_PER_BIT_g = (Frequencia de clock)/(Frequencia do UART)
-- exemplo: 10 MHz Clock, 115200 baud UART
-- (50000000)/(115200) = 87
 
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity UART_RX is
  generic (
    CLKS_PER_BIT_g : integer := 434     -- precisa ser corrigido
    );
  port (
    clock_i     : in  std_logic;
    RX_Serial_i : in  std_logic;
    RX_DV_o     : out std_logic;
    RX_Byte_o   : out std_logic_vector(7 downto 0)
    );
end UART_RX;
 
architecture rtl of UART_RX is
 
 -- maquina de estados
  type SM_Main_t is (Idle_s, RX_Start_Bit_s, RX_Data_Bits_s,
                     RX_Stop_Bit_s, Cleanuo_s);
  signal SM_Main_r : SM_Main_t := Idle_s;
 
  signal RX_Data_R_r : std_logic := '0';
  signal RX_Data_r   : std_logic := '0';
   
  signal Clk_Count_r : integer range 0 to CLKS_PER_BIT_g-1 := 0;
  signal Bit_Index_r : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal RX_Byte_r   : std_logic_vector(7 downto 0) := (others => '0');
  signal RX_DV_r     : std_logic := '0';
 
begin
 
  -- Proposito : Registrar duas vezes os dados de entrada.
  -- (Isso remove problemas de metaestabilidade)
  SAMPLE_p : process (clock_i)
  begin
    if rising_edge(clock_i) then
      RX_Data_R_r <= RX_Serial_i;
      RX_Data_r   <= RX_Data_R_r;
    end if;
  end process SAMPLE_p;
 
  -- Proposito: controle de maquina de estados RX
  UART_RX_p : process (clock_i)
  begin
    if rising_edge(clock_i) then
         
      case SM_Main_r is
 
        -- valor inicial 
        when Idle_s =>
          RX_DV_r     <= '0';
          Clk_Count_r <= 0;
          Bit_Index_r <= 0;
 
          if RX_Data_r = '0' then        -- se start bit é detectado
            SM_Main_r <= RX_Start_Bit_s; -- vai para o proximo estado
          else
            SM_Main_r <= Idle_s;
          end if;
 
           
        -- verifica se o start bit continua em baixo
        when RX_Start_Bit_s =>
          if Clk_Count_r = (CLKS_PER_BIT_g-1)/2 then  
            if RX_Data_r = '0' then                   -- se o start bit continuar em zero  
              Clk_Count_r <= 0;                       -- vai para o proximo estado 
              SM_Main_r   <= RX_Data_Bits_s;
            else
              SM_Main_r   <= Idle_s;
            end if;
          else
            Clk_Count_r <= Clk_Count_r + 1;
            SM_Main_r   <= RX_Start_Bit_s;
          end if;
 
           
        -- espera CLKS_PER_BIT_g-1 ciclos de clock para coletar o dado serial
        when RX_Data_Bits_s =>
          if Clk_Count_r < CLKS_PER_BIT_g-1 then
            Clk_Count_r <= Clk_Count_r + 1;
            SM_Main_r   <= RX_Data_Bits_s;
          else
            Clk_Count_r            <= 0;
            RX_Byte_r(Bit_Index_r) <= RX_Data_r;  -- grava bit recebido no vetor de dados
             
            -- verifica se ja recebeu todos os 8 bits de dados
            -- caso sim, pula para o proximo estado
            if Bit_Index_r < 7 then
              Bit_Index_r <= Bit_Index_r + 1;
              SM_Main_r   <= RX_Data_Bits_s;
            else
              Bit_Index_r <= 0;
              SM_Main_r   <= RX_Stop_Bit_s;
            end if;
          end if;
 
 
        -- Recebe o stop bit.  Stop bit = 1
        when RX_Stop_Bit_s =>
          -- aguarda CLKS_PER_BIT_g-1 ciclos de clock para o fim do Stop bit
          -- sinaliza RX_DV_r como alto e pula para o proximo estado
          if Clk_Count_r < CLKS_PER_BIT_g-1 then
            Clk_Count_r <= Clk_Count_r + 1;
            SM_Main_r   <= RX_Stop_Bit_s;
          else
            RX_DV_r     <= '1';
            Clk_Count_r <= 0;
            SM_Main_r   <= Cleanuo_s;
          end if;
 
                   
        -- fica aqui por 1 ciclo de clock
        -- coloca RX_DV_r em baixo (RX_DV_r fica em alto apenas por um ciclo)
        -- e então retorna para o valor inicial da maquina de estados
        when Cleanuo_s =>
          SM_Main_r <= Idle_s;
          RX_DV_r   <= '0';
 
             
        when others =>
          SM_Main_r <= Idle_s;
 
      end case;
    end if;
  end process UART_RX_p;
 
  RX_DV_o   <= RX_DV_r;
  RX_Byte_o <= RX_Byte_r;
 
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	 generic (
        letras : integer := 6 --teria q ser 128 bytes
    );
    port (
        clk      : in  std_logic;
        enable   : in  std_logic;
		reset 	 : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(letras*8-1 downto 0)
		  
    );
end entity reg;

architecture Behavioral of reg is
    signal reg_mid : std_logic_vector(letras*8-1 downto 0) := (others => '0');
begin
    process (clk, reset)
    begin
        if reset = '1' then
            reg_mid <= (others => '0');
		elsif rising_edge(clk) then
            if enable = '1' then
					 reg_mid(letras*8-1 downto 0) <= reg_mid;
					 --reg_mid(7 downto 0) <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg_mid;
end architecture Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity negador is
    port (
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
		  
    );
end entity negador;

architecture Behavioral of negador is
begin

   data_out <= not(data_in);
	
end architecture Behavioral;