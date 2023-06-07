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


	signal  b_in, e_in, m_in, result_out: bit_vector (15 downto 0);
    signal reset_in, done_out: bit;

    
-- DUT component


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: ModularExponentiation generic map(16)
           port map(clk_in,reset_in, b_in, e_in, m_in, result_out, done_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    
    b_in <= "0000000000000100";
    e_in <= "0000000000000101";
    m_in <= "0000000111110001";
    
    reset_in <= '1';
    
    wait for 4 ns;
    
    reset_in <= '0';
   
    wait until done_out = '1';
    

    assert(false) report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;