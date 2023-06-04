library IEEE;
use IEEE.numeric_bit.all;


 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component exponentiation is
    generic (
      n : positive := 8
    );
    port (
        clock, enable : in bit;
        load_initials: in bit;
        E : in bit_vector(n-1 downto 0);
        B : in bit_vector(n-1 downto 0);
        Result : out bit_vector(2*n-1 downto 0) -- arrumar tamanho
    );
  end component;


	signal E_in: bit_vector(7 downto 0);
    signal B_in: bit_vector(7 downto 0);
    signal Result_out: bit_vector(15 downto 0);
    signal load_initials_in, enable_in: bit;
    
-- DUT component


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: exponentiation generic map(8)
           port map(clk_in, enable_in ,load_initials_in, E_in, B_in, Result_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    E_in <= "00000101";
    B_in <= "00000100";
    load_initials_in <= '1';
    wait for 2 ns;
    
    load_initials_in <= '0';
    
    wait for 10 ns;

    assert(Result_out = "0000000001010001") report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;