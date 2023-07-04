library IEEE;
use IEEE.numeric_bit.all;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tx is
	generic (
		n : positive := 128
	);
	port(
		clock : in bit;
		start_transmission: in bit;
		data_in : in bit_vector(n-1 downto 0);
		reset : in bit;
		data_out : out bit;
		transmission_done: out bit
		
	);
end entity;

architecture arch_top of top_tx is
 
component UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  bit;
    i_TX_DV     : in  bit;
    i_TX_Byte   : in  bit_vector(7 downto 0);
    o_TX_Active : out bit;
    o_TX_Serial : out bit;
    o_TX_Done   : out bit
    );
end component;

component encoder is

  port(
	ascii: out bit_vector(7 downto 0);
	binary: in bit_vector(3 downto 0)
    
  );
end component;

signal ascii_byte: bit_vector(7 downto 0);
signal char_sent, send_char: bit := '0';
signal counter: integer range 0 to 32 := 32;
signal busy_transmitting : bit;
signal hexadecimal: bit_vector(3 downto 0);

type mem_type is array (0 to 32-1) of bit_vector(3 downto 0);

signal mem : mem_type;

begin

    fsm: process(clock)
    begin
	if (rising_edge(clock)) then 
		if (start_transmission = '1') then 
			counter <= 0;
			send_char <= '0';
			if (counter = 0) then
				send_char <= '1';
				counter <= counter +1;
			end if;
		else 
			if (char_sent = '1' and counter < 32) then 
				send_char <= '1';
				counter <= counter + 1;
			else  
				send_char <= '0';
			end if;
		end if;
	end if;
    end process;
hexadecimal <= mem(counter);
	
 g1: for i in 1 to 32 generate 
	mem(32-i) <= data_in(i*4-1 downto i*4-4);
end generate;

encoder1 : encoder port map(ascii_byte, hexadecimal);

U_TX: UART_TX port map(clock, send_char, ascii_byte, busy_transmitting, data_out, char_sent);

end architecture;