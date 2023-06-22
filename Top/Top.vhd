library IEEE;
use IEEE.numeric_bit.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity top is
    generic (
        n : positive := 1024
      );
    port (
    	clk: in bit;
        serial_in: in bit;
        transmission_finished: in bit; -- sinal para inciar descriptografia
        serial_out : out bit

    );
end entity top;

architecture Behavioral of top is
    component ModularExponentiation is
        generic (
            n : positive := 1024
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
		port(
			clock : in bit;
			data_in : in bit;
			reset : in bit;
			data_out : out bit_vector(1023 downto 0)
		);
	end component;


    signal public_N, private_d, encrypted, decrypted: bit_vector(n-1 downto 0);

    signal decryption_done: bit; -- usar para iniciar a transmissao de volta para o PC
	


    
    begin
        public_N <= x"ea583aebbe8b7d841afb4ffb54e3f874d0ac97acd18c2eab195060d35c6017f49b0ff3ec2df2130ae849cb9674f343bbc6dd7f0d1131b940aafc8adf2b9b31c4485dcc7c4ee74576310cafe0878fa80eb1787dee927f58c77f58e00d6f35fcbb8d7e9bae375f8ebb4c6b878c6f0b68941b9e7088c44f647908c70728f48a1399";
        private_d <= x"076bd35e84aa7f5ca80bc0de3ff38c8fa07872c0dce2f5ab0d47c11a8dc0979ef3567ce8eebc8d88a924b07490e564f0a4f7d33945f689e6bd1e21c4b6feb8c399145493c153997c1f8b8f98235ef10fed50f5b0170c2d9a74aa29693752df1159d08b3c6795de2dabfb72775b53fdf6452bbedc0b7515a7fb1a1dda76ee351d";

        modexp: ModularExponentiation generic map (n) port map (clk, not transmission_finished, encrypted, private_d, public_N, decrypted, decryption_done);
	
				receiver : top_rx 
		port map(
			clock => clk,
			data_in => serial_in,
			reset => '0',
			data_out => encrypted
		);
		     
end architecture;