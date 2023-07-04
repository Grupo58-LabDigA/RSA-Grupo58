library IEEE;
use IEEE.numeric_bit.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity top is
    generic (
        n : positive := 128
      );
    port (
    	clk: in bit;
        serial_in: in bit;
        transmission_finished: in bit; -- sinal para inciar descriptografia
		start_transmission_to_pc: in bit;
        serial_out : out bit;
		d0, d1, d2, d3, d4, d5: out bit_vector(7 downto 0);
		decryption_finished: out bit

    );
end entity top;

architecture Behavioral of top is
    component ModularExponentiation is
        generic (
            n : positive := 128
          );
        port (
            clk: in bit;
            reset: in bit;
            b : in bit_vector(n-1 downto 0);
            e : in bit_vector(n-1 downto 0);
            m : in bit_vector(n-1 downto 0);
            result : out bit_vector (n-1 downto 0);
            done : out bit
    
        );
    end component;
	

	
	component top_rx is
		generic (
			n : positive := 128
		);
		port(
			clock : in bit;
			data_in : in bit;
			reset : in bit;
			data_out : out bit_vector(n-1 downto 0)
			
		);
	end component;
	
	component top_tx is
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
	end component;
	
	
	component encoder is

	  port(
		ascii: out bit_vector(7 downto 0);
		binary: in bit_vector(3 downto 0)
		
	  );
	end component;
	
	component display is
	  port (
		input: in   bit_vector(7 downto 0); -- ASCII 8 bits
		output: out bit_vector(7 downto 0)  -- ponto + abcdefg
	  );
	end component;
	


    signal public_N, private_d, encrypted, decrypted: bit_vector(n-1 downto 0);

    signal decryption_done: bit; -- usar para iniciar a transmissao de volta para o PC
	
	signal debug: bit_vector(7 downto 0);
	
	signal zero: bit_vector (n-1 downto 0) := (others => '0');
	
	signal ascii: bit_vector(47 downto 0);

    
    begin
        --public_N <= x"ea583aebbe8b7d841afb4ffb54e3f874d0ac97acd18c2eab195060d35c6017f49b0ff3ec2df2130ae849cb9674f343bbc6dd7f0d1131b940aafc8adf2b9b31c4485dcc7c4ee74576310cafe0878fa80eb1787dee927f58c77f58e00d6f35fcbb8d7e9bae375f8ebb4c6b878c6f0b68941b9e7088c44f647908c70728f48a1399";
        --private_d <= x"076bd35e84aa7f5ca80bc0de3ff38c8fa07872c0dce2f5ab0d47c11a8dc0979ef3567ce8eebc8d88a924b07490e564f0a4f7d33945f689e6bd1e21c4b6feb8c399145493c153997c1f8b8f98235ef10fed50f5b0170c2d9a74aa29693752df1159d08b3c6795de2dabfb72775b53fdf6452bbedc0b7515a7fb1a1dda76ee351d";

		private_d <= x"ae69e757382013da213a32f3a0e986c1";
		public_N <= x"4cf239f6b7b32728b3917d1d100f8d31";
		
        --private_d <= zero(n-1 downto 4) & "1101";
		--public_N <= zero(n-1 downto 9) & "111110001";
		
		
		modexp: ModularExponentiation generic map (n) port map (clk, not transmission_finished, encrypted, private_d, public_N, decrypted, decryption_done);
	
		receiver : top_rx 
		generic map(n)
		port map(
			clock => clk,
			data_in => serial_in,
			reset => '0',
			data_out => encrypted
		);
		
		sender : top_tx port map (clk, not start_transmission_to_pc, decrypted, '0', serial_out, open);
		
		encoder1: encoder port map(ascii(47 downto 40), decrypted(23 downto 20));
		encoder2: encoder port map(ascii(39 downto 32), decrypted(19 downto 16));
		encoder3: encoder port map(ascii(31 downto 24), decrypted(15 downto 12));
		encoder4: encoder port map(ascii(23 downto 16), decrypted(11 downto 8));
		encoder5: encoder port map(ascii(15 downto 8), decrypted(7 downto 4));
		encoder6: encoder port map(ascii(7 downto 0), decrypted(3 downto 0));
		
		display6: display port map(ascii(47 downto 40), d5(7 downto 0));
		display5: display port map(ascii(39 downto 32), d4(7 downto 0));
		display4: display port map(ascii(31 downto 24), d3(7 downto 0));
		display3: display port map(ascii(23 downto 16), d2(7 downto 0));
		display2: display port map(ascii(15 downto 8), d1(7 downto 0));
		display1: display port map(ascii(7 downto 0), d0(7 downto 0));
		
		 --d0(3 downto 0) <= encrypted(23 downto 20);
		 --d1(3 downto 0) <= encrypted(19 downto 16);
		 --d2(3 downto 0) <= encrypted(15 downto 12);
		 --d3(3 downto 0) <= encrypted(11 downto 8);
		 --d4(3 downto 0) <= encrypted(7 downto 4);
		 --d5(3 downto 0) <= encrypted(3 downto 0);
		 
		 
		 
		
		
		
		decryption_finished <= decryption_done;
		     
end architecture;