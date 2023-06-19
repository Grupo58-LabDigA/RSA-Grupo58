library IEEE;
use IEEE.numeric_bit.all;
--use IEEE.bit_1164.all; 


 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component ModularExponentiation is
    generic (
        n : positive := 8
      );
    port (
    	clk: in bit;
        reset: in bit;
        b : in bit_vector(n-1 downto 0);
        e : in bit_vector(n-1 downto 0);
        m : in bit_vector(n-1 downto 0);
        result : out bit_vector (n - 1 downto 0);
        done : out bit

    );
end component;


	signal  b_in, e_in, m_in, result_out: bit_vector (1023 downto 0);
    signal reset_in, done_out: bit;

    
-- DUT component


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: ModularExponentiation generic map(1024)
           port map(clk_in,reset_in, b_in, e_in, m_in, result_out, done_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    
    
    b_in(1023 downto 4) <= (others => '0');
    b_in(3 downto 0) <= "1011";
    e_in(1023 downto 24) <= (others => '0');
    e_in (23 downto 0)<= x"010001";
    m_in(1023 downto 0) <= x"ea583aebbe8b7d841afb4ffb54e3f874d0ac97acd18c2eab195060d35c6017f49b0ff3ec2df2130ae849cb9674f343bbc6dd7f0d1131b940aafc8adf2b9b31c4485dcc7c4ee74576310cafe0878fa80eb1787dee927f58c77f58e00d6f35fcbb8d7e9bae375f8ebb4c6b878c6f0b68941b9e7088c44f647908c70728f48a1399";
    
    reset_in <= '1';
    
    wait for 4 ns;
    --ds_in <= '0';
    reset_in <= '0';
   
  
  
    
    --wait until done_out = '1';
   
    
    
    wait until done_out = '1';
    

    assert(result_out = x"671e8366eb76cc456374db6424f93c9551b357e232da50c6be362ac358200e7c1abd234e0ff58a1d6df90e69c7f66ad0baff774cd8ea39be32aeeec3ab28010b39c20a891e5b346f362b828984b81159a95213bf1f6b9836dacef86e346b6468150e4d77bb66eb7d5c79036c0638846781f1c14fdb9db286021f58ff549eb8aa") report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;